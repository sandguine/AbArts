function [ratingResult, imagesName] = rating(images,names,anchor0,anchor100, wPtr, rect, var)

% created by Simone
% last modified on 19 Jan 2016  

    % Randomize the image list
    randomIndex = randperm(length(images)); 
    images = images(randomIndex);
    names = names (randomIndex);
    % Initialize the rating results array
    resultArraysLength = length(images);
    ratingResult = zeros(1, resultArraysLength).';
    imagesName = cell(1, resultArraysLength).';
    
    for i = 1:length(images)
        ratingResult(i) = ratingImage(images{i},names, wPtr, rect,anchor0, anchor100, var);
        imagesName{i} = names{i};
        showCross(wPtr);
    end

end



function showCross(wPtr)

    cross = '+';
    Screen('TextStyle', wPtr, 1);
    Screen('TextSize', wPtr, 36);
    DrawFormattedText(wPtr, cross, 'center', 'center', [250 250 250]);
    Screen('Flip', wPtr);
    % Wait a random time between 1 and 2 secs.
    csPresentationTime = 1+rand(1,1);
    WaitSecs(csPresentationTime);
 
end