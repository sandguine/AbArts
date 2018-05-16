clear all
close all

%% Find analysis path and load files
if boolean(strfind(pwd, 'sandy'))
    savdir = '/Users/sandy/Dropbox/Caltech/AbArts/analysis/data';
else
    savdir = '/Users/miles/Dropbox/AbArts/analysis/data'
end
 
load([savdir '/', 'main_task', '.mat']);
load([savdir '/', 'features', '.mat']);

%% Transform files names to append
fileNames = table2array(image_file_names);
fileNames = fileNames.';
filePaths = array2table(fileNames(827:1652));
fileNames = array2table(fileNames(1:826));

imageFeatures = array2table(image_features);

fullData = [imageFeatures fileNames];