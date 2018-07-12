% Cluster user features to determine if different users rely
% on different image features in preference formation
% Iman Wahle
% July 10, 2018

% Constants
NUM_CLUST = 3;
NUM_PC = 10;

% Load data
usr_mat = load('user_svd_matrix20.mat');
usr_mat = usr_mat.user_svd_matrix20;

% PCA reduction
coeff = pca(usr_mat);
red = usr_mat * coeff(:, 1:NUM_PC);

% Cluster data
% c = clusterdata(red,'linkage', 'ward', 'maxclust', NUM_CLUST);
Y = pdist(usr_mat);
Z = linkage(Y, 'ward');
figure;dendrogram(Z);

% Plot first three dimensions
figure;scatter3(red(:,1),red(:,2),red(:,3),50,c,'filled');
xlabel('f1');ylabel('f2');zlabel('f3');
