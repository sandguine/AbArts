% Measure Feature Contribution by Excluding Features Individually from Regression
% Iman Wahle
% August 20 2018

%% Load data

% Load High-Level Features
conc = load('../feature_task_analysis/concreteness_data.mat');
conc = conc.classifications;
dyna = load('../feature_task_analysis/dynamic_data.mat');
dyna = dyna.classifications;
temp = load('../feature_task_analysis/temperature_data.mat');
temp = temp.classifications;
vale = load('../feature_task_analysis/valence_data.mat');
vale = vale.classifications;

% Load Li-Features
glbl = load('../data/features_global_all.mat');
lcl = load('../data/features_local_all.mat');
li_feats = [glbl.image_features(:,[1:6 8:end]) lcl.image_features(:,13:39)];

% Load New Low-Level Features
load('../new_features/new_feats4.mat');
% using seg_feats as well.

% Load Ratings and Response Times
trial_data = load('trial_data.mat');
ratings = trial_data.classifications;
rts = trial_data.response_times;

% Features to Ratings Mapping
mapping = [12 11 10 nan 6 7 8];
% (get the rating-th cell for the corresponding feature ID)

%% Leave-one-out Regression
RESULTS = cell(6,1);
overall_results = zeros(length(mapping), 2);

% Do analysis for each participant separately 
for rID=[1:3 5:7]
    % Combine all features
    high_feats = [conc(:,mapping(rID)) dyna(:,mapping(rID)) temp(:,mapping(rID)) vale(:,mapping(rID))];
    ALL_FEATS = [high_feats li_feats seg_feats new_feats4 ppl];
    BEST_FEATS = ALL_FEATS(:, find(difs(:,2)<-.001));
    % Store results here
    results = zeros(size(BEST_FEATS, 2), 2); % for each left out feature, store (RMSE, adj-R-squared)

    % first do full regression as baseline
    lm = fitlm(BEST_FEATS, ratings(:,rID), 'linear');
    fprintf(['Rating Participant: ' num2str(rID) '\n']);
    overall_results(rID,1) = lm.RMSE;
    overall_results(rID,2) = lm.Rsquared.Adjusted;
    
    % now do leave-one-feature-out regression and store in results
    for outfeat=1:size(BEST_FEATS,2)
        SUB_FEATS = BEST_FEATS;
        SUB_FEATS(:,outfeat) = [];
        
        lm = fitlm(SUB_FEATS, ratings(:,rID), 'linear');
        results(outfeat,1) = lm.RMSE;
        results(outfeat,2) = lm.Rsquared.Adjusted;
    end
    
    RESULTS(rID,1) = {results};
end

%%
% plot RMSE
figure;
cnt=1;
for rID = [1:3 5:7]
    subplot(2,3,cnt); cnt = cnt+1;
    bar(RESULTS{rID}(:,1) - overall_results(rID,1));
    title(['Change in RMSE for Participant ' num2str(rID)]);
    %ylim([min(RESULTS{rID}(:,1))-.005 max(RESULTS{rID}(:,1))+.005]);
    ylim([-.005 .015]);
end


% plot R-Squared
figure;
cnt=1;
for rID = [1:3 5:7]
    subplot(2,3,cnt); cnt = cnt+1;
    bar(RESULTS{rID}(:,2) - overall_results(rID,2));
    title(['Change in Adjusted R-Squared for Participant ' num2str(rID)]);
    %ylim([min(RESULTS{rID}(:,2))-.005 max(RESULTS{rID}(:,2))+.005]);
    ylim([-.02 .005]);

end



%% We can also do the regression allll together

ALLALL_FEATS = [];
ALL_RATINGS = [];
for rID=[1:3 5:7]
    ALL_RATINGS = [ALL_RATINGS; ratings(:,rID)];
    % Combine all features
    high_feats = [conc(:,mapping(rID)) dyna(:,mapping(rID)) temp(:,mapping(rID)) vale(:,mapping(rID))];
    ALL_FEATS = [high_feats li_feats seg_feats new_feats4 ppl];
    ALLALL_FEATS = [ALLALL_FEATS; ALL_FEATS]; 
end

lm = fitlm(ALLALL_FEATS, ALL_RATINGS, 'linear');
AARMSE = lm.RMSE;
AARS = lm.Rsquared.Adjusted;

AARESULTS = zeros(size(ALLALL_FEATS,2),2);
% now do leave-one-feature-out regression and store in results
for outfeat=1:size(ALLALL_FEATS,2)
    SUB_FEATS = ALLALL_FEATS;
    SUB_FEATS(:,outfeat) = [];

    lm = fitlm(SUB_FEATS, ALL_RATINGS, 'linear');
    AARESULTS(outfeat,1) = lm.RMSE;
    AARESULTS(outfeat,2) = lm.Rsquared.Adjusted;
end
%%
% plot RMSE
figure;bar(AARESULTS(:,1)-AARMSE);
title('Change in RMSE Overall');
ylim([-.005 .015]);

% plot RSquared
figure;bar(AARESULTS(:,2)-AARS);
title('Change in Adjusted R-Squared Overall');
ylim([-.03 .005]);