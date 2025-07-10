 function [t_ave,refl_ave_data]=refl_average(time,data,L)
   s1=size(data);
   if s1(2)>s1(1)
      data=data';
   end
   s2=size(time);
   if s2(2)>s2(1)
      time=time';
   end
   number=fix(length(data)/L); %% fix(x)是让x向0靠近取整
   data1=reshape(data(1:number*L),L,number);
   time1=reshape(time(1:number*L),L,number);
   t_ave=mean(time1,1);%%按照列向量求平均
   refl_ave_data=mean(data1,1);    
