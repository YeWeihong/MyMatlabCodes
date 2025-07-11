clc
clear
% close all
% shot=input('the pulse number:');
% time1=input('the start time:');
% time2=input('the end time:');
shot = 88001;
% 分析峰间时间间隔，提取间隔超过0.2秒的时间段
time_threshold = 0.12;  % 时间阈值 (秒)
time1 = 3.0;
time2 = 6.0;

treename_1='east';
% 初始化信号名列表
signal_names = cell(6, 1);
for i = 1:6
    signal_names{i} = ['\dau' num2str(i)];
end

% 连接MDSplus服务器并打开树
mdsconnect('mds.ipp.ac.cn');
mdsopen(treename_1, shot);

% 查找第一个有数据的信号
valid_signal_found = false;
signal_index = 0;

for i = 1:length(signal_names)
    signal_name = signal_names{i};
    
    try
        % 尝试读取信号
        y = mdsvalue(['_sig=' signal_name]);
        t = mdsvalue('dim_of(_sig)');
        
        % 检查数据有效性
        if ~isempty(y) && ~isempty(t) && all(isfinite(y)) && all(isfinite(t))
            signal_index = i;
            valid_signal_found = true;
            fprintf('成功读取信号: %s\n', signal_name);
            break;
        end
    catch ME
        % 捕获异常（如信号不存在）
        fprintf('读取信号 %s 失败: %s\n', signal_name, ME.message);
    end
end

% 处理结果
if valid_signal_found
    % 选择时间范围内的数据
    index = find(t >= time1 & t <= time2);
    signal1 = y(index);
    t_signal1 = t(index);
    
    % 检查截取后的数据是否有效
    if isempty(signal1) || isempty(t_signal1)
        error('在指定时间范围内未找到有效数据');
    end
    
    % 后续处理（例如寻峰）
    fprintf('数据读取成功，开始寻峰处理...\n');
    % 这里可以插入之前的寻峰代码
else
    error('所有信号均无有效数据');
end

%% findpeak
% 信号寻峰处理
% 信号参数
samplingRate = 250e3;  % 采样率 (Hz)
sampleInterval = 1/samplingRate;  % 采样间隔 (秒)

% 寻峰参数设置（基于时间间隔）
minPeakTime = 0.004;  % 最小峰间距 (秒)，可根据信号调整
minPeakHeight = 0.2 * max(abs(signal1));  % 最小峰高阈值
minPeakProminence = 0.1 * max(abs(signal1));  % 最小峰突出度

% 将时间间隔转换为样本点间隔
minPeakDistance = round(minPeakTime / sampleInterval);  % 样本点间隔

% 执行寻峰
[peakValues, peakLocations] = findpeaks(signal1, ...
                                        'MinPeakHeight', minPeakHeight, ...
                                        'MinPeakDistance', minPeakDistance, ...
                                        'MinPeakProminence', minPeakProminence);

% 将索引转换为时间点
peakTimes = t_signal1(peakLocations);

% 输出寻峰结果
fprintf('找到 %d 个峰\n', length(peakValues));
for i = 1:length(peakValues)
    fprintf('峰 %d: 时间 = %.4f s, 幅值 = %.4f\n', i, peakTimes(i), peakValues(i));
end

% 可视化寻峰结果
figure;
plot(t_signal1, signal1, 'b-', 'LineWidth', 1);
hold on;
plot(peakTimes, peakValues, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
title('信号寻峰结果');
xlabel('时间 (s)');
ylabel('信号幅值');
legend('原始信号', '检测到的峰');
hold on;
grid on;
%%

% 计算相邻峰之间的时间差
time_diffs = diff(peakTimes);

% 找到时间差超过阈值的位置
large_diff_indices = find(time_diffs > time_threshold);

% 提取对应的时间段
if ~isempty(large_diff_indices)
    % 初始化时间段数组 [开始时间, 结束时间]
    time_periods = zeros(length(large_diff_indices), 2);
    
    % 提取每个时间段的起始和结束时间点
    for i = 1:length(large_diff_indices)
        idx = large_diff_indices(i);
        time_periods(i, 1) = peakTimes(idx);     % 时间段开始时间
        time_periods(i, 2) = peakTimes(idx + 1); % 时间段结束时间
        
        % 输出时间段信息
        fprintf('时间段 %d: 开始时间 = %.4f s, 结束时间 = %.4f s, 间隔 = %.4f s\n', ...
                i, time_periods(i, 1), time_periods(i, 2), time_diffs(idx));
    end
    
    % 可视化时间段
    figure;
    plot(t_signal1, signal1, 'b-', 'LineWidth', 1);
    hold on;
    
    % 绘制原始峰点
    plot(peakTimes, peakValues, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
    
    % 标记时间段边界
    for i = 1:size(time_periods, 1)
        start_time = time_periods(i, 1);
        end_time = time_periods(i, 2);
        
        % 找到对应信号中的索引
        start_idx = find(t_signal1 >= start_time, 1, 'first');
        end_idx = find(t_signal1 <= end_time, 1, 'last');
        
        % 高亮显示时间段内的信号
        if ~isempty(start_idx) && ~isempty(end_idx)
            plot(t_signal1(start_idx:end_idx), signal1(start_idx:end_idx), 'g-', 'LineWidth', 2);
        end
        
        % 在图上标注时间段
        mid_time = (start_time + end_time) / 2;
        text(mid_time, max(signal1) * 0.9, ['时间段 ' num2str(i)], ...
             'HorizontalAlignment', 'center', 'BackgroundColor', 'white');
    end
    
    title('信号与提取的时间段');
    xlabel('时间 (s)');
    ylabel('信号幅值');
    legend('原始信号', '检测到的峰', '提取的时间段');
    grid on;
    
    % 保存时间段数据以供后续分析
    % save('extracted_time_periods.mat', 'time_periods');
    % fprintf('时间段数据已保存至 extracted_time_periods.mat\n');
else
    fprintf('警告: 没有找到时间间隔超过 %.2f 秒的峰对\n', time_threshold);
end