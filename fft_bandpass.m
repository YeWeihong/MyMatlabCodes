
function filt_data=fft_bandpass(data,band_pass,fs)
    %this function is to use FFT to filter the complex signal,
    %bandpass=filter_freq
    band_pass=sort(band_pass); %%sort(A)��A�������������л�����������Ĭ�϶��Ƕ�A�����������С�
    L=length(data);
    y_data=fft(data);
    f=((1:L)*(fs/L)-fs/2)/10^3; % kHz
    y_data=fftshift(y_data);
    index=find(f<band_pass(1)|f>band_pass(2));
    y_data(index)=0;
    y_data=ifftshift(y_data);
    filt_data=ifft(y_data);%%FFT�任�ǽ��źŴ�ʱ��ת����Ƶ��,IFFT��Ƶ���ź�ת����ʱ��