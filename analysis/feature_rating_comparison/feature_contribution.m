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

% % Load Li-Features
% glbl = load('../data/features_global_all.mat');
% lcl = load('../data/features_local_all.mat');
% li_feats = [glbl.image_features(:,[1:6 8:end]) lcl.image_features(:,13:39)];
% 
% % Load New Low-Level Features
% load('../new_features/new_feats4.mat');
% % using seg_feats as well.

% Load Ratings and Response Times
trial_data = load('../feature_rating_comparison/trial_data.mat');
ratings = trial_data.classifications;
rts = trial_data.response_times;

% Features to Ratings Mapping
mapping = [12 11 10 13 6 7 8];
% (get the rating-th cell for the corresponding feature ID)

%% Leave-one-out Regression
RESULTS = cell(6,1);
overall_results = zeros(length(mapping), 2);

% Do analysis for each participant separately 
for rID=[1:3 5:7]
    % Combine all features
    high_feats = [conc(:,mapping(rID)) dyna(:,mapping(rID)) temp(:,mapping(rID)) vale(:,mapping(rID))];
    ALL_FEATS = [high_feats li_feats seg_feats new_feats4 ppl];
    BEST_FEATS = ALL_FEATS(:, DIF_LOCS{rID});
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
% % plot RMSE
% figure;
% cnt=1;
% for rID = [1:3 5:7]
%     subplot(2,3,cnt); cnt = cnt+1;
%     bar(RESULTS{rID}(:,1) - overall_results(rID,1));
%     title(['Change in RMSE for Participant ' num2str(rID)]);
%     %ylim([min(RESULTS{rID}(:,1))-.005 max(RESULTS{rID}(:,1))+.005]);
%     ylim([-.005 .015]);
% end


% plot R-Squared
DIF_LOCS = cell(6,1);
figure;
cnt=1;
for rID = [1:3 5:7]
    subplot(2,3,cnt); cnt = cnt+1;
    difs = RESULTS{rID}(:,2) - overall_results(rID,2);
    dif_loc = find(difs<-0.001);
    DIF_LOCS(rID,1) = {dif_loc};
    disp(dif_loc);
    bar(difs);
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

%% Let's determine which features are best by their linreg weights instead of rsquared

ALL_FEATS = all_feats_reduced3(:,:);
num_weights = 1:size(ALL_FEATS,2);
rsquareds = zeros(length(num_weights), 7);

WEIGHTS = zeros(size(ALL_FEATS,2),7); % store feature weights for each person
% for nw=num_weights
    ratings(ratings==6)=0;
    % Do analysis for each participant separately 
    for rID=[1:7]
        % Combine all features
        %high_feats = [conc(:,mapping(rID)) dyna(:,mapping(rID)) temp(:,mapping(rID)) vale(:,mapping(rID))];
        %ALL_FEATS = [high_feats li_feats seg_feats new_feats4 ppl];
    %     ALL_FEATS = [MEAN_HIGH_FEATS li_feats seg_feats final_new_feats ppl];
    % 
    %     % zscore and normalize so we can compare features by linear regressionweights
    %     ALL_FEATS(isnan(ALL_FEATS))=0;
    %     ALL_FEATS(ALL_FEATS==inf)=0;
        ALL_FEATSz = zscore(ALL_FEATS);
        ALL_FEATSz(isnan(ALL_FEATSz))=0;
    %     coeff = pca(ALL_FEATSz);
    %     PCA_FEATS = ALL_FEATSz * coeff(:,1:90);

        % first do full regression as baseline
        lm = fitlm(ALL_FEATSz(:,:), zscore(ratings(:,rID)), 'linear');
        fprintf(['Rating Participant: ' num2str(rID) ...
            '    Adj R-Squared: ' num2str(lm.Rsquared.Adjusted) ...
            '    RMSE: ' num2str(lm.RMSE) '\n']);
        WEIGHTS(:,rID) = lm.Coefficients.Estimate(2:end);
        %rsquareds(nw,rID) = lm.Rsquared.Adjusted;
    end
%end

%%
figure;plot(1:size(ALL_FEATS,2), rsquareds);xlabel('Number of Features, Ordered by Descending Weight Magnitude'); ylabel('Adjusted R-squared');
xticks = 1:size(ALL_FEATS,2);
xlabels = feature_names_reduced2(no_third);
xlabels = xlabels(I);
set(gca, 'Xtick', xticks, 'XTicklabel', xlabels);xtickangle(45);
%% Plot WEIGHTS mean and std with feature labels
mweights = mean(abs(WEIGHTS(:,[1:3 5:7])),2);
sweights = std(abs(WEIGHTS(:,[1:3 5:7]))')';
[~,I] = sort(mweights,'descend');
xticks = 1:size(WEIGHTS,1);
xlabels = feature_names_reduced3;
xlabels = xlabels(I);
figure;errorbar(1:size(WEIGHTS,1),mweights(I),sweights(I),'or'); grid on; set(gca, 'Xtick', xticks, 'XTicklabel', xlabels);xtickangle(45);
ylabel('Feature Weight');
xlabel('Feature');
title('Mean and Standard Deviation of Feature Weights Across Participants 1:7');

%% changing weight threshold
threshs = .15;
rsquareds = zeros(length(threshs), 7);
num_feats = zeros(length(threshs),1);
for thresh=threshs
    above_thresh = [];
    for rID=[1:3 5:7]
        above_thresh = union(above_thresh, find(abs(WEIGHTS(:,rID))>=thresh));
    end
    % fprintf(['Number of Features above threshold: ' num2str(length(above_thresh)) '\n']);
    for rID=[1:3 5:7]
        lm = fitlm(ALL_FEATSz(:,above_thresh), zscore(ratings(:,rID)), 'linear');
%         fprintf(['Rating Participant: ' num2str(rID) ...
%             '    Adj R-Squared: ' num2str(lm.Rsquared.Adjusted) ...
%             '    RMSE: ' num2str(lm.RMSE) '\n']);
        rsquareds(find(threshs==thresh), rID) = lm.Rsquared.Adjusted;
        num_feats(find(threshs==thresh),1) = length(above_thresh);
    end
end
figure;plot(threshs, rsquareds);xlabel('Weight Threshold'); ylabel('Adjusted R-squared');
figure;plot(threshs, num_feats);xlabel('Weight Threshold'); ylabel('Number of Features');

%% Changing # PCs
ALL_FEATS = all_feats_reduced2;
rsquareds = zeros(size(ALL_FEATS,2), 7);
for numpc = 1:size(ALL_FEATS,2)
    ratings(ratings==6)=0;
    % Do analysis for each participant separately 
    for rID=[1:3 5:7]
        % Combine all features
        %high_feats = [conc(:,mapping(rID)) dyna(:,mapping(rID)) temp(:,mapping(rID)) vale(:,mapping(rID))];
        %ALL_FEATS = [high_feats li_feats seg_feats new_feats4 ppl];
        %ALL_FEATS = all_feats_reduced2; %[MEAN_HIGH_FEATS li_feats seg_feats new_feats4 ppl];

        % zscore and normalize so we can compare features by linear regressionweights
        ALL_FEATS(isnan(ALL_FEATS))=0;
        ALL_FEATS(ALL_FEATS==inf)=0;
        ALL_FEATSz = zscore(ALL_FEATS);
        ALL_FEATSz(isnan(ALL_FEATSz))=0;
        coeff = pca(ALL_FEATSz);
        PCA_FEATS = ALL_FEATSz * coeff(:,1:numpc);

        % first do full regression as baseline
        lm = fitlm(PCA_FEATS, zscore(ratings(:,rID)), 'linear');
        rsquareds(numpc, rID) = lm.Rsquared.Adjusted;
    end
end

figure;plot(1:size(ALL_FEATS,2), rsquareds);xlabel('Number of PCs'); ylabel('Adjusted R-squared');



