shot = 93871;
time1 = 3.1;
time2 = 3.2;
fftpoint=128;
%% 信号1
treename_1='east';
signalname_1 = '\uiis05'; %'\lois07'; %'\hrs05h' point_n1
% treename_1='east';
% signalname_1='\hrs05h';
mdsconnect('mds.ipp.ac.cn');

%download and choose the data
mdsopen(treename_1,shot)
y=mdsvalue(['_sig=' signalname_1]);
t=mdsvalue('dim_of(_sig)');
index=find(t>=time1&t<=time2);
signal1=y(index);
t_signal1=t(index);
%% plot
figure
plot(t_signal1, signal1);