% function magplot_amp_signal
%本函数是对EAST_webscope的信号进行STFT频谱分析，独立函数。
%shot_time=load('shot_time.txt');
% close all;
clear;
shot = 88001%input('shot:');%shot_time(:,1);
time1 =3.7%input('start time:');%shot_time(:,2);
time2 =3.9%input('end time:');%shot_time(:,3);
treename = 'east';
name = 'point_1'%'rppj_1@1';
ch =[10];
fftpoint = 512;
%%KMPT:1024*3
save_choice = 'n';
%%fluc_W_band:79.2GHz   fluc_12:85.2GHz   fluc_13:91.8GHz   fluc_14:96GHz
% ece:ch1_48 [1:48]  %%hrsh 1e6
% point:ch1_11 [1:11] point
% pxuv:ch1_64 [1:64]
% cxuv:ch1_24 [1:24]
% sxru:ch1_46 [1:46]  %%1e5
% sxrd:ch1_43 [1:43]
% sxrv:ch1_30 [1:30] 
% KHPT,LHPT,KHPN,LHPN:ch6_8 [6:8]
% KMPT,CMPT,KMPN,CMPN:ch1_26 [1:8,10:21,23:26]
% Uiis:ch1_28 [1:28]
% Uois:ch1_26 [1:26]
% Liis:ch1_15 [1:15]
% Lois:ch1_20 [1:20]
% MIT:ch1_16 [1:16] [PABCDEFGHIJKLMNOP]
[signalname,judge] = give_name(name,ch)
s = size(signalname);

L_shot = length(shot);
L_signal = s(2);
% amp signal
band_pass=[0 5000]%[10,50];%[-0,-10]%%;%[-10 -120];
average_point = 4;
mdsconnect('mds.ipp.ac.cn');
for i = 1:L_shot
    shot1 = shot(i);
    t1 = time1(i);
    t2 = time2(i);
    mdsopen(treename,shot1); 
    for j=1:L_signal
        [t,y,fs] = read_data(signalname{j},shot,t1,t2,judge,band_pass,average_point);
        figure();
        plot(t,y)
        %
        ts_temp = 1/fs;   
        g=2*fftpoint;
        m=0;
        while (m/2+1)*g<length(y)
            k=(m*g/2+1):(m/2+1)*g;
            x1=y(k);
            x1=x1-mean(x1);
            m=m+1;           
            [P(:,m),f]=psd_me(x1,fs,fftpoint);            
        end
        t_3D = (g/2*(0:(m-1))*ts_temp)+t1;      
%         if (L_signal>=2)&~isempty(strfind(save_choice,'sub'))    
%             figure(i)
%             A = my_factor(L_signal);
%             ax(j) = subplot(A(1),A(2),j);
%         else
            figure();
%         end
        PSD1 = log10(P);
        f_3D = f/10^3;
        imagesc(t_3D,f_3D,PSD1);
        colormap('jet');
        set(gca,'YDir','normal');
        xlabel([num2str(shot),'-',name,'-ch',num2str(ch(j))]);
        w = waitbar(j/L_signal);
%         linkaxes(ax,'xy');
        xlim([time1 time2])
        ylim([0,100]);%%调节频率范围
%         title([num2str(shot),'-',name,'-ch',num2str(ch(j))]);
        % if save
        switch save_choice
            case 'input'
                if_save = input('if you want to save it? y for yes:','s');
                if if_save == 'y'
                    save_it(shot,name,ch(j),judge);
                end
                close all;
            case {'y'}
                save_it(shot,name,ch(j),judge);
            case 'n'                
        end
        
    end
    

end
% mdsclose('all')
mdsdisconnect
%% PSD 2D图
figure();
PSD2d = sum(PSD1,2)/length(PSD1);
normal_psd2d = (PSD2d - min(PSD2d))/(max(PSD2d) - min(PSD2d));
plot(f_3D, normal_psd2d, 'blue');
title("PSD")
xlim([0 100]);
xlabel("f (kHz)");
ylabel("PSD (a.u.)");
legend("KHP6T");
grid on;
%% 各种函数
function save_it(shot,name,channel,judge)
    file_path = 'D:\matlabwork\fluc_results\amp_signal_leq10kHz_mode';
    file_name = [num2str(shot),'\',name];
    mkdir([file_path,'\',file_name]);
    if judge == 1
        saveas(gcf,[file_path,'\',file_name,'\','ch',num2str(channel),'_origin','.fig']);
    elseif (judge == 2)||(judge == 3)
         saveas(gcf,[file_path,'\',file_name,'\','ch',num2str(channel),'_amp','.fig']);
    end
end

function [t_spec,P,f]=spec_3D(t,signal,fs,fftpoint,g)
     L=length(signal);
     m=0;
     while (m/2+1)*g<L
           k=(m*g/2+1):(m/2+1)*g;
           y_temp=signal(k);
           y_temp=y_temp-mean(y_temp);
           m=m+1;
           t_spec(m)=mean(t(k));
          [P(:,m),f]=psd_me(y_temp,fs,fftpoint); 
     end
     f=f/10^3; 
end

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
    %     h = tftb_window(fftpoint);
    %     h = h'/norm(h);
        for k=1:m
            j=(k-1)*fftpoint/2;
            p=(j+1):(j+fftpoint);
    %         y(1:fftpoint,k)=x(p).*h';
            y(1:fftpoint,k)=x(p);
        end
        y_fft=fft(y)/fftpoint;
        y_psd=abs(y_fft).^2;
        y_psd=mean(y_psd,2);
        P=fftshift(y_psd);
        f=[-fftpoint/2:(fftpoint/2-1)]*(fs/fftpoint);
    end
end
