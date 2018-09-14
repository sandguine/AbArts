% can we predict high level features by low level features?
%kiigaya based on Calculate weights per person from linear regression model by Iman Wahle
% 
clear all
close all

do_lasso=0;

%% Load Data

% Load features
features = load('all_features.mat');
features = features.features;
feature_names = load('all_feature_names.mat');
feature_names = feature_names.feature_names;


feature_names_low=feature_names(5:end-1);

feature_names_high=feature_names([1:4,end]);


features_low= features(:,5:end-1);
features_high=features(:,[1:4,end]);

figure(1)
for i =1:4
    subplot(2,2,i)
    
    histogram(features_high(:,i))
    title(feature_names{i})
end


%% lasso



if do_lasso
    NUM_FEATS = size(features_low,2);

    % Store adjusted r-squared and feature weights for each person's regression
    RSQUAREDS = zeros(size(features_high,2),1);
    WEIGHTS = zeros(NUM_FEATS,size(features_high,2));

    % Now do regression for each person
    for fi=1:5
        lm = fitlm(zscore(features_low), zscore(features_high(:,fi)), 'linear');

        fprintf(['Rating Participant: ' num2str(fi) ...
            '    Adj R-Squared: ' num2str(lm.Rsquared.Adjusted) ...
            '    RMSE: ' num2str(lm.RMSE) '\n']);
        WEIGHTS(:,fi) = lm.Coefficients.Estimate(2:end);
        RSQUAREDS(fi,1) = lm.Rsquared.Adjusted;
        Se_WEIGHTS(:,fi) = lm.Coefficients.SE(2:end);



    %     figure(10+fi)
    %     
    %     errorbar(WEIGHTS(:,fi),Se_WEIGHTS(:,fi))
    %     xlabels = feature_names_low;
    %     title(feature_names{fi})
    %     set(gca, 'Xtick', xticks, 'XTicklabel', xlabels);xtickangle(45);

        D=zscore(features_low);
        y=zscore(features_high(:,fi));


         figure(20+fi)
        % [B,FitInfo] = lasso(D,y,'CV',10,'Alpha',0.5);
         [B,FitInfo] = lasso(D,y,'CV',10);

         lassoPlot(B,FitInfo,'PlotType','CV');
         legend('show') % Show legend

         idxLambda1SE = FitInfo.Index1SE;
        coef = B(:,idxLambda1SE);

        w_lasso= coef;

        [wd,J] = sort(abs(w_lasso),'descend')

        J=J(wd>0);
        figure(30)
        subplot(1,6,fi)
        bar( w_lasso(J))
        xlabels = feature_names_low(J);
        title(feature_names_high{fi})
        xticks = 1:length(J)
        set(gca, 'Xtick', xticks, 'XTicklabel', xlabels);xtickangle(45);

        lm = fitlm(zscore(D(:,J)), zscore(y), 'linear');
        RSQUAREDS_lasso(fi,1) = lm.Rsquared.Adjusted;

    %     coef0 = FitInfo.Intercept(idxLambda1SE);
    %   %  Predict exam scores for the test data. Compare the predicted values to the actual exam grades using a reference line.
    % 
    %     yhat = XTest*coef + coef0;
    %     hold on
    %     scatter(yTest,yhat)
    %     plot(yTest,yTest)
    %     xlabel('Actual Exam Grades')
    %     ylabel('Predicted Exam Grades')
    %     hold off




    end

end

%% svm

for fi=1:5
    
    X=zscore(features_low);
    y0=zscore(features_high(:,fi));
    
    if fi<5
        Y=(y0>2);
    else
        Y=(y0>0.5);
    end
    
    Mdl = fitcsvm(X,Y);
  %  Y=double(Y);
   % Mdl = fitrlinear(X,Y);
    CVSVMModel = crossval(Mdl);
    
    classLoss{fi} = kfoldLoss(CVSVMModel)
end
   
    

    




