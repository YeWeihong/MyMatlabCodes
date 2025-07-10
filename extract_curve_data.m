function [x, y] = extract_curve_data(fig_file, x_range, step)
% EXTRACT_CURVE_DATA 从figure文件提取曲线数据
% 输入参数：
%   fig_file - .fig文件路径（必需）
%   x_range - x取值范围 [默认值: [0.6, 1]]
%   step    - 采样间隔 [默认值: 0.01]
% 输出参数：
%   x, y - 提取的数据点（列向量）

% 参数校验与默认值处理
if nargin < 1
    error('必须指定figure文件路径');
end
if nargin < 2 || isempty(x_range)
    x_range = [0.6, 1];  % 默认提取范围
end
if nargin < 3 || isempty(step)
    step = 0.01;          % 默认采样间隔
end

% 验证参数有效性
assert(numel(x_range)==2 && x_range(1)<=x_range(2),...
    'x_range必须是包含两个元素的递增向量');
assert(step > 0, '采样间隔必须为正数');

% 加载figure文件
if ~exist(fig_file, 'file')
    error('文件不存在: %s', fig_file);
end
fig = openfig(fig_file, 'invisible');  % 静默加载

% 获取坐标轴和曲线对象
try
    ax = findall(fig, 'Type', 'axes');
    if isempty(ax)
        error('未找到坐标轴');
    end
    ax = ax(1);  % 默认取第一个坐标轴
    
    lines = findobj(ax, 'Type', 'line');
    if isempty(lines)
        error('未找到曲线对象');
    end
    % 提取第一条曲线的原始数据
    x_data = lines(1).XData(:);
    y_data = lines(1).YData(:);
    
    % 数据预处理
    data_sorted = sortrows([x_data, y_data],1);
    x_sorted = data_sorted(:,1);
    y_sorted = data_sorted(:,2);
    
    % 确定有效范围
    in_range = (x_sorted >= x_range(1)) & (x_sorted <= x_range(2));
    if any(in_range)
        valid_x = x_sorted(in_range);
        x_start = x_range(1);          % 用户指定的起始值
        x_end = min(x_range(2), max(valid_x));  % 有效终止值
    else
        x_end = max(x_sorted);
        x_start = x_end;  % 退化情况处理
    end
    
    % 生成采样点
    xq = (x_start : step : x_end)';
    if isempty(xq)  % 当间隔过大的处理
        xq = x_start;
    end
    
    % 执行插值
    if numel(x_sorted) > 1
        yq = interp1(x_sorted, y_sorted, xq, 'linear', 'extrap');
    else
        yq = repmat(y_sorted, size(xq));  % 单点特例
    end
    
    % 确保列向量输出
    x = xq(:);
    y = yq(:);
    
catch ME
    close(fig);
    rethrow(ME);
end

% 清理资源
close(fig);
end