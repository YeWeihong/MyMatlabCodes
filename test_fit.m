% 生成测试数据
x = linspace(-3, 5, 200)';
y = 2.8*tanh(0.9*(x - 1.4)) - 0.5 + 0.3*randn(size(x));

% 执行拟合
[xf, yf] = tanh_func(x, y);

% 可视化结果
figure;
scatter(x, y, 'filled', 'MarkerFaceAlpha',0.4);
hold on;
plot(xf, yf, 'LineWidth', 2, 'Color', [0.85 0.12 0.38]);
xlabel('输入特征'); ylabel('观测值');
title('Tanh函数拟合演示');
legend('原始数据', '拟合曲线', 'Location', 'southeast');