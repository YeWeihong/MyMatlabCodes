function [p, f, fd, A, tt] = fdcog_me_improved(y, t, nfft, overlap, Fs)
tic;
% 分帧计算
N = floor((length(y) - overlap) / (nfft - overlap)); % 总帧数
col = 1 + (0:(N-1)) * (nfft - overlap); % 每帧起始索引
row = (1:nfft)';
mask = row(:, ones(1, N)) + col(ones(nfft, 1), :) - 1; % 分帧索引矩阵

% 加窗与FFT
window = hamming(nfft);
window_energy = sum(window.^2); % 窗函数能量
y_windowed = y(mask) .* window(:, ones(1, N)); % 应用汉明窗
y_fft = fft(y_windowed); % 使用加窗数据计算FFT

% 功率谱计算
p = fftshift(abs(y_fft).^2 ./ (Fs * window_energy), 1); % 修正归一化
f = (-nfft/2 : nfft/2-1) * (Fs / nfft); % 频率轴

% 计算频率重心（排除直流）
pp = p(2:end, :); % 去除直流分量
ff = f(2:end)';
fd = sum(ff .* pp, 1) ./ sum(pp, 1); % 加权平均频率

% 总功率与时间戳
A = sum(pp, 1);
tt = mean(t(mask), 1);

toc;
end