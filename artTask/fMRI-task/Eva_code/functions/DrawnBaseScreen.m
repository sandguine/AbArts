
function DrawnBaseScreen (var,wPtr)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function defines the baseline screen for the experiments, display
% parameter can be changed in the main experiment scripts where the var
% structure is defined. The function only drwan the screen without
% diplaying it, a Screen('Flip',wPtr) is necessary after calling this
% function.
%
% Last modifed on 26 Jan 2016 

%%%% PLOT vertical ROIS
baseRect = [0 0 var.ROIdim var.ROIdim];% Make a base Rect

numSqaures = length(var.squareXpos);
allRectsV = nan(4, 2);% Make our rectangle coordinates
for i = 1:numSqaures
    allRectsV(:, i) = CenterRectOnPointd(baseRect, var.squareXpos(i), var.yCenter);
end


Screen('FrameRect', wPtr, var.allColors, allRectsV); 
numSqaures = length(var.squareYpos);
allRectsH = nan(4, 2);
for i = 1:numSqaures
    allRectsH(:, i) = CenterRectOnPointd(baseRect, var.xCenter, var.squareYpos(i));
end
Screen('FrameRect', wPtr, var.allColors, allRectsH);


% if var.session ==3 % activate this if you want to use strategies to prevent extinction
%     
%     base_mask= [0 0 var.ROIdim*1.3 var.ROIdim*1.3];% Make a base Rect
%     allMask = nan(4, 2);% Make our rectangle coordinates
%     for i = 1:numSqaures
%         allMask(:, i) = CenterRectOnPointd(base_mask, var.squareXpos(i), var.yCenter);
%     end
%     
%   Screen('FillRect', wPtr, [0 0; 0 0; 0 0], allMask);  %
% end
% 
% end