
% See if subjective high-level features can predict individual ratings
% Iman Wahle
% Created July 31 2018

%(:, [19:27 37:47 51 52:61 68:74])
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
load('../new_features/new_feats4.mat');
%new_feats3 = [new_feats new_feats2(:,2:end)];

%% Features to Ratings Matching:
% Feature ID    Rating ID
% 6             5
% 7             6
% 10            3
% 11            2
% 12            1
% no data       4
% 9             7

mapping = [12 11 10 nan 6 7 8];
% (get the rating-th cell for the corresponding feature ID)

%% Regression
% mask = rts<.5*10^6;
for rating=[1:3 5:7]
    y = ratings(:, rating);
    y(y==6)=0;
    X = [ALL_FEATS];% old_feats conc(:,mapping(rating)) dyna(:,mapping(rating)) ...
        %temp(:,mapping(rating)) vale(:,mapping(rating))];% old_feats];
    %X = new_feats4;%imfeats;%new_feats4;%(:, 66)%67:70);%[1:9 19:27 38:end]);
%     X = new_feats3;
%     X(isnan(X))=0;
%     X(X==Inf)=0;
    %X = old_feats;
    %lm = fitlm(X(mask(:,rating),:),y(mask(:,rating),1), 'linear');
    X(isnan(X))=0;
    X(X==Inf)=0;
    w = warning('off','all');
    lm = fitlm(X,y,'linear');
    disp(lm.Rsquared.Adjusted);
end
    
%% Neural Net
% X = [];
% y = [];
% for rating=[1:3 5:7]
%     y = [y; ratings(:, rating)];
%     y(y==6)=0;
%     X = [X; [conc(:,mapping(rating)) dyna(:,mapping(rating)) ...
%          temp(:,mapping(rating)) vale(:,mapping(rating))]];
% end
for rating=[1:3 5:7]
    disp(['Rating ID: ' num2str(rating)]);
    y = ratings(:, rating);
    y(y==6)=0;
    X = [conc(:,mapping(rating)) dyna(:,mapping(rating)) ...
         temp(:,mapping(rating)) vale(:,mapping(rating))];

    net = patternnet([4], 'trainscg', 'mse');
    [net,~] = train(net, X', y');
    nntraintool
    prednn = net(X');
    RMSE = sqrt(mean((y' - prednn).^2));  
    RMSE

    % rsquared
    n = size(X,1);
    p = size(X,2)+1; % +1 for intercept
    SSE = sum((y' - prednn).^2);
    SST = sum((y').^2);
    adjR2 = 1 - ((n-1)/(n-p))*(SSE/SST);
    adjR2

end

%% Out of Sample RMSE Linear Regression

for rating=[1:3 5:7]
    disp(['Rating ID: ' num2str(rating)]);
    y = ratings(:, rating);
    y(y==6)=0;
    X = [conc(:,mapping(rating)) dyna(:,mapping(rating)) ...
         temp(:,mapping(rating)) vale(:,mapping(rating))];
     
    % Split into in-sample and out-of-sample
    Xtrain = X([1:4:end 2:4:end 3:4:end],:);
    Xtest = X(4:4:end,:);
    ytrain = y([1:4:end 2:4:end 3:4:end],:);
    ytest = y(4:4:end,:);
    
    lm = fitlm(Xtrain, ytrain);
    pred = predict(lm,Xtest);
    RMSE = sqrt(mean((ytest - pred).^2))
end

%% Out of Sample RMSE Neural Network

for rating=[1:3 5:7]
    disp(['Rating ID: ' num2str(rating)]);
    y = ratings(:, rating);
    y(y==6)=0;
    X = [conc(:,mapping(rating)) dyna(:,mapping(rating)) ...
         temp(:,mapping(rating)) vale(:,mapping(rating))];
     
    % Split into in-sample and out-of-sample
    Xtrain = X([1:4:end 2:4:end 3:4:end],:);
    Xtest = X(4:4:end,:);
    ytrain = y([1:4:end 2:4:end 3:4:end],:);
    ytest = y(4:4:end,:);
    
    net = patternnet([4], 'trainscg', 'mse');
    [net,~] = train(net, Xtrain', ytrain');
    nntraintool
    prednn = net(Xtest');
    RMSE = sqrt(mean((ytest' - prednn).^2)) 
end

%% Out of Sample RMSE Naive Bayes Classifier (Matlab implementation)

for rating=2
    disp(['Rating ID: ' num2str(rating)]);
    y = ratings(:, rating);
    y(y==6)=0;
    %X = [conc(:,mapping(rating)) dyna(:,mapping(rating)) ...
    %     temp(:,mapping(rating)) vale(:,mapping(rating))];
    X = image_features(:, [1:6 8:end]);
    % Split into in-sample and out-of-sample
    Xtrain = X([1:4:end 2:4:end 3:4:end],:);
    Xtest = X(4:4:end,:);
    ytrain = y([1:4:end 2:4:end 3:4:end],:);
    ytest = y(4:4:end,:);
    
    mdl = fitcnb(Xtrain,ytrain);
    pred = predict(mdl, Xtest);
    RMSE = sqrt(mean((ytest - pred).^2))
end 

%% Naive Bayes Classifier (Self Implementation)

for rating=[1:3 5:7]
    disp(['Rating ID: ' num2str(rating)]);
     X = seg_feats(1:200,1:33);
%     X = [conc(:,mapping(rating)) dyna(:,mapping(rating)) ...
%              temp(:,mapping(rating)) vale(:,mapping(rating))]; %image_features(:, [1:6 8:end]); 
    y = ratings(1:200,rating);

    % Split into in-sample and out-of-sample
    Xtrain = X([1:4:end 2:4:end 3:4:end],:);
    Xtest = X(4:4:end,:);
    ytrain = y([1:4:end 2:4:end 3:4:end],:);
    ytest = y(4:4:end,:);

    means = zeros(size(Xtrain,2),2);
    vars = zeros(size(Xtrain,2),2);
    for f=1:size(Xtrain,2) % for every feature
        % calculate positive prob
        means(f,1) = nanmean(Xtrain(ytrain==1,f));
        vars(f,1) = nanvar(Xtrain(ytrain==1,f));

        % calculate negative prob
        means(f,2) = nanmean(Xtrain(ytrain==-1,f));
        vars(f,2) = nanvar(Xtrain(ytrain==-1,f));
    end
    preds = zeros(length(Xtest),1);
    for x = 1:length(Xtest)
        num = 1;
        denom = 1;

        for f=1:size(Xtest,2)
           num = num * normpdf(Xtest(x,f), means(f,1), sqrt(vars(f,1))); %sqrt(vars(f,1)).*randn(1,1) + means(f,1);
           denom = denom * normpdf(Xtest(x,f), means(f,2), sqrt(vars(f,2)));% sqrt(vars(f,2)).*randn(1,1) + means(f,2);
        end
        preds(x,1) = num/denom;
    end
    fps = []; tps = [];
    Tmax = max(preds); Tmin = min(preds);
    K = 50000;
    for T =Tmin:(Tmax-Tmin)/K:Tmax
        predsT = preds;
        predsT(predsT>=T)=1000;
        predsT(predsT<T)=-1000;
        predsT=predsT/1000;

        % ROC plot
        fps = [fps sum(predsT==1 & ytest==-1)/sum(ytest==-1)];
        tps = [tps sum(predsT==1 & ytest==1)/sum(ytest==1)];
    end
    figure;scatter(fps, tps); hold on; xlabel('False Positive Rate'); ylabel('True Positive Rate');
    scatter(0:.001:1, 0:.001:1);title(['Rating ID: ' num2str(rating)]);hold off;
end

%% Adaboost
for rating=[1:3 5:7]
    disp(['Rating ID: ' num2str(rating)]);

    X = image_features(:, [1:6 8:end]);%[conc(:,mapping(rating)) dyna(:,mapping(rating)) ...
           %  temp(:,mapping(rating)) vale(:,mapping(rating))];
    y = ratings(:,rating);

    % Split into in-sample and out-of-sample
    Xtrain = X([1:4:end 2:4:end 3:4:end],:);
    Xtest = X(4:4:end,:);
    ytrain = y([1:4:end 2:4:end 3:4:end],:);
    ytest = y(4:4:end,:);

    means = zeros(size(Xtrain,2),2);
    vars = zeros(size(Xtrain,2),2);
    for f=1:size(Xtrain,2) % for every feature
        % calculate positive prob
        means(f,1) = nanmean(Xtrain(ytrain==1,f));
        vars(f,1) = nanvar(Xtrain(ytrain==1,f));

        % calculate negative prob
        means(f,2) = nanmean(Xtrain(ytrain==-1,f));
        vars(f,2) = nanvar(Xtrain(ytrain==-1,f));
    end
  
    train_feats = zeros(size(Xtrain,1),size(Xtrain,2));
    for x = 1:length(Xtrain)
        for f=1:size(Xtrain,2)
            train_feats(x,f) = normpdf(Xtrain(x,f), means(f,1), sqrt(vars(f,1)))/...
                normpdf(Xtrain(x,f), means(f,2), sqrt(vars(f,2)));
        end
    end
    weights = train_feats\ytrain;
    

    pred_feats = zeros(size(Xtest,1),size(Xtest,2));
    preds = zeros(length(Xtest),1);
    for x = 1:size(Xtest,1)
        num = 1;
        denom = 1;

        for f=1:size(Xtest,2)
           pred_feats(x,f) = normpdf(Xtest(x,f), means(f,1), sqrt(vars(f,1)))/... %sqrt(vars(f,1)).*randn(1,1) + means(f,1);
           normpdf(Xtest(x,f), means(f,2), sqrt(vars(f,2)));% sqrt(vars(f,2)).*randn(1,1) + means(f,2);
        end
        preds(x,1) = dot(weights,pred_feats(x,:));
    end
    fps = []; tps = [];
    Tmax = max(preds); Tmin = min(preds);
    K = 50000;
    for T =Tmin:(Tmax-Tmin)/K:Tmax
        predsT = preds;
        predsT(predsT>=T)=1000;
        predsT(predsT<T)=-1000;
        predsT=predsT/1000;

        % ROC plot
        fps = [fps sum(predsT==1 & ytest==-1)/sum(ytest==-1)];
        tps = [tps sum(predsT==1 & ytest==1)/sum(ytest==1)];
    end
    figure;scatter(fps, tps); hold on; xlabel('False Positive Rate'); ylabel('True Positive Rate');
    scatter(0:.001:1, 0:.001:1);title(['Rating ID: ' num2str(rating)]);hold off;
end