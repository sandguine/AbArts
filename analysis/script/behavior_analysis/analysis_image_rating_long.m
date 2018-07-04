clear all
close all

%%

indexing=0;
do_slow_reg =0;

add_categories=0;

%%

if boolean(strfind(pwd, 'sandy'))
 %   savdir = '/Users/sandy/Dropbox/Caltech/AbArts/analysis/data';
elseif boolean(strfind(pwd, 'miles'))
  
    im_dir= '/Users/miles/Dropbox/AbArts/ArtTask/behavioral-all-stims/static/images'
    %im_dir='/Users/miles/Dropbox/AbArts/ArtsScraper/database'
else
   
    im_dir= 'D:\Dropbox\AbArts\ArtTask\behavioral-all-stims\static\images'
end
 


if boolean(strfind(pwd, 'sandy'))
    savdir = '/Users/sandy/Dropbox/Caltech/AbArts/analysis/data';
elseif boolean(strfind(pwd, 'miles'))
    savdir = '/Users/miles/Dropbox/AbArts/analysis/data'
else
     savdir = 'D:/Dropbox/AbArts/analysis/data'
end
 
load([savdir '/', 'main_task_long_v1', '.mat']);

%load([savdir '/', 'rating_image', '.mat']);



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

load([savdir '/', 'features_global_all', '.mat']);

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


    name_file_2='image_index_long_task';

    save(fullfile(savdir,name_file_2),'rated_image_index');

else 
    name_file_2='image_index_long_task';
    
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
 
 
 
load([savdir '/', 'features_local_all', '.mat']);
 
local_features= image_features;

clear image_features

%%

if add_categories 

    image_features = [global_features, local_features(:,13:end),categories ];
else
    image_features = [global_features, local_features(:,13:end)];
end
    
n_feature= size(image_features, 2);
bs=NaN(length(list_id),n_feature+1);
bs2=NaN(length(list_id),n_feature+1);
bs3=NaN(length(list_id),n_feature);

for i_sub=1:length(list_id)
     current_id=list_id(i_sub);     
     
     if length(find(sub_id_rating==current_id))>10
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
     [bs2(i_sub,:), ~,~,~, stats{i_sub}] = regress(current_response_list(non_nan_index,1),X2)  ;
     
     bs3(i_sub,:)= regress(zscore(current_response_list(non_nan_index,1)),zscore(non_nan_x))'  ;
     end
end

%bs2(375,:)=[];

%bs2(233,:)=[];
%%
% x=abs(bs2);
% x=x(:,1:end-1);
% x=nanmean(x);
% index_to_analyze=find(x>0.9);
% x_sub=bs2(:,index_to_analyze);
%    
% [x1,y1]=find(x_sub==min(x_sub(:,1)));
% 
% x_sub(x1,:)=[];
% 
% 
% [x2,y1]=find(x_sub==min(x_sub(:,7)));
% 
% x_sub(x2,:)=[];
% 
% 
% 
% corrplot(x_sub);
% 
% 
% beta = mvregress(X,Y) need to sort images for everyone. use NaN for
% non-rated figures?
% %
% 
% figure(11)
% 
% for j=1:n_feature+1
%     
%     scatter(j*ones(1,n_sub),bs(:,j))
%     hold on
%     ylim([-10,10])
% end
% 
% figure(12)
% boxplot(bs)
%     
% 
% figure(13)
% boxplot(bs)
% 
%     
% ylim([-10,10])
% 
% figure(14)
% boxplot(bs2)
% 
%     
% ylim([-10,10])
% % 
% figure(15)
% boxplot(bs3)
% for j=1:size(bs3,2)
%     
%     p(j)= signtest(bs3(:,j));
% end
%     
% %
% 
% image_categories=categories(rated_image_index,:);
% 
% for j=1:4
%     r=response_r(image_categories(:,j)==1);
%     mean_r_category(j)=mean(r);
%     std_r_category(j)=std(r);
%     n_r_category(j)=length(r);
% end
% 
% figure(4)
% 
% 
% 
% for j=1:4
%     
%     subplot(1,2,1)
%     
%     n_perm=1000;
%     
%    % if j==1
%         x=reordered_rs(reordered_fs==0);
%         y=reordered_rs(reordered_fs==1);
%     %else
%         x=length(find(reordered_fs==0));
%         y=length(find(reordered_fs==1));
%     %end
% 
% 
%     e=errorbar([1,2,3,4], [mean_r_category],[std_r_category./sqrt(n_r_category)],'black')
%     e.LineStyle = 'none';
%     hold all
%     bar([1,2],[mean(x),mean(y)],0.2,col(1))
% 
% 
%     bar([1,2,3,4],mean_r_category,0.2)
% 
% 
%     set(gca,'TickDir','out','Ticklength',[0.02,1],'box','off'); % The only other option is 'in'
% 
%     ax = gca;
%     
%    if j==1
%        
%        ax.XTick = [1,2,3,4];
%         ax.YTick = [0,1,2,3];    
%         ylabel(' rating')
% 
%         ylim([0,3])
% 
% 
%         ax.XTickLabel = {'Impressionism','AbstractArt','ColorFieldPainting','Cubism'};
% 
% 
%        p=permutation_test_mean(x,y ,n_perm)
%        text(1.5,2,['p=' sprintf('%5.3f',p) ])
%         
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
%         
% 
%     
% end
% 
% 
% % it should have ones for each subjects..
% if do_slow_reg 
% sub_ones=zeros(size(length(response_r),n_sub));
% 
% 
% 
% for i_sub=1:length(list_id)
%      current_id=list_id(i_sub);     
%      sub_ones(sub_id_rating==current_id,i_sub)=1;
%      
% end
% 
% 
% 
% 
% [b,bint,~,~,stats] =regress(response_r,[image_features(rated_image_index,:), sub_ones]);
% figure(100)
% %[~,~,~,~,stats] = regress(y,X)
% 
%  e=errorbar(1:length(b),b,b-bint(:,1),bint(:,2)-b,'black')
%  e.LineStyle = 'none';
%  hold all
%  bar(1:length(b),b,0.9)
%  xlim([0,40])
%  
%  figure(101)
% 
% br=b(1:40);
%  
%  bar(1:length(br),br,0.9)
% end
%  
%  %
% 
% figure(105) 
% 
% current_image_index_list=rated_image_index;
% current_feature_list=image_features(current_image_index_list,:);
%      
%      
% current_feature_list=image_features;
% 
% non_nan_index=~any(isnan(current_feature_list),2);
% non_nan_x=current_feature_list(non_nan_index,:);
% non_nan_x=double(non_nan_x);
% 
% non_nan_id=sub_id_rating(non_nan_index);
% 
% non_nan_response_r=response_r(non_nan_index);
% 
% sub_ones=zeros(size(length(non_nan_response_r),n_sub));
% 
% non_nan_image_index=rated_image_index(non_nan_index);
% 
% 
% 
% 
% for i_sub=1:length(list_id)
%      current_id=list_id(i_sub);     
%      sub_ones(non_nan_id==current_id,i_sub)=1;
%      
% end
% 
% if do_slow_reg 
% 
% [b,bint,~,~,stats] =regress(non_nan_response_r,[zscore(non_nan_x), sub_ones]);
% 
% [~,~,~,~,stats] = regress(y,X)
% 
% %
% figure(105) 
% 
%  e=errorbar(1:length(b),b,b-bint(:,1),bint(:,2)-b,'black')
%  e.LineStyle = 'none';
%  hold all
%  bar(1:length(b),b,0.9)
%  xlim([0,40])
%  
%  
% 
% br=b(1:40);
%  
%  bar(1:length(br),br,0.9)
%  
%  xlabel('features from Li and Chen 2009')
%  ylabel('\beta')
%  
% end
% 
% 
% %
% color_list=0:30:360;
% n_color=length(color_list)-1;
% color=current_feature_list(:,1);
% 
% clearvars mean_r_color ste_r_color
% for j=1:n_color
%     index=find(color_list(j)<=color& color <color_list(j+1));
%     
%     mean_r_color(j)=nanmean(response_r(index));
%     ste_r_color(j)=nanstd(response_r(index))/sqrt(length(index));
% end
% 
% figure(21)
% 
%  e=errorbar(1:n_color,mean_r_color,ste_r_color,'black')
%  e.LineStyle = 'none';
%  hold all
%  bar(1:n_color,mean_r_color,0.9)
%  xlim([0,41])
%  
% 
% 
%     set(gca,'TickDir','out','Ticklength',[0.02,1],'box','off'); % The only other option is 'in'
% 
%     ax = gca;
%        
%  ax.XTick = 1:n_color;
%  ax.XTickLabel = color_list;
%   
%         
%  xlabel('color')
%  ylabel('rating')
%  
%  
%  %
%  
% figure(22)
% 
% h = histogram(color,color_list,'Normalization','probability')
% 
% 
% 
% 
%     set(gca,'TickDir','out','Ticklength',[0.02,1],'box','off'); % The only other option is 'in'
% 
%     ax = gca;
%        
%  ax.XTick = 1:n_color;
%  ax.XTickLabel = color_list;
%   
%         
%  xlabel('color')
%  ylabel('density')
%  
%  %
%  figure(33)
%  [R,PValue]=corrplot(image_features(:,1:40));
%  % hue model
%  
%  
% color_list=1:8;
% n_color=length(color_list)-1;
% color=current_feature_list(:,6);
% 
% clearvars mean_r_color ste_r_color
% for j=1:n_color
%     index=find(color==color_list(j));
%     
%     mean_r_color(j)=nanmean(response_r(index));
%     ste_r_color(j)=nanstd(response_r(index))/sqrt(length(index));
% end
% 
% figure(51)
% 
%  e=errorbar(1:n_color,mean_r_color,ste_r_color,'black')
%  e.LineStyle = 'none';
%  hold all
%  bar(1:n_color,mean_r_color,0.9)
%  xlim([0,41])
%  
% 
% 
%     set(gca,'TickDir','out','Ticklength',[0.02,1],'box','off'); % The only other option is 'in'
% 
%     ax = gca;
%        
%  ax.XTick = 1:n_color;
%  ax.XTickLabel = color_list;
%   
%         
%  xlabel('hue model')
%  ylabel('rating')
%  
%  
%  %
%  
% figure(52)
% 
% h = histogram(color,color_list,'Normalization','probability')
% 
% 
% 
% 
%     set(gca,'TickDir','out','Ticklength',[0.02,1],'box','off'); % The only other option is 'in'
% 
%     ax = gca;
%        
%  ax.XTick = 1:n_color;
%  ax.XTickLabel = color_list;
%   
%         
%  xlabel('hue model')
%  ylabel('density')
%  
%  
%  %
%  
%  coeff = pca(non_nan_x);
%  
%  figure(302)
%  for j=1:16
%      subplot(4,4,j)
%     bar(1:40,coeff(:,j))
%     xlim([1,40])
%     title(['PC' num2str(j, '%d') ])
%  end
%  
%  
%  % brightness contrast
%  color=current_feature_list(:,10);
%  inc=(max(color)-min(color))/10;
%  
% color_list=min(color):(max(color)-min(color))/10:max(color);
% n_color=length(color_list)-1;
% 
% 
% clearvars mean_r_color ste_r_color
% for j=1:n_color
%     index=find(color_list(j)<=color& color <color_list(j+1));
%     
%     mean_r_color(j)=nanmean(response_r(index));
%     ste_r_color(j)=nanstd(response_r(index))/sqrt(length(index));
% end
% 
% figure(231)
% 
%  e=errorbar(1:n_color,mean_r_color,ste_r_color,'black')
%  e.LineStyle = 'none';
%  hold all
%  bar(1:n_color,mean_r_color,0.9)
%  xlim([0,41])
%  
% 
% 
%     set(gca,'TickDir','out','Ticklength',[0.02,1],'box','off'); % The only other option is 'in'
% 
%     ax = gca;
%        
%  ax.XTick = 1:n_color;
%  ax.XTickLabel = color_list;
%   
%         
%  xlabel('brightness contrast')
%  ylabel('rating')
%  
%  
% 
% figure(232)
% 
% h = histogram(color,color_list,'Normalization','probability')
% 
% 
% 
% 
%     set(gca,'TickDir','out','Ticklength',[0.02,1],'box','off'); % The only other option is 'in'
% 
%     ax = gca;
%        
%  ax.XTick = 1:n_color;
%  ax.XTickLabel = color_list;
%   
%         
%  xlabel('brightness contrast')
%  ylabel('density')
%  %
%  figure(1000)
%  
% 
% 
% 
%  x= image_features(:,10);
%  index=intersect(find(x>max(x)-2*inc),find(rating_image>2.1));
%  
%  im_path=[im_dir,cell2mat(image_r{index(1)})];
%         
%  imshow(im_path)
%     
%   figure(1001)
%  
% 
% 
%  x= image_features(:,10);
%  index=intersect(find(x<min(x)+1*inc),find(rating_image<1));
%  
%  im_path=[im_dir,cell2mat(image_r{index(1)})];
%         
%  imshow(im_path)
    
 
  