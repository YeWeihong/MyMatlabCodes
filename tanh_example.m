% Tanh函数拟合示例（MATLAB版本）
clear; clc; close all;

% 定义tanh拟合函数（匿名函数形式）
tanh_func = @(params, x) params(1) * tanh(params(2) * (x - params(3))) + params(4);
% 参数说明：
% params(1): 幅度缩放系数 (a)
% params(2): 输入缩放系数 (b)
% params(3): 水平平移参数 (c)
% params(4): 垂直平移参数 (d)

% 生成示例数据（带噪声）
rng(42); % 设置随机种子
x_data = linspace(-5, 5, 100);
true_params = [2.5, 1.2, 0.5, -1.0]; % [a, b, c, d]
y_data = tanh_func(true_params, x_data) + 0.2*randn(size(x_data));

% 执行曲线拟合
initial_guess = [1, 1, 0, 0]; % 初始参数猜测
options = optimoptions('lsqcurvefit', 'Display', 'off');
[params_fit, resnorm, residual, exitflag, output] = ...
    lsqcurvefit(tanh_func, initial_guess, x_data, y_data, [], [], options);

% 显示拟合结果
fprintf('拟合参数:\n');
fprintf('a = %.3f, b = %.3f, c = %.3f, d = %.3f\n', params_fit);
fprintf('\n真实参数:\n');
fprintf('a = %.1f, b = %.1f, c = %.1f, d = %.1f\n', true_params);

% 可视化结果
figure('Position', [100 100 800 600])
scatter(x_data, y_data, 40, 'filled', 'MarkerFaceAlpha',0.6,...
    'MarkerEdgeColor','none');
hold on;
plot(x_data, tanh_func(params_fit, x_data), 'r-', 'LineWidth', 2);
plot(x_data, tanh_func(true_params, x_data), 'g--', 'LineWidth', 2);
hold off;

% 图例和格式设置
legend('Noisy Data',...
    sprintf('Fit: a=%.2f, b=%.2f\n    c=%.2f, d=%.2f', params_fit),...
    'True Function',...
    'Location', 'southeast');
xlabel('x');
ylabel('y');
title('Tanh Function Fitting (MATLAB)');
grid on;
set(gca, 'FontSize', 12);
axis tight;