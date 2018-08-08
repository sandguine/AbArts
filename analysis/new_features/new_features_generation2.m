% Second attempt at new feature set
% Iman Wahle
% Created July 30 2018
%% init
NUM_FEATS = 4;
NUM_IMGS = 1001;
new_feats2 = zeros(NUM_IMGS, NUM_FEATS);

%% Image entropy (performed well in new_features_generation.m)
% https://www.mathworks.com/help/images/ref/entropy.html
fprintf('Calculating Entropy');
for i=1:length(ims)
    if mod(i,100)==0
        fprintf('.');
    end
    im = ims{i};
    if size(im,3) ~= 3
        continue;
    end
    
    new_feats2(i,1) = entropy(rgb2gray(im));
end
fprintf('\n');

%% Hue, Saturation, Value (performed well in Shonberg paper)
% https://www.mathworks.com/help/matlab/ref/rgb2hsv.html
fprintf('Calculating Hue, Saturation, and Value');
for i=1:length(ims)

    if mod(i,100)==0
        fprintf('.');
    end
    im = ims{i};
    if size(im,3) ~= 3
        continue;
    end

    hsv = rgb2hsv(im);
    new_feats2(i,2) = mean2(hsv(:,:,1));
    new_feats2(i,3) = mean2(hsv(:,:,2));
    new_feats2(i,4) = mean2(hsv(:,:,3));
end
fprintf('\n');

%% Now do Hue, Saturation, Value by clustered color segments
fprintf('Calculating Hue, Saturation, and Value by color segment');
for i=1:length(ims)
    if mod(i,100)==0
        fprintf('.');
    end
    im = ims{i}; 
    % figure;imshow(im); title(['im' num2str(i)]);
    if size(im,3) ~= 3
        continue;
    end
    lab_im = rgb2lab(im);
    ab = lab_im(:,:,2:3);
    nrows = size(ab,1); ncols = size(ab,2);
    ab = reshape(ab,nrows*ncols,2);
    nColors = 3;
    % repeat the clustering 3 times to avoid local minima
    [cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean');%, 'Replicates',3);
    pixel_labels = reshape(cluster_idx,nrows,ncols);
    % figure;imshow(pixel_labels,[]), title('image labeled by cluster index');
    
    si = cell(1,3);
    rgb_label = repmat(pixel_labels,[1 1 3]);

    for k = 1:nColors
        color = im;
        color(rgb_label ~= k) = 0;
        si{k} = color;
    end
    ind = 5;
    for j = 1:3
        hsv = rgb2hsv(si{j});
        for k=1:3
            hsvk = hsv(:,:,k);
            new_feats2(i,ind) = mean2(hsvk(hsvk~=0));
            ind = ind+1;
        end
    end
end
fprintf('\n');
