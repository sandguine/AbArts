clear all
close all

%% Import data from text file.
% Script for importing data from the following text file:
%
%    /Users/miles/Dropbox/AbArts/ArtTask/data/180420trialdata.csv
%
% To extend the code to different selected data or a different text file,
% generate a function instead of a script.

% Auto-generated by MATLAB on 2018/04/23 11:29:52

%% Initialize variables.
if boolean(strfind(pwd, 'sandy'))
     filename = '/Users/sandy/Dropbox/Caltech/AbArts/artTask/psiTurk-artTask-v3/trialdata.csv'; % v2
    % filename = '/Users/sandy/Dropbox/Caltech/AbArts/artTask/data/180424trialdata.csv';
elseif boolean(strfind(pwd, 'miles'))
     filename = '/Users/miles/Dropbox/AbArts/ArtTask/behavioral-all-stims/trialdata.csv';
    % filename = '/Users/miles/Dropbox/AbArts/ArtTask/data/180518trialdata.csv'; % v2
else
   %  filename = 'D:/Dropbox/AbArts/ArtTask/data/180424trialdata.csv';
     filename = 'D:\Dropbox\AbArts\ArtTask\behavioral-all-stims\trialdata.csv';
end

delimiter = ',';

%% Format for each line of text:
%   column1: text (%q)
%	column2: double (%f)
%   column3: double (%f)
%	column4: text (%q)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%q%f%f%q%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN,  'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.


%% Create output variable
trialdata = table(dataArray{1:end-1}, 'VariableNames', {'name','sequence','time','infos'});

%% Clear temporary variables
clearvars filename delimiter formatSpec fileID dataArray ans;


%%

name=trialdata(:,1);
name=table2cell(name);

names_all=unique(cellstr(name),'stable');

infos=trialdata(:,4);
infos=table2cell(infos);
infos=cellstr(infos);

l_matrix=size(infos,1)

nonempty_index=[];
for i=1:l_matrix
    x=infos{i,1};
    
    if length(char(x))>6
        nonempty_index=[nonempty_index; i];
    end
        

end

name_new=name(nonempty_index);
infos_new=infos(nonempty_index);
%%
l_matrix=length(infos_new);
task_trial=[]
for i=1:l_matrix
    x=char(infos_new{i,1});
    if  x(1:5)== '{"rt"'   
        task_trial=[task_trial;i];
    end
end

name_trial=name_new(task_trial);

infos_trial=infos_new(task_trial);
%%
%%
l_matrix=length(infos_new);
task_trial=[]
for i=1:l_matrix
    x=char(infos_new{i,1});
    if  x(1:5)== '{"rt"' 
        if ~contains(x, 'instructions') && ~contains(x, 'null') && ~contains(x, 'images/0.jpg') && ~contains(x, 'Ok, very')...
                &&  ~contains(x, 'In this part of') &&  ~contains(x, 'You are almost done') &&  ~contains(x, 'The new set of') ...
                && ~contains(x, 'This is a break point')
            task_trial=[task_trial;i];
        end
    end
end

name_trial=name_new(task_trial);  %% this contains, familiarity, rating, survey

infos_trial=infos_new(task_trial);


%% survey part
l_matrix =length(infos_trial);
survey_trial=[]
nonsurvey_trial=[];
for i=1:l_matrix
    x=char(infos_trial{i,1});
    if  contains(x, '"Q0')
        
        survey_trial=[survey_trial;i];
        
    else
        
        nonsurvey_trial=[nonsurvey_trial;i];
        
    end
end

name_survey=name_trial(survey_trial);  %% this contains survey

infos_survey=infos_trial(survey_trial);


name_maintask=name_trial(nonsurvey_trial);  %% this contains main task

infos_maintask=infos_trial(nonsurvey_trial);

%%


infos_maintask= strrep(infos_maintask, '"', '');
name_maintask= cellstr(name_maintask);




uniq_names=unique(name_maintask,'stable');
l_matrix=length(infos_maintask);


for s=1:l_matrix
    z=name_maintask{s,1};
    for j=1:length(uniq_names)
        if string(z) == string(uniq_names{j})
            sub_id(s,1)=j;
        end
    end
end
        

RT=[];
Response=[];


button_order=[];

image_path=[];

trial_type=[];

for i=1:l_matrix
    x=infos_maintask{i,1};
    
    q=extractBetween(x,":","trial_type");
    y = sscanf(char(q),'%f');
    
    RT=[RT;y];
    
    q=extractBetween(x,"pressed","stimulus");
    y = sscanf(char(q),'%f');
    
    if contains(q, '0')
        current_response=0;
        
    elseif contains(q, '1')
        current_response=1;
        
    elseif contains(q, '2')
        current_response=2;
        
    elseif contains(q, '3')
        current_response=3;
       
    end
    
    Response=[Response;current_response];
    
    if contains(char(x),"[I know., I don't know.]")
        button_order{i,1}='YN';
        trial_type{i,1}='knowledge';
        trial_type_1or2(i,1)=1;
        
        if current_response==0
            current_response_meaning = 1;
        elseif current_response==1
            current_response_meaning = 0;
        end
            
        
    elseif contains(char(x),"[I don't know., I know.]")
        button_order{i,1}='NY';
        trial_type{i,1}='knowledge';
        trial_type_1or2(i,1)=1;
        if current_response==0
            current_response_meaning = 0;
        elseif current_response==1
            current_response_meaning = 1;
        end
        
    else
        button_order{i,1}='NaN';
        trial_type{i,1}='rating';
        trial_type_1or2(i,1)=2;
        
        current_response_meaning = current_response;
    end
    
    response_meaning(i,1)=current_response_meaning;
        
    
    q=extractBetween(x,"images",",");
    
    image_path{i,1}=q;
        
   
end
%%
% maintask_table=table(name_maintask,sub_id,trial_type,trial_type_1or2, Response,button_order,response_meaning, RT,image_path);
maintask_table=table(name_maintask,sub_id,trial_type,trial_type_1or2, Response,button_order,response_meaning, RT,image_path);


name_file_1='main_task_long_v2';

if boolean(strfind(pwd, 'sandy'))
    % savdir = '/Users/sandy/Dropbox/Caltech/AbArts/analysis/data';
    savdir = '/Users/sandy/Dropbox/Caltech/AbArts/analysis/data';
elseif boolean(strfind(pwd, 'miles'))
    % savdir = '/Users/miles/Dropbox/AbArts/analysis/data'
    savdir = '/Users/miles/Dropbox/AbArts/analysis/data'
else
    savdir = 'D:/Dropbox/AbArts/analysis/data'
end
 


 
index_task1=find(trial_type_1or2==1);

% maintask_table_familiarity=maintask_table(index_task1,:);
maintask_table_familiarity=maintask_table(index_task1,:);

index_task2=find(trial_type_1or2==2);

% maintask_table_rating=maintask_table(index_task2,:);
maintask_table_rating=maintask_table(index_task2,:);
 
%save(fullfile(savdir,name_file_1),'maintask_table', 'maintask_table_familiarity','maintask_table_rating','uniq_names');
save(fullfile(savdir,name_file_1),'maintask_table', 'maintask_table_familiarity','maintask_table_rating','uniq_names');


%%
% name_file_2='completion_data';
% 
% %n_trials=114;
%  n_trials=120;
% 
% for i=1:length(names_all)
%     
%     current_name=string(names_all{i,1});
%     ok=0;
%     
%     for j=1:length(uniq_names)
%         
%         if string(uniq_names{j})==current_name
%             ok=1;
%             index_in_uniq_names=j;
%             
%         end
%       
%     end
%     
%     if ok ==0
%         missed_trials(i,1)=n_trials;
%     else
%             
%         n_trials_completed=length(find(sub_id==index_in_uniq_names));
%         missed_trials(i,1)=n_trials - n_trials_completed;
%     end
% end
% 
% 
% missed_trials=table(names_all,missed_trials);
% 
% 
% save(fullfile(savdir,name_file_2),'missed_trials');
