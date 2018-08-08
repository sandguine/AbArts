% Processes for extracting new objective feature set from images
% Tested on example image from each category
% Iman Wahle
% Created July 24, 2018

%% Setup
im1 = imread('abstraccion-no-3-1953.jpg!PinterestLarge.jpg');
im2 = imread('a-fisherman-s-cottage.jpg!PinterestLarge.jpg');
im3 = imread('after-the-cloud.jpg!PinterestLarge.jpg');
im4 = imread('arlequin-dansant-1924.jpg!PinterestLarge.jpg');

ims = {im1 im2 im3 im4};

%% Image Segmentation - by color
% https://www.mathworks.com/help/images/examples/color-based-segmentation-using-k-means-clustering.html?prodcode=IP&language=en
close all;
for i=1:length(ims)
    im = ims{i}; 
    figure;imshow(im); title(['im' num2str(i)]);
    lab_im = rgb2lab(im);
    ab = lab_im(:,:,2:3);
    nrows = size(ab,1); ncols = size(ab,2);
    ab = reshape(ab,nrows*ncols,2);
    nColors = 3;
    % repeat the clustering 3 times to avoid local minima
    [cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', 'Replicates',3);
    pixel_labels = reshape(cluster_idx,nrows,ncols);
    % figure;imshow(pixel_labels,[]), title('image labeled by cluster index');
    
    segmented_images = cell(1,3);
    rgb_label = repmat(pixel_labels,[1 1 3]);

    for k = 1:nColors
        color = im;
        color(rgb_label ~= k) = 0;
        segmented_images{k} = color;
    end

    figure;imshow(segmented_images{1}), title('objects in cluster 1');
    figure;imshow(segmented_images{2}), title('objects in cluster 2');
    figure;imshow(segmented_images{3}), title('objects in cluster 3');

end
clearvars -except ims
%% Image Segmentation - by watershed segmentation
% https://www.mathworks.com/help/images/examples/marker-controlled-watershed-segmentation.html?prodcode=IP&language=en
close all;
for i=1:length(ims)
    im = ims{i};
    figure;subplot(1,3,1);
    imshow(im);title('original');
    I = rgb2gray(im);
    hy = fspecial('sobel');
    hx = hy';
    Iy = imfilter(double(I), hy, 'replicate');
    Ix = imfilter(double(I), hx, 'replicate');
    gradmag = sqrt(Ix.^2 + Iy.^2);
    % figure;imshow(gradmag,[]), title('Gradient magnitude (gradmag)');
    se = strel('disk', 20);
    % Io = imopen(I, se);
    % figure;imshow(Io), title('Opening (Io)');
    Ie = imerode(I, se);
    Iobr = imreconstruct(Ie, I);
    % figure;imshow(Iobr), title('Opening-by-reconstruction (Iobr)');
    % Ioc = imclose(Io, se);
    % figure;imshow(Ioc), title('Opening-closing (Ioc)');
    Iobrd = imdilate(Iobr, se);
    Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
    Iobrcbr = imcomplement(Iobrcbr);
    % figure;imshow(Iobrcbr), title('Opening-closing by reconstruction (Iobrcbr)');
    fgm = imregionalmax(Iobrcbr);
    % figure;imshow(fgm), title('Regional maxima of opening-closing by reconstruction (fgm)');
    % I2 = I;
    % I2(fgm) = 255;
    % figure;imshow(I2), title('Regional maxima superimposed on original image (I2)');
    se2 = strel(ones(5,5));
    fgm2 = imclose(fgm, se2);
    fgm3 = imerode(fgm2, se2);
    fgm4 = bwareaopen(fgm3, 20);
    % I3 = I;
    % I3(fgm4) = 255;
    % figure;imshow(I3);title('Modified regional maxima superimposed on original image (fgm4)');
    bw = imbinarize(Iobrcbr);
    % figure;imshow(bw), title('Thresholded opening-closing by reconstruction (bw)');
    D = bwdist(bw);
    DL = watershed(D);
    bgm = DL == 0;
    subplot(1,3,2);imshow(bgm), title('Watershed ridge lines (bgm)');
    gradmag2 = imimposemin(gradmag, bgm | fgm4);
    L = watershed(gradmag2);
    % I4 = I;
    % I4(imdilate(L == 0, ones(3, 3)) | bgm | fgm4) = 255;
    % figure;imshow(I4);title('Markers and object boundaries superimposed on original image (I4)');
    Lrgb = label2rgb(L, 'jet', 'w', 'shuffle');
    subplot(1,3,3);imshow(Lrgb);title('Colored watershed label matrix (Lrgb)');
end
clearvars -except ims
%% Image Segmentation - by texture
% https://www.mathworks.com/help/images/examples/texture-segmentation-using-texture-filters.html
close all;
for i=1%:length(ims)
    im = ims{i};
    figure;subplot(1,3,1);imshow(im);
    im = rgb2gray(im);
    subplot(1,3,2);imshow(im);
    E = entropyfilt(im);
    % Eim = rescale(E);
    Eim = E./max(E);
    % figure;imshow(Eim);
    BW1 = imbinarize(Eim, .75);
    % figure;imshow(BW1);
    BWao = bwareaopen(BW1,2000);
    % figure;imshow(BWao);
    nhood = true(9);
    closeBWao = imclose(BWao,nhood);
    % figure;imshow(closeBWao);
    roughMask = imfill(closeBWao,'holes');
    subplot(1,3,3);imshow(roughMask);
end
%clearvars -except ims 
%% Edge Detection? 
% https://www.mathworks.com/videos/edge-detection-with-matlab-119353.html

%% Region-Specific Properties
% https://www.mathworks.com/help/images/calculate-region-properties-using-image-region-analyzer.html
%% Object Area
close all;
areas = zeros(length(ims),1);
for i=1%:length(ims)
    im = ims{i};
    im = rgb2gray(im);
    im = imbinarize(im);
    areas(i,1) = bwarea(im)/(size(im,1)*size(im,2));
end
%clearvars -except areas ims
%% Contour Plots
% https://www.mathworks.com/help/images/ref/imcontour.html

close all;
contours = cell(4);
for i=1:length(ims)
    im = ims{i};
    figure;subplot(1,2,1);imshow(im);
    im = rgb2gray(im);
    [ic,c] = imcontour(im, 4);
    contours{i} = ic;
    subplot(1,2,2);ic;
end
clearvars -except contours ims

%% Image Intensity Histogram
close all;
for i=1:length(ims)
    im = ims{i};
    figure;subplot(1,2,1);imshow(im);
    subplot(1,2,2);imhist(im);
end
%% Image Quality Measurements
% https://www.mathworks.com/help/images/image-quality-metrics.html

% brisque score:
% NOTE: Only works with Matlab 2017b and above.
close all;
brisques = zeros(length(ims),1);
for i=1:length(ims)
    im = ims{i};
    brisques(i,1) = brisque(im);
end

%% Block Processing?
% https://www.mathworks.com/help/images/ref/blockproc.html

%% Motion Measurement
% http://iopscience.iop.org/article/10.1088/0957-0233/21/7/075502/meta

%% Symmetry
% Mean Squared Error between the image and its flipped version
% immse( YourImage, fliplr(YourImage) )
close all;
symmetry = zeros(length(ims),1);
for i=1:length(ims)
    im = ims{i};
    im = rgb2gray(im);
    symmetry(i,1) = immse(im, fliplr(im));
end
clearvars -except symmetry ims
%% Image Orientation
% https://www.mathworks.com/matlabcentral/answers/124994-detecting-orientation-symmetry-in-an-image
close all;
orientations = zeros(length(ims),1);
for i=1:length(ims)
%     disp('new image');
    rgbImage = ims{i};
    % Get the dimensions of the image.  numberOfColorBands should be = 3.
    [rows, columns, numberOfColorBands] = size(rgbImage);
    if numberOfColorBands > 1
        grayImage = rgb2gray(rgbImage);
    else
        grayImage = rgbImage;
    end
    % Display the original color image.
%     figure;subplot(3, 3, 1);
%     imshow(grayImage);
%     title('Original Image');
    % Enlarge figure to full screen.
%     set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
    % Let's compute and display the histogram.
    [pixelCount, grayLevels] = imhist(grayImage);
%     subplot(3, 3, 2); 
%     bar(grayLevels, pixelCount);
%     grid on;
%     title('Histogram of original image');
%     xlim([0 grayLevels(end)]); % Scale x axis manually.
%     drawnow;
    mask = grayImage < 200; % Entire can lid
    % Get rid of holes inside.
    mask = imfill(mask, 'holes');
    % Erode to shrink the mask and get rid of letters.
    se = strel('disk', 45, 0);
    mask = imerode(mask, se);
%     subplot(3, 3, 3);
%     imshow(mask);
%     drawnow;
%     title('Mask for can interior');
    % Mask the image
    maskedImage = grayImage;
    maskedImage(~mask) = 0;
%     subplot(3, 3, 4);
%     imshow(maskedImage);
%     title('Masked can lid');
    % Get gradient
    gradImage = imgradient(maskedImage);
%     subplot(3, 3, 5);
%     imshow(gradImage, []);
%     title('Gradient');
    % Shrink mask again to get rid of outer outline
    se = strel('disk', 15, 0);
    mask = imerode(mask, se);
    gradImage(~mask) = 0;
%     subplot(3, 3, 6);
%     imshow(gradImage, []);
%     title('Gradient (smaller)');
    % Get histogram
    pixelCount = hist(gradImage(:), 100);
    % Suppress 0 so we can see the histogram
    pixelCount(1)=0;
%     subplot(3, 3, 7); 
%     bar(pixelCount);
%     grid on;
%     title('Histogram of Gradient Image');
%     drawnow;
    % Threshold to get a binary image
    binaryImage = gradImage > 45;
    % Get rid of holes inside.
    binaryImage = imfill(binaryImage, 'holes');
%     subplot(3, 3, 8);
%     imshow(binaryImage, []);
%     title('Initial Binary Image');
    % Label the image
    labeledImage = bwlabel(binaryImage);
    % Make measurements of orientation
    measurements = regionprops(labeledImage, 'Orientation', 'Area');
%     disp(measurements(1).Orientation);
    % Find the largest blob
    [allAreas, sortIndexes] = max(sort([measurements.Area], 'Descend'));
    % Pluck out largest one
    biggestBlob = ismember(labeledImage, sortIndexes(1)) > 0;
%     subplot(3, 3, 9);
%     imshow(biggestBlob, []);
%     title('Final Binary Image');
    % Measure again, this time just the largest blob.
    % Label the image
    labeledImage = bwlabel(biggestBlob);
    % Make measurements of orientation
    measurements = regionprops(labeledImage, 'Orientation', 'Area');
    orientations(i,1) = measurements(1).Orientation;
end
clearvars -except orientations ims
%% Image Entropy
% https://www.mathworks.com/help/images/ref/entropy.html

close all;
entropies = zeros(length(ims),1);
for i=1:length(ims)
    im = ims{i};
    entropies(i,1) = entropy(rgb2gray(im));
end
clearvars -except ims entropies
%% Temperature
% https://www.mathworks.com/matlabcentral/answers/130143-how-to-convert-image-pixels-values-to-the-temperature-values

%% Contrast
% RMS contrast: https://en.wikipedia.org/wiki/Contrast_(vision)

close all;
contrasts = zeros(length(ims),1);
for i=1:length(ims)
   im = ims{i};
   contrasts(i,1) = sqrt(mean2(im-mean2(im)).^2);
end