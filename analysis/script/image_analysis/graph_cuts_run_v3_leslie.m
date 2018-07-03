clear all
close all

%%
target_n_label=6;
initials=-1;
max_smooth=5;

list_initial_n_labels=6;

options = optimset('MaxFunEvals',10,'TolX',1.5)
warning('off','all')

%%
image_base='/Users/miles/Dropbox/AbArts/data_from_leslie/artworks_175/';
%image_base='D:\Dropbox\AbArts\data_from_leslie\artworks_175\';

%categories={'Impressionism','AbstractArt','ColorFieldPainting','Cubism'};

  current_folder=image_base;
    
    %filelist=dir([current_folder, '*.jpg']);
    
    filelist=dir([current_folder, '*.bmp']);
i_image=0;    
for i=1:length(filelist)


%for i_category =1:length(categories)
%for    i_category =1:3
%    i_category
    
 %   current_folder=[image_base, categories{i_category}, '/', '000/']
    
  %  filelist=dir([current_folder, '*.jpg']);
    
   
        
    
 %   for i=1:length(filelist)
    %for i=1:2
        i
        
        
        i_image=i_image+1;

        image_file = [current_folder,  filelist(i).name];
        
         image_names{i_image}=filelist(i).name;
         image_folder{i_image}=filelist(i).folder;
        
    
        for i_run=1:length(list_initial_n_labels)

            initial_n_label=list_initial_n_labels(i_run);
            
            for i_ini=1:length(initials)
                
                initial=initials(i_ini);

                [x_candidates(i_ini), fval(i_ini)] = fminsearch(@(x0)...
                        kernel_graphcut_raw_label_v1( image_file, target_n_label,x0, initial_n_label,max_smooth),initial,options);

                
            end
            min_ind=find(fval==min(fval),1);
            
            xs(i_run,1)=x_candidates(min_ind);
            y=fval(min_ind)
           
            diff_n_regions(i_run,1)=y;
            
                
            if y> 100
                initial=-2;
                [xs(i_run,1), y] = fminsearch(@(x0)...
                    kernel_graphcut_raw_label_v1( image_file, target_n_label,x0, initial_n_label,max_smooth),initial,options);
                diff_n_regions(i_run,1)=y;
                initial=0;
            end
                

        end
        %%

        index=find(diff_n_regions==min(diff_n_regions),1);
        x=xs(index);

        [difference, n_label, label_L]=kernel_graphcut_rawlabel_parameters( image_file, target_n_label,x, initial_n_label,max_smooth);
        

        n_labels(i_image,1)=n_label;
        label_segments{i_image,1}=label_L;
end
%end


image_file_names=table(image_names,image_folder);


if boolean(strfind(pwd, 'sandy'))
    savdir = '/Users/sandy/Dropbox/Caltech/AbArts/analysis/data';
else
    savdir = '/Users/miles/Dropbox/AbArts/analysis/data'
end
 

name_file_2='segments_leslie_v1';

save(fullfile(savdir,name_file_2),'n_labels','label_segments','image_file_names');

