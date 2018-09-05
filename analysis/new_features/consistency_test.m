% See how small a sample size we can use for consistency test
% Iman Wahle
% August 27 2018

%% Load
trial_data = load('trial_data.mat');
ratings = trial_data.classifications;

%%
for rID=[1:3 5:7]
    imgs = [1:99 205:304 418:517 622:721];
    lm = fitlm(feats(imgs,5:end), ratings(imgs,rID),'linear');
    disp(lm.Rsquared.Adjusted);
end