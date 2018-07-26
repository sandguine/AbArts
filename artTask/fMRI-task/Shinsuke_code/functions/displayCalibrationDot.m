function displayCalibrationDot(var,wPtr,x,y)
%last modified on January 29 2016 by Eva

baseRectBig = [0 0 var.dotDim var.dotDim];% Make a base Rect
baseRectMediumBig = [0 0 (var.dotDim/1.5) (var.dotDim/1.5)];% Make a base Rect
baseRectMediumSmall = [0 0 (var.dotDim/3) (var.dotDim/3)];
baseRectSmall = [0 0 (var.dotDim/6) (var.dotDim/6)];

positionBig = CenterRectOnPointd(baseRectBig, x, y);
positionMediumBig = CenterRectOnPointd(baseRectMediumBig, x, y);
positionMediumSmall = CenterRectOnPointd(baseRectMediumSmall, x, y);
positionSmall = CenterRectOnPointd(baseRectSmall, x, y);

Screen('FillOval', wPtr, [250 250 250], positionBig);
Screen('FillOval', wPtr, [0 0 0], positionMediumBig);
Screen('FillOval', wPtr, [250 250 250], positionMediumSmall);
Screen('FillOval', wPtr, [250 0 0], positionSmall);

Screen('Flip', wPtr);