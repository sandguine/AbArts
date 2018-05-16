
clear all
close all

 %% I'm not sure the difference between HSV and HSL
addpath('./functions')

%image_base='/Users/miles/Dropbox/AbArts/ArtsScraper/database/';

image_base='D:/Dropbox/AbArts/ArtsScraper/database/';

categories={'Impressionism','AbstractArt','ColorFieldPainting','Cubism'};

% load('/Users/miles/Dropbox/AbArts/analysis/data/segments_v2'); %%'n_labels','label_segments','image_file_names'
load('D:/Dropbox/AbArts/analysis/data/segments_v2')
i_image=0;

n_images=length(image_file_names.image_names);

F=NaN(n_images,40);

for i_category =1:length(categories)
    
    current_folder=[image_base, categories{i_category}, '/', '000/']
    
    filelist=dir([current_folder, '*.jpg']);
    
    for i=1:length(filelist)
        
        i_image=i_image+1
        
        current_name=filelist(i).name;
        
        
        image_file = [current_folder,  filelist(i).name];
        
        X = imread(image_file); 

       % image(X)

        X = double(X)/255;  %% RGB 0 to 1

        Y=colorspace('rgb->hsl',X);  %% HSL  hue is expressed in dgree 0 - 360. 
        
        
        for j=1: n_images
            if strcmp(current_name,image_file_names.image_names{j}) 
                
                image_index=j;
                
                break
            end
            
        end
        
        label_pixels=label_segments{j};
        current_n_labels=n_labels(j);
        
        if current_n_labels<4
            %put all features NaN
        else
            label_array=reshape(label_pixels,[],1);
            n_pixel=length(label_array);

            label_list = maxk(label_array,current_n_labels);
            
            
            
            for i_label=1:current_n_labels
                
                Label_ones{i_label}= (label_pixels==label_list(i_label));
            end
            
            for i_label=1:3
                
            
                [row,col] = find( Label_ones{i_label} == 1);

                n_pixel_segment=length(find( Label_ones{i_label} == 1));

                F(i_image, 12+i_label)= sum(row)/n_pixel_segment;

                F(i_image, 15+i_label)= sum(col)/n_pixel_segment;

                F(i_image,18+i_label)= sum((row-mean(row)).^2+(col-mean(col)).^2)/n_pixel_segment;  


                F(i_image,21+i_label)= sum((row-mean(row)).^3+(col-mean(col)).^3)/n_pixel_segment;
                
                q1=sum(sum(Y(row,col,1)))/n_pixel_segment;
                
               
                
                F(i_image,24+i_label)= q1;
                
                q2=sum(sum(Y(row,col,2)))/n_pixel_segment;
                
             %   MeanS(i_label)=q2;
                
                F(i_image,27+i_label)=  q2;
                
                q3=sum(sum(Y(row,col,3)))/n_pixel_segment;
                
                F(i_image,30+i_label)= q3;
                
        %        MeanL(i_label)=q3;
               
            end
            
            for i_label=1:current_n_labels
                
                q1=sum(sum(Y(row,col,1)))/n_pixel_segment;
                
                MeanH(i_label)=q1;
                
                q2=sum(sum(Y(row,col,2)))/n_pixel_segment;
                
                MeanS(i_label)=q2;
                
                 q3=sum(sum(Y(row,col,3)))/n_pixel_segment;
                
                 MeanL(i_label)=q3;
                
                threshold=4;
                
                 localimage=X(row,col,:);
                local_blur(i_label)=blurr( localimage,threshold );
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
                    
             F(i_image,34)=max(diffH);
             
             F(i_image,35)=max(diffS);
             
             F(i_image,36)=max(diffL);
             
             F(i_image,37)= max(diffB);
             
             clearvars diffH diffS diffL difB
             
             
                
                
                
            
        end
        
        [p_y,p_x,p_z]=size(X);
        
        qx=round(p_y/15);
        qy=round(p_x/15);
        
        centre_image= Y([4*qy:11*qy],[4*qx:11*qx], :);
        
        imshow(X([4*qy:11*qy],[4*qx:11*qx], :))
        
        F(i_image,38)=mean(mean(centre_image(:,:,1)));
             
        F(i_image,39)=mean(mean(centre_image(:,:,2)));
             
        F(i_image,40)=mean(mean(centre_image(:,:,2)));
        
        
        
        
            
            
            
            
        
        
        
        
        
            
                
                
            
%         
%         
%         X = imread(image_file); 
% 
%        % image(X)
% 
%         X = double(X)/255;  %% RGB 0 to 1
% 
%         Y=colorspace('rgb->hsl',X);  %% HSL  hue is expressed in dgree 0 - 360. 
%         
%         
%         
%         
%         
% 
%         Z(i_image,1) = mean_hue(Y);
% 
%         Z(i_image,2) = mean_s(Y);
% 
%         n_bin=20;
%         threshold =0.1;
%         Z(i_image,3) = hue_count( Y,n_bin, threshold );
% 
%         Z(i_image,4) = number_most_count_hue( Y,n_bin);
% 
%         Z(i_image,5)= hue_contrast( Y,n_bin,threshold);
%         
%         n_sample=5;
% 
%         [Z(i_image,6), F_k, best_angles]= hue_model_choose( Y, n_sample);
%         
%         Z7(i_image,7) = 0;   %% I haven't done it yet. Do we need this?
%         
%         Z(i_image,8)=mean_brightness(X);
% 
%         Z(i_image,9)=mean_log_brightness(X);
% 
%         n_bin=100;
% 
%         Z(i_image,10)= brightness_contrast(X, n_bin );
% 
%         threshold=4;
%         Z(i_image,11)=blurr( X,threshold );
%         n_sample=5;
%         Z(i_image,12)=edge_distribution( X,n_sample );
%         
%         
         image_names{i_image}=filelist(i).name;
         image_folder{i_image}=filelist(i).folder;
        
    
    


    end
end

%%

image_file_names=table(image_names,image_folder);
image_features=F;


if boolean(strfind(pwd, 'sandy'))
    savdir = '/Users/sandy/Dropbox/Caltech/AbArts/analysis/data';
else
    savdir = '/Users/miles/Dropbox/AbArts/analysis/data'
end
 

name_file_2='local_features';

save(fullfile(savdir,name_file_2),'image_features','image_file_names');



