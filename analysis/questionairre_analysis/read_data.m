% Read questionairre data from csvs into mats
% Iman Wahle
% Adapted from AbArts/analysis/data/create_table_concatinate
% July 10, 2018

% Loading Data

% load files and set constants
id_key = load('../data/main_task_all_v1.mat');
id_key = id_key.uniq_names;
formatSpec = '%q%f%f%q%[^\n\r]';
delimiter = ',';
NUM_USERS = 1545;


% concatenate loaded data in these structures
age = []; % 1 - 4
gender = []; % 1 - 3 
degree = []; % 1 - 5
museum = []; % 1 - 3
race = []; % 1 - 5
features = []; % 1 - 13
other_features = table; % str
feedback = table; % str
art_degree = []; % 1 - 2

% patterns
part_degree = ["Yes", "No"];
page = ["18 to 24 years old", "25 to 34 years old", "35 to 44 years old", "45 years old or above"];
pgender = ["Female", "Male", "Non-binary"];
pdegree = ["Did not complete High School", "High School/GED", "Some College or Associate Degree",...
       "Bachelor's Degree", "Master's Degree or higher"];
pmuseum = ["Less than once a month", "1 to 3 times per month", "Once a week or more"];
prace = ["American Indian or Alaska Native", "Asian or Asian American", "Black or African American",...
      "Native Hawaiian and Other Pacific Islander", "White or Caucasian"];
pfeatures = ["Color", "Composition", "Meaning/Content", "Texture/Brushstrokes",...
       "Shape", "Perspective", "Feeling of Motion", "Balance", "Style",...
       "Mood", "Originality", "Unity", "Others"];

% loop through every trial
for i=1:13
    disp(i);
    disp('reading data');
    % open file
    fname = ['../../../artTask/psiTurk-artTask-v' num2str(i) '/trialdata.csv'];
    fileID = fopen(fname, 'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, ...
            'TextType', 'string', 'EmptyValue', NaN,  'ReturnOnError', false);
    fclose(fileID);
    data = table(dataArray{1:end-1}, 'VariableNames', ...
            {'name','sequence','time','infos'});

    % match name IDs to number IDs
    names = table2cell(data(:,1));
    id_names = zeros(length(names),1);
    for j=1:length(names)
        name = names(j,1);
        try
            id = find(ismember(id_key,name{1}));
            id_names(j,1) = find(ismember(id_key,name{1}));
        catch
            id_names(j,1) = 0;
        end
    end
    
    % add to total dataset
    data = [array2table(id_names) data];

    disp('splitting data');
    % Parsing through responses in 'infos' column

    % go through every response to pull out survey data
    for k=1:size(data,1)
        r = table2cell(data(k,5));
        raw = r{1};
        if contains(raw,'"trial_type": "survey-multi-choice"') | ...
           contains(raw,'"trial_type": "survey-multi-select"') | ...
           contains(raw,'"trial_type": "survey-text"') 

            response = extractAfter(raw, '"{\"Q0\":');
            response = extractBefore(response, '}"');
            rlist = strsplit(response, '\');
            id = table2array(data(k,1));
            for r=1:size(rlist,2)
                resp = rlist(r);
                resp = strip(resp, '"');
                if any(find(strcmp(pdegree, resp))) degree = [degree; [id find(strcmp(pdegree, resp))]]; 
                elseif any(find(strcmp(page,resp))) age = [age; [id find(strcmp(page,resp))]];
                elseif any(find(strcmp(pgender, resp))) gender = [gender; [id find(strcmp(pgender, resp))]];
                elseif any(find(strcmp(pmuseum, resp))) museum = [museum; [id find(strcmp(pmuseum, resp))]];
                elseif any(find(strcmp(prace, resp))) race = [race; [id find(strcmp(prace, resp))]];
                elseif any(find(strcmp(pfeatures, resp))) features = [features; [id find(strcmp(pfeatures, resp))]];
                elseif any(find(strcmp(part_degree, resp))) art_degree = [art_degree; [id find(strcmp(part_degree, resp))]];
                % TODO: collect free response questions
                end
            end
        end

    end

end


%%
save('survey_data.mat', 'age', 'gender', 'degree', 'museum', 'race', ...
    'features', 'art_degree');



