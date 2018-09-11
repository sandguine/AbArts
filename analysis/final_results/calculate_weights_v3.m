% Calculate weights per person from linear regression model
% Iman Wahle
% September 5 2018

% v2,3 modified by kiigaya@gmail.com
close all
clear all

m_turk = 0;

%% Load Data

% Load features
features = load('all_features.mat');
features = features.features;
feature_names = load('all_feature_names.mat');
feature_names = feature_names.feature_names;

% Use this block if doing MTurk predictions
mturk_ratings = load('ratings_matrix.mat');
mturk_ratings = mturk_ratings.X';
weight_order = load('weight_order.mat'); % which features are most important
weight_order = weight_order.I;           % since we have to use a subset of
                                         % features for the MTurk data.
                                         % 'weight_order' was determined
                                         % from 7-person data set
                                         % performance.

% Use this block if doing 7-person predictions
seven_ratings = load('trial_data.mat');
seven_ratings = seven_ratings.classifications;
seven_ratings(seven_ratings==6)=0; % artifact of how data was stored before

%% MTurk Predictions
if m_turk
% Extract feature names for our subset of features
NUM_FEATS = 40;
sub_feature_names = feature_names(weight_order(1:NUM_FEATS));

% Store adjusted r-squared and feature weights for each person's regression
RSQUAREDS = zeros(size(mturk_ratings,2),1);
WEIGHTS = zeros(NUM_FEATS,size(mturk_ratings,2));

% Now do regression for each person
for fi=1:size(mturk_ratings,2)
    rtngs = mturk_ratings(:,fi);
    % select out paintings that this participant gave ratings for
    rated = find(rtngs~=0);
    % handle false trial case
    if length(rated)<=50
        continue;
    end
    % fit linear model
    lm = fitlm(zscore(features(rated, weight_order(1:NUM_FEATS))), ...
         zscore(rtngs(rated)), 'linear');
    % store results
    RSQUAREDS(fi,1) = lm.Rsquared.Adjusted;
    WEIGHTS(:,fi) = lm.Coefficients.Estimate(2:end);
end

% Plot the resultant weights
mweights = mean(abs(WEIGHTS),2);
sweights = std(abs(WEIGHTS)')';
[~,J] = sort(mweights,'descend');
xticks = 1:size(WEIGHTS,1);
xlabels = sub_feature_names;
xlabels = xlabels(J);
figure;errorbar(1:size(WEIGHTS,1),mweights(J),sweights(J),'or'); grid on; set(gca, 'Xtick', xticks, 'XTicklabel', xlabels);xtickangle(45);
ylabel('Feature Weight');
xlabel('Feature');
title('Mean and Standard Deviation of Feature Weights Across Participants 1:1545');


W_names= xlabels;
%save w_mturk_fit_ind WEIGHTS W_names
end
%% 7-Person Predictions

NUM_FEATS = size(features,2);

% Store adjusted r-squared and feature weights for each person's regression
RSQUAREDS = zeros(size(seven_ratings,2),1);
WEIGHTS = zeros(NUM_FEATS,size(seven_ratings,2));

% Now do regression for each person
for fi=[1:7]
    
    
    D=zscore(features);
    y=zscore(seven_ratings(:,fi));


    figure(20+fi)
    % [B,FitInfo] = lasso(D,y,'CV',10,'Alpha',0.5);
    [B,FitInfo] = lasso(D,y,'CV',10);

    lassoPlot(B,FitInfo,'PlotType','CV');
    legend('show') % Show legend

    idxLambda1SE = FitInfo.Index1SE;
    idxLambdamin=FitInfo.IndexMinMSE;
    %coef = B(:,idxLambda1SE);
    
    coef = B(:,idxLambdamin);

    w_lasso= coef;

    [wd,J] = sort(abs(w_lasso),'descend')
    
    Ws_lasso(:,fi)=w_lasso;

    J=J(abs(wd)>0.02);
    
    if fi<4
        figure(30)
        subplot(1,3,fi)
    else
        figure(31)
        subplot(1,4,fi-3)
    end
    bar( w_lasso(J))
    xlabels = feature_names(J);
    title(fi)
    xticks = 1:length(J)
    set(gca, 'Xtick', xticks, 'XTicklabel', xlabels);xtickangle(45);

    lm = fitlm(zscore(D(:,J)), zscore(y), 'linear');
    RSQUAREDS_lasso(fi,1) = lm.Rsquared.Adjusted;
        
        
    lm = fitlm(zscore(features), zscore(seven_ratings(:,fi)), 'linear');
    
    fprintf(['Rating Participant: ' num2str(fi) ...
        '    Adj R-Squared: ' num2str(lm.Rsquared.Adjusted) ...
        '    RMSE: ' num2str(lm.RMSE) '\n']);
    WEIGHTS(:,fi) = lm.Coefficients.Estimate(2:end);
    RSQUAREDS(fi,1) = lm.Rsquared.Adjusted;
end
%%

ws_mean= mean( abs(Ws_lasso),2);


[wd,J] = sort(abs(ws_mean),'descend')

 J=J(abs(wd)>0.01);

se_w=std( abs(Ws_lasso)')'/sqrt(7);
 
 
% Plot the resultant weights
% mweights = mean(abs(WEIGHTS),2);
% sweights = std(abs(WEIGHTS)')';
% [~,J] = sort(mweights,'descend');
 xticks = 1:length(J);
 xlabels = feature_names;
 xlabels = xlabels(J);
 figure(200)
 errorbar(1:length(J),ws_mean(J),se_w(J),'.'); grid on; set(gca, 'Xtick', xticks, 'XTicklabel', xlabels);
 hold all
 bar(1:size(wd,1),wd)
 
 xtickangle(45);
% ylabel('Feature Weight');
% xlabel('Feature');
% title('Mean and Standard Deviation of Feature Weights Across Participants 1:1545');
% 
% 
% W_names=feature_names;

%save w_seven_fit_ind WEIGHTS W_names

