function run_Protein(subID)
%%
% run_BDM('150424a')

try

    % Load image files for the subject
    load(['data/data_id_new']) % item_ids is loaded
    idx_rnd = randperm(length(data_id_new));
    item_rnd_idx = data_id_new(idx_rnd);
    
    % Set window pointer
    [wpt, rect] = Screen('OpenWindow', 0, [0, 0, 0], [0 0 800 600] * 1.5); w = rect(3); h = rect(4);
    %[wpt, rect] = Screen('OpenWindow', 1, [0, 0, 0]); w = rect(3); h = rect(4);
    Screen('BlendFunction', wpt, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    % Preparation
    durITI = 0.5;
    num_trials = length(item_rnd_idx);
    %num_trials = 10;
    d_tics = prep_tics2(wpt, w, h);
    w_bin = linspace(w * 0.2, w * 0.8, 30);
    str_question = DispString('init', wpt, 'How High Is the Item in Protein?', [0,-h/2.75], floor(h/17), [255, 255, 255], []);
    
    % Prepare data
    time_ITI = []; time_DEC = [];
    value = []; item = []; init_V = []; num_L = []; num_R = [];
    
    % Ready
    disp_ready(wpt, w, h);
    
    % Start BDM
    time_zero = GetSecs;
    for i = 1:num_trials
        
        % ITI
        disp(['trial #',num2str(i),': ',num2str(item_rnd_idx(i))])
        time_ITIstrt = GetSecs - time_zero;
        disp_fix(wpt, w, h, durITI)
        time_ITIend = GetSecs - time_zero;
        time_ITI = [time_ITI; [time_ITIstrt, time_ITIend]];
        
        % BDM
        shown_item = ['data/imgs/item_',num2str(item_rnd_idx(i)),'.jpg'];
        itm_img = DispImage('init', wpt, shown_item, [0,-h/15], w/50, [100,100]);
        
        target = ceil(rand() * length(w_bin));
        init_valueBDM = 4 * (target - 1) / (length(w_bin) - 1);numL_tmp = 0; numR_tmp = 0;
        
        FlushEvents
        time_DECstrt = GetSecs - time_zero;
        while 1
            DispImage('draw', wpt, itm_img);
            DispString('draw', wpt, str_question);
            draw_tics2(wpt, w, h, d_tics)
            Screen('FillRect', wpt, [255,0,0], [w_bin(target) - 0.015 * w, 0.71 * h ,w_bin(target) + 0.015 * w, 0.78 * h]);
            Screen(wpt,'Flip');
            
            keyRes = GetChar;
            if isequal(keyRes,'3')
                break
            elseif isequal(keyRes,'1')
                target = target - 1; numL_tmp = numL_tmp + 1; if target < 1, target = 1; end
            elseif isequal(keyRes,'2')
                target = target + 1; numR_tmp = numR_tmp + 1; if target > length(w_bin), target = length(w_bin); end
            end
            FlushEvents
        end
        time_DECend = GetSecs - time_zero;
        time_DEC = [time_DEC; [time_DECstrt, time_DECend]];
        valueBDM = 4 * (target - 1) / (length(w_bin) - 1); % disp(['$',num2str(valueBDM)]);
        
        % save data
        value = [value; valueBDM];
        item = [item; item_rnd_idx(i)];
        init_V = [init_V; init_valueBDM];
        num_L = [num_L; numL_tmp]; 
        num_R = [num_R; numR_tmp];
       
        DispImage('clear', itm_img);
        
    end 
    
    % data save and closing
    fname_log = ['logs/protein_sub_',subID];
    save(fname_log,'value','item','init_V','num_L','num_R');
    
    durITI = 4;
    time_ITIstrt = GetSecs - time_zero;
    disp_fix(wpt, w, h, durITI)
    time_ITIend = GetSecs - time_zero;
    time_ITI = [time_ITI; [time_ITIstrt, time_ITIend]];
    
    fname_log_time = ['logs/protein_sub_',subID,'_time'];
    save(fname_log_time, 'time_ITI', 'time_DEC');
    
    Screen('CloseAll');

catch
    
    Screen('CloseAll');
    psychrethrow(psychlasterror);

end

end