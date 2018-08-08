%% Match up number keys with new image names for larger images

% ims = cell(1001,1);
image_names = cell(1,1001);
image_folder = cell(1,1001);
names = load('../data/segments_v2.mat');
files = names.image_file_names.image_names;
folders = names.image_file_names.image_folder;
for i=1:826
    folder = strrep(folders(i), '/Users/miles/Dropbox/AbArts', '/Users/imanwahle/Desktop/AbArts');
    folder = strrep(folder, 'database', 'better_res_database');
    folder = strrep(folder, '000', '');
    folder = strrep(folder,'AbstractArt', 'abstract');
    folder = strrep(folder,'ColorFieldPainting', 'colorField');
    folder = strrep(folder, 'Impressionism', 'impressionism');
    file = files(i);
    if contains(file, '(Unicode Encoding Conflict)')
        image_names{i} = file{1};
        image_folder{i} = folder; 
        % ims{i} = 0;
    else
        img = file{1};%strcat(folder, file);
        % gross naming special cases :( 
        if strcmp(img, 'untitled-1.jpg!PinterestLarge(2).jpg') 
            image_names{i} = 'untitled-1.jpg';
            image_folder{i} = folder{1};
            %ims{i} = imread([folder{1} 'untitled-1.jpg']);
        elseif strcmp(img, 'untitled-1.jpg!PinterestLarge(5).jpg')
            image_names{i} = img;
            image_folder{i} = folder{1};
            % ims{i} = imread([folder{1} img]);
        elseif strcmp(img, 'untitled-1962.jpg!PinterestLarge(3).jpg')
            image_names{i} = img;
            image_folder{i} = folder{1};
            % ims{i} = imread([folder{1} img]);
        elseif strcmp(img, 'untitled-1962.jpg!PinterestLarge(4).jpg')
            image_names{i} = 'untitled-1962.jpg';
            image_folder{i} = folder{1};
            % ims{i} = imread([folder{1} 'untitled-1962.jpg']);
        else
            sp = strsplit(img, '.');
            img = sp{1};%strrep(img, sp{end},'');
            img = [img '.*'];
            real_name = dir([folder{1} img]);
            image_names{i} = real_name.name;
            image_folder{i} = folder{1};
            % ims{i} = imread([folder{1} real_name.name]);
        end
    end
end
%% Do the same for Leslie pictures
names = load('../data/segments_leslie_v1.mat');
files = names.image_file_names.image_names;
folder = '/Users/imanwahle/Desktop/AbArts/data_from_leslie/big_photos/';

for i=827:1001
    file = files(i-826);
    img = strcat(folder, file);
    img = img{1};
    sp = strsplit(img, '.');
    img = strrep(img,sp{end},'');
    img = [img(1:end-1) '*'];
    real_name = dir(img);
    image_names{i} = real_name.name;
    image_folder{i} = folder;
    %ims{i} = imread([folder real_name.name]);
    
end
