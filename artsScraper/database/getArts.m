%% This script will copy random 200 pictures from original folder to another subfolder

% find directory
dirName = {'/Users/sandy/Dropbox/Caltech/AbArts/artsScraper/database/ColorFieldPainting'};
% get all pictures
artsWildcard = '*.jpg';

% create an array of full file path with names
artsDirs = {};
for d = dirName
    fullArts = dir(fullfile(d{1}, artsWildcard));
    for i = 1 : numel(fullArts)
        artsDirs = [artsDirs ...
            fullfile(d{1}, fullArts(i).name)];
    end;
end;

% specify number of all pictures in the folder
nArts = size(arts_dirs,2);

% randomly picking first 200 artworks
randomArts = randperm(nArts);
arts200 = randomArts(1:200);
realArts = artDirs(arts200);

%% change directory
cd dirName
% create new sub directory called real
mkdir real

% add full file path
desDir = [dirName, 'real'];

% copy and paste 200 pictures
for i = 1:length(realArts)
    real = realArts(i);
    copyfile(real{1}, desDir);
end