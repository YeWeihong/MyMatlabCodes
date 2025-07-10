function [p,f,fd,A,tt] = fdcog_me(y,t,nfft,overlap,Fs)
tic;
N = floor((length(y)-overlap)/(nfft-overlap));
col = 1 + (0:(N-1))*(nfft-overlap);
row = (1:nfft)';
mask = row(:,ones(1,N))+col(ones(nfft,1),:)-1;
y_fft = fft(y(mask));
p = fftshift(abs(y_fft).^2./(Fs*nfft),1);
f = [-nfft/2:(nfft/2-1)]*(Fs/nfft);
pp = p(2:end,:);
ff = f(2:end);
fd = sum(ff*pp,1)./sum(pp,1);
A=sum(pp,1);
tt = mean(t(mask),1);
toc;


