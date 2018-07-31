clear all
close all

image_base= 'D:\Dropbox\AbArts\ArtTask\fMRI-task\Shinsuke_code\data\images_better'

categories = {'abstract','colorField','cubism','impressionism','leslie'}

savdir = 'D:\Dropbox\AbArts\ArtTask\fMRI-task\Shinsuke_code\data\images_better'

%image_names=[];
%image_categories=[];

index=0

for j=1:length(categories)
    
    foldername = [image_base, '/', categories{j}];

    listing = dir(foldername);
    
    for i= 1: length(listing)
        
        xx=listing(i).name;
        
        if  ~ (xx(1) == '.') && ~ (xx(end) == 't')
            index=index+1;
        
    
            image_names{index} = xx;

            image_categories{index} = categories{j};
        end
    end
    
end


name_file='image_names';
save(fullfile(savdir,name_file),'image_names','image_categories');
    
   