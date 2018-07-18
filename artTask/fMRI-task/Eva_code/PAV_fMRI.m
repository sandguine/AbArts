%__________________________________________________________________________
%--------------------------------------------------------------------------
%
% Outcome specific task (Task version 1)
% PTB 3.0.12 on matlab 2015b
%__________________________________________________________________________
%--------------------------------------------------------------------------

% modifications from pilot task

%- 1 only first block has a blocked list
%- 2 adjust buttons for fmri
%- 3 script compatible with Eyelink
%- 4 extra ratings after third session wait for the T2 to start (pressing
%    "space" to start)
%- 5 lateral ROI more far away: 0.10 and 0.90 (instead of 0.15 and 0.95)
% -6 manually displaying videos to avoid Java/Gstreamer on window (stimPC
% conntected to the eyelink PC on the scanner room)
% -7 added a reset of the black screen after calibration
%- 8 added an instruction screen for the calibration
%- 9 changed the name of behav file (only 2 zeros).

% Task: press 9 when US is left and 6 when US is right (left and right
% hand) central keys (7, 8) for the confirm.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT VARIABLES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
var.real = 0;
var.eyetrack = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PRELIMINARY STUFF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AssertOpenGL; % Check for Opengl compatibility, abort otherwise:
KbName('UnifyKeyNames');% Make sure keyboard mapping is the same on all supported operating systems (% Apple MacOS/X, MS-Windows and GNU/Linux)
KbCheck; WaitSecs(0.1); GetSecs; FlushEvents; % clean the keyboard memory% Do dummy calls to GetSecs, WaitSecs, KbCheck to make sure they are loaded and ready when we need them - without delays

whichScreen = max(Screen('Screens'));
maxPriorityLevel = MaxPriority(whichScreen);
Priority(maxPriorityLevel);

path(path, 'functions'); % add the function folder to the path just for this session

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% open PTS
PsychDefaultSetup(1);% Here we call some default settings for setting up PTB
screenNumber = max(Screen('Screens')); % check if there are one or two screens and use the second screen when if there is one
if var.real == 1
    [wPtr,rect] = Screen('OpenWindow',screenNumber, [0 0 0]);
else
    [wPtr,rect] = Screen('OpenWindow',screenNumber, [100 100 100], [20 20 500 500]);
end

data.screen = rect;
var.favoriteUS_1 = str2double (input('skittles:1, raisins:2, chocoRaisins:3, YoguRaisins:4, M&Ms:5, chocoCoco:6, chocoRise:7, chocoAlmond:8, or chocoDrop:9 ?\n  (1 2 3 4 5 6 7 8 or 9) ','s'));
var.favoriteUS_2 = str2double (input('pretzelStick:10, patatoStick:11, miniPretzel:12, Ritz:13, cracker:14, popcorn:15, cashew:16, chaddarCracker:17 or peanuts:18 ? \n(10 11 12 13 14 15 16 17 or 18) ','s'));
var.session      = str2double (input('session 1 2 3?', 's'));

[resultFile, participantID, resultName] = createResultFile(var.session);
data.SubDate= datestr(now, 24); % Use datestr to get the date in the format dd/mm/yyyy
data.SubHour= datestr(now, 13); % Use datestr to get the time in the format hh:mm:ss
save(resultFile,'data'); % We save immediately the session's informations


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create lists and variables

% list that need to be randomized
[CSname,CSposition,US_side,US_identity,CS_side_congr,CS_outcome_congr] = LoadRandList(var.session);

data.list.CSname = CSname; % we record how the list is randomized for a particular participant (redoundacy maybe helpful in case of crahses)
data.list.CSposition = CSposition;
data.list.US_side = US_side;
data.list.US_identity = US_identity;
data.list.CS_side_congr = CS_side_congr;
data.list.CS_out_congr = CS_outcome_congr;

save(resultFile, 'data', '-append');

% variables that do not have to be randomized
[USname_1, USname_2, var.USlabel_1, var.USlabel_2] = uploadUSmovies (var);
var.movie_1 = fullfile('videos',USname_1);
var.movie_2 = fullfile('videos',USname_2);
data.list.movie_1 = var.movie_1;
data.list.movie_2 = var.movie_2;
[bfm] = loadMoviesByFrame (var); 

[CSAL_image,CSAR_image,CSBL_image,CSBR_image,CSm_image,list] = counterBalanceCS(participantID); % counter balance the Pavlovian role of the CS images
var.CSAL_image = CSAL_image;
var.CSAR_image = CSAR_image;
var.CSBL_image = CSBL_image;
var.CSBR_image = CSBR_image;
var.CSm_image = CSm_image;
var.US_background = imread('background_US.jpg');
var.list.counterbalanceList = list;

% define keys of interests
var.leftKey   = [ KbName('9('), KbName('9') ];
var.rightKey  = [ KbName('6^'), KbName('6') ];
var.confKey1  = [ KbName('7&'), KbName('7') ];
var.confKey2  = [ KbName('8*'), KbName('8') ];
var.mycontrol = KbName('space');
var.pulseKeyCode = [KbName('5'), KbName('5%')];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Background settings and Screen depedent variables
[screenXpixels, screenYpixels] = Screen('WindowSize', wPtr);% Get the size of the on screen window
ROIlt = 0.10; %from the left and from the top co-ordinates for left and top ROI
ROIrb = 0.90; % from the left from the top co-cordinates for right and bottom ROI
cornerlt = 0.10;
cornerrb = 0.90;

var = GetPositions (ROIlt,ROIrb,cornerlt,cornerrb,screenXpixels,screenYpixels,var,rect);

var.ROIdim = RectHeight(rect)/8; % the pixel of the ROI are defined based on the screeen
var.dotDim = RectHeight(rect)/20; % pixels of the calibration dot
var.allColors = [150 150; 150 150; 150 150];% Set the colors of the ROI frames

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIALIZE EYELINK (EL) EYETRACKR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if var.eyetrack
    
    el=EyelinkInitDefaults(wPtr); % give to EL details about graphic enviroment
    
    dummymode = 0; % initialize connection to EL gaze tracker
    if ~EyelinkInit(dummymode, 1)
        fprintf('Eyelink Init aborted.\n');
        Eyelink('Shutdown');sca; % close all if it does not work
        return;
    end
    
    % Retrieve eye tracker version.
    [~, vs]=Eyelink('GetTrackerVersion');
    fprintf('Running experiment on a ''%s'' tracker.\n', vs);
    % make sure that we get gaze data from the Eyelink
    Eyelink('Command', 'link_sample_data = LEFT,RIGHT,GAZE,AREA'); 
    % open file to record data to
    edfFile = [resultName '.edf'];
    Eyelink('Openfile', edfFile);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALIBRATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if var.eyetrack
    
    showInstruction(wPtr,'instructions/calibrationStart.txt') % we want participant to evaluate the images after each block
    WaitSecs(0.4);
    while 1
        
        [down, secs, keycode] = KbCheck(-3,2);
        keyresp = find(keycode);
        if ismember (keyresp, [var.leftKey, var.rightKey, var.confKey1, var.confKey2, var.mycontrol])
            break
        end
        
    end
    
    % Calibrate the eye tracker
    EyelinkDoTrackerSetup(el);
    % do a final check of calibration using driftcorrection
    success = EyelinkDoDriftCorrection(el);
    if success~=1
         Eyelink('Shutdown');sca;
        disp('Eyelink calibration failed.');
        return;
    end
    
end

Screen('FillRect', wPtr, [0 0 0]); % reset blackground
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Instructions before the experiment starts
if var.session ==1
    
    showInstruction(wPtr,'instructions/trainingStart.txt')
    WaitSecs(0.4);
    KbWait(-3,2);
    training(var,wPtr,CSname,CSposition,US_side,US_identity,bfm);
 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EXPERIMENT STARTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% randomize jitter of CS and ITI so that the mean duration is similar for
% each participant
vjietter.CS = randJietter ([1.5:4.5,2:4], length(CSname));
vjietter.ITI = randJietter ([4.5:8,4:8], length(CSname));

%%%%%%%%%%%%%%%% Syncronize stimuli and EL with scanner Pulse %%%%%%%%%%%%%

showInstruction(wPtr,'instructions/wait.txt');
triggerscanner = 0;
WaitSecs(0.4);
while ~triggerscanner
    [down, secs, keycode, d] = KbCheck(-3,2);
    keyresp = find(keycode);
    if (down == 1)
        if ismember (keyresp, var.pulseKeyCode)
            triggerscanner = 1;
        end
    end
    WaitSecs(.01);
end

var.time_MRI = GetSecs(); % absolute reference of the experiment beginning
var.ref_end = 0;

if var.eyetrack
    Eyelink('StartRecording');
    Eyelink('Message', 'SYNCTIME');  % mark zero-plot time in data file
    Eyelink('Message', 'START EXPERIMENT'); % mark experiment start 
else
    data.timeStamp.absStart = java.lang.System.nanoTime/1000000000; % unixformat (if you are happy with that then remove the java timestampS
end

RestrictKeysForKbCheck([var.leftKey, var.rightKey, var.confKey1, var.confKey2, var.mycontrol]); %once the scanner is on we just check the task relevant botton to avoid any interference witht the 5

%%%%%%%%%%%%%%%% lead in screen for 2 s (is 2 s) %%%%%%%%%%%%%%%%%%%%%%%%%%
var.ref_end = var.ref_end + 2;
data.onsets.leadIn = GetSecs -var.time_MRI;
data.durations.leadIn = DisplayITI(var,wPtr);

for i = 1:length(CSname)% the loop controlling the experiment
    
    % eyelink start recording eye position for this trial
    if var.eyetrack
        Eyelink('Message', ['TRIALID' ' ' mat2str(i)]); % message is the trial number
    end
    
    % define variables for this trial and save their order since they are
    % randomized differently for each participant
    var.CSname = CSname(i);
    data.CSname(i,1) = var.CSname;
    
    var.US_identity = US_identity(i);
    data.US_identity(i,1) = var.US_identity;
    
    var.US_side = US_side(i);
    data.US_side(i,1) = var.US_side;
    
    var.CSposition = CSposition(i);
    data.CSposition(i,1) = var.CSposition;
    
    var.CS_side_congr =  CS_side_congr(i);
    data.CS_side_congr (i,1) = CS_side_congr(i);
    
    var.CS_outcome_congr =  CS_outcome_congr(i);
    data.CS_outcome_congr (i,1) = CS_outcome_congr(i);
    
    %%%%%%%%%%%%%%% Display CS JItter between 1.5 to 4.5  %%%%%%%%%%%%%%%%%
    tjietter = vjietter.CS(i);
    var.ref_end = var.ref_end + tjietter;
    data.onsets.CS(i,1) = GetSecs -var.time_MRI;
    
    if var.eyetrack
        Eyelink('Message', 'TTL=1');% time stamped message (TTL numeric code to use Julien functions)
    else
        data.timeStamp.CS(i,1) = java.lang.System.nanoTime/1000000000; % get timestamp unixformat
    end
    
    [time, Button, RT, ACC] = DrawnCS(var,wPtr);
    data.durations.CS(i,1) = time;
    data.behavior.CSbutton{i,:} = Button;
    data.behavior.CSRT (i,1) = RT;
    data.behavior.CSACC(i,1) = ACC;
    
    %%%%%%%%%%%%%%% Display Anticipantion screens 3 s%%%%%%%%%%%%%%%%%%%%%%
    var.ref_end = var.ref_end + 3;
    data.onsets.anticipation(i,1) = GetSecs - var.time_MRI;
    
    if var.eyetrack
        Eyelink('Message', 'TTL=2');
    else
        data.timeStamp.anticipation(i,1) = java.lang.System.nanoTime/1000000000;% unixformat
    end
    
    data.durations.anticipation(i,1) = AnticipationScreen(var,wPtr);
    
    %%%%%%%%%%%%%%%%%%% Display US for 3s %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    var.ref_end = var.ref_end + 3; % attention here there is always a drift of going from 10 to 90 ms
    data.onsets.US(i,1) = GetSecs -var.time_MRI;
    
    if var.eyetrack
        Eyelink('Message', 'TTL=3');
    else
        data.timeStamp.US(i,1) = java.lang.System.nanoTime/1000000000; %unix format
    end
    
    [time, Button, RT, ACC]= ShowUS(wPtr,var, bfm);
    data.durations.US(i,1) = time;
    data.behavior.USbutton{i,:} = Button;
    data.behavior.USRT (i,1) = RT;
    data.behavior.USACC(i,1) = ACC;
    
    %%%%%%%%%%%%%% Display ITI for 6s (jistter 4-8)%%%%%%%%%%%%%%%%%%%%%%%%
    tjietter = vjietter.ITI(i);
    var.ref_end = var.ref_end + tjietter;
    data.onsets.ITI(i,1) = GetSecs - var.time_MRI;
    
    if var.eyetrack
        Eyelink('Message', 'TTL=4');
    else
        data.timeStamp.ITI(i,1) = java.lang.System.nanoTime/1000000000; %unix format
    end
    
    data.durations.ITI(i,1) = DisplayITI (var,wPtr);
    
    save(resultFile, 'data', '-append');
    
    if var.eyetrack
        Eyelink('Message', 'TRIAL OK'); % trial recodered successfully
    end
    
end

studyEnd = GetSecs();
data.durations.wholeBlock = studyEnd-var.time_MRI;
save(resultFile, 'data', '-append'); % save behavior


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EVALUATE PLEASANTNESS OF THE IMAGES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CSs = {var.CSAL_image;var.CSAR_image;var.CSBL_image;var.CSBR_image;var.CSm_image};
names = {'CSAL'; 'CSAR';'CSBL'; 'CSBR'; 'CSmiu'};
% 1 up 2 down 3 to confirm

showInstruction(wPtr,'instructions/ratings.txt') % we want participant to evaluate the images after each block
WaitSecs(0.4);
while 1
    
    [down, secs, keycode] = KbCheck(-3,2);
    keyresp = find(keycode);
    if ismember (keyresp, var.leftKey)
        break
    end
    
end

[ratingResult, imagesName] = rating(CSs,names,'NOT PLEASANT AT ALL', 'EXTREMELY PLEASANT', wPtr, rect, var);
data.behavior.likingRating = ratingResult;
data.behavior.likingImageName = imagesName;
save(resultFile, 'data', '-append');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHECK THE CONTINGECIES LEARNING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if var.session == 3 % at the very end we check the contigencies learning of the previous learning blocks
    
    %% STOP THE SCRIPT TO WAIT FOR THE T2
    % Say that we are waiting for the T2 to start
    showInstruction(wPtr,'instructions/waitforT2.txt')
    while 1
        
        [down, secs, keycode] = KbCheck(-3,2);
        keyresp = find(keycode);
        if ismember (keyresp, var.mycontrol)
            break
        end
        
    end
    
    % re-initialize timining variables
    data.timeStampJava.absStart = java.lang.System.nanoTime;
    data.timeStamp.absStart = java.lang.System.nanoTime/1000000000; % unixformat (if you are happy with that then remove the java timestampS
    var.time_MRI = GetSecs(); % absolute reference of the experiment beginning
    var.ref_end = 0;
    
    %% GO HEAD AFTER PRESSING START WITH THE EXTRA QUESTIONS
    
    showInstruction(wPtr,'instructions/learn_check.txt') % we want participant to evaluate the images after each block
    while 1
        
        [down, secs, keycode] = KbCheck(-3,2);
        keyresp = find(keycode);
        if ismember (keyresp, var.leftKey)
            break
        end
        
    end
    
    
    [ratingResult, imagesName] = rating(CSs,names,'100%   LEFT', '100%  RIGHT', wPtr, rect, var);
    data.behavior.sideContingencies_Rating = ratingResult;
    data.behavior.sideContingencies_ImageName = imagesName;
    save(resultFile, 'data', '-append');
    
    showInstruction(wPtr,'instructions/learn_check_identity.txt') % we want participant to evaluate the images after each block
    WaitSecs(0.4);
    while 1
        
        [down, secs, keycode] = KbCheck(-3,2);
        keyresp = find(keycode);
        if ismember (keyresp, var.leftKey)
            break
        end
        
    end
    
    [ratingResult, imagesName] = rating(CSs,names,['100% ' var.USlabel_1], ['100% ' var.USlabel_2], wPtr, rect, var);
    data.behavior.IDcontingencies_Rating = ratingResult;
    data.behavior.IDcontingencies_ImageName = imagesName;
    save(resultFile, 'data', '-append');
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EXPERIMENT END

showInstruction(wPtr,'instructions/thanks.txt')
WaitSecs(0.4);
while 1
    
    [down, secs, keycode] = KbCheck(-3,2);
    keyresp = find(keycode);
    if ismember (keyresp, var.mycontrol)
        break
    end
    
end

if var.eyetrack % close and save eyelink
    
    Eyelink('StopRecording')
    Eyelink('CloseFile');
    status = Eyelink('ReceiveFile'); % dowload file 
    Eyelink('Shutdown');
    
end


Screen('CloseAll');
RestrictKeysForKbCheck([]); %re-allow all keys to be read

%[~,output] = system(['/bin/bash ' pwd '/functions/sendToDecisionNeuro.sh']); %immediatly backup the data to decisionneuroscience