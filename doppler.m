%% birdview, P1 is upper and P2 is lower
shot = 93871
shotxx = num2str(shot);

%% 判断炮号在哪个对应文件夹
shot2018O = [76181:80699];
shot2018X = [80710:81692];

shot2019 = [83218:94686];
shot2020 = [94688:97422];
shot2021 = [97423:107851];


if ismember(shot,shot2018O)
    data_path='V:\reflfluc\Refl_Fluc_2018\O_20-40';
    filepathxx = 'E:\2018EHOlikeshot\';
    card_name = '5105A';
elseif ismember(shot,shot2018X)
    data_path='V:\reflfluc\Refl_Fluc_2018\X_W';
    filepathxx = 'E:\2018EHOlikeshot\';
    card_name = '5105A';
elseif ismember(shot, shot2019)
    data_path='V:\reflfluc\Refl_Fluc_2019';
    filepathxx = 'E:\2019EHOlikeshot\';
    card_name = 'O_P1';
elseif ismember(shot, shot2020)
    data_path='V:\reflfluc\Refl_Fluc_2020';
    filepathxx = 'E:\2020EHOlikeshot\';
    card_name = 'O_P1';
elseif ismember(shot, shot2021)
    data_path='V:\reflfluc\Refl_Fluc_2021';
    filepathxx = 'E:\2021EHOlikeshot\';
    card_name = 'O_P1';
else
    disp('Shot num error!!')
end

