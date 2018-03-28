%% Instruction for Working with EEG Data
% 1. Obtain the data as .CNT/ .rs3/ .dap
% 2. Clean the data by eye-balling
% 3. Run ICA (need good computer)
% 4. Run this Script

%% Clear Current WD
clear all

% Call EEGLab for using ERPLab
eeglab()

%% Load Cleaned Data Set
expt_dir = {'~//EEG_ITC/EEGCleaned'};
subj_dir_wildcard = '10*.set';

% Directory of each EEG file is stored in subj_dirs 
subj_dirs = {};
for d = expt_dir
    subj_ids = dir(fullfile(d{1}, subj_dir_wildcard));
    for i = 1 : numel(subj_ids)
        subj_dirs = [subj_dirs ...
            fullfile(d{1}, subj_ids(i).name)];
    end;
end;

%% Load Data Set with EEGLab
el_dir = {fullfile('~/Dropbox\Documents\EEG_ITC\EEGCleaned\EventLists\')};

for si = 1:numel(subj_dirs)
    % Load SET files
    EEG = pop_loadset(strcat(subj_dirs{si}));

    % Create Event File (Automated by Default Value from ERPLab)
    EEG = pop_creabasiceventlist( EEG , 'AlphanumericCleaning',...
       'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' },...
       'Eventlist', strcat(subj_dirs{si},'EventList.txt'));

    % Assign BINS
    EEG = pop_binlister( EEG , 'BDF',...
       '~/Dropbox\Documents\EEG_ITC\Binlister_160510.txt',...
       'IndexEL',  1, 'SendEL2', 'EEG','Voutput', 'EEG');

    % Extract Bin-based Epoch
    EEG = pop_epochbin( EEG , [-1000.0  1000.0],  'pre');

    % Compute Average ERPs
    ERP = pop_averager( EEG , 'Criterion', 'good', 'DSindex',  1,...
         'ExcludeBoundary', 'on', 'SEM', 'on' );
 
    % Save ERP
    ERP = pop_savemyerp(ERP, 'erpname', 'ERP_name.erp', 'filename',...
        strcat(subj_dirs{si},'ERP.erp'));
end;

for si = 1:numel(subj_dirs)
    % Load ERP
    ERP = pop_loaderp( 'filename', strcat(subj_dirs{si},'ERP.erp'));
    
    % something's wrong
    % Filter the data
    ERP = pop_filterp( ERP,  1:34 , 'Cutoff', [ 0.1 30], 'Design', 'butter',...
        'Filter', 'bandpass', 'Order',  2, 'RemoveDC', 'on' );


    % Plot the data
%     ERP = pop_ploterps( ERP,  6:2:10, [ 1:30] , 'AutoYlim', 'on',...
%         'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box',...
%         [ 7 6], 'ChLabel', 'on', 'FontSizeChan',  10, 'FontSizeLeg',...
%         12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec',...
%         {'k-' , 'r-' , 'b-' }, 'LineWidth', 1, 'Maximize', 'on',...
%         'Position', [ 103.8 20.5 106.8 31.9375], 'Style', 'Classic',...
%         'Tag', 'ERP_figure', 'Transparency',  0, 'xscale',...
%      [ -1000.0 200.0   -1000:200:200 ], 'YDir', 'normal' );

end;