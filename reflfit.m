% 从当前Figure提取数据（支持Scatter/Line/Errorbar）
fig = gcf;
ax = fig.CurrentAxes;

% 查找数据对象（新增errorbar支持）
h = [];
obj_types = {'scatter', 'line', 'errorbar'};
for k = 1:length(obj_types)
    h = [h; findobj(ax, 'Type', obj_types{k})]; %#ok<AGROW>
end

% 提取数据主循环
R = [];
n = [];
for k = 1:length(h)
    % 处理errorbar对象
    if strcmpi(h(k).Type, 'errorbar')
        % 提取误差条数据主体
        child_objs = h(k).Children;
        data_line = findobj(child_objs, 'Tag', 'data');
        if ~isempty(data_line)
            R = [R; data_line.XData(:)]; %#ok<AGROW>
            n = [n; data_line.YData(:)]; %#ok<AGROW>
        end
    else
        % 处理常规对象
        R = [R; h(k).XData(:)]; %#ok<AGROW>
        n = [n; h(k).YData(:)]; %#ok<AGROW>
    end
end

[R, idx] = sort(R);
n = n(idx);

% 数据预处理：选择有效拟合区域（根据实际情况调整阈值）
valid_idx = R > 0.0 & R <1.1;  % 类似原函数中的阈值截断
R_fit = R(valid_idx);
n_fit = n(valid_idx);

% 自动估算初始参数（可根据实际数据调整逻辑）
ped_pos_guess = median(R_fit);            % 位形中心初始猜测
h_guess = max(n_fit) - min(n_fit);        % 高度差
w_guess = (max(R_fit)-min(R_fit))/10;     % 宽度初始猜测
B0 = min(n_fit) + 0.1 * (h_guess);

% 构建初始参数向量（与原函数参数结构一致）
%                    alpha                          beta
a0 = [h_guess/2, B0, 0.0, ped_pos_guess, w_guess, 0];

% 执行非线性拟合（已修正beta参数问题）
opts = statset('Display', 'iter', 'MaxIter', 1000);
[fit_params, ~, ~] = nlinfit(R_fit, n_fit, @MTANH, a0, opts);

% 计算拟合结果指标
x_fine = linspace(min(R_fit), max(R_fit), 500);
y_fit = MTANH(fit_params, x_fine);
nped = fit_params(1) + fit_params(2);      % 基底密度
nwidth = fit_params(5);                    % 特征宽度
gradient = abs(diff(y_fit)./diff(x_fine)); % 计算梯度
max_grad = max(gradient);                  % 最大梯度

% 可视化结果
figure;
scatter(R, n, 40, 'filled', 'MarkerEdgeColor', [0.2 0.2 0.2],...
    'MarkerFaceColor', [0.7 0.7 1], 'DisplayName', '原始数据');
hold on;
plot(x_fine, y_fit, 'r-', 'LineWidth', 2, 'DisplayName', 'MTANH拟合');

% 计算宽度边界位置
x0 = fit_params(4);
w = fit_params(5);
width_start = x0 - w/2;
width_end = x0 + w/2;

% 绘制特征位置标记
xline(width_start, '--', 'Color', [0.2 0.6 0.2], 'LineWidth', 1.5,...
    'DisplayName', '宽度起点');
xline(width_end, '--', 'Color', [0.2 0.6 0.2], 'LineWidth', 1.5,...
    'DisplayName', '宽度终点');
xline(x0, 'g--', 'LineWidth', 1.5, 'DisplayName', '中心位置');

% 添加宽度范围填充区域（可选）
% ylim = get(gca, 'YLim');
% fill([width_start width_end width_end width_start],...
%     [ylim(1) ylim(1) ylim(2) ylim(2)], [0.9 0.9 0.9],...
%     'FaceAlpha', 0.3, 'EdgeColor', 'none', 'DisplayName', '特征宽度');

% 添加文本标注
text(width_start, min(y_fit), sprintf('%.3f', width_start),...
    'HorizontalAlignment', 'right', 'VerticalAlignment', 'top',...
    'Color', [0.2 0.6 0.2], 'FontWeight', 'bold');
text(width_end, min(y_fit), sprintf('%.3f', width_end),...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'top',...
    'Color', [0.2 0.6 0.2], 'FontWeight', 'bold');
text(x0, max(y_fit), sprintf('w = %.3f', w),...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom',...
    'Color', 'k', 'FontWeight', 'bold');

xlabel('\rho');
ylabel('ne (10^{19} m^{-3})');
title(sprintf('等离子体密度剖面MTANH拟合 (w=%.3f)', w));
legend('Location', 'best');
grid on;


% 显示关键参数
disp('======= 拟合结果 =======');
fprintf('基底密度 nped: %.3f ×10^{19}m^{-3}\n', nped);
fprintf('特征宽度 w: %.4f m\n', nwidth);
fprintf('最大梯度: %.3f ×10^{19}m^{-3}/m\n', max_grad);
fprintf('中心位置 x0: %.3f m\n', fit_params(4));

% 定义修正后的MTANH函数（beta参数已启用）
function y = MTANH(a, x)
    % 参数解析
    A = a(1);
    B = a(2);
    alpha = a(3);
    x0 = a(4);
    w = a(5);
    beta = a(6);
    
    % 计算归一化坐标
    z = (x0 - x) / (w/2);
    
    % 数值稳定性处理
    z(z < -700) = -700;
    z(z > 700) = 700;
    
    % 改进的MTANH计算（已修正beta参数）
    numerator = (1 + alpha*z).*exp(z) - (1 + beta*z).*exp(-z);
    denominator = exp(z) + exp(-z);
    mtanh = numerator ./ denominator;
    
    % 最终输出
    y = A .* mtanh + B;
end