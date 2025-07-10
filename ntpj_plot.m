% 读取数据文件（假设文件名为data.txt）
filename = 'ntpj.txt';

% 初始化存储变量
rho = [];
ne = [];
Te = [];
pressure = [];
current_density = [];

% 读取文件
fid = fopen(filename, 'r');
if fid == -1
    error('文件打开失败，请检查文件名和路径');
end

% 跳过第一行标题
fgetl(fid);

% 读取数据行
while ~feof(fid)
    line = fgetl(fid);
    % 分割数据列（处理不定数量空格分隔符）
    data = sscanf(line, '%f %f %f %f %f');
    
    if numel(data) == 5
        rho(end+1) = data(1);
        ne(end+1) = data(2);
        Te(end+1) = data(3);
        pressure(end+1) = data(4);
        current_density(end+1) = data(5);
    end
end

fclose(fid);

% 验证数据读取（可选）
disp('前5行数据:');
disp([rho(1:5)', ne(1:5)', Te(1:5)', pressure(1:5)', current_density(1:5)']);

% 绘制图形
figure('Position', [100 100 1000 800])

subplot(2,2,1)
plot(rho, ne)
ylabel('n_e (10^{13} cm^{-3})')
grid on

subplot(2,2,2)
plot(rho, Te)
ylabel('T_e (keV)')
grid on

subplot(2,2,3)
plot(rho, pressure)
xlabel('\rho')
ylabel('Pressure (kPa)')
grid on

subplot(2,2,4)
plot(rho, current_density)
xlabel('\rho')
ylabel('Current Density (MA/m^2)')
grid on

sgtitle('等离子体参数分布');  % MATLAB R2018b及以上版本支持

% 自动调整子图间距
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);