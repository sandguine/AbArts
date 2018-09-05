% Predicting out of subject
% Iman Wahle
% August 29 2018

%% Load Data

% Load Features
feats = load('all_feats_reduced3.mat');
feats = feats.all_feats_reduced3;

% swap in the new mean feats
% Load Ratings
trial_data = load('../feature_rating_comparison/trial_data.mat');
ratings = trial_data.classifications;
rts = trial_data.response_times;

% Features to Ratings Mapping

mapping = [12 11 10 13 6 7 8];

%% Leave one participant out performance
pts = 1:7;
n = size(feats,1) * length(pts);
p = size(feats,2) + 1;

in_sample = zeros(length(pts),1);
out_sample = zeros(length(pts),1);
self = zeros(length(pts),1);
for rID=pts
    % leave one person out of training each time to predict on
    comp_feats = repmat(feats, length(pts)-1,1);
    comp_ratings = [];
    pts2 = (pts ~= rID);
    for rID2=pts(pts2)
        comp_ratings = [comp_ratings; ratings(:,rID2)];
    end
    lm = fitlm(zscore(comp_feats), zscore(comp_ratings), 'linear');
    
    in_sample(rID) = lm.Rsquared.Adjusted;
    
    pred = lm.predict(zscore(feats));
    R = corrcoef(pred,zscore(ratings(:,rID)));
    R = R(1,2);
    out_sample(rID) = 1-((n-1)/(n-p))*(1-R^2);
    
    lm = fitlm(zscore(feats), zscore(ratings(:,rID)), 'linear');
    self(rID) = lm.Rsquared.Adjusted;

end
figure;plot(1:7, in_sample);hold on; plot(1:7, out_sample); hold on; plot(1:7, self);
legend('In Sample', 'Out of Sample', 'Train and Predict on Self');
xlabel('Participant');
ylabel('Adjusted R-squared');
    
%% Weight Correlation

weights = zeros(7, size(feats,2));

for rID = 1:7
    lm = fitlm(zscore(feats), zscore(ratings(:,rID)),'linear');
    weights(rID,:) = lm.Coefficients.Estimate(2:end);
end

figure;imagesc(corr(weights'));colorbar;
title('Linear Regression Weight Correlation Between Participants');
xlabel('Participants');ylabel('Participants');