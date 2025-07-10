 clear;
% close all;
shot = 83219;
time1 =2.5;
time2 =3.2;

  card_name = {'5105A'};
%  card_name = {'Doppler'};
% card_name = {'O_P1','O_P2','V_P1','V_P2','U_P1','U_P2','W_P2','W_P2'};
%  card_name = {'U_P1','U_P2','W_P2','W_P2'};
%card_name = {'O_P1','O_P2'};
for i = 1:size(card_name,2)
    K_reflfluc_psd_longtime_datacheck(num2str(shot),time1,time2,card_name{i});    
end