% 绘制pe和pe梯度图像
pe_c1 = te1 .* ne1 * 2 * 1.602;
pe_c2 = te2 .* ne2 * 2 * 1.602;

[dp1, x_mid1] = calculate_derivative(te_rho1, pe_c1);
[dp2, x_mid2] = calculate_derivative(te_rho2, pe_c2);

figure();
plot(te_rho1, pe_c1)
hold on
plot(te_rho2, pe_c2)
legend()
ylabel("P_e (kPa)")
xlabel("\rho")

figure()
plot(te_rho1, dp1)
hold on
plot(te_rho2, dp2)
legend()
ylabel("\Delta Pe")
xlabel("\rho")