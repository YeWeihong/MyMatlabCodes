clear;
% close all;

%% 读取CSV文件-炮号
% data = readtable('E:\EHOshotcsv\2020shot_3s.csv');
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

%% 手动输入炮号范围
% shot = [132043:148211];
shot = 126000:126999;
time1 = 2.5;
time2 = 4.0;

% card_name = {'5105A'};
% card_name = {'O_P1'};
%  card_name = {'Doppler'};

%% 启动并行池（如果尚未启动）
pool = gcp('nocreate');  % 获取当前并行池
if isempty(pool)
    maxCores = feature('NumCores');
    parpool(maxCores-1);
end

if ~isempty(pool)
    pool.NumWorkers      % 显示工作进程数量
end

% 创建存储错误信息的容器
errorInfo = cell(length(shot), 2);

% 使用parfor并行执行循环
parfor i = 1:length(shot)
    try 
        K_reflfluc_psd_longtime_multishot(shot(i), time1, time2);    
        errorInfo(i, :) = {shot(i), ''}; % 存储成功执行的炮号
    catch ME
        errorInfo(i, :) = {shot(i), ME.message}; % 存储错误信息
        fprintf('错误发生在数字 %d：\n', shot(i));
        disp(ME.message); % 显示错误信息
    end
end

% 显示所有错误信息
% fprintf('\n所有错误信息汇总：\n');
% for i = 1:length(errorInfo)
%     if ~isempty(errorInfo{i, 2})
%         fprintf('炮号 %d 错误: %s\n', errorInfo{i, 1}, errorInfo{i, 2});
%     end
% end