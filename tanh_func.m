function [x_fit, y_fit] = tanh_func(x, y)
% TANH_FIT 使用tanh函数拟合数据
% 输入：
%   x - 输入数据的自变量（向量）
%   y - 输入数据的因变量（向量）
% 输出：
%   x_fit - 拟合曲线的自变量（100个均匀采样点）
%   y_fit - 拟合曲线对应的函数值

% 数据有效性验证
assert(numel(x) == numel(y), '输入向量x和y长度必须一致');
x = x(:); y = y(:);  % 转换为列向量

% 清除无效数据点
valid_idx = ~isnan(x) & ~isnan(y);
x = x(valid_idx);
y = y(valid_idx);
assert(~isempty(x), '有效数据点不足（去除NaN后）');

% 定义tanh拟合函数（参数化版本）
tanh_model = @(params, t) params(1)*tanh(params(2)*(t - params(3))) + params(4);

% 优化配置
options = optimoptions('lsqcurvefit', ...
    'Display', 'none', ...
    'MaxFunctionEvaluations', 2000);

% 初始参数猜测（可根据数据类型调整）
init_params = [median(y), 1/diff(quantile(x,[0.25 0.75])), median(x), mean(y)];

% 执行非线性最小二乘拟合
fit_params = lsqcurvefit(tanh_model, init_params, x, y, [], [], options);

% 生成拟合曲线
x_fit = linspace(min(x), max(x), 100)';
y_fit = tanh_model(fit_params, x_fit');

% 确保输出列向量
y_fit = y_fit(:);

% 可选：显示拟合参数
fprintf('拟合参数结果:\n');
fprintf('幅度 a = %.3f\n陡度 b = %.3f\n横移 c = %.3f\n纵移 d = %.3f\n', fit_params);
end