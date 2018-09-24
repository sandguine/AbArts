%% Generating new segments with regional segementation method
% Iman Wahle
% August 9 2018

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


%% Initialize where masks will be stored
region_masks2 = cell(1001,1);

%% Segment

for i=1% :length(ims)

    if mod(i,50)==0
        fprintf('.');
        close all;
    end
    im = imread('../a-fisherman-s-cottage.jpg!PinterestLarge.jpg'); %ims{i}; 
    figure;imshow(im);
    if size(im,3) ~= 3
        continue;
    end
%     realsize1 = size(im,1); realsize2=size(im,2);
%     if realsize1 > 500 | realsize2 > 500
%         im = imresize(im, .5);
%     end
    im = double(im);
    num_segs = 0;
    pwr = 4;
    while num_segs < 3 
        Qlevels = 2.^pwr;
        [maps,images]=srm(im,Qlevels);
        num_segs = length(unique(maps{1,1}));
        pwr = pwr+1;
    end
    Iedge = srm_plot_segmentation(images,maps);
    figure;imshow(im); hold on; imshow(Iedge); hold off;
    map = maps{1,1};
%     map = imresize(map, [realsize1, realsize2]);
  %  region_masks2{i,1} = map;
end
        