% 从txt文件读取数据
shot = 80491
t1 = 2.9
t2 = 3.05
type = 'pedestal'
path = 'D:\mywork\EHO-like\codes\';
filename = [path type '_' num2str(shot) '_' num2str(t1) '_' num2str(t2) '.txt']  % 请替换为您的文件名
data = load(filename);       % 自动加载为N×2矩阵

% 提取两列数据
time = data(:, 1);       % 第一列是时间
pedestal = data(:, 2);   % 第二列是pedestal

% 绘制散点图
if strcmp(type, 'pedestal')
    figure;
    scatter(time, pedestal, 30, 'filled');  % 散点大小为40，填充颜色
    ylabel('Pedestal');
    title(['# ' num2str(shot) ' Pedestal vs Time 2D Scatter Plot']);
    grid on;
elseif strcmp(type, 'nwidth')
    scatter(time, pedestal*100, 30, 'filled');  % 散点大小为40，填充颜色
    % plot(time, pedestal*100)
    ylabel('Width (cm)');
    title(['# ' num2str(shot) ' Width vs Time 2D Scatter Plot']);
    grid on;
end


% 添加标签和标题
xlabel('Time (s)');


% 可选：调整坐标轴范围
% xlim([min(time)-0.1, max(time)+0.1]);
% ylim([min(pedestal)-1, max(pedestal)+1]);