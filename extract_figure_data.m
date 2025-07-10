function [x, y] = extract_figure_data(varargin)
% 万能数据提取器，支持所有常规2D图表
% 输入参数：figure句柄/文件名（可选）
% 输出参数：x, y数据列向量

% ================== 参数预处理 ==================
if nargin > 0
    if ischar(varargin{1}) || isstring(varargin{1})
        h = openfig(varargin{1}); % 打开.fig文件
    else
        h = varargin{1};          % 直接使用figure句柄
    end
else
    h = gcf;                      % 无输入时获取当前figure
end

ax = findobj(h, 'Type', 'axes');  % 查找所有坐标系
if isempty(ax), error('图中未找到坐标系'); end
ax = ax(1);                       % 默认取第一个坐标系

% ================== 智能数据探测 ==================
data_sources = {'XData', 'YData';    % 支持的对象类型列表
                'XData', 'YData';
                'XData', 'YData';
                'XVectors', 'YVectors'};
obj_types = {'line', 'scatter', 'errorbar', 'image'};

% 按优先级搜索数据
for k = 1:length(obj_types)
    obj = findobj(ax, 'Type', obj_types{k});
    if ~isempty(obj)
        obj = obj(1); % 取第一个对象
        try
            x = get(obj, data_sources{k,1});
            y = get(obj, data_sources{k,2});
            % 特殊格式处理
            if strcmp(obj_types{k}, 'image')
                [x, y] = meshgrid(1:size(x,2), 1:size(y,1));
            end
            if ~isempty(x) && ~isempty(y)
                [x, y] = format_data(x, y); % 统一数据格式
                return;
            end
        catch
            continue;
        end
    end
end

% ================== 旧版errorbar处理 ==================
lines = findobj(ax, 'Type', 'line');
if ~isempty(lines)
    % 识别误差条特征线段
    is_errorbar = false;
    x = [];
    y = [];
    
    % 收集所有可能的候选点
    candidates = [];
    for k = 1:length(lines)
        l = lines(k);
        xd = l.XData; yd = l.YData;
        
        % 判断是否为中心数据点
        if length(xd) == 1 && length(yd) == 1
            candidates(end+1, :) = [xd, yd];
        end
        
        % 检查误差条结构
        if length(xd) == 2
            if xd(1) == xd(2) && abs(yd(1)-yd(2)) > 0 % 垂直误差
                candidates(end+1, :) = [xd(1), mean(yd)];
                is_errorbar = true;
            elseif yd(1) == yd(2) && abs(xd(1)-xd(2)) > 0 % 水平误差
                candidates(end+1, :) = [mean(xd), yd(1)];
                is_errorbar = true;
            end
        end
    end
    
    % 如果是errorbar则提取中心点
    if is_errorbar && ~isempty(candidates)
        [~, idx] = unique(round(candidates,4), 'rows', 'stable');
        data = candidates(idx, :);
        x = data(:,1);
        y = data(:,2);
        [x, y] = format_data(x, y);
        return;
    end
end

% ================== 最终异常处理 ==================
error(['无法自动提取数据，请检查：\n'...
       '1. 图中需包含至少一个二维数据系列\n'...
       '2. 不支持三维图表/极坐标\n'...
       '3. 可尝试先执行h = gca; h.Children查看数据对象']);

% ================== 子函数：统一数据格式 ==================
function [x_out, y_out] = format_data(x, y)
    % 确保列向量输出
    x_out = x(:);
    y_out = y(:);
    
    % 自动排序（当x为单调递增时）
    if ~issorted(x_out)
        try
            [x_out, idx] = sort(x_out);
            y_out = y_out(idx);
        catch
            % 非数值数据不排序
        end
    end
end

end