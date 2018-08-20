% Does our prediction accuracy vary with rating response time
% Iman Wahle
% August 17 2018

%% Load high-level feats
conc = load('../feature_task_analysis/concreteness_data.mat');
conc = conc.classifications;
dyna = load('../feature_task_analysis/dynamic_data.mat');
dyna = dyna.classifications;
temp = load('../feature_task_analysis/temperature_data.mat');
temp = temp.classifications;
vale = load('../feature_task_analysis/valence_data.mat');
vale = vale.classifications;

% load li-features 
glbl = load('../data/features_global_all.mat');
lcl = load('../data/features_local_all.mat');
li_feats = [glbl.image_features lcl.image_features(:,13:39)];

% load rating data
trial_data = load('trial_data.mat');
ratings = trial_data.classifications;
rts = trial_data.response_times;

% Feature ID    Rating ID
% 6             5
% 7             6
% 10            3
% 11            2
% 12            1
% no data       4
% 9             7

 mapping = [12 11 10 nan 6 7 8];


% concv = []; dynav = []; tempv = []; valev = [];

li_feats = li_feats(:, [1:6 8:end]);
li_feats(isnan(li_feats))=0;

li_featsv = []; ratingsv = []; rtsv = [];
for rID = [1:3 5:7]
    li_featsv = [li_featsv ; li_feats];
    ratingsv = [ratingsv ; ratings(:,rID)];
    rtsv = [rtsv ; rts(:,rID)];
end
        
%% Now go through by time bins

start_times = [0:1:4]*1000000;

lm = fitlm(li_featsv, ratingsv, 'linear');

for ts = start_times
    te = ts +  1000000;
    li_featsvt = li_featsv(rtsv >= ts & rtsv < te,:);
    ratingsvt = ratingsv(rtsv >=ts & rtsv < te);
    pred = predict(lm, li_featsvt);
    R = corrcoef(pred, ratingsvt);
%     p = size(li_featsvt,2);
%     n = size(li_featsvt,1);
%     adjRsqrd = (R(1,2))^2 - (1-(R(1,2))^2)*(p/(n-p-1));
    fprintf(['Times: ' num2str(ts) ' to ' num2str(te) ': ' num2str(R(1,2)) '\n']);
end

%% Now do time analysis independently per person for li features

lm = fitlm(li_featsv, ratingsv, 'linear');
%%
for rID = [1:3 5:7]
    fprintf(['Rating ID: ' num2str(rID) '\n']);
    ratingsv = ratings(:,rID);
    rtsv = rts(:,rID);
    
    for ts = start_times
        te = ts +  1000000;
        li_featsvt = li_featsv(rtsv >= ts & rtsv < te,:);
        ratingsvt = ratingsv(rtsv >=ts & rtsv < te);
        if length(ratingsvt)==0
            fprintf(['    Times: ' num2str(ts) ' to ' num2str(te) ': No Response Times in this Interval \n']);
        else
            %lm = fitlm(li_featsvt, ratingsvt, 'linear');
            pred = predict(lm, li_featsvt);
            R = corrcoef(pred, ratingsvt);
            fprintf(['    Times: ' num2str(ts) ' to ' num2str(te) ': ' num2str(R(1,2)) '\n']);
        end
    end
end

%% Now do time analysis independently per person for high level features
high_featsv = [];
for rID = [1:3 5:7]
    fprintf(['Rating ID: ' num2str(rID) '\n']);
    high_featsv = [conc(:,mapping(rID)) dyna(:,mapping(rID)) ... 
                    temp(:,mapping(rID)) vale(:,mapping(rID))];
    ratingsv = ratings(:,rID);
    lm = fitlm(high_featsv, ratingsv, 'linear')
end
%%
for rID = [1:3 5:7]
    fprintf(['Rating ID: ' num2str(rID) '\n']);
    ratingsv = ratings(:,rID);
    rtsv = rts(:,rID);
    high_feats = [conc(:,mapping(rID)) dyna(:,mapping(rID)) ... 
                    temp(:,mapping(rID)) vale(:,mapping(rID))];
    
    for ts = start_times
        te = ts +  1000000;
        high_featst = high_feats(rtsv >= ts & rtsv < te, :);
        ratingsvt = ratingsv(rtsv >=ts & rtsv < te);
        if length(ratingsvt)==0
            fprintf(['    Times: ' num2str(ts) ' to ' num2str(te) ': No Response Times in this Interval \n']);
        else
            pred = predict(lm, high_featst);
            R = corrcoef(pred, ratingsvt);
            %lm = fitlm(high_featst, ratingsvt, 'linear');
            fprintf(['    Times: ' num2str(ts) ' to ' num2str(te) ': ' num2str(R(1,2)) '\n']);
        end
    end
end