
% categories = {'concreteness', 'dynamic', 'temperature', 'valence'};
%file_path = '../../artTask/features-task/';
NUM_IMGS = 1001;
formatSpec = '%q%f%f%q%[^\n\r]';
delimiter = ',';

% load data
fname = 'trialdata.csv';
fileID = fopen(fname, 'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, ...
        'TextType', 'string', 'EmptyValue', NaN,  'ReturnOnError', false);
fclose(fileID);
data = table(dataArray{1:end-1}, 'VariableNames', ...
        {'name','sequence','time','infos'});


% find trial starts and ends to distinguish between classifiers
seq = table2array(data(:,2));
starts = find(seq==0);
ends = [starts(2:end)-1; length(seq)];
dif = ends-starts;
ends(find(dif<100))=[];
starts(find(dif<100))=[];

image_key = load('../data/segments_v2.mat');
image_key_leslie = load('../data/segments_leslie_v1.mat');
image_key = image_key.image_file_names.image_names;
image_key_leslie = image_key_leslie.image_file_names.image_names;
for i=1:length(image_key_leslie)
    %n = image_key_leslie(i);
    %lst = strsplit(n{1},'.');
    im = image_key_leslie(i);
    im = im{1};
    image_key_leslie(i) = {im(1:3)}; %extractBefore(image_key_leslie(i), lst(end));
end
classifications =  6*ones(NUM_IMGS, length(starts));
response_times =  6*ones(NUM_IMGS, length(starts));

text = data(:,4);
disp('num users: ');
disp(length(starts));
for j=1:length(starts)
    s=starts(j);e=ends(j);
    cnt=0;
    cnt2=0;
    for k=s:e
        resp = table2cell(text(k,1));
        raw = resp{1};
        if contains(raw,'static/')
            cnt2=cnt2+1;
            label = extractAfter(raw, '"button_pressed": ');
            label = extractBefore(label, ',');
            name = extractAfter(raw, '"stimulus": "');
            name = extractBefore(name, '", ');
            rt = extractAfter(raw, '"time_elapsed": ');
            rt = extractBefore(rt, ', ');
            if strcmp(label, 'null')
                continue
            end
            % look up key for this image
            path = strsplit(name, '/');
            if strcmp(path(end), '0.jpg')
                continue
            end
            key = find(strcmp(image_key, path(end)));
            if isempty(key)
                cnt=cnt+1;
                %lst = strsplit(path(end), '.');
                %pe = extractBefore(path(end), lst(end));
                pe = path(end);
                pe = pe{1};
                key = find(strcmp(image_key_leslie, pe(1:3)));
                if isempty(key)
                    if pe(1:3)=='yer'
                        key = 201;
                    elseif pe(1:3)=='aft'
                        key = 9;
                    else
                        disp('not found');
                        %disp(path);
                    end
                else
                    key = key + 826;
                end
            end
            classifications(key,j) = str2num(label{1});
            response_times(key, j) = str2num(rt{1});
        end
    end
end
save('trial_data.mat', 'classifications', 'response_times');

