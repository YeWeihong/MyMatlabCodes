shot = 90774
time1 = 2.86
time2 = 2.88


shot2018O = [76181:80699];
shot2018X = [80710:81692];

shot2019 = [83218:94686];
shot2020 = [94688:97422];
shot2021 = [97423:107851];
shot2022 = [107960:120623];
shot2023 = [121675:137931];
shot2024 = [132043:148211];

%% 文件位置
if ismember(shot,shot2018O)
    data_path='X:\reflfluc2\Refl_Fluc_2018\O_20-40';
    filepathxx = 'E:\2018EHOlikeshotnbipng\';
    card_name = 'Doppler';
elseif ismember(shot,shot2018X)
    data_path='X:\reflfluc2\Refl_Fluc_2018\X_W';
    filepathxx = 'E:\2018EHOlikeshotnbipng\';
    card_name = 'Doppler';
elseif ismember(shot, shot2019)
    data_path='X:\reflfluc2\Refl_Fluc_2019';
    filepathxx = 'E:\2019EHOlikeshotnbipng\';
    card_name = 'Doppler';
elseif ismember(shot, shot2020)
    data_path='X:\reflfluc2\Refl_Fluc_2020';
    filepathxx = 'E:\2020EHOlikeshotnbipng\';
    card_name = 'Doppler';
elseif ismember(shot, shot2021)
    data_path='X:\reflfluc2\Refl_Fluc_2021';
    filepathxx = 'E:\2021EHOlikeshot2\';
    card_name = 'Doppler';
elseif ismember(shot, shot2022)
    data_path='X:\reflfluc2\Refl_Fluc_2022';
    filepathxx = 'E:\2022EHOlikeshot\';
    card_name = 'O_P1';
elseif ismember(shot, shot2023)
    data_path='X:\reflfluc2\Refl_Fluc_2023';
    filepathxx = 'E:\2023EHOlikeshot\';
    card_name = 'O_P1';
elseif ismember(shot, shot2024)
    data_path='X:\reflfluc2\Refl_Fluc_2024';
    filepathxx = 'E:\2024EHOlikeshot\';
    card_name = 'O_P1';
else
    disp('Shot num error!!')
end

% clc
% clear
% close all
% shot=input('shot number:','s');
% time1=input('the start time:');
% time2=input('the end time:');
time_span=[time1 time2];
 % data_path='V:\reflfluc\Refl_Fluc_2018\O_20-40';
 % data_path = 'V:\reflfluc\Refl_Fluc_2018\X_W';
 % data_path = 'V:\reflfluc\Refl_Fluc_2021';
% data_path='V:\reflfluc\Refl_Fluc_2018\O_20-40';
% filepathxx = 'F:\2018EHOlikeshot\';
%% 
fs=20*10^6;
% time_delay=7.012*10^-3;
time_delay=6.993*10^-3;
judge=2;
% card_name='U_P2';
%%
if strcmp(card_name,'O_P1')|strcmp(card_name,'O_P2')
    freq_inj=[20.4 24.8 33 40];  
elseif strcmp(card_name,'U_P1')|strcmp(card_name,'U_P2')
    freq_inj=[42.4 48 52.6 57.2];
elseif strcmp(card_name,'V_P1')|strcmp(card_name,'V_P2')
    freq_inj=[61.2 65.6 69.2 73.6];
elseif strcmp(card_name,'W_P1')|strcmp(card_name,'W_P2')
    freq_inj=[79.2 85.2 91.8 96];
elseif strcmp(card_name,'5105A')|strcmp(card_name,'5105A')
    freq_inj=[20.4 24.8 33 40];
elseif strcmp(card_name,'5105B')|strcmp(card_name,'5105B')
    freq_inj=[20.4 24.8 33 40];
elseif strcmp(card_name,'5105C')|strcmp(card_name,'5105C')
    freq_inj=[20.4 24.8 33 40];    
elseif strcmp(card_name,'Doppler')
    freq_inj=[56 61 66 70]; 
end
%% 主程序

nfft = 4096;
overlap = nfft/2;

[S1, S2, S3, S4]=genIQ(shot,time_span,card_name,data_path,fs,time_delay);
DATA = S4;
L_signal=length(DATA);
t_signal=linspace(time1,time2,L_signal);

[p, f, fd, A, tt] = fdcog_me_improved(DATA, t_signal, nfft, overlap, fs);

% 绘制频谱图并标注重心
figure;
spectrogram_dB = 10*log10(abs(p));      % 转换为分贝单位
imagesc(tt, f/1000, spectrogram_dB);    % 绘制频谱图
axis xy; colormap jet; colorbar;
hold on;

% 叠加绘制谱重心轨迹（红色曲线）
plot(tt, fd/1000, 'blue', 'LineWidth', 2);
xlabel('Time (s)'); ylabel('Frequency (kHz)');
ylim([-100,100])
title('Spectrogram with Frequency Centroid');
legend('Centroid', 'Location', 'northeast');

figure;
plot(f,spectrogram_dB(:,150));

%% 计算IQ信号
fclose('all');
function [S1, S2, S3, S4]=genIQ(shot,time_span,card_name,data_path,fs,time_delay)
shotxx = num2str(shot);
if strcmp(card_name,'O_P1')
    filename=[data_path '\' shotxx '\O_P1.bin'];
    row_1=[5 6];  %RF=20.4GHz, LO=28GHz, IF=+7.6 GHz (LO>RF)
    row_2=[1 2];  %RF=24.8GHz, LO=28GHz, IF=+3.2 GHz (LO>RF)
    row_3=[3 4];  %RF=33GHz, LO=28GHz, IF=-5 GHz   (LO<RF)
    row_4=[7 8];  %RF=40GHz, LO=28GHz, IF=-12 GHz  (LO<RF)
    IQ_sign=[1 1 -1 -1];     
 elseif strcmp(card_name,'O_P2')
    filename=[data_path '\' shotxx '\O_P2.bin'];  
    row_1=[5 6];  %RF=20.4GHz, LO=28GHz, IF=+7.6 GHz (LO>RF)
    row_2=[1 2];  %RF=24.8GHz, LO=28GHz, IF=+3.2 GHz (LO>RF)
    row_3=[3 4];  %RF=33GHz, LO=28GHz, IF=-5 GHz   (LO<RF)
    row_4=[7 8];  %RF=40GHz, LO=28GHz, IF=-12 GHz  (LO<RF)
    IQ_sign=[1 1 -1 -1];  
 elseif strcmp(card_name,'U_P1')
    filename=[data_path '\' shotxx '\U_P1.bin'];  
    row_1=[5 6];  %RF=42.4GHz, LO=49.2GHz, IF=+6.8 GHz (LO>RF)
    row_2=[1 2];  %RF=48GHz, LO=49.2GHz, IF=+1.2 GHz (LO>RF)
    row_3=[3 4];  %RF=52.6GHz, LO=49.2GHz, IF=-3.4 GHz   (LO<RF)
    row_4=[7 8];  %RF=57.2GHz, LO=49.2GHz, IF=-8 GHz  (LO<RF)
    IQ_sign=[1 1 1 1];  
 elseif strcmp(card_name,'U_P2')
    filename=[data_path '\' shotxx '\U_P2.bin'];  
    row_1=[5 6];  %RF=42.4GHz, LO=49.2GHz, IF=+6.8 GHz (LO>RF)
    row_2=[1 2];  %RF=48GHz, LO=49.2GHz, IF=+1.2 GHz (LO>RF)
    row_3=[3 4];  %RF=52.6GHz, LO=49.2GHz, IF=-3.4 GHz   (LO<RF)
    row_4=[7 8];  %RF=57.2GHz, LO=49.2GHz, IF=-8 GHz  (LO<RF)
    IQ_sign=[1 1 -1 -1];   
 elseif strcmp(card_name,'V_P1')
    filename=[data_path '\' shotxx '\V_P1.bin']; 
    row_1=[1 2];  %RF=61.2GHz, LO=58.4GHz, IF=-2.8 GHz (LO<RF)
    row_2=[3 4];  %RF=65.6GHz, LO=58.4GHz, IF=-7.2 GHz (LO<RF)
    row_3=[5 6];  %RF=69.2GHz, LO=58.4GHz, IF=-10.8 GHz   (LO<RF)
    row_4=[7 8];  %RF=73.6GHz, LO=58.4GHz, IF=-15.2 GHz  (LO<RF)
    IQ_sign=[-1 -1 -1 -1];   
 elseif strcmp(card_name,'V_P2')
    filename=[data_path '\' shotxx '\V_P2.bin'];  
    row_1=[1 2];  %RF=61.2GHz, LO=58.4GHz, IF=-2.8 GHz (LO<RF)
    row_2=[3 4];  %RF=65.6GHz, LO=58.4GHz, IF=-7.2 GHz (LO<RF)
    row_3=[5 6];  %RF=69.2GHz, LO=58.4GHz, IF=-10.8 GHz   (LO<RF)
    row_4=[7 8];  %RF=73.6GHz, LO=58.4GHz, IF=-15.2 GHz  (LO<RF)
    IQ_sign=[-1 -1 -1 -1];   
 elseif strcmp(card_name,'W_P1')
    filename=[data_path '\' shotxx '\W_P1.bin']; 
    row_1=[7 8];  %RF=79.2GHz, LO=89.4GHz, IF=+10.2 GHz (LO>RF)
    row_2=[3 4];  %RF=85.2GHz, LO=89.4GHz, IF=+4.2 GHz (LO>RF)
    row_3=[1 2];  %RF=91.8GHz, LO=89.4GHz, IF=-2.4 GHz   (LO<RF)
    row_4=[5 6];  %RF=96GHz, LO=89.4GHz, IF=-6.6 GHz  (LO<RF)
    IQ_sign=[1 1 1 1];   
 elseif strcmp(card_name,'W_P2')
    filename=[data_path '\' shotxx '\W_P2.bin']; 
    row_1=[7 8];  %RF=79.2GHz, LO=89.4GHz, IF=+10.2 GHz (LO>RF)
    row_2=[3 4];  %RF=85.2GHz, LO=89.4GHz, IF=+4.2 GHz (LO>RF)
    row_3=[1 2];  %RF=91.8GHz, LO=89.4GHz, IF=-2.4 GHz   (LO<RF)
    row_4=[5 6];  %RF=96GHz, LO=89.4GHz, IF=-6.6 GHz  (LO<RF)
    IQ_sign=[1 1 -1 -1];   
 elseif strcmp(card_name,'5105B')
    filename=[data_path '\' shotxx '\5105B.bin'];  
    row_1=[5 6];  %RF=20.4GHz, LO=28GHz, IF=+7.6 GHz (LO>RF)
    row_2=[1 2];  %RF=24.8GHz, LO=28GHz, IF=+3.2 GHz (LO>RF)
    row_3=[3 4];  %RF=33GHz, LO=28GHz, IF=-5 GHz   (LO<RF)
    row_4=[7 8];  %RF=40GHz, LO=28GHz, IF=-12 GHz  (LO<RF)
    IQ_sign=[1 1 -1 -1];   
 elseif strcmp(card_name,'5105A')
    filename=[data_path '\' shotxx '\5105A.bin'];  
    row_1=[5 6];  %RF=20.4GHz, LO=28GHz, IF=+7.6 GHz (LO>RF)
    row_2=[1 2];  %RF=24.8GHz, LO=28GHz, IF=+3.2 GHz (LO>RF)
    row_3=[3 4];  %RF=33GHz, LO=28GHz, IF=-5 GHz   (LO<RF)
    row_4=[7 8];  %RF=40GHz, LO=28GHz, IF=-12 GHz  (LO<RF)
    IQ_sign=[1 1 -1 -1];     
elseif strcmp(card_name,'5105C')
    filename=[data_path '\' shotxx '\5105C.bin'];  
    row_1=[5 6];  %RF=20.4GHz, LO=28GHz, IF=+7.6 GHz (LO>RF)
    row_2=[1 2];  %RF=24.8GHz, LO=28GHz, IF=+3.2 GHz (LO>RF)
    row_3=[3 4];  %RF=33GHz, LO=28GHz, IF=-5 GHz   (LO<RF)
    row_4=[7 8];  %RF=40GHz, LO=28GHz, IF=-12 GHz  (LO<RF)
    IQ_sign=[1 1 -1 -1]; 
elseif strcmp(card_name,'Doppler')
    filename=[data_path '\' shotxx '\Doppler.bin']; 
    row_1=[7 8];  %RF=79.2GHz, LO=89.4GHz, IF=+10.2 GHz (LO>RF)
    row_2=[3 4];  %RF=85.2GHz, LO=89.4GHz, IF=+4.2 GHz (LO>RF)
    row_3=[1 2];  %RF=91.8GHz, LO=89.4GHz, IF=-2.4 GHz   (LO<RF)
    row_4=[5 6];  %RF=96GHz, LO=89.4GHz, IF=-6.6 GHz  (LO<RF)
    IQ_sign=[1 1 -1 -1];   
 else
    warning('The card name is not right!')
 end
channel=8;
time1=min(time_span);
time2=max(time_span);
L_time=0.5;
time=[time1:L_time:time2];
if time(end)<time2
    time=[time time2];
end
L=length(time);
t_3D=[];
PSD1=[];
PSD2=[];
PSD3=[];
PSD4=[];
disp(filename)
%     judge=1; %% judge=1: original signal judge=2: amplitude signal 
    for i=1:L-1
        t1=time(i);
        t2=time(i+1);
        time_1=t1-time_delay;    
        fid=fopen(filename);
        datapoint1=channel*fs*(time_1)*2;
        datapoint2=str2num(num2str(datapoint1));
        fseek(fid,datapoint2,'cof'); 
        lth=ceil(abs(t2-t1)*fs)*channel;    %
        data_2=fread(fid,lth,'int16');
        data2=reshape(data_2,channel,[]);
        clear data_2;
        fclose(fid);
       
       S1=data2(row_1(1),:)+IQ_sign(1)*sqrt(-1)*data2(row_1(2),:); 
       S2=data2(row_2(1),:)+IQ_sign(2)*sqrt(-1)*data2(row_2(2),:);
       S3=data2(row_3(1),:)+IQ_sign(3)*sqrt(-1)*data2(row_3(2),:);
       S4=data2(row_4(1),:)+IQ_sign(4)*sqrt(-1)*data2(row_4(2),:);
       clear data2; 
    end
end