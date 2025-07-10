clear
data_path='Y:\reflfluc\Refl_Fluc_2024';
shot='135350';
time1=2.5;             % 开始时间
time2=12;           % 结束时间

time_span=[time1 time2];
% data_path='W:\reflfluc\Refl_Fluc_2019';
fs=2*10^6;
time_delay=6.5*10^-3;
% judge=1;
% card_name={'O_P1'};
card_name =  {'O_P1', 'O_P2','V_P1', 'V_P2', 'U_P2','W_P1','W_P2'};
ts_temp=1/fs;

save_path = 'D:\要的数据\mats\';

for i = 1:length(card_name)
    [S1, S2, S3, S4, t_signal] = genIQ(shot, time_span, card_name{i}, data_path, fs, time_delay);
    fclose('all');
    disp(i)
    if strcmp(card_name{i},'O_P1')|strcmp(card_name{i},'O_P2')
        freq_inj=[20.4 24.8 33 40];
    elseif strcmp(card_name{i},'U_P1')|strcmp(card_name{i},'U_P2')
        freq_inj=[42.4 48 52.6 57.2];
    elseif strcmp(card_name{i},'V_P1')|strcmp(card_name{i},'V_P2')
        freq_inj=[61.2 65.6 69.2 73.6];
    elseif strcmp(card_name{i},'W_P1')|strcmp(card_name{i},'W_P2')
        freq_inj=[79.2 85.2 91.8 96];
    elseif strcmp(card_name{i},'5105A')|strcmp(card_name{i},'5105A')
        freq_inj=[20.4 24.8 33 40];
    elseif strcmp(card_name{i},'5105B')|strcmp(card_name{i},'5105B')
        freq_inj=[20.4 24.8 33 40];
    elseif strcmp(card_name{i},'5105C')|strcmp(card_name{i},'5105C')
        freq_inj=[20.4 24.8 33 40];
    elseif strcmp(card_name{i},'Doppler')
        freq_inj=[56 61 66 70];
    else
        disp('Problem! ')
    end
    
    
    
    fs_temp=1/ts_temp;
    
    I1 = real(S1)-mean(real(S1));
    Q1 = imag(S1)-mean(imag(S1));
    mat_name = [save_path shot '_IQ_' card_name{i} '_' num2str(freq_inj(1)) 'GHz.mat'];
    save(mat_name, 't_signal', 'I1', 'Q1')
    
    I2 = real(S2)-mean(real(S2));
    Q2 = imag(S2)-mean(imag(S2));
    mat_name = [save_path shot '_IQ_' card_name{i} '_' num2str(freq_inj(2)) 'GHz.mat'];
    save(mat_name, 't_signal', 'I2', 'Q2')
    
    I3 = real(S3)-mean(real(S3));
    Q3 = imag(S3)-mean(imag(S3));
    mat_name = [save_path shot '_IQ_' card_name{i} '_' num2str(freq_inj(3)) 'GHz.mat'];
    save(mat_name, 't_signal', 'I3', 'Q3')
    
    I4 = real(S4)-mean(real(S4));
    Q4 = imag(S4)-mean(imag(S4));
    mat_name = [save_path shot '_IQ_' card_name{i} '_' num2str(freq_inj(4)) 'GHz.mat'];
    save(mat_name, 't_signal', 'I4', 'Q4')

    %% 绘图部分
    % figure();
    % 
    % ax(1)=subplot(411);
    % plot(t_signal, I1)
    % hold on
    % plot(t_signal, Q1,'r')
    % ylim([min([min(real(S1)),min(imag(S1))]),max([max(real(S1)),max(imag(S1))])]);
    % title([shot ' Refl.@' card_name{i}])
    % ax(2)=subplot(412);
    % plot(t_signal, I2)
    % hold on
    % plot(t_signal, Q2,'r')
    % ylim([min([min(real(S2)),min(imag(S2))]),max([max(real(S2)),max(imag(S2))])]);
    % ax(3)=subplot(413);
    % plot(t_signal, I3)
    % hold on
    % plot(t_signal, Q3,'r')
    % ylim([min([min(real(S3)),min(imag(S3))]),max([max(real(S3)),max(imag(S3))])]);
    % ax(4)=subplot(414);
    % plot(t_signal, I4)
    % hold on
    % plot(t_signal, Q4,'r')
    % ylim([min([min(real(S4)),min(imag(S4))]),max([max(real(S4)),max(imag(S4))])]);
    % linkaxes(ax,'x');xlim([t_signal(1) t_signal(end)]);
end
disp('done! ')



function [S1_final, S2_final, S3_final, S4_final, t_signal_final]=genIQ(shot,time_span,card_name,data_path,fs,time_delay)
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
time=(time1:L_time:time2);
if time(end)<time2
    time=[time time2];
end
L=length(time);

disp(filename)
%     judge=1; %% judge=1: original signal judge=2: amplitude signal 
S1_final = [];
S2_final = [];
S3_final = [];
S4_final = [];
t_signal_final = [];

    for i=1:L-1
        t1=time(i);
        t2=time(i+1);
        time_1=t1-time_delay;    
        fid=fopen(filename);
        datapoint1=channel*fs*(time_1)*2;
        datapoint2=str2num(num2str(datapoint1)); %#ok<ST2NM>
        fseek(fid,datapoint2,'cof'); 
        lth=ceil(abs(t2-t1)*fs)*channel;    %
        data_2=fread(fid,lth,'int16');
        data2=reshape(data_2,channel,[]);
        clear data_2;
        % fclose(fid);
       
       S1=data2(row_1(1),:)+IQ_sign(1)*sqrt(-1)*data2(row_1(2),:); 
       S2=data2(row_2(1),:)+IQ_sign(2)*sqrt(-1)*data2(row_2(2),:);
       S3=data2(row_3(1),:)+IQ_sign(3)*sqrt(-1)*data2(row_3(2),:);
       S4=data2(row_4(1),:)+IQ_sign(4)*sqrt(-1)*data2(row_4(2),:);
       S1_final = [S1_final, S1];
       S2_final = [S2_final, S2];
       S3_final = [S3_final, S3];
       S4_final = [S4_final, S4];
       
       clear data2; 
       L_signal=length(S1);
       t_signal=linspace(t1,t2,L_signal);
       t_signal_final = [t_signal_final, t_signal];
    end
end
