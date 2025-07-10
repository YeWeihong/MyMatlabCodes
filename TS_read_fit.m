% clear;clc;
shot = 93871;
% shot=79861;
t0=3.0;
mdsconnect('202.127.204.42');  
mdsopen('ts_east',shot);
Te_MAX=mdsvalue('\Te_maxTS');
t_Te_MAX=mdsvalue('dim_of(\Te_maxTS)');
Te_ori=mdsvalue('\Te_coreTS');
R=mdsvalue('\R_coreTS');
Z=mdsvalue('\Z_coreTS');
Te_err_ori=mdsvalue('\Te_coreTSerr');
ne_ori=mdsvalue('\ne_coreTS');
ne_err_ori=mdsvalue('\ne_coreTSerr');
t_Te_ori=mdsvalue('dim_of(\Te_coreTS)');
t_ne_ori=mdsvalue('dim_of(\ne_coreTS)');
mdsclose;
mdsdisconnect;
t_Te=Te_ori(1,:);           % Te_ori第一行是每一列的采样的时间点
Te=Te_ori(2:end,:)/1000;
Te_err=Te_err_ori(2:end,:)/1000;
ne=ne_ori(2:end,:)/1000;
ne_err=ne_err_ori(2:end,:)/1000;
[t0_1,t0_position]=min(abs(t_Te-t0));
t0_2=t_Te(t0_position);     % 获得采样时刻
icheck=1;
[npsip,nrhot,rhotb,Rin,Rout,redge]=exmap_mds(R,Z,t0_2,shot,icheck);
%% 绘图
% figure
% plot(nrhot,Te(:,t0_position),'*')
% legend(['shot:',num2str(shot),'-','t=',num2str(t0_2),'s']);set(gca,'FontSize',20,'LineWidth',3);
% xlabel('nrhot');ylabel('Te(keV)');
% figure
% title('Te')
% errorbar(nrhot,Te(:,t0_position),Te_err(:,t0_position),'o');
% legend(['shot:',num2str(shot),'-','t=',num2str(t0_2),'s']);set(gca,'FontSize',20,'LineWidth',3);
% xlabel('\rho');ylabel('Te(keV)');
% figure
% title('ne');
% errorbar(nrhot,ne(:,t0_position),ne_err(:,t0_position),'o');
% legend(['shot:',num2str(shot),'-','t=',num2str(t0_2),'s']);set(gca,'FontSize',20,'LineWidth',3);
% xlabel('\rho');ylabel('ne');

%% 拟合
[rhof, Tef] = tanh_func(nrhot, Te(:, t0_position));

errorbar(nrhot,Te(:,t0_position),Te_err(:,t0_position),'o',"MarkerFaceColor",[0.65 0.85 0.90]);
hold on;
plot(rhof, Tef, 'LineWidth', 2, 'Color', [0.85 0.12 0.38]);

title('TS-Te')
xlabel('\rho');
ylabel('Te(keV)');
legend(['shot:',num2str(shot) newline 't=',num2str(t0_2),'s'],'fit');
set(gca,'FontSize',16,'LineWidth',1);
hold on;
grid on;