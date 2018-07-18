function [time, Button, RT, ACC] = ShowUS(wPtr,var,bfm)

% last modified on jan 2017
% added FlushEvents(); % clean the keyboard memory
% video displayed manually (compatible with window 64 bits)
% works with loadMoviesByFrame

% session 3  (var.session3) is administered under extinction with a strategy to prevent
% extinction adapted from Pr?vost (2012 JoN), in which the reward
% delivery place is hidden behind to black patches and participants are
% asked to do their predictions based on what they learned and that
% they will received the reward delivered behind the patches at the end
% of the session.
% prepare an initialize variables


if var.session ==3 % activate this if you want to use strategies to prevent extinction
    
    numSqaures = length(var.squareXpos);
    base_mask= [0 0 var.ROIdim*1.3 var.ROIdim*1.3];% Make a base Rect
    allMask = nan(4, 2);% Make our rectangle coordinates
    for i = 1:numSqaures
        allMask(:, i) = CenterRectOnPointd(base_mask, var.squareXpos(i), var.yCenter);
    end
    
end


RT = NaN;
Button = 'NaN';
ACC = NaN;

% Determine the position of the US
baseRect = [0 0 var.ROIdim var.ROIdim];% Make a base Rect
startT = GetSecs();

switch var.US_side % establish which side the reward delivery will be displayed
    
    case 1 % show US to the left
        positionVideo = CenterRectOnPointd(baseRect, var.USleft, var.yCenter);
        positionPicture = CenterRectOnPointd(baseRect, var.USright,var.yCenter);
        response = var.leftKey; % press 1 when US is left
        
    case 2 % show US to the right
        positionVideo = CenterRectOnPointd(baseRect, var.USright,var.yCenter);
        positionPicture = CenterRectOnPointd(baseRect, var.USleft, var.yCenter);
        response = var.rightKey; % press 7 when US is right
        
    case 0 % show to snapshots but no video
        positionL = CenterRectOnPointd(baseRect, var.USleft, var.yCenter);
        positionR = CenterRectOnPointd(baseRect, var.USright,var.yCenter);
        pressed = 0;
        timer = GetSecs()-var.time_MRI;
        while timer < var.ref_end
            
            timer = GetSecs()-var.time_MRI;
            
            if var.session == 1 || var.session == 2
                US_background1 = Screen('MakeTexture',wPtr, var.US_background);
                US_background2 = Screen('MakeTexture',wPtr, var.US_background);
                Screen('DrawTexture', wPtr, US_background1 ,[], positionL);
                Screen('DrawTexture', wPtr, US_background2 ,[], positionR);
                Screen('Close', US_background1);
                Screen('Close', US_background2);
                DrawnBaseScreen(var,wPtr);
                Screen('Flip', wPtr);% Update display
                
            elseif var.session == 3 % if we are in the test session the reward delivery location will be covered
                DrawnBaseScreen(var,wPtr);
                Screen('FillRect', wPtr, [50 50; 50 50; 50 50], allMask);  %
                Screen('Flip', wPtr);% Update display
            end
            % record reaction times and compute ACC
            slideOnT = GetSecs();
            [keyPressed, ~, keyCode]= KbCheck(-3,2);
            
            if (keyPressed == 1) && pressed ==0 % if a botton is pressed --> false alarm (we record only the first press)
                pressed = pressed+1;
                Button = KbName(keyCode);
                RT = GetSecs - slideOnT;
                ACC = 0;
            elseif keyPressed == 0 && pressed ==0 % if no button is pressed --> correct rejection
                ACC = 1;
            end
            
            time = GetSecs()-startT;
        end
        return
end


switch var.US_identity % establish which reward will be displayed
    
    case 3
        movieName  = char(var.movie_1(8:end-4)); % display outcome 1 movie
        
    case 4
        movieName  = char(var.movie_2(8:end-4)); % display outcome 2 movie
        
    case 0
        %this should never happen because the function return before if var
        %moviefile = [pwd filesep var.movie_1]; % display outcome 1 movie
        disp ('attention something is wrong')
        
end


fprintf('\t displaying movie...');
tic

% initialize variables
bfm.(movieName).frameTime = (0:(bfm.(movieName).nFrames-1))/bfm.(movieName).frameRate;
actualFrameTime  = zeros(1,bfm.(movieName).nFrames);
FlushEvents(); % clean the keyboard memory
iFrame = 0;
pressed = 0;
timer = GetSecs()-var.time_MRI;
slideOnT = GetSecs();

while timer < var.ref_end% Playback loop: Runs until end of movie or 3 s have passed:
    
    timer = GetSecs()-var.time_MRI;
    iFrame = iFrame + 1;
    
    if iFrame > bfm.(movieName).nFrames
        break;% We're done, break out of loop:
    end
    
   
        % display first frame to get
        if iFrame == 1
            
            tex    = Screen('MakeTexture', wPtr, bfm.(movieName).mov(iFrame).cdata);
            Screen('DrawTexture', wPtr, tex, [], positionVideo); % Draw the new texture immediately to screen
            DrawnBaseScreen(var,wPtr);
            US_background = Screen('MakeTexture',wPtr, var.US_background); % draw the picture on the opposite side of the video
            Screen('DrawTexture', wPtr, US_background ,[], positionPicture);
            if var.session ==3
                Screen('FillRect', wPtr, [50 50; 50 50; 50 50], allMask);  %
            end
            
            [~,actualFrameTime(iFrame)]=Screen('Flip',wPtr,0);
            Screen('Close', US_background);
            Screen('Close', tex);% Release texture:
            
            [keyPressed, ~, keyCode]= KbCheck(-3,2);
            if (keyPressed == 1) && pressed ==0 % we register only the first button that is pressed
                pressed = pressed+1;
                Button = KbName(keyCode);
                RT = GetSecs - slideOnT;
                respKey = find(keyCode); % Taken from Jeff
                
                if (keyPressed == 1) && ismember(respKey, response) %(keyCode(response) == 1) % Register the accuracy of the response
                    ACC = 1;
                else
                    ACC = 0;
                end
                
            elseif pressed ==0 % if no response
                ACC = 0;
            end
            
        end
        
        
        tex    = Screen('MakeTexture', wPtr, bfm.(movieName).mov(iFrame).cdata);
        Screen('DrawTexture', wPtr, tex, [], positionVideo); % Draw the new texture immediately to screen
        DrawnBaseScreen(var,wPtr);
        US_background = Screen('MakeTexture',wPtr, var.US_background); % draw the picture on the opposite side of the video
        Screen('DrawTexture', wPtr, US_background ,[], positionPicture);
        if var.session ==3
            Screen('FillRect', wPtr, [50 50; 50 50; 50 50], allMask);  %
        end
        when = actualFrameTime(1) + bfm.(movieName).frameTime(iFrame);
        [~,actualFrameTime(iFrame)]= Screen('Flip', wPtr,when);% Update display
        Screen('Close', US_background);
        Screen('Close', tex);% Release texture:
       
 
    
    [keyPressed, ~, keyCode]= KbCheck(-3,2);
    if (keyPressed == 1) && pressed ==0 % we register only the first button that is pressed
        pressed = pressed+1;
        Button = KbName(keyCode);
        RT = GetSecs - slideOnT;
        respKey = find(keyCode); % Taken from Jeff
        
        if (keyPressed == 1) && ismember(respKey, response) %(keyCode(response) == 1) % Register the accuracy of the response
            ACC = 1;
        else
            ACC = 0;
        end
        
    elseif pressed ==0 % if no response
        ACC = 0;
    end
    
end

elapsed = toc;
fprintf('done in %.2fs\n',elapsed);

time = GetSecs()-startT;
