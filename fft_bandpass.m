
function filt_data=fft_bandpass(data,band_pass,fs)
    %this function is to use FFT to filter the complex signal,
    %bandpass=filter_freq
    band_pass=sort(band_pass); %%sort(A)若A是向量不管是列还是行向量，默认都是对A进行升序排列。
    L=length(data);
    y_data=fft(data);
    f=((1:L)*(fs/L)-fs/2)/10^3; % kHz
    y_data=fftshift(y_data);
    index=find(f<band_pass(1)|f>band_pass(2));
    y_data(index)=0;
    y_data=ifftshift(y_data);
    filt_data=ifft(y_data);%%FFT变换是将信号从时域转换到频域,IFFT将频域信号转换到时域