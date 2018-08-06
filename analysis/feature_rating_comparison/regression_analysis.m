
% See if subjective high-level features can predict individual ratings
% Iman Wahle
% Created July 31 2018
%% Load data

conc = load('../feature_task_analysis/concreteness_data.mat');
conc = conc.classifications;
dyna = load('../feature_task_analysis/dynamic_data.mat');
dyna = dyna.classifications;
temp = load('../feature_task_analysis/temperature_data.mat');
temp = temp.classifications;
vale = load('../feature_task_analysis/valence_data.mat');
vale = vale.classifications;

trial_data = load('trial_data.mat');
ratings = trial_data.classifications;
rts = trial_data.response_times;

% load('../new_features/new_feats.mat');
% load('../new_features/new_feats2.mat');

%new_feats3 = [new_feats new_feats2(:,2:end)];

%% Features to Ratings Matching:
% Feature ID    Rating ID
% 6             5
% 7             6
% 10            3
% 11            2
% 12            1
% no data       4

mapping = [12 11 10 nan 6 7];
% (get the rating-th cell for the corresponding feature ID)

%% Regression
% mask = rts<.5*10^6;
for rating=[1:3 5:6]
    y = ratings(:, rating);
    y(y==6)=0;
%     X = [conc(:,mapping(rating)) dyna(:,mapping(rating)) ...
%         temp(:,mapping(rating)) vale(:,mapping(rating)) old_feats];
    X = new_feats4;%(:, 66)%67:70);%[1:9 19:27 38:end]);
%     X = new_feats3;
%     X(isnan(X))=0;
%     X(X==Inf)=0;
    %X = old_feats;
    %lm = fitlm(X(mask(:,rating),:),y(mask(:,rating),1), 'linear');
    lm = fitlm(X(:, [1:9 19:27 37:end]),y,'linear');
    lm.Rsquared
end
    
    
        
    


