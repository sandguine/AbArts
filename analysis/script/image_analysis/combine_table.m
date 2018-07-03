
clear all
close all

 %% 
 
if boolean(strfind(pwd, 'sandy'))
    savdir = '/Users/sandy/Dropbox/Caltech/AbArts/analysis/data';
elseif  boolean(strfind(pwd, 'miles'))
    savdir = '/Users/miles/Dropbox/AbArts/analysis/data';
else
     savdir = 'D:/Dropbox/AbArts/analysis/data';
end
 

name_file_1='features';

load(fullfile(savdir,name_file_1),'image_features','image_file_names','categories');


image_features_1=image_features;
image_file_names_1= image_file_names;

clearvars image_features image_file_names

name_file_2='features_FellowLab';

load(fullfile(savdir,name_file_2),'image_features','image_file_names');


image_features_2=image_features;
image_file_names_2= image_file_names;

clearvars image_features image_file_names

image_names = [image_file_names_1.image_names,image_file_names_2.image_names];

image_folder= [image_file_names_1.image_folder,image_file_names_2.image_folder];


image_file_names= table(image_names,image_folder);

image_features=[image_features_1; image_features_2];


name_file_3='features_global_all';

save(fullfile(savdir,name_file_3),'image_features','image_file_names');


%% local



name_file_1='local_features';

load(fullfile(savdir,name_file_1),'image_features','image_file_names','categories');


image_features_1=image_features;
image_file_names_1= image_file_names;

clearvars image_features image_file_names

name_file_2='local_features_leslie';

load(fullfile(savdir,name_file_2),'image_features','image_file_names');


image_features_2=image_features;
image_file_names_2= image_file_names;

clearvars image_features image_file_names

image_names = [image_file_names_1.image_names,image_file_names_2.image_names];

image_folder= [image_file_names_1.image_folder,image_file_names_2.image_folder];


image_file_names= table(image_names,image_folder);

image_features=[image_features_1; image_features_2];


name_file_3='features_local_all';

save(fullfile(savdir,name_file_3),'image_features','image_file_names');





