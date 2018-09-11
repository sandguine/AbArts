% Calculate weights per person from linear regression model
% Iman Wahle
% September 5 2018

% v2 modified by kiigaya@gmail.com

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

% Extract feature names for our subset of features
NUM_FEATS = 40;
sub_feature_names = feature_names(weight_order(1:NUM_FEATS));

% Store adjusted r-squared and feature weights for each person's regression
RSQUAREDS = zeros(size(mturk_ratings,2),1);
WEIGHTS = zeros(NUM_FEATS,size(mturk_ratings,2));

% Now do regression for each person
for rID=1:size(mturk_ratings,2)
    rtngs = mturk_ratings(:,rID);
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
    RSQUAREDS(rID,1) = lm.Rsquared.Adjusted;
    WEIGHTS(:,rID) = lm.Coefficients.Estimate(2:end);
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
save w_mturk_fit_ind WEIGHTS W_names

%% 7-Person Predictions

NUM_FEATS = size(features,2);

% Store adjusted r-squared and feature weights for each person's regression
RSQUAREDS = zeros(size(seven_ratings,2),1);
WEIGHTS = zeros(NUM_FEATS,size(seven_ratings,2));

% Now do regression for each person
for rID=[1:7]
    lm = fitlm(zscore(features), zscore(seven_ratings(:,rID)), 'linear');
    
    fprintf(['Rating Participant: ' num2str(rID) ...
        '    Adj R-Squared: ' num2str(lm.Rsquared.Adjusted) ...
        '    RMSE: ' num2str(lm.RMSE) '\n']);
    WEIGHTS(:,rID) = lm.Coefficients.Estimate(2:end);
    RSQUAREDS(rID,1) = lm.Rsquared.Adjusted;
end

% Plot the resultant weights
mweights = mean(abs(WEIGHTS),2);
sweights = std(abs(WEIGHTS)')';
[~,J] = sort(mweights,'descend');
xticks = 1:size(WEIGHTS,1);
xlabels = feature_names;
xlabels = xlabels(J);
figure;errorbar(1:size(WEIGHTS,1),mweights(J),sweights(J),'or'); grid on; set(gca, 'Xtick', xticks, 'XTicklabel', xlabels);xtickangle(45);
ylabel('Feature Weight');
xlabel('Feature');
title('Mean and Standard Deviation of Feature Weights Across Participants 1:1545');


W_names=feature_names;

save w_seven_fit_ind WEIGHTS W_names

