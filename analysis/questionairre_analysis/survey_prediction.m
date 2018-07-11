% Using survey responses to predict ratings
% Iman Wahle
% July 11, 2018


%% Load and Process Data
data = load('survey_data.mat');
feats = zeros(1545,6);

% age
for i=1:length(data.age)
    if data.age(i,1)==0 continue; end
    feats(data.age(i,1),1) = data.age(i,2);
end
% art_degree
for i=1:length(data.art_degree)
    if data.art_degree(i,1)==0 continue; end
    feats(data.art_degree(i,1),2) = data.art_degree(i,2);
end
% degree
for i=1:length(data.degree)
    if data.degree(i,1)==0 continue; end
    feats(data.degree(i,1),3) = data.degree(i,2);
end
% gender
for i=1:length(data.gender)
    if data.gender(i,1)==0 continue; end
    feats(data.gender(i,1),4) = data.gender(i,2);
end
% museum
for i=1:length(data.museum)
    if data.museum(i,1)==0 continue; end
    feats(data.museum(i,1),5) = data.museum(i,2);
end
%race
for i=1:length(data.race)
    if data.race(i,1)==0 continue; end
    feats(data.race(i,1),6) = data.race(i,2);
end

ratings = load('ratings_list.mat');
ratings = ratings.X_list;
X = [ratings(:,2) zeros(length(ratings), 6)];
for i=1:length(ratings)
    X(i,2:7) = feats(ratings(i,1), :);
end
y = ratings(:,3);

%% Linear Regression Method

weights = X\y;

predlr = X*weights;

RMSE = sqrt(mean((y - predlr).^2));  
% RMSE in sample training on everything = 1.0268 :(

%% Neural Network Method

net = patternnet([150 50], 'trainscg', 'mse');
[net,tr] = train(net, X', y');
nntraintool
% [150 50] MSE .891
prednn = predict(net, X');
RMSE = sqrt(mean((y - prednn).^2));  


%% Clustering Method



%% Considered Features Analysis