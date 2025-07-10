% 读取数据文件的MATLAB程序
function data = readDataFile(filename)
    % 打开文件
    fileID = fopen(filename, 'r');
    if fileID == -1
        error('无法打开文件: %s', filename);
    end
    
    % 读取并跳过标题行
    headerLine = fgetl(fileID);
    
    % 初始化数据存储
    psi = [];
    rho = [];
    value = [];
    error = [];
    
    % 读取数据行
    tline = fgetl(fileID);
    while ischar(tline)
        % 跳过空行
        if ~isempty(strtrim(tline))
            % 使用正则表达式匹配数据行中的数值
            dataPattern = '([\d.e+-]+)\s+([\d.e+-]+)\s+([\d.e+-]+)\s+([\d.e+-]+)';
            tokens = regexp(tline, dataPattern, 'tokens');
            
            if ~isempty(tokens)
                % 提取匹配到的数据
                psi = [psi; str2double(tokens{1}{1})];
                rho = [rho; str2double(tokens{1}{2})];
                value = [value; str2double(tokens{1}{3})];
                error = [error; str2double(tokens{1}{4})];
            end
        end
        
        % 读取下一行
        tline = fgetl(fileID);
    end
    
    % 关闭文件
    fclose(fileID);
    
    % 创建数据结构体
    data.psi = psi;
    data.rho = rho;
    data.value = value;
    data.error = error;
    
    % 显示读取的数据信息
    fprintf('成功读取 %d 行数据\n', length(psi));
end