function export_for_origin(x, y, err, filename)
% 将数据导出为Origin兼容格式
% 输入参数：
%   x, y   - 数据向量
%   err    - 误差数据（对称误差向量或非对称误差矩阵）
%   filename - 可选，输出文件名（默认：'origin_data.txt'）

% 参数检查
if nargin < 4
    filename = 'origin_data.txt';
end

% 确保数据列方向一致
x = x(:);
y = y(:);

% 处理误差数据类型
if size(err,2) == 2
    % 非对称误差 [负误差, 正误差]
    err_neg = err(:,1);
    err_pos = err(:,2);
    header = 'X\tY\tY_neg\tY_pos';
    data = [x, y, err_neg, err_pos];
else
    % 对称误差
    header = 'X\tY\tError';
    data = [x, y, err];
end

% 写入文件
fid = fopen(filename, 'w');
fprintf(fid, '%s\n', header); % 写入列标题
fprintf(fid, '%.6f\t%.6f\t%.6f\t%.6f\n', data'); % 数据精度可调整
fclose(fid);

% 显示保存信息
fprintf('数据已保存至: %s\n', which(filename));
fprintf('包含 %d 行数据\n', length(x));
end