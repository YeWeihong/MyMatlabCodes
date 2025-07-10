clc
clear
% close all
% shot=input('the pulse number:');
% time1=input('the start time:');
% time2=input('the end time:');
shot = 80490;
time1 = 2.6;
time2 = 3.1;

fftpoint = 128 * 2;
%% 信号1
treename_1='east';
signalname_1 = '\uois07'; %'\lois07'; %'\hrs05h' point_n1
%% filter?
filter_judge = 1;
%%
% treename_1='east';
% signalname_1='\hrs05h';
mdsconnect('mds.ipp.ac.cn');
%download and choose the data
mdsopen(treename_1,shot)
y=mdsvalue(['_sig=' signalname_1]);
t=mdsvalue('dim_of(_sig)');
index=find(t>=time1&t<=time2);
signal1=y(index);
t_signal1=t(index);
%clear t y
%%
figure();
plot(t_signal1, signal1);
title(signalname_1)
xlabel('t(s)')
% ylabel('a.u.')
%% 滤波，降噪
if filter_judge
    y_filt = combined_filter(t_signal1, signal1, 31,31);
    figure();
    plot(t_signal1, y_filt);
    title(signalname_1)
    xlabel('t(s)')
else
    disp('no filter');
end
%% 计算增长率
% compute_derivative(t_signal1, y_filt,'spline')
%%
function y_filtered = combined_filter(x, y, median_window, avg_window)
    % COMBINED_FILTER 组合中值滤波和递推平均滤波
    % 输入参数:
    %   x - 自变量向量(如时间、空间坐标等)
    %   y - 因变量向量(待滤波的数据)
    %   median_window - 中值滤波窗口大小(建议奇数)
    %   avg_window - 递推平均滤波窗口大小
    % 输出参数:
    %   y_filtered - 滤波后的数据向量
    
    % 检查输入参数
    if nargin < 4
        error('至少需要4个输入参数: x, y, median_window, avg_window');
    end
    
    % 确保x和y长度相同
    if length(x) ~= length(y)
        error('x和y必须具有相同的长度');
    end
    
    % 1. 中值滤波 - 去除脉冲噪声
    % 如果数据是均匀采样的，可以直接使用medfilt1
    if isuniform(x)
        y_median = medfilt1(y, median_window);
    else
        % 对于非均匀采样数据，使用基于索引的中值滤波
        y_median = y;
        half_window = floor(median_window/2);
        
        for i = 1:length(y)
            % 确定当前点的窗口范围
            left_idx = max(1, i - half_window);
            right_idx = min(length(y), i + half_window);
            
            % 提取窗口内的数据并计算中值
            window_data = y(left_idx:right_idx);
            y_median(i) = median(window_data);
        end
    end
    
    % 2. 递推平均滤波 - 平滑随机噪声
    y_filtered = y_median;
    
    % 如果数据是均匀采样的，使用高效的滑动窗口实现
    if isuniform(x)
        % 使用conv实现滑动平均(更高效)
        avg_kernel = ones(1, avg_window) / avg_window;
        y_filtered = conv(y_median, avg_kernel, 'same');
    else
        % 对于非均匀采样数据，使用基于索引的递推平均
        for i = 1:length(y)
            % 确定当前点的窗口范围
            left_idx = max(1, i - floor(avg_window/2));
            right_idx = min(length(y), i + floor(avg_window/2));
            
            % 提取窗口内的数据并计算平均值
            window_data = y_median(left_idx:right_idx);
            y_filtered(i) = mean(window_data);
        end
    end
end

% 判断数据是否均匀采样的辅助函数
function result = isuniform(x)
    % 计算相邻点之间的差值
    diffs = diff(x);
    
    % 检查差值的变化是否小于一个小阈值
    result = max(abs(diffs - mean(diffs))) < 1e-10;
end

function compute_derivative(x, y, method, plot_title)
    % COMPUTE_DERIVATIVE 计算并绘制y随x的一阶导数
    % 输入:
    %   x - 自变量向量
    %   y - 因变量向量
    %   method - 导数计算方法，可选: 'central'（中心差分，默认）, 'forward'（前向差分）, 'spline'（样条插值）
    %   plot_title - 图表标题（可选）
    
    % 检查输入参数
    if nargin < 2
        error('至少需要输入x和y向量');
    end
    
    if nargin < 3
        method = 'central'; % 默认使用中心差分法
    end
    
    if nargin < 4
        plot_title = sprintf('y随x的一阶导数 (方法: %s)', method);
    end
    
    % 确保x和y是列向量
    x = x(:);
    y = y(:);
    
    % 检查x是否严格递增
    if any(diff(x) <= 0)
        [x, idx] = sort(x);
        y = y(idx);
        warning('x不是严格递增的，已排序');
    end
    
    % 计算导数
    switch lower(method)
        case 'central'
            % 中心差分法（更精确，适用于平滑数据）
            dx = diff(x);
            dy = diff(y);
            dydx = zeros(size(y));
            
            % 中间点使用中心差分
            dydx(2:end-1) = (dy(2:end) + dy(1:end-1)) ./ (dx(2:end) + dx(1:end-1));
            
            % 端点使用单边差分
            dydx(1) = dy(1) / dx(1);
            dydx(end) = dy(end) / dx(end);
            
        case 'forward'
            % 前向差分法（简单，适用于非平滑数据）
            dx = diff(x);
            dy = diff(y);
            dydx = zeros(size(y));
            
            % 除最后一点外的所有点
            dydx(1:end-1) = dy ./ dx;
            
            % 最后一点使用向后差分
            dydx(end) = (y(end) - y(end-1)) / (x(end) - x(end-1));
            
        case 'spline'
            % 样条插值法（平滑，适用于噪声数据）
            xx = linspace(min(x), max(x), 10*length(x)); % 插值到更密集的点
            
            % 创建样条插值结构体
            spl = spline(x, y);
            
            % 计算导数（使用fnval函数）
            dydx_spline = fnval(fnder(spl, 1), xx);
            
            % 将结果插值回原始x点
            dydx = interp1(xx, dydx_spline, x, 'linear');
            
        otherwise
            error('未知的方法，请选择: central, forward, spline');
    end
    
    % 绘制结果
    figure('Position', [100, 100, 800, 600]);
    
    % 绘制原始数据
    subplot(2, 1, 1);
    plot(x, y, 'b-', 'LineWidth', 1.5);
    title('原始数据');
    xlabel('x');
    ylabel('y');
    grid on;
    
    % 绘制导数
    subplot(2, 1, 2);
    plot(x, dydx, 'r-', 'LineWidth', 1.5);
    title(plot_title);
    xlabel('x');
    ylabel('\frac{dy}{dx}');
    grid on;
    
    % 如果是spline方法，同时绘制插值后的导数曲线
    if strcmpi(method, 'spline')
        hold on;
        plot(xx, dydx_spline, 'g--', 'LineWidth', 1);
        legend('计算点导数', '插值平滑导数');
        hold off;
    end
    
    % 调整布局
    sgtitle(sprintf('y = f(x) 及其一阶导数 (N = %d)', length(x)), 'FontSize', 14);
    set(gcf, 'Color', 'white');
end