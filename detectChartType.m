function chartType = detectChartType()
    % 获取当前axes的所有子对象
    ax = gca;
    children = ax.Children;
    
    chartType = 'unknown';
    
    for i = 1:length(children)
        obj = children(i);
        switch obj.Type
            case 'scatter'
                chartType = 'scatter';
                return;
            case 'errorbar'
                chartType = 'errorbar';
                return;
            case 'line'
                % 进一步判断是否是普通线图或旧版errorbar
                if isprop(obj, 'LData') && ~isempty(obj.LData)
                    chartType = 'errorbar (new)';
                    return;
                else
                    chartType = 'line/plot';
                end
        end
    end
end