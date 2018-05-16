clear all
close all

%%
image_path='/Users/miles/Dropbox/AbArts/ArtsScraper/database/Cubism/a-caipirinha.jpg!PinterestLarge.jpg';
target_n_label=6;
initial=0;
%initial_n_label=4;
max_smooth=12;
max_label=6;

list_initial_n_labels=[3,4,5];

options = optimset('MaxFunEvals',10)
warning('off','all')


% for i_run=1:length(list_initial_n_labels)
%     
%     for j=1:length(initials)
%         initial=initials(j);
%         [xs(i_run,j), diff_n_regions(i_run,j)] = fminsearch(@(x)...
%             kernel_graphcut_relabel_v2( image_path, target_n_label,x, initial_n_label,max_smooth),initial,options);
%     end
% end

for i_run=1:length(list_initial_n_labels)
    
    initial_n_label=list_initial_n_labels(i_run)
    
   % for j=1:length(initials)
   % initial=initial;
    [xs(i_run,1), diff_n_regions(i_run,1)] = fminsearch(@(x)...
            kernel_graphcut_relabel_v2( image_path, target_n_label,x, initial_n_label,max_smooth),initial,options);
    %end
end
%%
 
index=find(diff_n_regions==min(diff_n_regions),1);
x=xs(index);

[difference, n_label, re_labeled_L]=kernel_graphcut_relabel_parameters( image_path, target_n_label,x, initial_n_label,max_smooth);
