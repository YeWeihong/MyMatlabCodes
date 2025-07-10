function [t_temp,y,fs] = read_data(name,shot,t1,t2,judge,band_pass,average_point)
if ~isempty(strfind(name,'fluc'))
    [y,t] = choose_channel(name,shot,t1,t2);
elseif ~isempty(strfind(name,'dopl'))
    [y,t] = choose_channel_doppler(name,shot,t1,t2);
elseif ~isempty(strfind(name,'rppj'))
    [y,t] = choose_channel_reflppj(name,shot,t1,t2);
elseif ~isempty(strfind(name,'plhi'))
    y = mdsvalue(name);
    t = mdsvalue('dim_of(\plhi2)');
else
    y = mdsvalue(name);
    t = mdsvalue('dim_of(_sig)');
end
index = find(t>=t1&t<=t2);
y = y(index);
t_temp = t(index);
ts_temp = (t_temp(4)+t_temp(5)+t_temp(6)-t_temp(1)-t_temp(2)-t_temp(3))/9;
fs = 1/ts_temp;
% % amp signal
if judge == 2
    t_temp1 = linspace(t1,t2,length(y));
    [t_temp,y] = refl_amp(t_temp1,y,band_pass,fs,average_point);
elseif judge == 3
    t_temp1 = linspace(t1,t2,length(y));
    y1 = fft_bandpass(y,band_pass,fs);
    [t_temp,y1] = refl_average(t_temp1,y1,average_point);
    y = abs(sqrt(y1.^2+hilbert(y1).^2));
elseif judge == 4
    t_temp = linspace(t1,t2,length(y));
    y = fft_bandpass(y,band_pass,fs);
elseif judge == 5
    fs_temp = 1e5;
    t_temp = linspace(t1,t2,length(y));
    [y,t_temp] = resample(y,t_temp,fs_temp); 
elseif judge == 6 % for the cog
    nfft = 20;
    overlap = 10;
    [y,t_temp] = fdcog(y,t_temp,nfft,overlap,fs);
end
y = y(:);
t_temp = t_temp(:);
ts_temp = (t_temp(4)+t_temp(5)+t_temp(6)-t_temp(1)-t_temp(2)-t_temp(3))/9;
fs = 1/ts_temp

