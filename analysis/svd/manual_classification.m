
function [] = manual_classification(which_images, file_to_edit, which_column)
    
    f = load(file_to_edit);
    data = f.data;
    names = load('../data/segments_v2.mat');
    files = names.image_file_names.image_names;
    folders = names.image_file_names.image_folder;
    
    for i=which_images
        folder = strrep(folders(i), '/Users/miles/Dropbox/AbArts', '../..');
        folder = strrep(folder, '000', '');
        folder = strrep(folder,'AbstractArt', 'abstract');
        folder = strrep(folder,'ColorFieldPainting', 'colorFields');
        file = files(i);
        if contains(file, '(Unicode Encoding Conflict)')
            disp('unable to display');
            data(i,which_column) = nan;
            continue
        end
        img = strcat(folder, file);
        im = imshow(imread(img{1}));
        w = waitforbuttonpress;
        close all
        try
            label = input(strcat('label ',num2str(i),':'), 's');
            data(i,which_column) = str2num(label);
        catch
            warning('Input should have been a number, try again:');
            label = input(strcat('label ',num2str(i),':'), 's');
            data(i,which_column) = str2num(label);
        end
    end
    save(file_to_edit, 'data');
        
end