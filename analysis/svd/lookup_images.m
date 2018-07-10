% Given a list of image indices, this function will
% display the corresponding images
function [] = lookup_images(inds,dim1,dim2)
    names = load('../data/segments_v2.mat');
    files = names.image_file_names.image_names;
    folders = names.image_file_names.image_folder;
    figure;
%     dim1 = round(sqrt(length(inds)))+1;
%     dim2 = round(length(inds)/dim1);
    cnt = 0;
    for i=inds
        cnt = cnt+1;
        folder = strrep(folders(i), '/Users/miles/Dropbox/AbArts', '../..');
        folder = strrep(folder, '000', '');
        folder = strrep(folder,'AbstractArt', 'abstract');
        folder = strrep(folder,'ColorFieldPainting', 'colorFields');
        file = files(i);
        if contains(file, '(Unicode Encoding Conflict)')
            disp('skipped');
            continue
        end
        img = strcat(folder, file);
        subplot(dim1,dim2,cnt), imshow(imread(img{1}));
    end
end
