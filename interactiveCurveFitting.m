function interactiveCurveFitting()
    % 获取当前图形中的散点数据
    hScatter = findobj(gcf, 'Type', 'errorbar');
    if isempty(hScatter)
        error('当前图形中没有找到散点图');
    end
    
    % 读取原始数据
    x = hScatter.XData;
    y = hScatter.YData;
    
    % 创建新图形并绘制原始数据
    fig = figure;
    scatter(x, y, 'b');
    hold on;
    title('左键添加控制点 | 右键结束 | 拖动调整');
    xlabel('X'); ylabel('Y');
    grid on;
    
    % 初始化控制点数组
    controlPoints = [];
    hPoints = [];
    hSpline = [];
    isAdding = true;
    currentDragger = [];
    
    % 设置鼠标回调函数
    set(fig, 'WindowButtonDownFcn', @buttonDownCallback);
    set(fig, 'WindowButtonUpFcn', @buttonUpCallback);
    
    % 辅助函数定义
    % ================================================
    
    function updateTempDisplay()
        if ~isempty(hPoints)
            delete(hPoints);
        end
        hPoints = plot(controlPoints(:,1), controlPoints(:,2),...
            'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
        updateSpline();
    end
    
    function updateSpline()
        if size(controlPoints,1) < 2
            return;
        end
        
        xx = linspace(min(controlPoints(:,1)), max(controlPoints(:,1)), 100);
        yy = spline(controlPoints(:,1), controlPoints(:,2), xx);
        
        if isempty(hSpline)
            hSpline = plot(xx, yy, 'r-', 'LineWidth', 2);
        else
            set(hSpline, 'XData', xx, 'YData', yy);
        end
    end
    
    function finalizeControlPoints()
        delete(hPoints);
        hPoints = [];
        
        for i = 1:size(controlPoints,1)
            h = plot(controlPoints(i,1), controlPoints(i,2),...
                'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r',...
                'UserData', i, 'ButtonDownFcn', @startDrag);
            hPoints = [hPoints; h];
        end
    end
    
    function h = getClosestControlPoint()
        cp = get(gca, 'CurrentPoint');
        x = cp(1,1);
        y = cp(1,2);
        
        minDist = inf;
        h = [];
        for i = 1:length(hPoints)
            xp = get(hPoints(i), 'XData');
            yp = get(hPoints(i), 'YData');
            d = sqrt((xp-x)^2 + (yp-y)^2);
            if d < 0.05 % 有效点击距离阈值
                if d < minDist
                    minDist = d;
                    h = hPoints(i);
                end
            end
        end
    end
    
    % 主回调函数
    % ================================================
    
    function buttonDownCallback(~, ~)
        if isAdding
            processAddPoint();
        else
            h = getClosestControlPoint();
            if ~isempty(h)
                startDrag(h);
            end
        end
    end
    
    function processAddPoint()
        pt = get(gca, 'CurrentPoint');
        newX = pt(1,1);
        newY = pt(1,2);
        
        if strcmp(get(fig, 'SelectionType'), 'alt')
            if size(controlPoints,1) >= 2
                isAdding = false;
                finalizeControlPoints();
                title('拖动控制点调整曲线');
            else
                warndlg('至少需要2个控制点才能生成曲线','警告');
            end
            return;
        end
        
        controlPoints = [controlPoints; newX newY];
        [~, idx] = sort(controlPoints(:,1));
        controlPoints = controlPoints(idx,:);
        updateTempDisplay();
    end
    
    % 修复关键点：修正参数列表
    function startDrag(src, ~) % 添加第二个输入参数
        currentDragger = src;
        set(fig, 'WindowButtonMotionFcn', @dragging);
    end
    
    function dragging(~, ~)
        if isempty(currentDragger)
            return;
        end
        
        cp = get(gca, 'CurrentPoint');
        newX = cp(1,1);
        newY = cp(1,2);
        
        set(currentDragger, 'XData', newX, 'YData', newY);
        
        idx = get(currentDragger, 'UserData');
        controlPoints(idx,1) = newX;
        controlPoints(idx,2) = newY;
        
        [~, sortIdx] = sort(controlPoints(:,1));
        controlPoints = controlPoints(sortIdx,:);
        for i = 1:length(hPoints)
            set(hPoints(i), 'XData', controlPoints(i,1),...
                'YData', controlPoints(i,2),...
                'UserData', i);
        end
        updateSpline();
    end
    
    function buttonUpCallback(~, ~)
        stopDrag();
    end
    
    function stopDrag()
        currentDragger = [];
        set(fig, 'WindowButtonMotionFcn', '');
    end
end