% Using survey responses to predict ratings
% Iman Wahle
% July 11, 2018


%% Load and Process Data
data = load('survey_data.mat');
feats = zeros(1545,6);

% age
for i=1:length(data.age)
    if data.age(i,1)==0 
        continue; 
    end
    feats(data.age(i,1),1) = data.age(i,2);
end
% art_degree
for i=1:length(data.art_degree)
    if data.art_degree(i,1)==0 
        continue; 
    end
    feats(data.art_degree(i,1),2) = data.art_degree(i,2);
end
% degree
for i=1:length(data.degree)
    if data.degree(i,1)==0 
        continue; 
    end
    feats(data.degree(i,1),3) = data.degree(i,2);
end
% gender
for i=1:length(data.gender)
    if data.gender(i,1)==0 
        continue; 
    end
    feats(data.gender(i,1),4) = data.gender(i,2);
end
% museum
for i=1:length(data.museum)
    if data.museum(i,1)==0 
        continue; 
    end
    feats(data.museum(i,1),5) = data.museum(i,2);
end
%race
for i=1:length(data.race)
    if data.race(i,1)==0 
        continue; 
    end
    feats(data.race(i,1),6) = data.race(i,2);
end

ratings = load('ratings_list.mat');
ratings = ratings.X_list;

X = [ratings(:,1) zeros(length(ratings), 6)];

for i=1:length(ratings)
    X(i,2:7) = feats(ratings(i,1), :);
end
y = ratings(:,3);

%% Linear Regression Method

weights = X\y;

predlr = X*weights;

RMSE = sqrt(mean((y - predlr).^2));
disp(RMSE);
% RMSE in sample training on everything = 1.0267 :(

%% Neural Network Method

net = patternnet([150 50], 'trainscg', 'mse');
[net,~] = train(net, X', y');
nntraintool
% [150 50] MSE .883
prednn = net(X');
RMSE = sqrt(mean((y - prednn').^2));  
disp(RMSE);
% RMSE = .9418

%% Clustering Method
% Cluster user features to determine if different users rely
% on different image features in preference formation
% Iman Wahle
% July 10, 2018

% Constants
NUM_CLUST = 3;
NUM_PC = 3;

% PCA reduction
coeff = pca(X);
red = X * coeff(:, 1:NUM_PC);

% Cluster data
%c = clusterdata(red,'linkage', 'ward', 'maxclust', NUM_CLUST);
% Y = pdist(red);
% Z = linkage(Y, 'ward');
% figure;dendrogram(Z);

% Plot first three dimensions
figure;scatter3(red(:,1),red(:,2),red(:,3),50,y,'filled');
xlabel('f1');ylabel('f2');zlabel('f3');

%% Mean Rating by User Predicted by Questionairre Responses - Linreg

% Calculate mean rating by user
m_usr = zeros(1545,2);
for r=1:length(ratings)
    m_usr(ratings(r,1),1) = m_usr(ratings(r,1),1) + ratings(r,3);
    m_usr(ratings(r,1),2) = m_usr(ratings(r,1),2) +1;
end
for r = 1:length(m_usr)
    m_usr(r,1)=m_usr(r,1)/m_usr(r,2);
end
m_usr = m_usr(:,1);
for m=1:length(m_usr)
    if isnan(m_usr(m,:))
        m_usr(m,:)=0;
    end
end
weights = feats\m_usr;
pred = feats*weights;
RMSE = sqrt(mean((m_usr - pred).^2)); 
disp(RMSE);
% RMSE = 0.5018


%% Mean Rating - Neural Network

net = patternnet([150 50], 'trainscg', 'mse');
[net,~] = train(net, feats', m_usr');
nntraintool
% [150 50] MSE .210
prednn = net(feats');
RMSE = sqrt(mean((m_usr - prednn').^2));  
disp(RMSE);
% RMSE = .4867


%% Considered Features Analysis

rep_feats = data.features;
rep_feat_mat = zeros(1545,13);

% will set feature to 1 if reported to be considered by user, 0 otherwise
for r=1:length(rep_feats)
    if rep_feats(r,1)==0 || rep_feats(r,2)==0
        continue; 
    end
    rep_feat_mat(rep_feats(r,1),rep_feats(r,2)) = 1;
end

XX = [ratings(:,1) zeros(length(ratings),13)];
for i=1:length(ratings)
    XX(i,2:14) = rep_feat_mat(ratings(i,1), :);
end
y = ratings(:,3);

weights = XX\y;
predlr = XX*weights;

RMSE = sqrt(mean((y - predlr).^2));
disp(RMSE);
% RMSE in sample = 1.0998

% neural net on considered features
net = patternnet([150 50], 'trainscg', 'mse');
[net,tr] = train(net, X', y');
nntraintool
% [150 50] MSE .887
prednn = net(X');
RMSE = sqrt(mean((y - prednn').^2));
disp(RMSE);
% RMSE = .9484


%% Ratings as a function of Questionairre Responses

% First we will look at (user,image) ratings as a function of what features
% were considered by that user
rep_feats = data.features;
rep_feat_mat = zeros(1545,13);

% will set feature to 1 if reported to be considered by user, 0 otherwise
for r=1:length(rep_feats)
    if rep_feats(r,1)==0 || rep_feats(r,2)==0
        continue; 
    end
    rep_feat_mat(rep_feats(r,1),rep_feats(r,2)) = 1;
end

xy = zeros(length(ratings)*13,2);
cnt=1;
for i=1:length(ratings)
    for j=1:13
        if rep_feat_mat(ratings(i,1),j)==1
            xy(cnt,:) =[j ratings(i,3)]; % storing feature and rating
            cnt=cnt+1;
        end
    end
end

figure;scatter(xy(:,1),xy(:,2));
xlabel('Considered Feature');ylabel('Rating');

feat_by_rating = zeros(13,4);
for i = 1:length(xy)
    if xy(i,1)==0
        continue;
    end
    feat_by_rating(xy(i,1),xy(i,2)+1) = feat_by_rating(xy(i,1),xy(i,2)+1)+1;
end

% normalizing by number of given ratings
num_zero = sum(xy(:,2)==0 & xy(:,1)~=0);
num_one = sum(xy(:,2)==1);
num_two = sum(xy(:,2)==2);
num_three = sum(xy(:,2)==3);
feat_by_rating(:,1) = feat_by_rating(:,1)/num_zero;
feat_by_rating(:,2) = feat_by_rating(:,2)/num_one;
feat_by_rating(:,3) = feat_by_rating(:,3)/num_two;
feat_by_rating(:,4) = feat_by_rating(:,4)/num_three;

bar3(feat_by_rating);
ylabel('Features Considered');xlabel('Rating Given');zlabel('Frequency');
% tentative conclusion: refined feature choices lead to higher ratings

%% Does art degree, age, and/or general degree determine which features are used?
% (this would support previous conclusion)

feat_by_deg = zeros(13, 2);

% clean up art degree data
ad = data.art_degree;
ad(ad(:,1)==0,:) = [];
while length(ad)>1545
    for i=1:1545
        if(ad(i,1)~=i)
            ad(i,:)=[];
            break;
        end
    end
end


for i=1:length(ad)
    for j=1:13
        if rep_feat_mat(i, j)==1
            feat_by_deg(j,ad(i,2)) = feat_by_deg(j,ad(i,2)) + 1;
        end
    end
end

% normalizing by number of people who have or don't have art degree
feat_by_deg(:,1) = feat_by_deg(:,1)/sum(ad(:,2)==1);
feat_by_deg(:,2) = feat_by_deg(:,2)/sum(ad(:,2)==2);

figure;bar3(feat_by_deg);
ylabel('Features Considered');xlabel('Art Degree (1=yes, 2 = no)');

%% Same as above but with age instead of art degree

% clean up age data

age = zeros(1545,1);
for i =1:length(data.age)
    age(data.age(i,1),1) = data.age(i,2);
end

feat_by_age = zeros(13, 4);

for i=1:length(age)
    if age(i,1)==0
        continue;
    end
    for j=1:13
        if rep_feat_mat(i, j)==1
            feat_by_age(j,age(i,1)) = feat_by_age(j,age(i,1)) + 1;
        end
    end
end

% normalizing by number of people who have or don't have art degree
feat_by_age(:,1) = feat_by_age(:,1)/sum(age(:,1)==1);
feat_by_age(:,2) = feat_by_age(:,2)/sum(age(:,1)==2);
feat_by_age(:,3) = feat_by_age(:,3)/sum(age(:,1)==3);
feat_by_age(:,4) = feat_by_age(:,4)/sum(age(:,1)==4);


figure;bar3(feat_by_age);
ylabel('Features Considered');xlabel('Age');

%% Same as before but with general degree


% clean up degree data

deg = zeros(1545,1);
for i =1:length(data.degree)
    deg(data.degree(i,1),1) = data.degree(i,2);
end

feat_by_deg = zeros(13, 5);

for i=1:length(deg)
    if deg(i,1)==0
        continue;
    end
    for j=1:13
        if rep_feat_mat(i, j)==1
            feat_by_deg(j,deg(i,1)) = feat_by_deg(j,deg(i,1)) + 1;
        end
    end
end

% normalizing by number of people who have or don't have art degree
feat_by_deg(:,1) = feat_by_deg(:,1)/sum(deg(:,1)==1);
feat_by_deg(:,2) = feat_by_deg(:,2)/sum(deg(:,1)==2);
feat_by_deg(:,3) = feat_by_deg(:,3)/sum(deg(:,1)==3);
feat_by_deg(:,4) = feat_by_deg(:,4)/sum(deg(:,1)==4);
feat_by_deg(:,5) = feat_by_deg(:,5)/sum(deg(:,1)==5);

figure;bar3(feat_by_deg);
ylabel('Features Considered');xlabel('Degree');


%% Do people with different degrees tend to rate differently?

ratings_by_ad = zeros(4,2);

% clean up art degree data
ad = data.art_degree;
ad(ad(:,1)==0,:) = [];
while length(ad)>1545
    for i=1:1545
        if(ad(i,1)~=i)
            ad(i,:)=[];
            break;
        end
    end
end

for i=1:length(ratings)
    ratings_by_ad(ratings(i,3)+1, ad(ratings(i,1),2)) = ratings_by_ad(ratings(i,3)+1, ad(ratings(i,1),2)) +1;
end

ratings_by_ad(:,1) = ratings_by_ad(:,1)/sum(ad(:,2)==1);
ratings_by_ad(:,2) = ratings_by_ad(:,2)/sum(ad(:,2)==2);

figure;bar3(ratings_by_ad);
xlabel('Art Degree (1=yes, 2 = no)');ylabel('Rating');
    
