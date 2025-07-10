shot = 87997;
time1 = 3.4;
time2 = 3.6;


[t_3D,f_3D,PSD1,PSD2,PSD3,PSD4,freq_inj] = DPRoutput(shot,time1,time2);
%% 绘制PSD图
psd = log10(sum(PSD3, 2)/length(PSD3));
normal_psd = (psd - min(psd))/(max(psd) - min(psd));
plot(f_3D,normal_psd,'red');
title([num2str(shot) '-' num2str(time1) '-' num2str(time2)])
xlim([0 100]);
xlabel("f (kHz)");
ylabel("PSD (a.u.)");
legend("DPR");
grid on;
