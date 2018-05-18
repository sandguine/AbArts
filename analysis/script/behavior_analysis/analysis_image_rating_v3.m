clear all
close all

%%

indexing=0;


if boolean(strfind(pwd, 'sandy'))
    savdir = '/Users/sandy/Dropbox/Caltech/AbArts/analysis/data';
elseif boolean(strfind(pwd, 'miles'))
    savdir = '/Users/miles/Dropbox/AbArts/analysis/data'
else
     savdir = 'D:/Dropbox/AbArts/analysis/data'
end
 
load([savdir '/', 'main_task', '.mat']);

%name= maintask_table.name_maintask;
sub_id=maintask_table.sub_id;
trial_type_1or2=maintask_table.trial_type_1or2;
response= maintask_table.response_meaning;


sub_id_familiarity=maintask_table_familiarity.sub_id;
sub_id_rating=maintask_table_rating.sub_id;

response_f =  maintask_table_familiarity.response_meaning;

response_r =  maintask_table_rating.response_meaning;

image_f = maintask_table_familiarity.image_path;

image_r = maintask_table_rating.image_path;

%%



image_name_task_r = cellfun(@(x) extractAfter(extractAfter(x,'/'),'/'),image_r);



%%

load([savdir '/', 'features', '.mat']);

n_images=length(image_file_names.image_names);

image_name_list=image_file_names.image_names;

n_feature=size(image_features,2);

unique_images_task= unique(image_name_task_r , 'stable');


image_index=zeros(length(image_name_list),1);
%%
% for j=1: length(unique_images_task)
%     
%     
%     y = unique_images_task{j};
%     
%     for i=1:length(image_name_list)
%         
%         z = image_name_list{i};
%         
%         if string(y) == string(z)
%             
%             image_index(i,1) = j;
%         end
%     end
%             
%             
%     
% end

%%
if indexing

    for i=1:length(image_name_task_r)

        current_image=image_name_task_r{i};


        for j=1: n_images



            if strcmp(current_image,image_file_names.image_names{j}) 

                    image_index=j;


                    rated_image_index(i)=image_index;



                    break
            end
        end



    end

    if boolean(strfind(pwd, 'sandy'))
        savdir = '/Users/sandy/Dropbox/Caltech/AbArts/analysis/data';
    elseif  boolean(strfind(pwd, 'miles'))
        savdir = '/Users/miles/Dropbox/AbArts/analysis/data'
    else
          savdir = 'D:\Dropbox/AbArts/analysis/data'
    end


    name_file_2='image_index_main_task';

    save(fullfile(savdir,name_file_2),'rated_image_index');

else 
    name_file_2='image_index_main_task';
    
    load(fullfile(savdir,name_file_2),'rated_image_index')
    
end

%%

list_id=unique(sub_id_rating);
n_sub=length(list_id);
bs=NaN(length(list_id),n_feature+1);
for i_sub=1:length(list_id)
     current_id=list_id(i_sub);     
     current_image_index_list=rated_image_index(sub_id_rating==current_id);
     current_feature_list=image_features(current_image_index_list,:);
     
     current_response_list=response_r(sub_id_rating==current_id);
     X = [ current_feature_list ones(size(current_response_list))];
     bs(i_sub,:)= regress(current_response_list,X)'  ;
end

global_features=image_features;

clearvars image_features
 %%
 
 
 
load([savdir '/', 'local_features', '.mat']);
 
local_features= image_features;

clear image_features



image_features = [global_features, local_features(:,13:end),categories ];
n_feature= size(image_features, 2);
bs=NaN(length(list_id),n_feature+1);
bs2=NaN(length(list_id),n_feature+1);
bs3=NaN(length(list_id),n_feature);

for i_sub=1:length(list_id)
     current_id=list_id(i_sub);     
     current_image_index_list=rated_image_index(sub_id_rating==current_id);
     current_feature_list=image_features(current_image_index_list,:);
     
     current_response_list=response_r(sub_id_rating==current_id);
     X = [ current_feature_list ones(size(current_response_list))];
     X=double(X);
     bs(i_sub,:)= regress(current_response_list,X)'  ;
     
     
      non_nan_index=~any(isnan(current_feature_list),2);
      non_nan_x=current_feature_list(non_nan_index,:);
      non_nan_x=double(non_nan_x);
      
      X2 =  [zscore(non_nan_x),ones(size(non_nan_x,1),1)];
     bs2(i_sub,:)= regress(current_response_list(non_nan_index,1),X2)'  ;
     
     bs3(i_sub,:)= regress(zscore(current_response_list(non_nan_index,1)),zscore(non_nan_x))'  ;
end
   


%beta = mvregress(X,Y) need to sort images for everyone. use NaN for
%non-rated figures?
%%

figure(11)

for j=1:n_feature+1
    
    scatter(j*ones(1,n_sub),bs(:,j))
    hold on
    ylim([-10,10])
end

figure(12)
boxplot(bs)
    

figure(13)
boxplot(bs)

    
ylim([-10,10])

figure(14)
boxplot(bs2)

    
ylim([-10,10])
%% 
figure(15)
boxplot(bs3)
for j=1:size(bs3,2)
    
    p(j)= signtest(bs3(:,j));
end
    
%%

image_categories=categories(rated_image_index,:);

for j=1:4
    r=response_r(image_categories(:,j)==1);
    mean_r_category(j)=mean(r);
    std_r_category(j)=std(r);
    n_r_category(j)=length(r);
end

figure(4)



for j=1:4
    
    %subplot(1,2,1)
    
    n_perm=1000;
    
%    % if j==1
%         x=reordered_rs(reordered_fs==0);
%         y=reordered_rs(reordered_fs==1);
%     %else
%         x=length(find(reordered_fs==0));
%         y=length(find(reordered_fs==1));
%     %end


    e=errorbar([1,2,3,4], [mean_r_category],[std_r_category./sqrt(n_r_category)],'black')
    e.LineStyle = 'none';
    hold all
    %bar([1,2],[mean(x),mean(y)],0.2,col(1))


    bar([1,2,3,4],mean_r_category,0.2)


    set(gca,'TickDir','out','Ticklength',[0.02,1],'box','off'); % The only other option is 'in'

    ax = gca;
    
  %  if j==1
       
       ax.XTick = [1,2,3,4];
        ax.YTick = [0,1,2,3];    
        ylabel(' rating')

        ylim([0,3])


        ax.XTickLabel = {'Impressionism','AbstractArt','ColorFieldPainting','Cubism'};


    %    p=permutation_test_mean(x,y ,n_perm)
    %    text(1.5,2,['p=' sprintf('%5.3f',p) ])
        
%     
%     else
%         
%         ax.XTick = [1,2];
%        % ax.YTick = [0,1,2,3];    
%         ylabel('number of trials')
% 
%       %  ylim([0,3])
% 
% 
%         ax.XTickLabel = {'I dont know','I know'};
% 
% 
%         p=permutation_test_mean(x,y ,n_perm)
%         text(1.5,2,['p=' sprintf('%5.3f',p) ])
%     end
        

    
end