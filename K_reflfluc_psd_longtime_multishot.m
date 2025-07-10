function K_reflfluc_psd_longtime_multishot(shot,time1,time2)
% % low field side reflectometry: 
%%O mode: 20-40GHz + U-band (40-60 GHz)
%%X mode: V-band (50-75)GHz + W-band (75-110) GHz
%%O-P1:  20-40 GHz O-refl. P1@ [20.4, 24.8, 33, 40] GHz        LO: 28 GHz
%%O-P2:  20-40 GHz O-refl. P2@ [20.4, 24.8, 33, 40] GHz        LO: 28 GHz 
%%U-P1:  40-60 GHz O-refl. P1@ [42.4, 48, 52.6, 57.2] GHz      LO: 49.2 GHz
%%U-P2:  40-60 GHz O-refl. P2@ [42.4, 48, 52.6, 57.2] GHz      LO: 49.2 GHz
%%V-P1:  50-75 GHz X-refl. P1@ [61.2, 65.6, 69.2, 73.6] GHz    LO: 58.4 GHz
%%V-P2:  50-75 GHz X-refl. P2@ [61.2, 65.6, 69.2, 73.6] GHz    LO: 58.4 GHz
%%W-P1:  75-110GHz X-refl. P1@ [79.2, 85.2, 91.8, 96] GHz      LO: 89.4 GHz
%%W-P2:  75-110GHz X-refl. P2@ [79.2, 85.2, 91.8, 96] GHz      LO: 89.4 GHz
%% birdview, P1 is upper and P2 is lower
shotxx = num2str(shot);

shot2018O = [76181:80699];
shot2018X = [80710:81692];

shot2019 = [83218:94686];
shot2020 = [94688:97422];
shot2021 = [97423:107851];
shot2022 = [107960:120623];
shot2023 = [121675:137931];
shot2024 = [132043:148211];

%%
if ismember(shot,shot2018O)
    data_path='X:\reflfluc2\Refl_Fluc_2018\O_20-40';
    filepathxx = 'E:\2018ECM2_4\';
    card_name = '5105A';
elseif ismember(shot,shot2018X)
    data_path='X:\reflfluc2\Refl_Fluc_2018\X_W';
    filepathxx = 'E:\2018ECM2_4\';
    card_name = '5105A';
elseif ismember(shot, shot2019)
    data_path='X:\reflfluc2\Refl_Fluc_2019';
    filepathxx = 'E:\2019ECM2_4\';
    card_name = 'O_P1';
elseif ismember(shot, shot2020)
    data_path='X:\reflfluc2\Refl_Fluc_2020';
    filepathxx = 'E:\2020EHOlikeshotAMP\';
    card_name = 'O_P1';
elseif ismember(shot, shot2021)
    data_path='X:\reflfluc2\Refl_Fluc_2021';
    filepathxx = 'E:\2021EHOlikeshotAMP\';
    card_name = 'O_P1';
elseif ismember(shot, shot2022)
    data_path='X:\reflfluc2\Refl_Fluc_2022';
    filepathxx = 'E:\2022EHOlikeshotAMP\';
    card_name = 'O_P2';
elseif ismember(shot, shot2023)
    data_path='X:\reflfluc2\Refl_Fluc_2023';
    filepathxx = 'E:\2023EHOlikeshotAMP\';
    card_name = 'O_P2';
elseif ismember(shot, shot2024)
    data_path='X:\reflfluc2\Refl_Fluc_2024';
    filepathxx = 'E:\2024EHOlikeshotAMP\';
    card_name = 'O_P2';
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
fs=2*10^6;
% time_delay=7.012*10^-3;
time_delay=6.993*10^-3;
%% 确定是幅度信号judge = 2还是原始信号judge = 1
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
[t_3D,f_3D,PSD1,PSD2,PSD3,PSD4]=K_reflfluc_3D(shotxx,time_span,card_name,data_path,fs,time_delay,judge); 

%% 绘图
fig = figure('Visible','off');
ax(1)=subplot(4,1,1);
imagesc(t_3D,f_3D,log10(PSD1));
      colormap('jet');
      set(gca,'YDir','normal');
      hold on;
      title([shotxx 'f=' num2str(freq_inj(1)) 'GHz']);

ax(2)=subplot(412);
imagesc(t_3D,f_3D,log10(PSD2));
      colormap('jet');
      set(gca,'YDir','normal');
      hold on;
      title([shotxx 'f=' num2str(freq_inj(2)) 'GHz']);


ax(3)=subplot(413);
imagesc(t_3D,f_3D,log10(PSD3));
      colormap('jet');
      set(gca,'YDir','normal');
      hold on;
      title([shotxx 'f=' num2str(freq_inj(3)) 'GHz']);

ax(4)=subplot(414);
imagesc(t_3D,f_3D,log10(PSD4));
      colormap('jet');
      set(gca,'YDir','normal');
      hold on;
      title([shotxx 'f=' num2str(freq_inj(4)) 'GHz']);
      linkaxes(ax) ;
        ylim([0 100]);
%% 
 fileNumber = shotxx;
% filepathxx = 'F:\2018EHOlikeshot\';

% 构建完整的文件名，包括文件编号和文件扩展名
filenamexx = fullfile(filepathxx, [fileNumber '.png']);
% 如果路径不存在，创建它
if ~exist(filepathxx, 'dir')
    mkdir(filepathxx);
end
% 保存当前图形为 PNG 文件
saveas(fig, filenamexx);
disp(['saved ', shotxx])
    close all
      
function [t_3D,f_3D,PSD1,PSD2,PSD3,PSD4]=K_reflfluc_3D(shot,time_span,card_name,data_path,fs,time_delay,judge) 
    % shot = num2str(shot);
    if strcmp(card_name,'O_P1')
        filename=[data_path '\' shot '\O_P1.bin'];
        row_1=[5 6];  %RF=20.4GHz, LO=28GHz, IF=+7.6 GHz (LO>RF)
        row_2=[1 2];  %RF=24.8GHz, LO=28GHz, IF=+3.2 GHz (LO>RF)
        row_3=[3 4];  %RF=33GHz, LO=28GHz, IF=-5 GHz   (LO<RF)
        row_4=[7 8];  %RF=40GHz, LO=28GHz, IF=-12 GHz  (LO<RF)
        IQ_sign=[1 1 -1 -1];     
     elseif strcmp(card_name,'O_P2')
        filename=[data_path '\' shot '\O_P2.bin'];  
        row_1=[5 6];  %RF=20.4GHz, LO=28GHz, IF=+7.6 GHz (LO>RF)
        row_2=[1 2];  %RF=24.8GHz, LO=28GHz, IF=+3.2 GHz (LO>RF)
        row_3=[3 4];  %RF=33GHz, LO=28GHz, IF=-5 GHz   (LO<RF)
        row_4=[7 8];  %RF=40GHz, LO=28GHz, IF=-12 GHz  (LO<RF)
        IQ_sign=[1 1 -1 -1];  
     elseif strcmp(card_name,'U_P1')
        filename=[data_path '\' shot '\U_P1.bin'];  
        row_1=[5 6];  %RF=42.4GHz, LO=49.2GHz, IF=+6.8 GHz (LO>RF)
        row_2=[1 2];  %RF=48GHz, LO=49.2GHz, IF=+1.2 GHz (LO>RF)
        row_3=[3 4];  %RF=52.6GHz, LO=49.2GHz, IF=-3.4 GHz   (LO<RF)
        row_4=[7 8];  %RF=57.2GHz, LO=49.2GHz, IF=-8 GHz  (LO<RF)
        IQ_sign=[1 1 1 1];  
     elseif strcmp(card_name,'U_P2')
        filename=[data_path '\' shot '\U_P2.bin'];  
        row_1=[5 6];  %RF=42.4GHz, LO=49.2GHz, IF=+6.8 GHz (LO>RF)
        row_2=[1 2];  %RF=48GHz, LO=49.2GHz, IF=+1.2 GHz (LO>RF)
        row_3=[3 4];  %RF=52.6GHz, LO=49.2GHz, IF=-3.4 GHz   (LO<RF)
        row_4=[7 8];  %RF=57.2GHz, LO=49.2GHz, IF=-8 GHz  (LO<RF)
        IQ_sign=[1 1 -1 -1];   
     elseif strcmp(card_name,'V_P1')
        filename=[data_path '\' shot '\V_P1.bin']; 
        row_1=[1 2];  %RF=61.2GHz, LO=58.4GHz, IF=-2.8 GHz (LO<RF)
        row_2=[3 4];  %RF=65.6GHz, LO=58.4GHz, IF=-7.2 GHz (LO<RF)
        row_3=[5 6];  %RF=69.2GHz, LO=58.4GHz, IF=-10.8 GHz   (LO<RF)
        row_4=[7 8];  %RF=73.6GHz, LO=58.4GHz, IF=-15.2 GHz  (LO<RF)
        IQ_sign=[-1 -1 -1 -1];   
     elseif strcmp(card_name,'V_P2')
        filename=[data_path '\' shot '\V_P2.bin'];  
        row_1=[1 2];  %RF=61.2GHz, LO=58.4GHz, IF=-2.8 GHz (LO<RF)
        row_2=[3 4];  %RF=65.6GHz, LO=58.4GHz, IF=-7.2 GHz (LO<RF)
        row_3=[5 6];  %RF=69.2GHz, LO=58.4GHz, IF=-10.8 GHz   (LO<RF)
        row_4=[7 8];  %RF=73.6GHz, LO=58.4GHz, IF=-15.2 GHz  (LO<RF)
        IQ_sign=[-1 -1 -1 -1];   
     elseif strcmp(card_name,'W_P1')
        filename=[data_path '\' shot '\W_P1.bin']; 
        row_1=[7 8];  %RF=79.2GHz, LO=89.4GHz, IF=+10.2 GHz (LO>RF)
        row_2=[3 4];  %RF=85.2GHz, LO=89.4GHz, IF=+4.2 GHz (LO>RF)
        row_3=[1 2];  %RF=91.8GHz, LO=89.4GHz, IF=-2.4 GHz   (LO<RF)
        row_4=[5 6];  %RF=96GHz, LO=89.4GHz, IF=-6.6 GHz  (LO<RF)
        IQ_sign=[1 1 1 1];   
     elseif strcmp(card_name,'W_P2')
        filename=[data_path '\' shot '\W_P2.bin']; 
        row_1=[7 8];  %RF=79.2GHz, LO=89.4GHz, IF=+10.2 GHz (LO>RF)
        row_2=[3 4];  %RF=85.2GHz, LO=89.4GHz, IF=+4.2 GHz (LO>RF)
        row_3=[1 2];  %RF=91.8GHz, LO=89.4GHz, IF=-2.4 GHz   (LO<RF)
        row_4=[5 6];  %RF=96GHz, LO=89.4GHz, IF=-6.6 GHz  (LO<RF)
        IQ_sign=[1 1 -1 -1];   
     elseif strcmp(card_name,'5105B')
        filename=[data_path '\' shot '\5105B.bin'];  
        row_1=[5 6];  %RF=20.4GHz, LO=28GHz, IF=+7.6 GHz (LO>RF)
        row_2=[1 2];  %RF=24.8GHz, LO=28GHz, IF=+3.2 GHz (LO>RF)
        row_3=[3 4];  %RF=33GHz, LO=28GHz, IF=-5 GHz   (LO<RF)
        row_4=[7 8];  %RF=40GHz, LO=28GHz, IF=-12 GHz  (LO<RF)
        IQ_sign=[1 1 -1 -1];   
     elseif strcmp(card_name,'5105A')
        filename=[data_path '\' shot '\5105A.bin'];  
        row_1=[5 6];  %RF=20.4GHz, LO=28GHz, IF=+7.6 GHz (LO>RF)
        row_2=[1 2];  %RF=24.8GHz, LO=28GHz, IF=+3.2 GHz (LO>RF)
        row_3=[3 4];  %RF=33GHz, LO=28GHz, IF=-5 GHz   (LO<RF)
        row_4=[7 8];  %RF=40GHz, LO=28GHz, IF=-12 GHz  (LO<RF)
        IQ_sign=[1 1 -1 -1];     
    elseif strcmp(card_name,'5105C')
        filename=[data_path '\' shot '\5105C.bin'];  
        row_1=[5 6];  %RF=20.4GHz, LO=28GHz, IF=+7.6 GHz (LO>RF)
        row_2=[1 2];  %RF=24.8GHz, LO=28GHz, IF=+3.2 GHz (LO>RF)
        row_3=[3 4];  %RF=33GHz, LO=28GHz, IF=-5 GHz   (LO<RF)
        row_4=[7 8];  %RF=40GHz, LO=28GHz, IF=-12 GHz  (LO<RF)
        IQ_sign=[1 1 -1 -1]; 
    elseif strcmp(card_name,'Doppler')
        filename=[data_path '\' shot '\Doppler.bin']; 
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
    % disp(filename)
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
       
       if judge==1
            ts_temp=1/fs;
            fftpoint=512*4;
       elseif judge==2
           fftpoint=512;
            band_pass=[-600 -1000];
            average_point=4;
            t_temp=linspace(t1,t2,length(S1));
            [t_temp1,S1]=refl_amp(t_temp,S1,band_pass,fs,average_point);
            [t_temp1,S2]=refl_amp(t_temp,S2,band_pass,fs,average_point);
            [t_temp1,S3]=refl_amp(t_temp,S3,band_pass,fs,average_point);
            [t_temp1,S4]=refl_amp(t_temp,S4,band_pass,fs,average_point);
            ts_temp=t_temp1(2)-t_temp1(1);
            clear t_temp t_temp1
       end 
        
        L_signal=length(S1);
        t_signal=linspace(t1,t2,L_signal);
        fs_temp=1/ts_temp;
        g=5/4*fftpoint;
        m=0;

        while (m/2+1)*g<L_signal
           k=(m*g/2+1):(m/2+1)*g;
           x1=S1(k);
           x1=x1-mean(x1);
           x2=S2(k);
           x2=x2-mean(x2);
           x3=S3(k);
           x3=x3-mean(x3);
           x4=S4(k);
           x4=x4-mean(x4);
           m=m+1;
           t_3D_temp(m)=mean(t_signal(k));
          [PSD1_temp(:,m),f]=psd_me(x1,fs_temp,fftpoint); 
          [PSD2_temp(:,m),f]=psd_me(x2,fs_temp,fftpoint); 
          [PSD3_temp(:,m),f]=psd_me(x3,fs_temp,fftpoint); 
          [PSD4_temp(:,m),f]=psd_me(x4,fs_temp,fftpoint);    
        end
        %clear S1 S2 S3 S4
        t_3D=[t_3D t_3D_temp];
        PSD1=[PSD1 PSD1_temp];
        PSD2=[PSD2 PSD2_temp];
        PSD3=[PSD3 PSD3_temp];
        PSD4=[PSD4 PSD4_temp]; 
        clear PSD1_temp PSD2_temp PSD3_temp PSD4_temp t_3D_temp
        waitbar(i/(L-1))
    end
    f_3D=f/10^3;
    

function [P,f]=psd_me(x,fs,fftpoint)
%========================
%calculate the power spectrum density of signal x through
%        Pxx(f)=<x(f)*x(f)*/N>, <...> represents ensemble average
%fs is sampling frequency, fftpoint is fft point.
%x must be a vector. 
%the returned value P is Pxx(f), f is the frequency. 50% overlap
%========================
if nargin~=3
error('the standard form is [PSD,frequency]=psd_me(signal,sample_frequency,fftpoint)');
else
a=length(x);
L=fix(a/fftpoint);
m=2*L-1;
   for k=1:m
   j=(k-1)*fftpoint/2;
   p=(j+1):(j+fftpoint);
   y(1:fftpoint,k)=x(p);
   end
   y_fft=fft(y)/fftpoint;
   y_psd=abs(y_fft).^2;
   y_psd=mean(y_psd,2);
   P=fftshift(y_psd);
   f=[-fftpoint/2:(fftpoint/2-1)]*(fs/fftpoint);
end     

function [t,S]=refl_amp(t_refl,S_refl,band_pass,fs,L)
    
    S1=abs(fft_bandpass(S_refl,band_pass,fs));
    [t,S]=refl_average(t_refl,S1,L);

function filt_data=fft_bandpass(data,band_pass,fs)
    %this function is to use FFT to filter the complex signal,
    %bandpass=filter_freq
    band_pass=sort(band_pass);
    L=length(data);
    y_data=fft(data);
    f=((1:L)*(fs/L)-fs/2)/10^3; % kHz
    y_data=fftshift(y_data);
    index=find(f<band_pass(1)|f>band_pass(2));
    y_data(index)=0;
    y_data=ifftshift(y_data);
    filt_data=ifft(y_data);

 function [t_ave,refl_ave_data]=refl_average(time,data,L)
   s1=size(data);
   if s1(2)>s1(1)
      data=data';
   end
   s2=size(time);
   if s2(2)>s2(1)
      time=time';
   end
   number=fix(length(data)/L);
   data1=reshape(data(1:number*L),L,number);
   time1=reshape(time(1:number*L),L,number);
   t_ave=mean(time1,1);
   refl_ave_data=mean(data1,1);    

