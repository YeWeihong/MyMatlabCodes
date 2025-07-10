function [dy_dx, x_mid] = calculate_derivative(x, y, method)
% CALCULATE_DERIVATIVE 计算离散数据的一阶导数
% 输入：
%   x      - 自变量数据（向量）
%   y      - 因变量数据（向量）
%   method - 差分方法（可选）：
%            'auto'    - 自动选择（默认）
%            'central' - 中心差分
%            'forward' - 前向差分
%            'backward'- 后向差分
% 输出：
%   dy_dx  - 导数值（列向量）
%   x_mid  - 对应的中点x坐标（列向量）

% 输入校验
assert(nargin >= 2, '必须提供x和y数据');
assert(isvector(x) && isvector(y), '输入必须是向量');
assert(numel(x) == numel(y), 'x和y必须长度相同');
x = x(:);  % 强制转换为列向量
y = y(:);
assert(numel(x) >= 2, '至少需要2个数据点');
if nargin < 3 || isempty(method)
    method = 'auto';
end

% 检查数据单调性
[~, idx] = sort(x);
if any(diff(idx) ~= 1)
    warning('数据未排序，将进行排序处理');
    [x, sort_idx] = sort(x);
    y = y(sort_idx);
end

% 自动检测数据间隔
dx = diff(x);
if strcmpi(method, 'auto')
    if all(abs(dx - dx(1)) < 1e-10)
        method = 'central';
    else
        method = 'gradient';
    end
end

% 选择计算方法
switch lower(method)
    case 'central'
        % 中心差分法（等间距优化）
        dy = (y(3:end) - y(1:end-2)) ./ (x(3:end) - x(1:end-2));
        x_mid = (x(3:end) + x(1:end-2))/2;
        % 边界处理
        dy = [ (y(2)-y(1))/(x(2)-x(1)); dy; (y(end)-y(end-1))/(x(end)-x(end-1)) ];
        x_mid = [x(1); x_mid; x(end)];
        
    case 'gradient'
        % 非等间距梯度法
        dy_dx = gradient(y) ./ gradient(x);
        x_mid = x;
        
    case 'forward'
        % 前向差分
        dy_dx = (y(2:end) - y(1:end-1)) ./ (x(2:end) - x(1:end-1));
        x_mid = (x(2:end) + x(1:end-1))/2;
        % 右边界扩展
        dy_dx = [dy_dx; dy_dx(end)];
        x_mid = [x_mid; x(end)];
        
    case 'backward'
        % 后向差分
        dy_dx = (y(2:end) - y(1:end-1)) ./ (x(2:end) - x(1:end-1));
        x_mid = (x(2:end) + x(1:end-1))/2;
        % 左边界扩展
        dy_dx = [dy_dx(1); dy_dx];
        x_mid = [x(1); x_mid];
        
    otherwise
        error('不支持的差分方法: %s', method);
end

% 统一输出格式
if exist('dy_dx', 'var')
    dy_dx = dy_dx(:);
    x_mid = x_mid(:);
else
    dy_dx = dy(:);
    x_mid = x_mid(:);
end

% 可视化验证（可选）
if nargout == 0
    figure
    subplot(2,1,1)
    plot(x, y, 'b-o')
    title('原始数据')
    
    subplot(2,1,2)
    plot(x_mid, dy_dx, 'r-s')
    title('一阶导数')
    xlabel('x')
    ylabel('dy/dx')
    grid on
end
end