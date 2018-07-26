function rate = ratingImage(image,names,wPtr, rect,anchor0, anchor100, var) 

% created by Simone 
% modified on the 28.04.2015 by Vanessa
% last modified on Nov 2016 

% Load image and create texture
%[~, imageName, imageExt] = fileparts(image);
%image = imread(strcat(imageName, imageExt));

imageName = names;
imageTexture = Screen('MakeTexture', wPtr, image);

% Define the image rect and the destination rect
imageRect = [0 0 RectWidth(rect) (RectHeight(rect) - 100)];
imageDestRect = CenterRect([0 0 var.ROIdim var.ROIdim], imageRect); %%%%%%%%%%%%%%%%% modified by Me

% Query the frame duration
ifi = Screen('GetFlipInterval', wPtr);

% Sync us and get a time stamp
vbl = Screen('Flip', wPtr);
waitframes = 1;

% VAS parameters
verticalPosLine = RectHeight(rect) - 200;
distanceFromBorderLine = 150;
horizontalCenterOfTheLine = RectWidth(rect)/2;
cursorPosition = horizontalCenterOfTheLine ;

% Maximum priority level
topPriorityLevel = MaxPriority(wPtr);
Priority(topPriorityLevel);

% The avaliable keys to press (adapted for MRI system)
escapeKey = [var.confKey1, var.confKey2];%||%  former 'space' that has been adapted to the middle button for the MRI boxes
leftKey = var.leftKey; % former 'LeftArrow'
rightKey = var.rightKey; % former 'RightArrow'

% Set the amount we want our square to move on each button press
pixelsPerPress = 10;

% This is the cue which determines whether we exit the demo
exitDemo = false;

% Loop the animation until the escape key is pressed
while exitDemo == false
    
    % Check the keyboard to see if a button has been pressed
    [~,~, keyCode] = KbCheck(-3,2);
    
    respKey = find(keyCode); % Taken from Jeff

    
    % Depending on the button press, either move ths position of the square
    % or exit the demo
    if ismember(respKey, escapeKey)%keyCode(escapeKey)
        exitDemo = true;
    elseif ismember (respKey, leftKey) %keyCode(leftKey)
        cursorPosition = cursorPosition - pixelsPerPress;
    elseif ismember (respKey, rightKey)%keyCode(rightKey)
        cursorPosition = cursorPosition + pixelsPerPress;
    end
    
    % We set bounds to make sure our square doesn't go completely off of
    % the screen
    if cursorPosition < distanceFromBorderLine
        cursorPosition = distanceFromBorderLine;
    elseif cursorPosition > RectWidth(rect) - distanceFromBorderLine
        cursorPosition = RectWidth(rect) - distanceFromBorderLine;
    end
    
    % Draw the image and the VAS.
    draw;
end

% Save the rate of the image
rate = (cursorPosition - 50) / ((RectWidth(rect) - 100) / 100);

% Close the texture
Screen('Close', imageTexture);

% Function to draw the VAS and the image on screen
    function draw()
        
        % Show image
        Screen('DrawTexture', wPtr, imageTexture, [], imageDestRect);
        
        % Draw the line
        Screen('DrawLine', wPtr, [250 250 250], distanceFromBorderLine, verticalPosLine, RectWidth(rect) - distanceFromBorderLine, verticalPosLine, 2);
        
        % Print VAS' text
        Screen('TextFont', wPtr, 'Arial');
        Screen('TextStyle', wPtr, 1);
        Screen('TextSize', wPtr, 20); 
        Screen('DrawText', wPtr, '', distanceFromBorderLine, verticalPosLine + 15);
        Screen('DrawText', wPtr, anchor0, distanceFromBorderLine - 30, verticalPosLine + 40); %%%%% modified by Eva
        Screen('DrawText', wPtr, '', RectWidth(rect) - distanceFromBorderLine - 12, verticalPosLine + 15);
        Screen('DrawText', wPtr, anchor100, RectWidth(rect) - distanceFromBorderLine - 90, verticalPosLine + 40);%%%%% modified by Eva
        
        % Print confirmation message
        Screen('TextFont', wPtr, 'Arial');
        Screen('TextSize', wPtr, 20);
        Screen('TextStyle', wPtr, 1);
        DrawFormattedText(wPtr, 'press one of the center keys to confirm', 'center', RectHeight(rect) - 60);
        
        % Draw the cursor with the new position
        Screen('DrawLine', wPtr, [200 200 200], cursorPosition, verticalPosLine - 20, cursorPosition, verticalPosLine + 20, 5); %%% modified by Eva: the color is adapated to a grey backgroud
        
        % Flip to the screen
        vbl  = Screen('Flip', wPtr, vbl + (waitframes - 0.5) * ifi);
        
    end

end