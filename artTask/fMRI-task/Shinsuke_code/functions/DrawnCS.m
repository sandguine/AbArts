function [time, Button, RT, ACC] = DrawnCS(var,wPtr)
%last modified nov 2016


startT = GetSecs();
%initilize variables
RT = NaN; 
Button = 'NaN';
ACC = NaN;

% Determine the position of the CS
baseRect = [0 0 var.ROIdim var.ROIdim];% Make a base Rect

switch var.CSposition % we leave this for the moment even though we will ask participants to press in this version of the task
    case 1
        position = CenterRectOnPointd(baseRect, var.xCenter, var.CSupper);
        response = KbName('1!'); % press 1 when CS is up
    case 2
        position = CenterRectOnPointd(baseRect, var.xCenter, var.CSlower);
        response = KbName('2@'); % press 2 when CS is down
end

% Determine the image used as CS
switch var.CSname
    
    case 31 %outcome A (3) position left (1) see loadRandList in case of doubts)
        CS = var.CSAL_image; 
    case 32 % outcome A (3) position right (2) see loadRandList in case of doubts
        CS = var.CSAR_image;
    case 41 % outcome B (4) position left (1) see loadRandList in case of doubts
        CS = var.CSBL_image;
    case 42 % outcome B (4) position right (2) see loadRandList in case of doubts
        CS = var.CSBR_image;
    case 50 % no outcome (5) no position (0) see loadRandList in case of doubts
        CS = var.CSm_image;
        
end


CS = Screen('MakeTexture',wPtr, CS);
Screen('DrawTexture', wPtr, CS,[], position);
Screen('Close', CS);
DrawnBaseScreen(var,wPtr);
Screen('Flip',wPtr);


slideOnT = GetSecs();

timer = GetSecs()-var.time_MRI;
FlushEvents(); % clean the keyboard memory
pressed = 0;

while timer < var.ref_end
    timer = GetSecs()-var.time_MRI;
    
    [keyPressed, ~, keyCode]= KbCheck(-1);
    
    if (keyPressed == 1) && pressed ==0 % we register only the first button that is pressed
        pressed = pressed+1;
        Button = KbName(keyCode);
        RT = GetSecs - slideOnT;
        if (keyPressed == 1) && (keyCode(response) == 1) % Register the accuracy of the response
            ACC = 1;
        else 
            ACC = 0;
        end
    end
    
end
time = GetSecs()-startT;

end
