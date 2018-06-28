%% This script will copy random 200 pictures from original folder to another subfolder

% function getArts = getArts(styleName)
    % find directory
    dirName = {'/Users/sandy/Dropbox/Caltech/AbArts/artsScraper/database/Impressionism'};
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
    nArts = size(artsDirs,2);

    % randomly picking first 200 artworks
    randomArts = randperm(nArts);
    arts200 = randomArts(1:200);
    realArts = artsDirs(arts200);

    %% change directory
    cd '/Users/sandy/Dropbox/Caltech/AbArts/artsScraper/database/Impressionism'
    % create new sub directory called real
    mkdir 0000

    % add full file path
    desDir = fullfile(dirName, '0000');
    desDir = desDir{1};

    % copy and paste 200 pictures
    for i = 1:length(realArts)
        real = realArts(i);
        copyfile(real{1}, desDir);
    end
    
% end