% Calculate features with srm segmentation
% Iman Wahle
% August 8 2018


%% Load images

NUM_IMGS = 1001;
ims = cell(NUM_IMGS,1);
names = load('../data/segments_v2.mat');
files = names.image_file_names.image_names;
folders = names.image_file_names.image_folder;
for i=1:826
    folder = strrep(folders(i), '/Users/miles/Dropbox/AbArts', '../..');
    folder = strrep(folder, 'database', 'better_res_database');
    folder = strrep(folder, '000', '');
    folder = strrep(folder,'AbstractArt', 'abstract');
    folder = strrep(folder,'ColorFieldPainting', 'colorField');
    folder = strrep(folder, 'Impressionism', 'impressionism');
    file = files(i);
    if contains(file, '(Unicode Encoding Conflict)')
        ims{i} = 0;
    else
        img = file{1};%strcat(folder, file);
        % gross naming special cases :( 
        if strcmp(img, 'untitled-1.jpg!PinterestLarge(2).jpg') 
            ims{i} = imread([folder{1} 'untitled-1.jpg']);
        elseif strcmp(img, 'untitled-1.jpg!PinterestLarge(5).jpg')
            ims{i} = imread([folder{1} img]);
        elseif strcmp(img, 'untitled-1962.jpg!PinterestLarge(3).jpg')
            ims{i} = imread([folder{1} img]);
        elseif strcmp(img, 'untitled-1962.jpg!PinterestLarge(4).jpg')
            ims{i} = imread([folder{1} 'untitled-1962.jpg']);
        else
            sp = strsplit(img, '.');
            img = sp{1};%strrep(img, sp{end},'');
            img = [img '.*'];
            real_name = dir([folder{1} img]);
            ims{i} = imread([folder{1} real_name.name]);
        end
    end
end
%% also put the leslie pics in there
names = load('../data/segments_leslie_v1.mat');
files = names.image_file_names.image_names;
    folder = '../../data_from_leslie/big_photos/';

for i=827:1001
    file = files(i-826);
    img = strcat(folder, file);
    img = img{1};
    sp = strsplit(img, '.');
    img = strrep(img,sp{end},'');
    img = [img(1:end-1) '*'];
    real_name = dir(img);
    ims{i} = imread([folder real_name.name]);
end



%% load masks

load('region_masks12.mat');
load('region_masks22.mat');
load('region_masks32.mat');
load('region_masks42.mat');
load('region_masks52.mat');

masks = [region_masks1; region_masks2; region_masks3; region_masks4; region_masks5];
% masks = region_masks;
%% Initialize New Feature Set
seg_feats = zeros(NUM_IMGS, 100);
num_clusters = 3;

%% Calculate Relative Cluster Sizes For Each Image Beforehand
% and also store percent sizes of top 3 as features
orders = zeros(NUM_IMGS, num_clusters);
for i=1 %:length(ims)
    curr_feat = 1;

    if mod(i,100)==0
        fprintf('.');
    end
    im = ims{i}; 
    if size(im,3) ~= 3
        disp(i);
        continue;
    end
    
    mask_all = masks{i};
    cluster_labels = unique(mask_all);
    num_clusts = length(cluster_labels);
    % figure out which clusters are largest
    cluster_sizes = [cluster_labels zeros(num_clusts,1)];
    for m=1:num_clusts
        cluster_sizes(m,2) = sum(sum(mask_all==cluster_labels(m)));
    end
    cluster_sizes = sortrows(cluster_sizes, 2,  'descend');
    % store orders for later
    orders(i,:) = cluster_sizes(1:3,1)';
    % store sizes as features
%     for c=1:3
%         seg_feats(i,curr_feat) = cluster_sizes(c,2)/(size(im,1)*size(im,2));
%         curr_feat = curr_feat + 1;
% 
%     end 
end
%% Mean Hue, saturation, color value Per Segment
% This should address most color considerations

fprintf('\n');

% go through each image
for i=1:length(ims)
    curr_feat = 4;
    
    if mod(i,100)==0
        fprintf('.');
    end
    im = ims{i}; 
    if size(im,3) ~= 3
        continue;
    end
    
    mask_all = masks{i};
    
    % go through largest 3 clusters
    for c=1:3
        m = orders(i,c); % looking up the c'th largest cluster for image i
        %figure;subplot(1,2,1);imshow(im);
        % mask image
        mask = uint8(mask_all==m);
        try
            maskim = im.*repmat(mask,[1,1,3]);
        catch
            disp(i);
            continue;
        end
        %subplot(1,2,2);imshow(maskim);
        
        % store hue, saturation, and color value for largest 3 clusters
        hsv = rgb2hsv(maskim);
        for j=1:3
            cur = hsv(:,:,j);
            seg_feats(i,curr_feat) = mean2(cur(cur~=0));
            curr_feat = curr_feat + 1;
        end
    end
end


%% Distribution of Segments across Image
% This may correlate with what people may call 'balance' or 'unity'
fprintf('\n');
% go through each image
for i=1:length(ims)
    curr_feat = 13;
    
    if mod(i,100)==0
        fprintf('.');
    end
    im = ims{i}; 
    if size(im,3) ~= 3
        continue;
    end
    
    mask_all = masks{i};
    if size(mask_all,1) ~= size(im,1)
        continue;
    end
    % go through largest 3 clusters
    for c=1:3
        m = orders(i,c); % looking up the c'th largest cluster for image i
        %figure;subplot(1,2,1);imshow(im);
        % mask image
        mask = uint8(mask_all==m);
        % maskim = im.*repmat(mask,[1,1,3]);

        %subplot(1,2,2);imshow(mask);
        
        % first we need to define a rectangle around this cluster
        min_left = size(mask,2);
        min_right = 0;
        for x=1:size(mask,1)
            first = find(mask(x,:),1,'first');
            if first < min_left
                min_left = first;
            end
            last = find(mask(x,:),1, 'last');
            if last > min_right
                min_right = last;
            end
        end
        min_up = size(mask,1);
        min_down = 0;
        for y = 1:size(mask,2)
            first = find(mask(:,y),1, 'first');
            if first < min_up
                min_up = first;
            end
            last = find(mask(:,y),1,'last');
            if last > min_down
                min_down = last;
            end
        end
        
        rectx = min_down-min_up;
        recty = min_right-min_left;
%         min_down
%         min_up
%         min_right
%         min_left
%         rectx
%         recty
%         size(mask,1)
%         size(mask,2)
        seg_feats(i,curr_feat) = rectx/size(mask,1);
        curr_feat = curr_feat + 1;
        seg_feats(i,curr_feat) = recty/size(mask,2);
        curr_feat = curr_feat + 1;
        
        % now figure out how dense these rectangles are
        seg_feats(i,curr_feat) = sum(sum(mask(min_up:min_down, min_left:min_right)))/(rectx*recty);
        curr_feat = curr_feat + 1;
    end
end

%% Segment Moments
fprintf('\n');

% go through each image
for i=1:length(ims)
    curr_feat = 22;
    
    if mod(i,100)==0
        fprintf('.');
    end
    im = ims{i}; 
    if size(im,3) ~= 3
        continue;
    end
    
    mask_all = masks{i};
    if size(mask_all,1) ~= size(im,1)
        continue;
    end
    % go through largest 3 clusters
    for c=1:3
        m = orders(i,c); % looking up the c'th largest cluster for image i
        %figure;subplot(1,2,1);imshow(im);
        % mask image
        mask = (mask_all==m);
        
        % center of mass along x and y axes
        % taken from formulas 19 and 20 in Li paper
        indicesx = double(repmat((1:size(mask,2))/size(mask,2), size(mask,1),1));
        indicesxmask = indicesx.*mask; %repmat(mask,[1,1,3]);
        comx = sum(sum(indicesxmask))/sum(sum(mask));
        seg_feats(i,curr_feat) = comx;
        curr_feat = curr_feat + 1;
        
        indicesy = double(repmat(((1:size(mask,1))/size(mask,1))', 1, size(mask,2)));
        indicesymask = indicesy.*mask; %repmat(mask,[1,1,3]);
        comy = sum(sum(indicesymask))/sum(sum(mask));
        seg_feats(i,curr_feat) = comy;
        curr_feat = curr_feat + 1; 
        
        % variance
        % taken from formula 21 in Li paper
        indicesxsub = indicesx-comx;
        indicesxsubmask = indicesxsub.*mask;%repmat(mask,[1,1,3]);
        indicesysub = indicesy-comy;
        indicesysubmask = indicesysub.*mask;%repmat(mask,[1,1,3]);
        seg_feats(i,curr_feat) = ((sum(sum(indicesxsubmask.^2)) + sum(sum(indicesysubmask.^2))))/sum(sum(mask));
        curr_feat = curr_feat + 1;       
        
        % skewww
        % taken from formula 22 in Li paper
        indicesxsub = indicesx-comx;
        indicesxsubmask = indicesxsub.*mask;%repmat(mask,[1,1,3]);
        indicesysub = indicesy-comy;
        indicesysubmask = indicesysub.*mask;%repmat(mask,[1,1,3]);
        seg_feats(i,curr_feat) = ((sum(sum(indicesxsubmask.^3)) + sum(sum(indicesysubmask.^3))))/sum(sum(mask));
        curr_feat = curr_feat + 1;       
    end
    
end


%% entropy overall and by segment
fprintf('\n');

for i=1:length(ims)
    curr_feat = 33;
    if mod(i,50)==0
        fprintf('.');
    end
    im = ims{i};
    if size(im,3) ~= 3
        continue;
    end
    
    % overall entropy
    seg_feats(i,curr_feat) = entropy(rgb2gray(im));
    curr_feat = curr_feat + 1;
    
    % entropy by segment
    mask_all = masks{i};
    if size(mask_all,1) ~= size(im,1)
        continue;
    end
    
    % go through largest 3 clusters
    for c=1:3
        m = orders(i,c); % looking up the c'th largest cluster for image i
        %figure;subplot(1,2,1);imshow(im);
        % mask image
        mask = uint8(mask_all==m);
        maskim = im.*repmat(mask,[1,1,3]);
        seg_feats(i,curr_feat) = entropy(rgb2gray(maskim));
        curr_feat = curr_feat + 1;   
    end
end

%% Image Size Ratio
fprintf('\n');

for i=1:length(ims)
    curr_feat = 37;
    if mod(i,50)==0
        fprintf('.');
    end
    im = ims{i};
    if size(im,3) ~= 3
        continue;
    end
    seg_feats(i,curr_feat) = size(im,1)/size(im,2);
end

%% Symmetry by Segment
fprintf('\n');

for i=1 %:length(ims)
    curr_feat = 70;
    if mod(i,100)==0
        fprintf('.');
    end
    im = ims{i};
    if size(im,3) ~= 3
        continue;
    end
    mask_all = masks{i};
    if size(mask_all,1) ~= size(im,1)
        continue;
    end
    % go through largest 3 clusters
    for c=1:3
        m = orders(i,c); % looking up the c'th largest cluster for image i
        %figure;subplot(1,2,1);imshow(im);
        % mask image
        mask = uint8(mask_all==m);
        
        % first we need to define a rectangle around this cluster
        min_left = size(mask,2);
        min_right = 0;
        for x=1:size(mask,1)
            first = find(mask(x,:),1,'first');
            if first < min_left
                min_left = first;
            end
            last = find(mask(x,:),1, 'last');
            if last > min_right
                min_right = last;
            end
        end
        min_up = size(mask,1);
        min_down = 0;
        for y = 1:size(mask,2)
            first = find(mask(:,y),1, 'first');
            if first < min_up
                min_up = first;
            end
            last = find(mask(:,y),1,'last');
            if last > min_down
                min_down = last;
            end
        end
        cropped = mask(min_up:min_down, min_left:min_right);
        figure;imagesc(cropped);
        figure;imagesc(fliplr(cropped));
        figure;imagesc(flipud(cropped));
        area = (min_down-min_up)*(min_right-min_left);
%         all_feats_reduced2(i,curr_feat) = immse(cropped, fliplr(cropped))/area;
%         curr_feat = curr_feat + 1;
%         all_feats_reduced2(i,curr_feat) = immse(cropped, flipud(cropped))/area;
%         curr_feat = curr_feat + 1;
    end
end