function [rho, data] = read_fitted_data(filename)
    fid = fopen(filename, 'r');
    if fid == -1
        error('文件无法打开');
    end

    found_fitted = false;
    block_str = '';

    % 定位到 &fitted_data 部分
    while ~feof(fid)
        line = strtrim(fgetl(fid));
        if startsWith(line, '&fitted_data')
            found_fitted = true;
            break;
        end
    end

    if ~found_fitted
        fclose(fid);
        error('未找到 &fitted_data 部分');
    end

    % 读取区块内容直到遇到 /
    while ~feof(fid)
        line = fgetl(fid);
        if startsWith(strtrim(line), '/')
            break;
        end
        block_str = [block_str ' ' line];  % 合并行并保留空格分隔符
    end
    fclose(fid);

    % 提取 rho 数据
    rho_match = regexp(block_str, 'rho\s*=\s*([^data]*)', 'tokens');
    if isempty(rho_match)
        error('未找到 rho 数据');
    end
    rho = str2num(rho_match{1}{1});

    % 提取 data 数据
    data_match = regexp(block_str, 'data\s*=\s*([^/]*)', 'tokens');
    if isempty(data_match)
        error('未找到 data 数据');
    end
    data = str2num(data_match{1}{1});

    % 输出结果
    disp('读取成功:');
    disp(['rho 长度: ', num2str(length(rho))]);
    disp(['data 长度: ', num2str(length(data))]);
end