% Test if all_feats_reduced2 can predict well on mturk data
% Iman Wahle
% August 27 2018

%% Load data
rmat = load('ratings_matrix.mat');
rmat = rmat.X;
load('../all_feats_reduced3.mat');
load('../feature_names_reduced3.mat');
feats = all_feats_reduced3(1:826,:); % since mturk data doesn't include lesley
feat_labels = feature_names_reduced3;


%%
rsquareds = zeros(size(rmat,1),1);
WEIGHTS = zeros(40,1545);
sub_names = feature_names_reduced3(I);
for rID=1:size(rmat,1)
    rtngs = rmat(rID,:);
    rated = find(rtngs~=0);
    if length(rated)<=50
        continue;
    end
    lm = fitlm(zscore(feats(rated,I(1:40))), zscore(rtngs(rated)), 'linear');
    rsquareds(rID,1) = lm.Rsquared.Adjusted;
    WEIGHTS(:,rID) = lm.Coefficients.Estimate(2:end);
end

%% Plot WEIGHTS mean and std with feature labels
mweights = mean(abs(WEIGHTS),2);
sweights = std(abs(WEIGHTS)')';
[~,J] = sort(mweights,'descend');
xticks = 1:size(WEIGHTS,1);
xlabels = sub_names;
xlabels = xlabels(J);
figure;errorbar(1:size(WEIGHTS,1),mweights(J),sweights(J),'or'); grid on; set(gca, 'Xtick', xticks, 'XTicklabel', xlabels);xtickangle(45);
ylabel('Feature Weight');
xlabel('Feature');
title('Mean and Standard Deviation of Feature Weights Across Participants 1:1545');

%%
rsquareds = zeros(size(rmat,1),1);
WEIGHTS = zeros(40,1545);
sub_names = feature_names_reduced3(I);
for rID=1:size(rmat,1)
    rtngs = rmat(rID,:);
    rated = find(rtngs~=0);
    if length(rated)<=50
        continue;
    end
    lm = fitlm(zscore(feats(rated,I(1:40))), zscore(rtngs(rated)), 'linear');
    rsquareds(rID,1) = lm.Rsquared.Adjusted;
    WEIGHTS(:,rID) = lm.Coefficients.Estimate(2:end);
end
