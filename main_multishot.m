 clear;
% close all;

%% 读取CSV文件-炮号
% data = readtable('export_file.csv');
% 
% % 提取指定列（假设列名为 'ColumnName'）
% % columnData = data.ColumnName;         % 数值列直接转为数组
% % 或
% columnData = data{:, 'Treeshot'};   % 通用提取方式（支持数值/字符）
% 
% % 若列索引已知（例如第2列）
% % columnData = data{:, 2};
% 
% % 保存为工作区变量（如名为myList）
% myList = columnData;
% shot = myList;

clear;
close all;

%% 手动输入炮号范围
shot = 80490:80491;  % 示例炮号范围
time1 = 2.0;
time2 = 4.0;

for i = 1:length(shot)
    try
        fprintf('处理炮号: %d\n', shot(i));
        K_reflfluc_psd_longtime_multishot_ds(shot(i), time1, time2);
    catch ME
        fprintf('处理炮号 %d 时出错:\n', shot(i));
        fprintf('错误信息: %s\n', ME.message);
        fprintf('错误位置: %s (行号 %d)\n', ME.stack(1).name, ME.stack(1).line);
    end
end