function [a] = randJietter (timeVector, nitem)

% last modified on jan 1 2017

% this function is to be sure to have the same length of each block even if
% the jitter time is randomized
% input 1: number of item for block e.g., 60
% input 2: vector with the time that will be selected in s e.g., [4.5:8,4:8]
% output: vector with random jitter on average are no longer than than the
% mean + 0.500 s


goal = nanmean(timeVector) + 0.2;
a = nan(nitem,1);


while 1
    
    for i = 1:60
        a(i) = randsample(timeVector,1);
    end
    
    average = nanmean(a);
    
    if average < goal
        break
    end
    
end