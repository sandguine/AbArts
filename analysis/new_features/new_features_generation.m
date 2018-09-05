% Calculate new features for all pictures

NUM_FEATS = 100;
NUM_IMGS = 1001;

new_feats = zeros(NUM_IMGS, NUM_FEATS);

%% Construct collection of images to calculate features for

ims = cell(1001,1);
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

%% calculate features now :) 


%% Image Segmentation - by color
% https://www.mathworks.com/help/images/examples/color-based-segmentation-using-k-means-clustering.html?prodcode=IP&language=en
close all;
for i=1 :length(ims)
    if mod(i,50)==0
        fprintf('.');
    end
    im = ims{i}; 
    % figure;imshow(im); title(['im' num2str(i)]);
    if size(im,3) ~= 3
        continue;
    end
    lab_im = rgb2lab(im);
    ab = lab_im(:,:,2:3);
    clear lab_im;
    nrows = size(ab,1); ncols = size(ab,2);
    ab = reshape(ab,nrows*ncols,2);
    nColors = 3;
    % repeat the clustering 3 times to avoid local minima (skipped)
    [cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean');%, 'Replicates',3);
    pixel_labels = reshape(cluster_idx,nrows,ncols);
    % figure;imshow(pixel_labels,[]), title('image labeled by cluster index');
    
    segmented_images = cell(1,3);
    rgb_label = repmat(pixel_labels,[1 1 3]);

    for k = 1:nColors
        color = im;
        color(rgb_label ~= k) = 0;
        segmented_images{k} = color;
    end
    s1 = segmented_images{1}; s2 = segmented_images{2}; s3 = segmented_images{3}; 
    
    c1 = [mean(s1(s1(:,:,1)~=0)) mean(s1(s1(:,:,2)~=0)) mean(s1(s1(:,:,3)~=0))];
    c2 = [mean(s2(s2(:,:,1)~=0)) mean(s2(s2(:,:,2)~=0)) mean(s2(s2(:,:,3)~=0))];
    c3 = [mean(s3(s3(:,:,1)~=0)) mean(s3(s3(:,:,2)~=0)) mean(s3(s3(:,:,3)~=0))];
    
    new_feats(i,1:3) = c1; new_feats(i,4:6) = c2; new_feats(i,7:9) = c3;
    new_feats(i,10:12) = c1-c2; new_feats(i,13:15) = c2-c3; new_feats(i,16:18) = c3-c1;

    cnt = 19;
    hsv1 = rgb2hsv(s1); hsv2 = rgb2hsv(s2);hsv3 = rgb2hsv(s3);
    for l = 1:3
        new_feats(i,cnt) = mean2(hsv1(:,:,l));
        cnt = cnt + 1;
    end
    for l = 1:3
        new_feats(i,cnt) = mean2(hsv2(:,:,l));
        cnt = cnt + 1;
    end
    for l = 1:3
        new_feats(i,cnt) = mean2(hsv3(:,:,l));
        cnt = cnt + 1;
    end
%     new_feats(i,cnt) = new_feats(i,13)-new_feats(i,16);
%     new_feats(i,cnt+1) = new_feats(i,16)-new_feats(i,19);
%     new_feats(i,cnt+2) = new_feats(i,19)-new_feats(i,13);
%     
%     new_feats(i,cnt+3) = new_feats(i,14)-new_feats(i,17);
%     new_feats(i,cnt+4) = new_feats(i,17)-new_feats(i,20);
%     new_feats(i,cnt+5) = new_feats(i,20)-new_feats(i,14);
%     
%     new_feats(i,cnt+6) = new_feats(i,15)-new_feats(i,18);
%     new_feats(i,cnt+7) = new_feats(i,18)-new_feats(i,21);
%     new_feats(i,cnt+8) = new_feats(i,21)-new_feats(i,15);
end
%clearvars -except ims new_feats


%% Image Segmentation - by texture
% https://www.mathworks.com/help/images/examples/texture-segmentation-using-texture-filters.html
close all;
for i=1:length(ims)
    if mod(i,50)==0
        fprintf('.');
    end
    im = ims{i};
    if size(im,3) ~= 3
        continue;
    end
    % figure;subplot(1,3,1);imshow(im);
    im = rgb2gray(im);
%     subplot(1,3,2);imshow(im);
    Eim = entropyfilt(im);
    % Eim = rescale(E);
    % Eim = E./max(E);
    % figure;imshow(Eim);
    BW1 = imbinarize(Eim, max(3*max(Eim)/4));%.8);
    % figure;imshow(BW1);
    BWao = bwareaopen(BW1,2000);
    % figure;imshow(BWao);
    nhood = true(9);
    closeBWao = imclose(BWao,nhood);
    % figure;imshow(closeBWao);
    roughMask = imfill(closeBWao,'holes');
    % subplot(1,3,3);imshow(roughMask);
    cnt = 37;
    final_new_feats(i,19) = (sum(sum(roughMask==1)) - sum(sum(roughMask==0)))/(size(im,1)*size(im,2));
    
%     third_x = round(size(roughMask,1)/3); third_y = round(size(roughMask,2)/3);
%     
%     final_new_feats(i,cnt+1) = sum(sum(roughMask(1:third_x,1:third_y)==1)) - sum(sum(roughMask(1:third_x,1:third_y)==0));
%     final_new_feats(i,cnt+2) = sum(sum(roughMask(third_x+1:2*third_x+1, 1:third_y)==1)) - sum(sum(roughMask(third_x+1:2*third_x+1, 1:third_y)==0));
%     final_new_feats(i,cnt+3) = sum(sum(roughMask(2*third_x+2:end, 1:third_y)==1)) - sum(sum(roughMask(2*third_x+2:end, 1:third_y)==0));
%    
%     final_new_feats(i,cnt+4) = sum(sum(roughMask(1:third_x,third_y+1:2*third_y+1)==1)) - sum(sum(roughMask(1:third_x, third_y+1:2*third_y+1)==0));
%     final_new_feats(i,cnt+5) = sum(sum(roughMask(third_x+1:2*third_x+1, third_y+1:2*third_y+1)==1)) - sum(sum(roughMask(third_x+1:2*third_x+1, third_y+1:2*third_y+1)==0));
%     final_new_feats(i,cnt+6) = sum(sum(roughMask(2*third_x+2:end, third_y+1:2*third_y+1)==1)) - sum(sum(roughMask(2*third_x+2:end, third_y+1:2*third_y+1)==0));
%     
%     final_new_feats(i,cnt+7) = sum(sum(roughMask(1:third_x, 2*third_y+2:end)==1)) - sum(sum(roughMask(1:third_x,2*third_y+2:end)==0));
%     final_new_feats(i,cnt+8) = sum(sum(roughMask(third_x+1:2*third_x+1, 2*third_y+2:end)==1)) - sum(sum(roughMask(third_x+1:2*third_x+1, 2*third_y+2:end)==0));
%     final_new_feats(i,cnt+9) = sum(sum(roughMask(2*third_x+2:end, 2*third_y+2:end)==1)) - sum(sum(roughMask(2*third_x+2:end, 2*third_y+2:end)==0));
%     new_feats(i,cnt+10) = mean2(Eim(Eim>3*max(Eim)/4));
%     new_feats(i,cnt+11) = mean2(Eim(Eim<3*max(Eim)/4));
    
%     if length(im(roughMask==1))~=0 & length(im(roughMask==0))~=0
%         new_feats(i,cnt+12) = entropy(im(roughMask==1)) - entropy(im(roughMask==0));
%     end
    
%     for plus = 0:9
%         final_new_feats(i,cnt+plus) = final_new_feats(i,cnt+plus)/(size(im,1)*size(im,2));
%     end
end
%clearvars -except ims new_feats

%% Image Segmentation - by watershed segmentation
% https://www.mathworks.com/help/images/examples/marker-controlled-watershed-segmentation.html?prodcode=IP&language=en
close all;
for i=1:length(ims)
    if mod(i,50)==0
        fprintf('.');
    end
    im = ims{i};
    if size(im,3) ~= 3
        continue;
    end
    %     figure;subplot(1,3,1);
%     imshow(im);title('original');
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
    % subplot(1,3,2);imshow(bgm), title('Watershed ridge lines (bgm)');
    gradmag2 = imimposemin(gradmag, bgm | fgm4);
    L = watershed(gradmag2); 
    % I4 = I;
    % I4(imdilate(L == 0, ones(3, 3)) | bgm | fgm4) = 255;
    % figure;imshow(I4);title('Markers and object boundaries superimposed on original image (I4)');
    % Lrgb = label2rgb(L, 'jet', 'w', 'shuffle');
%     subplot(1,3,3);imshow(Lrgb);title('Colored watershed label matrix (Lrgb)');
    new_feats(i,50) = max(max(L)); % how many segments there are
end
%clearvars -except ims new_feats

%% Contour Plots
% https://www.mathworks.com/help/images/ref/imcontour.html

close all;
for i=1:length(ims)
    if mod(i,50)==0
        fprintf('.');
    end
    im = ims{i};
    if size(im,3) ~= 3
        continue;
    end
    %     figure;subplot(1,2,1);imshow(im);
    im = rgb2gray(im);
    ic = imcontour(im, 4);
%     subplot(1,2,2);ic;
    new_feats(i,51) = size(ic,2);
    
end
% clearvars -except ims new_feats

%% Image Intensity Histogram
for i=2%length(ims)
    if mod(i,50)==0
        fprintf('.');
    end
    im = ims{i};
    if size(im,3) ~= 3
        continue;
    end
    %     figure;subplot(1,2,1);imshow(im);
    [counts, ~] = imhist(im,5);
    figure;(imhist(im,5));set(gcf, 'color', 'white');
    intensity_temp(i,:) = counts/(size(im,1)*size(im,2));
end

%% Image Quality Measurements
% https://www.mathworks.com/help/images/image-quality-metrics.html

% brisque score:
% NOTE: Only works with Matlab 2017b and above.
% close all;
% for i=1:length(ims)
%     if mod(i,100)==0
%         fprintf('.');
%     end
%     im = ims{i};
%     if size(im,3) ~= 3
%         continue;
%     end
%     new_feats(i,275) = brisque(im);
% end
load('brisques.mat');
new_feats(:,62) = brisques;
%clearvars -except ims new_feats
%% Symmetry
% Mean Squared Error between the image and its flipped version
% immse( YourImage, fliplr(YourImage) )
close all;
for i=1:length(ims)
    if mod(i,50)==0
        fprintf('.');
    end
    im = ims{i};
    if size(im,3) ~= 3
        continue;
    end
    im = rgb2gray(im);
    new_feats(i,63) = immse(im, fliplr(im));
    new_feats(i,64) = immse(im, flipud(im));
end
%clearvars -except ims new_feats

%% Line of Symmetry
% https://www.mathworks.com/matlabcentral/answers/337281-i-have-extracted-an-image-object-now-i-need-to-determine-the-line-of-symmetry-for-that-object

for i=1% :length(ims)
    if mod(i,50)==0
        fprintf('.');
    end
    im = ims{i};
    if size(im,3) ~= 3
        continue;
    end
    im = rgb2gray(im);
    minerr = Inf;
    mindeg = 0;
    for deg = 1:2:359
        imrot = imrotate(im, deg, 'crop');
        err = immse(im, imrot);
        if err < minerr
            minerr = err;
            mindeg = deg;
        end
    end
    new_feats(i,63) = minerr;
    new_feats(i,64) = mindeg;
end
%% Contrast
% RMS contrast: https://en.wikipedia.org/wiki/Contrast_(vision)

close all;
contrasts = zeros(length(ims),1);
for i=1:length(ims)
    if mod(i,50)==0
        fprintf('.');
    end
    im = ims{i};
    if size(im,3) ~= 3
        continue;
    end
    new_feats(i,65) = sqrt(mean2(im-mean2(im)).^2);
end

%% Image Orientation
% https://www.mathworks.com/matlabcentral/answers/124994-detecting-orientation-symmetry-in-an-image
close all;
for i=1:length(ims)
%     disp('new image');
    if mod(i,50)==0
        fprintf('.');
    end
    rgbImage = ims{i};
    if size(rgbImage,3) ~= 3
        continue;
    end
    % Get the dimensions of the image.  numberOfColorBands should be = 3.
    [rows, columns, numberOfColorBands] = size(rgbImage);
    if numberOfColorBands > 1
        grayImage = rgb2gray(rgbImage);
    else
        grayImage = rgbImage;
    end
    % Let's compute and display the histogram.
    [pixelCount, grayLevels] = imhist(grayImage);
    mask = grayImage < 200; % Entire can lid
    % Get rid of holes inside.
    mask = imfill(mask, 'holes');
    % Erode to shrink the mask and get rid of letters.
    se = strel('disk', 45, 0);
    mask = imerode(mask, se);
    % Mask the image
    maskedImage = grayImage;
    maskedImage(~mask) = 0;
    % Get gradient
    gradImage = imgradient(maskedImage);
    % Shrink mask again to get rid of outer outline
    se = strel('disk', 15, 0);
    mask = imerode(mask, se);
    gradImage(~mask) = 0;
    % Get histogram
    pixelCount = hist(gradImage(:), 100);
    % Suppress 0 so we can see the histogram
    pixelCount(1)=0;
    % Threshold to get a binary image
    binaryImage = gradImage > 45;
    % Get rid of holes inside.
    binaryImage = imfill(binaryImage, 'holes');
    % Label the image
    labeledImage = bwlabel(binaryImage);
    % Make measurements of orientation
    measurements = regionprops(labeledImage, 'Orientation', 'Area');
    if size(measurements,1)==0
        continue;
    end
    % Find the largest blob
    [allAreas, sortIndexes] = max(sort([measurements.Area], 'Descend'));
    % Pluck out largest one
    biggestBlob = ismember(labeledImage, sortIndexes(1)) > 0;
    % Measure again, this time just the largest blob.
    % Label the image
    labeledImage = bwlabel(biggestBlob);
    % Make measurements of orientation
    measurements = regionprops(labeledImage, 'Orientation', 'Area');
    new_feats(i,66) = measurements(1).Orientation;
end

%clearvars -except ims new_feats


%% Image Entropy
% https://www.mathworks.com/help/images/ref/entropy.html

close all;
for i=1:length(ims)
    if mod(i,50)==0
        fprintf('.');
    end
    im = ims{i};
    if size(im,3) ~= 3
        continue;
    end
    new_feats(i,67) = entropy(rgb2gray(im));
end
%clearvars -except ims new_feats

%% Present Colors
close all;
for i=1:length(ims)
    if mod(i,50)==0
        fprintf('.');
    end
    rgbImage = ims{i};
    if size(rgbImage,3) ~= 3
        continue;
    end
    % Get the dimensions of the image.  numberOfColorBands should be = 3.
    [rows, columns, numberOfColorBands] = size(rgbImage);
    % Display the original color image.
%     figure;imshow(rgbImage);
%     title('Original Color Image');%, 'FontSize', fontSize);
    % Enlarge figure to full screen.
    %set(gcf, 'units','normalized','outerposition',[0 0 1 1]);

    % Extract the individual red, green, and blue color channels.
    redChannel = rgbImage(:, :, 1);
    greenChannel = rgbImage(:, :, 2);
    blueChannel = rgbImage(:, :, 3);
    % Construct the 3D color gamut (3D histogram).
    gamut3D = zeros(256,256,256);
    for column = 1: columns
        for row = 1 : rows
            rIndex = redChannel(row, column) + 1;
            gIndex = greenChannel(row, column) + 1;
            bIndex = blueChannel(row, column) + 1;
            gamut3D(rIndex, gIndex, bIndex) = gamut3D(rIndex, gIndex, bIndex) + 1;
        end
    end

    % Get a list of non-zero colors so we can put it into scatter3()
    % so that we can visualize the colors that are present.
    r = zeros(256, 1);
    g = zeros(256, 1);
    b = zeros(256, 1);
    nonZeroPixel = 1;
    for red = 1 : 256
        for green = 1: 256
            for blue = 1: 256
                if (gamut3D(red, green, blue) > 1)
                    % Record the RGB position of the color.
                    r(nonZeroPixel) = red;
                    g(nonZeroPixel) = green;
                    b(nonZeroPixel) = blue;
                    nonZeroPixel = nonZeroPixel + 1;
                end
            end
        end
    end
    cnt = 68;
    new_feats(i,cnt) = nonZeroPixel/(rows*columns); % how many colors
    %rgb range
    new_feats(i,cnt+1) = min(r);
    new_feats(i,cnt+2) = max(r);
    new_feats(i,cnt+3) = min(g);
    new_feats(i,cnt+4) = max(g);
    new_feats(i,cnt+5) = min(b);
    new_feats(i,cnt+6) = max(b);


    % find r g b peaks
    cr = zeros(256,1); cg = zeros(256,1); cb = zeros(256,1);
    for c = 1:256
        cr(i,1) = sum(r==i);
        cg(i,1) = sum(g==i);
        cb(i,1) = sum(b==i);
    end
    
    mr = zeros(26,1); mg = zeros(26,1); mb = zeros(26,1);
    cnt2 = 1;
    for s=1:10:256
        e = min(s+10,256);
        mr(cnt2,1) = max(r(s:e));
        mg(cnt2,1) = max(g(s:e));
        mb(cnt2,1) = max(b(s:e));
        cnt2=cnt2+1;
    end
    mr = sort(mr); mg = sort(mg); mb = sort(mb);
    new_feats(i,cnt+7:cnt+9) = mr(end-2:end);
    new_feats(i,cnt+10:cnt+12) = mg(end-2:end);
    new_feats(i,cnt+13:cnt+15) = mb(end-2:end);

%     
%     figure;scatter3(r, g, b, 3);
%     xlabel('R');%, 'FontSize', fontSize);
%     ylabel('G');%, 'FontSize', fontSize);
%     zlabel('B');%, 'FontSize', fontSize);
end
%%
peaks_temp = zeros(1001,6);
for i=1:length(ims)
    if mod(i,50)==0
        fprintf('.');
    end
    rgbImage = ims{i};
    if size(rgbImage,3) ~= 3
        continue;
    end
    imgr = rgbImage(:,:,1);
    moder = mode(reshape(imgr,[],1));
    imgg = rgbImage(:,:,2);
    modeg = mode(reshape(imgg,[],1));
    imgb = rgbImage(:,:,3);
    modeb = mode(reshape(imgb,[],1));
    peaks_temp(i,1) = moder;
    peaks_temp(i,2) = modeg;
    peaks_temp(i,3) = modeb;
    
    hsvImage = rgb2hsv(rgbImage);
    imgh = hsvImage(:,:,1);
    modeh = mode(reshape(imgh,[],1));
    imgs = hsvImage(:,:,2);
    modes = mode(reshape(imgs,[],1));
    imgv = hsvImage(:,:,3);
    modev = mode(reshape(imgv,[],1));
    peaks_temp(i,4) = modeh;
    peaks_temp(i,5) = modes;
    peaks_temp(i,6) = modev;
end
%% 
% for i=1:length(ims)
%     if mod(i,50)==0
%         fprintf('.');
%     end
%     im = ims{i};
%     if size(im,3) ~= 3
%         continue;
%     end
%     new_im = zeros(size(im,1), size(im,2),size(im,3));
%     round_level = 4;
%     new_im(:,:,1) = round_level*round(double(im(:,:,1)/round_level),-1);
%     new_im(:,:,2) = round_level*round(double(im(:,:,2)/round_level),-1);
%     new_im(:,:,3) = round_level*round(double(im(:,:,3)/round_level),-1);
%     new_im(new_im>255)=255;
%     hist = zeros(256,256,256);
%     for row = 1:size(new_im,1)
%         for col = 1:size(new_im,2)
%             rgb = squeeze(new_im(row, col, :));
%             hist(rgb(1)+1, rgb(2)+1, rgb(3)+1) = hist(rgb(1)+1, rgb(2)+1, rgb(3)+1) + 1;
%         end
%     end
%     m1 = max(max(max(hist)));
%     [r1,g1,b1] = ind2sub(size(hist), find(hist == m1));
%     hist(r1,g1,b1) = 0;
%     m2 = max(max(max(hist)));
%     [r2,g2,b2] = ind2sub(size(hist), find(hist == m2));
%     hist(r2,g2,b2) = 0;
%     m3 = max(max(max(hist)));
%     [r3,g3,b3] = ind2sub(size(hist), find(hist == m3));
%     new_feats(i,84:95) = [r1 g1 b1 r2 g2 b2 r3 g3 b3 m1 m2 m3];
% end