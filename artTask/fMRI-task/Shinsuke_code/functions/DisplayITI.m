
function time = DisplayITI (var,wPtr)

% Last modifed on 26 Jan 2015 by Eva

startT = GetSecs();

DrawnBaseScreen(var,wPtr);

%%%% PLOT fixation cross in the middle
Screen('TextFont',wPtr, 'Arial');
Screen('TextSize', wPtr, 36);
Screen('TextColor',wPtr, [250 250 250]);
DrawFormattedText(wPtr,'+','center','center');

Screen ('Flip', wPtr);

timer = GetSecs()-var.time_MRI;
while timer < var.ref_end
    timer = GetSecs()-var.time_MRI;
end

time = GetSecs()-startT;

end