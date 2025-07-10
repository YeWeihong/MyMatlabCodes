press = [1.40967, 2.06065, 2.38105, 2.72221, 3.43164];
width = [0.04, 0.06, 0.07, 0.08, 0.1];
pointx = 0.0559078216088097;
pointy = 1.92702046334115;

exp_pointx = 0.0906619;
exp_pointy = 2.46402;

%% PBM
x1 = width;
y1 = press;
p = polyfit(x1, y1, 1);
a = p(1);  % 斜率
b = p(2);  % 截距

fprintf('拟合结果: y = %.4fx + %.4f\n', a, b);
y_fit = polyval(p, x1);

% 绘制原始数据和拟合直线
figure();
plot(x1, y1, 'bo');
hold on;
plot(x1, y_fit, 'b-', 'DisplayName', 'PBM stability boundary');
legend;

grid on;
hold on;
%% KBM
cc = 0.12;
Ipp = 0.4090414e6;  % plasma current, in Ampere
polline = 3.4411625; % length of the poloidal perimeter of the plasma, in m
mu0 = 4.* 3.14159 * 1.e-7;
x2 = linspace(0, 0.1, 51);
betap_ped = (x2/cc).^2;
y2 = 0.5e-3 * betap_ped * mu0 * Ipp^2 / polline^2;

plot(x2, y2, 'g--', 'DisplayName', 'KBM stability boundary',LineWidth=1.5)
hold on;
%% solve
scatter(pointx, pointy, 'r*', 'DisplayName', 'REPED Predict pedestal')
xlabel('Pedestal width (\psi)');
ylabel('Pedestal height (P_{ped}, kPa)');
title_str = sprintf('[Width = %.4f, Height = %.4f]', pointx, pointy);
title(title_str);
%% experimental
scatter(exp_pointx, exp_pointy, 'red', 'DisplayName', 'Experimental point');
%% y3
cc3 = 0.172;
betap_ped3 = (x2/cc3).^2;
y3 = 0.5e-3 * betap_ped3 * mu0 * Ipp^2 / polline^2;
plot(x2, y3, '--',LineWidth=1.5)