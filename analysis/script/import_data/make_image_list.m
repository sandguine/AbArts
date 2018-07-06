clear all
close all

image_base= '/Users/miles/Dropbox/AbArts/ArtsScraper/database'

categories = {'abstract','colorFields','cubism','impressionism','leslie'}

image_names=[];
image_categories=[];

for j=1:length(categories)
    
    foldername = [image_base, '/', categories{j}];

    listing = dir(foldername);
    
    for i= 1: length(listing)
        
        x=listing(i).name;
        
        if ~ x =='.'
        
    
            image_names = [image_names;x];

            image_categories= [image_categories; categories{j}];
        end
    end
    
end
    
   