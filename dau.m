clear;
shot = 83961%input('shot:');%shot_time(:,1);
time1 =2.0%input('start time:');%shot_time(:,2);
time2 =4.0%input('end time:');%shot_time(:,3);


treename = 'east';
mdsconnect('202.127.204.12');
mdsopen('east', shot);
SignalName = '\dau2';
dau2 = mdsvalue(SignalName);
tSignal = strcat('dim_of(',SignalName,')');
t = mdsvalue(tSignal);

% 时间索引
[r, c] = find(time1 < t & t < time2);

dau2time = t(r);
Da = dau2(r);

if ischar(dau2)
    ELM1 = 0;
    ELM1_T=0;
else
    ELM1=zeros(1,floor(length(dau2)));
    ELM1_T=zeros(1,floor(length(dau2)));
    ELM1=Da;
    ELM1_T=dau2time;
end

clear t
clear y

figure()
plot(ELM1_T, ELM1)