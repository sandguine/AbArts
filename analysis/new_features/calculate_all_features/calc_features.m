% Calculate all low-level features given an image
% Iman Wahle
% September 22 2018

% Calculating low-level features according to 
% analysis/new_features/calculate_all_features/calc_features_names.mat
function [features] = calc_features(image)
    
    % init
    features = zeros(72,1);
   
    % calculate li global low-level features (based on
    % analysis/script/image_analysis/create_feature_table.m)
    addpath('./functions');
    
    X = double(image)/255;  %% RGB 0 to 1
    Y=colorspace('rgb->hsl',X);  %% HSL  hue is expressed in dgree 0 - 360.
    
    features(1) = mean_hue(Y);
    features(2) = mean_s(Y);

    n_bin=20;
    threshold =0.1; 
    features(3) = hue_count(Y,n_bin, threshold );
    features(4) = number_most_count_hue(Y,n_bin);
    features(5) = hue_contrast( Y,n_bin,threshold);

    n_sample=5;
    [features(6), ~, ~] = hue_model_choose( Y, n_sample);
    % features(7) = 0;   %% I haven't done it yet. Do we need this? %
    % skipped
    features(7) = mean_brightness(X);
    features(8) = mean_log_brightness(X);

    n_bin=100;
    features(9) = brightness_contrast(X, n_bin);

    threshold=4;
    features(10) = blurr(X, threshold);
    n_sample=5;
    features(11) = edge_distribution(X, n_sample);
    
    % graphcut segmentation
    label_pixels = label_segments(image); % TODO: implement label_segments
    
    
    % calculate li local low-level features (based on
    % analysis/script/image_analysis/create_feature_table_local_leslie.m)
    
    label_array=double(reshape(label_pixels,[],1));
    n_pixel=length(label_array);

    [n,bin] = hist(label_array,unique(label_array));
    [~,idx] = sort(-n);
    label_list=bin(idx); % corresponding values

    clearvars Label_ones
    for i_label=1:current_n_labels
        Label_ones{i_label} = (label_pixels==label_list(i_label));
    end

    for i_label=1:2
        [row,col] = find(Label_ones{i_label} == 1);
        index = find(Label_ones{i_label} == 1);

        n_pixel_segment=length(index);
        
        features(11+i_label)= sum(row)/n_pixel_segment; % com x
        features(13+i_label)= sum(col)/n_pixel_segment; % com y
        features(15+i_label)= sum((row-mean(row)).^2+(col-mean(col)).^2)/n_pixel_segment; % var
        features(17+i_label)= sum((row-mean(row)).^3+(col-mean(col)).^3)/n_pixel_segment; % skew
        
        z=Y(:,:,1);
        q1=sum(z(index))/n_pixel_segment;
        features(19+i_label)= q1; % mean hue

        z=Y(:,:,2);
        q2=sum(z(index))/n_pixel_segment;
        features(21+i_label)=  q2; % mean saturation

        z=Y(:,:,3);
        q3=sum(z(index))/n_pixel_segment;
        features(23+i_label)= q3; % mean brightness
    end
    
    for i_label=1:current_n_labels
                
        [row,col] = find( Label_ones{i_label} == 1);
        index=find( Label_ones{i_label} == 1);
        index_ones=(Label_ones{i_label} == 1);
        
        z=Y(:,:,1);
        q1=sum(z(index))/n_pixel_segment;
        MeanH(i_label)=q1;
        
        z=Y(:,:,2);
        q2=sum(z(index))/n_pixel_segment;
        MeanS(i_label)=q2;
        
        z=Y(:,:,3);
        q3=sum(z(index))/n_pixel_segment;
        MeanL(i_label)=q3;

        threshold=1;

        clearvars z localimage

        for q=1:3
            z=X(:,:,q);
            localimage(:,:,q)=z.*index_ones;
        end

        local_blur(i_label)=blurr( localimage,threshold );

        clearvars localimage index_ones z 
    end

    s=0;
    for l=1: current_n_labels-1
        for j=2:current_n_labels
            s=s+1;

           diffH(s)= abs(MeanH(l)-MeanH(j));
           diffS(s)=abs(MeanS(l)-MeanS(j));
           diffL(s)=abs(MeanL(l)-MeanL(j));
           diffB(s)=abs(local_blur(l)-local_blur(j));
        end
    end

    features(26)=max(diffH); % hue contrast between segments
    features(27)=max(diffS); % sat contrast between segments
    features(28)=max(diffL); % brightness contrast between segments
    features(29)= max(diffB); % blurring contrast between segments

    clearvars diffH diffS diffL difB localimage index_ones z Label_ones 
    
    [p_y,p_x,p_z]=size(X);
    qy=round(p_y/15);
    qx=round(p_x/15);
    centre_image= Y(4*qy:11*qy,4*qx:11*qx, :);
    % imshow(X(4*qy:11*qy,4*qx:11*qx, :))
    
    features(30)=mean(mean(centre_image(:,:,1))); % mean H focus region
    features(31)=mean(mean(centre_image(:,:,2))); % mean S focus region
    features(32)=mean(mean(centre_image(:,:,3))); % mean L focus region



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % calculate srm features
    
    
    % srm segmentation
    curr_feat = 33;
    mask_all = srm_masks(image);

    if size(image,3) ~= 3
        return;
    end
    
    % cluster size
    
    cluster_labels = unique(mask_all);
    num_clusts = length(cluster_labels);
    % figure out which clusters are largest
    cluster_sizes = [cluster_labels zeros(num_clusts,1)];
    for m=1:num_clusts
        cluster_sizes(m,2) = sum(sum(mask_all==cluster_labels(m)));
    end
    cluster_sizes = sortrows(cluster_sizes, 2,  'descend');
    % store orders for later
    order = cluster_sizes(1:3,1)';
    % store sizes as features
    for c=1:2
        features(curr_feat) = cluster_sizes(c,2)/(size(image,1)*size(image,2));
        curr_feat = curr_feat + 1;
    end
 
    % mean hsv
    for c=1:2
        m = order(c); % looking up the c'th largest cluster for image i
        %figure;subplot(1,2,1);imshow(image);
        % mask image
        mask = uint8(mask_all==m);
        try
            maskim = image.*repmat(mask,[1,1,3]);
        catch
            disp('error with cluster mask in mean hsv calculation');
            return;
        end
        
        % store hue, saturation, and color value for largest 3 clusters
        hsv = rgb2hsv(maskim);
        for j=1:3
            cur = hsv(:,:,j);
            features(curr_feat) = mean2(cur(cur~=0));
            curr_feat = curr_feat + 1;
        end
    end
    
    % moments
    for c=1:2
        m = order(c); % looking up the c'th largest cluster for image i
        % mask image
        mask = (mask_all==m);
        
        % center of mass along x and y axes
        % taken from formulas 19 and 20 in Li paper
        indicesx = double(repmat((1:size(mask,2))/size(mask,2), size(mask,1),1));
        indicesxmask = indicesx.*mask; %repmat(mask,[1,1,3]);
        comx = sum(sum(indicesxmask))/sum(sum(mask));
        features(curr_feat) = comx;
        curr_feat = curr_feat + 1;
        
        indicesy = double(repmat(((1:size(mask,1))/size(mask,1))', 1, size(mask,2)));
        indicesymask = indicesy.*mask; %repmat(mask,[1,1,3]);
        comy = sum(sum(indicesymask))/sum(sum(mask));
        features(curr_feat) = comy;
        curr_feat = curr_feat + 1; 
        
        % variance
        % taken from formula 21 in Li paper
        indicesxsub = indicesx-comx;
        indicesxsubmask = indicesxsub.*mask;%repmat(mask,[1,1,3]);
        indicesysub = indicesy-comy;
        indicesysubmask = indicesysub.*mask;%repmat(mask,[1,1,3]);
        features(curr_feat) = ((sum(sum(indicesxsubmask.^2)) + sum(sum(indicesysubmask.^2))))/sum(sum(mask));
        curr_feat = curr_feat + 1;       
        
        % skewww
        % taken from formula 22 in Li paper
        indicesxsub = indicesx-comx;
        indicesxsubmask = indicesxsub.*mask;%repmat(mask,[1,1,3]);
        indicesysub = indicesy-comy;
        indicesysubmask = indicesysub.*mask;%repmat(mask,[1,1,3]);
        features(curr_feat) = ((sum(sum(indicesxsubmask.^3)) + sum(sum(indicesysubmask.^3))))/sum(sum(mask));
        curr_feat = curr_feat + 1;       
    end
    
    
    % overall entropy
    features(curr_feat) = entropy(rgb2gray(image));
    curr_feat = curr_feat + 1;
    
    % entropy by segment
    for c=1:2
        m = order(c); % looking up the c'th largest cluster for image i
        %figure;subplot(1,2,1);imshow(im);
        % mask image
        mask = uint8(mask_all==m);
        maskim = image.*repmat(mask,[1,1,3]);
        features(curr_feat) = entropy(rgb2gray(maskim));
        curr_feat = curr_feat + 1;   
    end
    
    % image size ratio
    features(curr_feat) = size(image,1)/size(image,2);
    curr_feat = curr_feat + 1;   

    % symmetry
    for c=1:2
        m = order(c); % looking up the c'th largest cluster for image i
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
%         figure;imagesc(cropped);
%         figure;imagesc(fliplr(cropped));
%         figure;imagesc(flipud(cropped));
        area = (min_down-min_up)*(min_right-min_left);
        features(curr_feat) = immse(cropped, fliplr(cropped))/area;
        curr_feat = curr_feat + 1;
        features(curr_feat) = immse(cropped, flipud(cropped))/area;
        curr_feat = curr_feat + 1;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % calculate kmeans features
    
    % mean r
    
    % lab clustering explained:
    % https://www.mathworks.com/help/images/color-based-segmentation-using-k-means-clustering.html)
    lab_im = rgb2lab(image);
    ab = lab_im(:,:,2:3);
    clear lab_im;
    nrows = size(ab,1); ncols = size(ab,2);
    ab = reshape(ab,nrows*ncols,2);
    nColors = 3;
    [cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean');%, 'Replicates',3);
    pixel_labels = reshape(cluster_idx,nrows,ncols);
    % figure;imshow(pixel_labels,[]), title('image labeled by cluster index');
    
    segmented_images = cell(1,3);
    rgb_label = repmat(pixel_labels,[1 1 3]);

    for k = 1:nColors
        color = image;
        color(rgb_label ~= k) = 0;
        segmented_images{k} = color;
    end
    s1 = segmented_images{1}; s2 = segmented_images{2}; s3 = segmented_images{3}; 
    
    features(curr_feat) = mean(s1(s1(:,:,1)~=0));
    curr_feat = curr_feat + 1;
    features(curr_feat) = mean(s2(s2(:,:,1)~=0));
    curr_feat = curr_feat + 1;
    
    
    % mean hsv
    hsv1 = rgb2hsv(s1); hsv2 = rgb2hsv(s2);
    for l = 1:3
        features(curr_feat) = mean2(hsv1(:,:,l));
        curr_feat = curr_feat + 1;
    end
    for l = 1:3
        features(curr_feat) = mean2(hsv2(:,:,l));
        curr_feat = curr_feat + 1;
    end
    
    % image intensity histogram bins
    [counts, ~] = imhist(image,5);
    %figure;(imhist(image,5));set(gcf, 'color', 'white');
    features(curr_feat:curr_feat+4) = counts/(size(image,1)*size(image,2));
    curr_feat = curr_feat + 5;
    
    % hsv mode
    hsvall = rgb2hsv(image);
    for l = 1:3
        features(curr_feat) = mode(reshape(hsvall(:,:,l),[],1));
        curr_feat = curr_feat + 1;
    end   
end