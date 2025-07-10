function  [signalname,judge] = give_name(name1,ch)
ind = strfind(name1,'_'); %%在name1中寻找字符'_'并返回其位置
name = name1(1:ind-1)
switch name
    case 'hrsh'
        for i = 1:length(ch)
            if ch(i)>=10
                signalname{i} = ['_sig=\hrs',num2str(ch(i)),'h'];
            elseif ch(i)<10
                signalname{i} = ['_sig=\hrs0',num2str(ch(i)),'h'];
            end
            judge(i) = str2num(name1(ind+1));
        end
    case 'point'
        % point
        for i = 1:length(ch)
            signalname{i} = ['_sig=\point_n',num2str(ch(i))];
            judge(i) = str2num(name1(ind+1));
        end
    case {'KHPN','LHPN','KHPT','LHPT','KMPT','KMPN','CMPT','CMPN'}
        % point
        for i = 1:length(ch)
            signalname{i} = ['_sig=\',name(1:3),num2str(ch(i)),name(end)];
            judge(i) = str2num(name1(ind+1));
        end
    case 'pxuv'
        for i = 1:length(ch)
            signalname{i} = ['_sig=\',name,num2str(ch(i))];
            judge(i) = str2num(name1(ind+1));
        end
    case 'cxuv'
        for i = 1:length(ch)
            signalname{i} = ['_sig=\',name,num2str(ch(i)),'V'];
            judge(i) = str2num(name1(ind+1));
        end
    case {'sxru','sxrd','sxrv'}
        for i = 1:length(ch)
            signalname{i} = ['_sig=\',name(1:3),num2str(ch(i)),name(end)];
            judge(i) = str2num(name1(ind+1));
        end
    case {'Lois','Liis','Uois','Uiis'}
        for i = 1:length(ch)
            if ch(i)>=10
                signalname{i} = ['_sig=\',name,num2str(ch(i))];
            elseif ch(i)<10
                signalname{i} = ['_sig=\',name,'0',num2str(ch(i))];
            end
            judge(i) = str2num(name1(ind+1));
        end
    case {'fluc','dopl'}
        for i = 1:length(ch)
            signalname{i} = [name,'_',num2str(ch(i))];
            judge(i) = str2num(name1(ind+1));
        end
    case {'rppj'}
        ind_1 = strfind(name1,'@');
        part = name1(ind_1+1:end)
        for i = 1:length(ch)
            signalname{i} = [name,'@',part,'_',num2str(ch(i))];
            judge(i) = str2num(name1(ind(1)+1));
        end
    case {'MIT'}
        name_temp = ['PABCDEFGHIJKLMNOP'];
        for i = 1:length(ch)
            signalname{i} = ['_sig=\',name,name_temp(i:i+1),'2'];
            end
            judge(i) = str2num(name1(ind+1));
        end
end

