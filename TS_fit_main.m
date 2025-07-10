Table = readtable("EHO_num.xlsx"); 
shotnum = Table.shot;


for i = 1:height(Table)
    % shotxx=num2str(shot(i));
    % K_reflfluc_psd_longtime_multishot(shot,time1,time2); 
    try 
        TS_fit(shotnum(i));
        
    catch ME
        fprintf('错误发生在数字 %d：\n', shotnum(i));
        disp(ME.message); % 显示错误信息
    end
end