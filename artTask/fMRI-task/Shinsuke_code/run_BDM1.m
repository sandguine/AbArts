function run_BDM1(subID)
%% run_BDM1('150424a')
%% run_BDM1('000000a')

try
    run_idx = 1;
    num_rep = 2;
    
    % image_base='/Users/miles/Dropbox/AbArts/ArtsScraper/database/';
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
        idx_rnd = randperm(length(item_list));
        item_idx = [item_idx; item_list(idx_rnd)];
        endScreen('CloseAll')
        Screen('CloseAll')
        
    num_trials = length(item_idx);
    
    % Set window pointer
    [wpt, rect] = Screen('OpenWindow', 0, [0, 0, 0], [0 0 800 600] *1.5); w = rect(3); h = rect(4);
    %[wpt, rect] = Screen('OpenWindow', 1, [0, 0, 0]); w = rect(3); h = rect(4);
    Screen('BlendFunction', wpt, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    % Preparation
    durITI = linspace(2,12,num_trials);
    %durITI = linspace(1,2,num_trials);
    durITI = durITI(randperm(num_trials));
    durDEC = 3; durOUT = 0.5; durRES = 2.5;
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
    
    % Start BDM
    time_zero = GetSecs;
    for i = 1:num_trials
        
        % ITI
        disp(['trial #',num2str(i),': ',num2str(item_idx(i))])
        time_ITIstrt = GetSecs - time_zero;
        disp_fix(wpt, w, h, durITI(i))
        time_ITIend = GetSecs - time_zero;
        time_ITI = [time_ITI; [time_ITIstrt, time_ITIend]];
        
        % DEC (PRESENTATION)
        % images are here
        shown_item = ['data/imgs/item_',num2str(item_idx(i)),'.jpg'];
        time_DECstrt = GetSecs - time_zero;
        disp_item(wpt, w, h, shown_item, durDEC);
        time_DECend = GetSecs - time_zero;
        time_DEC = [time_DEC; [time_DECstrt, time_DECend]];
    
        % RESPONSE
        draw_response(wpt, w, h)
        res_nums = draw_res_nums(wpt, w, h, pst_V(i,:));
        valueBDM = 100;
        Screen(wpt,'Flip');
        time_RESstrt = GetSecs - time_zero;
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
        
        % OUTCOME (FEEDBACK)
        time_OUTstrt = GetSecs - time_zero;
        disp_out(wpt, w, h, valueBDM, durOUT)
        time_OUTend = GetSecs - time_zero;
        time_OUT = [time_OUT; [time_OUTstrt, time_OUTend]];
        
        % save data
        value = [value; valueBDM];
        item = [item; item_idx(i)];
        
    end 
    
    % data save and closing
    fname_log = ['logs/bdm_',num2str(run_idx),'_sub_',subID];
    save(fname_log,'value','item','pst_V');
    
    durITI = 14;
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