% Created June 29, 2018
% Iman Wahle
% Formatting MTurk image preference data for SVD analysis
close all;
clear all;

main_task = load('../data/main_task_all_v1.mat');
data = main_task.maintask_table_rating;
image_data = load('../data/image_index_main_task.mat');
image_index = image_data.rated_image_index.';
NUM_USERS = max(table2array(data(:,2)));
NUM_IMAGES = max(image_index);

if size(image_index,1) ~= size(data,1)
    disp('indexing off');
end

% input data format: user | image | rating
X_list = [table2array(data(:,2)) image_index(:,1) table2array(data(:,5))];

% fill user x image matrix
X = -1*ones(NUM_USERS,NUM_IMAGES);
for i=1:size(X_list,1)
    X(X_list(i,1),X_list(i,2)) = X_list(i,3);
end
X = X+1; % increase all ratings by 1 so that images are rated from 1-4 and
         % non-rated images are denoted 0 so we can use as sparse matrix

% save('ratings_matrix.mat', 'X');
% save('ratings_list.mat','X_list');
% 


