function [t,S]=refl_amp(t_refl,S_refl,band_pass,fs,L)
    
    S1=abs(fft_bandpass(S_refl,band_pass,fs));
    [t,S]=refl_average(t_refl,S1,L);