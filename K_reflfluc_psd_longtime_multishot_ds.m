function K_reflfluc_psd_longtime_multishot_ds(shot, time1, time2)
% ... (保持原有注释和初始代码不变，直到调用K_reflfluc_3D函数的部分)

% 使用cell数组预分配结果
[t_3D, f_3D, PSD1, PSD2, PSD3, PSD4] = K_reflfluc_3D_optimized(...
    shotxx, time_span, card_name, data_path, fs, time_delay, judge);

% ... (保持绘图和保存部分不变)
end

function [t_3D, f_3D, PSD1, PSD2, PSD3, PSD4] = K_reflfluc_3D_optimized(...
    shot, time_span, card_name, data_path, fs, time_delay, judge)

% ... (保持原有参数设置不变)

% 将恒定参数移出循环
if judge == 2
    band_pass = [-600, -1000];
    average_point = 4;
end

% 预分配cell数组收集结果
numSegments = length(time) - 1;
t_3D_cell = cell(1, numSegments);
PSD1_cell = cell(1, numSegments);
PSD2_cell = cell(1, numSegments);
PSD3_cell = cell(1, numSegments);
PSD4_cell = cell(1, numSegments);

% 主循环处理每个时间段
parfor i = 1:numSegments % 使用parfor加速
    % 读取数据
    [t1, t2] = deal(time(i), time(i+1));
    [data2, t_temp] = read_segment(filename, channel, fs, time_delay, t1, t2);
    
    % 处理四个通道
    S = process_channels(data2, row_1, row_2, row_3, row_4, IQ_sign);
    clear data2;
    
    % 幅度信号处理
    if judge == 2
        S = process_amplitude(S, t_temp, band_pass, fs, average_point);
        ts_temp = S(1).ts;
    else
        ts_temp = 1/fs;
        fftpoint = 512*4;
    end
    
    % 计算PSD
    [t_seg, PSD_seg] = compute_psd(S, ts_temp, t_temp, judge, fftpoint);
    
    % 存储结果
    t_3D_cell{i} = t_seg;
    PSD1_cell{i} = PSD_seg{1};
    PSD2_cell{i} = PSD_seg{2};
    PSD3_cell{i} = PSD_seg{3};
    PSD4_cell{i} = PSD_seg{4};
end

% 合并结果
t_3D = [t_3D_cell{:}];
PSD1 = [PSD1_cell{:}];
PSD2 = [PSD2_cell{:}];
PSD3 = [PSD3_cell{:}];
PSD4 = [PSD4_cell{:}];
f_3D = f/1000; % 转换为kHz
end

function [data2, t_temp] = read_segment(filename, channel, fs, time_delay, t1, t2)
% 读取数据段
time_1 = t1 - time_delay;
fid = fopen(filename, 'r');
datapoint1 = channel * fs * time_1 * 2;
fseek(fid, datapoint1, 'bof');
lth = ceil(abs(t2 - t1) * fs) * channel;
data_2 = fread(fid, lth, 'int16');
fclose(fid);

% 重组数据
data2 = reshape(data_2, channel, []);
t_temp = linspace(t1, t2, size(data2, 2));
end

function S = process_channels(data2, rows, signs)
% 处理四个通道
S = struct();
channels = {rows(1,:), rows(2,:), rows(3,:), rows(4,:)};
sign_vals = num2cell(signs);

for k = 1:4
    ch = channels{k};
    sign_val = sign_vals{k};
    S(k).sig = data2(ch(1), :) + sign_val * 1i * data2(ch(2), :);
end
end

function S = process_amplitude(S, t_temp, band_pass, fs, average_point)
% 处理幅度信号
for k = 1:4
    sig = S(k).sig;
    [t_out, sig_out] = refl_amp(t_temp, sig, band_pass, fs, average_point);
    S(k).sig = sig_out;
    S(k).ts = t_out(2) - t_out(1);
end
end

function [t_seg, PSD_seg] = compute_psd(S, ts_temp, t_temp, judge, fftpoint)
% 计算PSD
fs_temp = 1/ts_temp;
L_signal = length(S(1).sig);
t_signal = linspace(t_temp(1), t_temp(end), L_signal);

% 确定分段参数
if judge == 1
    fftpoint_val = 512*4;
else
    fftpoint_val = 512;
end
g = 5/4 * fftpoint_val;
max_segments = floor(2 * L_signal / fftpoint_val) - 1;
num_freq = fftpoint_val;

% 预分配PSD存储
PSD_temp = zeros(num_freq, 4, max_segments);
t_seg_temp = zeros(1, max_segments);
valid_segments = 0;

% 分段处理
m = 0;
while (m/2 + 1) * g < L_signal
    k = (m*g/2 + 1) : ((m/2 + 1) * g);
    m = m + 1;
    valid_segments = valid_segments + 1;
    t_seg_temp(m) = mean(t_signal(k));
    
    for ch = 1:4
        x = S(ch).sig(k);
        x = x - mean(x);
        [PSD, ~] = psd_me(x, fs_temp, fftpoint_val);
        PSD_temp(:, ch, m) = PSD;
    end
end

% 裁剪有效结果
t_seg = t_seg_temp(1:valid_segments);
PSD_seg = cell(1,4);
for ch = 1:4
    PSD_seg{ch} = PSD_temp(:, ch, 1:valid_segments);
end
end

% 保持原有的psd_me、refl_amp等函数不变