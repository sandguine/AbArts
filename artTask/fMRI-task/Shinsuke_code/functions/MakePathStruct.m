function path = MakePathStruct()
% last modified on the 14 Jan 2016 by Eva

path.main = pwd;
path.data = fullfile(path.main,'data');
cd(path.main);
path.functions = fullfile(path.main,'functions');
path.videos = fullfile(path.main,'videos');
path.instructions = fullfile(path.main,'instructions');

end