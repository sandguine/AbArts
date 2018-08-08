% Image Segmentation Testing
% Iman Wahle
% August 6 2018

% source: https://www.mathworks.com/help/images/ref/multithresh.html

%% Load Images

im1 = imread('../abstraccion-no-3-1953.jpg!PinterestLarge.jpg');
im2 = imread('../a-fisherman-s-cottage.jpg!PinterestLarge.jpg');
im3 = imread('../after-the-cloud.jpg!PinterestLarge.jpg');
im4 = imread('../arlequin-dansant-1924.jpg!PinterestLarge.jpg');

ims = {im1 im2 im3 im4};

%%
n_clusters = 4;
for j=1:length(ims)
    im = ims{j};
    
    figure;subplot(1,2,1);imshow(im);
    [thresh,metric] = multithresh(im,n_clusters-1);
    
    threshForPlanes = zeros(3,n_clusters);			

    for i = 1:3
        threshForPlanes(i,:) = multithresh(im(:,:,i),n_clusters-1);
    end

    value = [0 thresh(2:end) 255]; 
    quantRGB = imquantize(im, thresh, value);
    
    quantPlane = zeros(size(im));

    for i = 1:3
        value = [0 threshForPlanes(i,2:end) 255]; 
        quantPlane(:,:,i) = imquantize(im(:,:,i),threshForPlanes(i,:),value);
    end

    quantPlane = uint8(quantPlane);
    figure;imshowpair(quantRGB,quantPlane,'montage') 
    axis off
    title('Full RGB Image Quantization        Plane-by-Plane Quantization')
end


%%
n_clusters = 4;
for j=1:length(ims)
    
    im = ims{j};
    im = rgb2gray(im);
    
    figure;subplot(1,2,1);imshow(im);
    [thresh,metric] = multithresh(im,n_clusters-1);
    
    seg_I = imquantize(im,thresh);
    RGB = label2rgb(seg_I); 	 
    subplot(1,2,2);imshow(RGB)
    axis off
    title('RGB Segmented Image')
 
end




