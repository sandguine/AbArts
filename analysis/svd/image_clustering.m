% Clustering images by SVD-extracted features
% Iman Wahle
% July 9, 2018

% Constants
NUM_PC = 3;
NUM_CLUST = 3;

% Load data
img_mat = load('image_svd_matrix100.mat');
img_mat = img_mat.image_svd_matrix100;

% PCA reduction
coeff = pca(img_mat);
red = img_mat * coeff(:, 1:NUM_PC);

% Cluster principal components
c = clusterdata(red,'linkage', 'ward', 'maxclust', NUM_CLUST);

% Plot first three dimensions
figure;scatter3(red(:,1),red(:,2),red(:,3),50,c,'filled');
xlabel('f1');ylabel('f2');zlabel('f3');

% Look at image variation across a dimension
comp = [(1:826)' c red];

c1 = comp(comp(:,4)>-.1 & comp(:,4)<.1 & comp(:,5)>-.1 & comp(:,5)<.1, :);
c2 = comp(comp(:,3)>-.1 & comp(:,3)<.1 & comp(:,5)>-.1 & comp(:,5)<.1, :);
c3 = comp(comp(:,4)>-.1 & comp(:,4)<.1 & comp(:,3)>-.1 & comp(:,3)<.1, :);

c1 = sortrows(c1, 3);
c2 = sortrows(c2, 4);
c3 = sortrows(c3, 5);

lookup_images(c1(:,1)', round(length(c1(:,1))/10)+1, 10);
lookup_images(c2(:,1)', round(length(c2(:,1))/10)+1, 10);
lookup_images(c3(:,1)', round(length(c3(:,1))/10)+1, 10);

