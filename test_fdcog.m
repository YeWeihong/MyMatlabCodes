% 生成测试IQ信号（带时变频率偏移）
Fs = 1e6;                    % 采样率1 MHz
t_total = 0.01;              % 总时长10 ms
t = 0:1/Fs:t_total;          % 时间序列（长度10001点）
f_offset = 5e3 + 1e3*sin(2*pi*50*t); % 频率偏移在5 kHz附近波动

IQ_signal = exp(1j*2*pi*f_offset.*t); % 复数信号

% 调用fdcog_me计算谱重心
nfft = 512;
overlap = 256;
[p, f, fd, A, tt] = fdcog_me_improved(IQ_signal, t, nfft, overlap, Fs);

% 绘制频谱图并标注重心
figure;
spectrogram_dB = 10*log10(abs(p)); % 转换为分贝单位
imagesc(tt, f, spectrogram_dB);    % 绘制频谱图
axis xy; colormap jet; colorbar;
hold on;

% 叠加绘制谱重心轨迹（红色曲线）
plot(tt, fd, 'r', 'LineWidth', 2);
xlabel('Time (s)'); ylabel('Frequency (Hz)');
title('Spectrogram with Frequency Centroid');
legend('Centroid', 'Location', 'northeast');

figure;
plot(f,spectrogram_dB(:,29));
% xlim([-10000,10000]);