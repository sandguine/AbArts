function run_Art_Rating_v2(subID, eyetrack)
%% Art rating task kiigaya@gmail.com, mostly based on Shinsuke Suzuki's code
%% run_BDM1('000000a')

try
    run_idx = 1;
    num_rep = 2;
    
    %image_folder = 'D:\Dropbox\AbArts\ArtTask\features-task\concreteness\static\images';
     if boolean(strfind(pwd, 'sandy'))
         
     elseif boolean(strfind(pwd, 'miles'))
         image_base='/Users/miles/Dropbox/AbArts/ArtsScraper/database/';
     else
       
     end
     
    load('data/images/image_names.mat'); %% image_names, image_categories
    
    
    
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIALIZE EYELINK (EL) EYETRACKR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if eyetrack
    
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

if eyetrack
    
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
           
         
   % load('D:\Dropbox\AbArts\analysis\data\features_global_all.mat');  %% image_file_names
   
    
    
    % if boolean(strfind(pwd, 'sandy'))
    % savdir = '/Users/sandy/Dropbox/Caltech/AbArts/analysis/data';
    %    image_base = '/Users/sandy/Dropbox/Caltech/AbArts/artTask/fMRI-task/Shinsuke_code/data/images/'
    % elseif  boolean(strfind(pwd, 'miles'))
    %    image_base = '/Users/miles/Dropbox/AbArts/artTask/fMRI-task/Shinsuke_code/data/images';
    % else
    %    image_base = 'D:/Dropbox/AbArts/artTask/fMRI-task/Shinsuke_code/data/images/';
    % end

    % categories = {'abstract','colorFields','cubism','impressionism', 'leslie'};

    % current_folder = [image_base, categories{i_category}, '/', '000/']
    
    % Load image files for the subject
    % Change to Arts image folder here
    file_items = ['data/item_id_sub_',subID];
    % file_items = dir([current_folder, '*.jpg']);
    load(file_items) % item_id_sub is loaded
    
    % Set the item list presented
    item_list = item_id_sub{run_idx};
    item_idx = [];
    for i = 1:num_rep
        idx_rnd = randperm(length(item_list));   %% generate random index
        item_idx = [item_idx; item_list(idx_rnd)];
    end
    num_trials = length(item_idx);
    
    % Set window pointer
    [wpt, rect] = Screen('OpenWindow', 0, [0, 0, 0], [0 0 800 600] *1.5); w = rect(3); h = rect(4);
    
   % [wpt, rect] = Screen('OpenWindow', 0, [0, 0, 0], [0 0 800 600] *5); w = rect(3); h = rect(4);
    
    
    %[wpt, rect] = Screen('OpenWindow', 1, [0, 0, 0]); w = rect(3); h = rect(4);
    Screen('BlendFunction', wpt, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    % Preparation
   % durITI = linspace(2,12,num_trials);
    durITI = linspace(1,2,num_trials);
    durITI = durITI(randperm(num_trials));
    durDEC = 10; durOUT = 1.5; durRES = 4;
    %durDEC = 1; durOUT = 1; durRES = 2;
    pst_V = [];
    for i = 1:num_trials
        pst_V = [pst_V; randperm(4) - 1];
    end
    
    % Prepare data
    time_ITI = []; time_DEC = []; time_RES = []; time_OUT = [];
    value = []; item = []; pst_value = pst_V;
    
    % Ready
    disp_ready(wpt, w, h);
    
    
    
    

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

%var.time_MRI = GetSecs(); % absolute reference of the experiment beginning
var.ref_end = 0;

if eyetrack
    Eyelink('StartRecording');
    Eyelink('Message', 'SYNCTIME');  % mark zero-plot time in data file
    Eyelink('Message', 'START EXPERIMENT'); % mark experiment start 
else
   % data.timeStamp.absStart = java.lang.System.nanoTime/1000000000; % unixformat (if you are happy with that then remove the java timestampS
end

%RestrictKeysForKbCheck([var.leftKey, var.rightKey, var.confKey1, var.confKey2, var.mycontrol]); %once the scanner is on we just check the task relevant botton to avoid any interference witht the 5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    
    % Start BDM
    time_zero = GetSecs;
    for i = 1:num_trials
        
        % ITI
        disp(['trial #',num2str(i),': ',num2str(item_idx(i))])
        time_ITIstrt = GetSecs - time_zero;
        disp_fix(wpt, w, h, durITI(i))
        time_ITIend = GetSecs - time_zero;
        time_ITI = [time_ITI; [time_ITIstrt, time_ITIend]];
        
        if eyetrack
            Eyelink('Message', ['TRIALID' ' ' mat2str(i)]); % message is the trial number
        end
        
        % DEC (PRESENTATION)
        % images are here
        
       % shown_item = ['data/imgs/item_',num2str(item_idx(i)),'.jpg'];
        shown_item = [image_base, image_categories{item_idx(i)}, '/' image_names{item_idx(i)}]
        time_DECstrt = GetSecs - time_zero;
        
        if eyetrack
             Eyelink('Message', 'TTL=1');% time stamped message (TTL numeric code to use Julien functions)
        end
            
                 
        disp_item(wpt, w*4, h, shown_item, durDEC);
        time_DECend = GetSecs - time_zero;
        time_DEC = [time_DEC; [time_DECstrt, time_DECend]];
        
        if eyetrack
             Eyelink('Message', 'TTL=2');% time stamped message (TTL numeric code to use Julien functions)
        end
            
        
        
        
        
        
        
        
    
        % RESPONSE
        draw_response(wpt, w, h)
        res_nums = draw_res_nums(wpt, w, h, pst_V(i,:));
        valueBDM = 100;
        Screen(wpt,'Flip');
        time_RESstrt = GetSecs - time_zero;
        
        if eyetrack
             Eyelink('Message', 'TTL=3');% time stamped message (TTL numeric code to use Julien functions)
        end
        
        FlushEvents
        t_strt = GetSecs;
        while GetSecs < t_strt + durRES
            if CharAvail == 1
                keyRes = GetChar;
                if isequal(keyRes,'1')
                    valueBDM = pst_V(i,1); break
                elseif isequal(keyRes,'2')
                    valueBDM = pst_V(i,2); break
                elseif isequal(keyRes,'3')
                    valueBDM = pst_V(i,3); break
                elseif isequal(keyRes,'4')
                    valueBDM = pst_V(i,4); break
                elseif isequal(keyName,'q')
                    %%added by Logan for Demo
                    Screen('CloseAll');
                    break
                end
            end
        end
        time_RESend = GetSecs - time_zero;
        clear_res_numes(res_nums);
        disp(valueBDM)
        time_RES = [time_RES; [time_RESstrt, time_RESend]];
        
        
        if eyetrack
             Eyelink('Message', 'TTL=3');% time stamped message (TTL numeric code to use Julien functions)
        end
        
        % OUTCOME (FEEDBACK)
        time_OUTstrt = GetSecs - time_zero;
        disp_out_v2(wpt, w, h, valueBDM, durOUT)
        time_OUTend = GetSecs - time_zero;
        time_OUT = [time_OUT; [time_OUTstrt, time_OUTend]];
        
        if eyetrack
             Eyelink('Message', 'TTL=4');% time stamped message (TTL numeric code to use Julien functions)
        end
        
        % save data
        value = [value; valueBDM];
        item = [item; item_idx(i)];
        
    end 
    
    % data save and closing
    fname_log = ['logs/bdm_',num2str(run_idx),'_sub_',subID];
    save(fname_log,'value','item','pst_V');
    
    durITI = 2;
    time_ITIstrt = GetSecs - time_zero;
    disp_fix(wpt, w, h, durITI)
    time_ITIend = GetSecs - time_zero;
    time_ITI = [time_ITI; [time_ITIstrt, time_ITIend]];
    
    fname_log_time = ['logs/bdm_',num2str(run_idx),'_sub_',subID,'_time'];
    save(fname_log_time, 'time_ITI','time_DEC','time_RES','time_OUT');
    
    Screen('CloseAll');

catch
    
    Screen('CloseAll');
    psychrethrow(psychlasterror);

end

end