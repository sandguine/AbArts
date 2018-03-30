function  printTestStim = getArtsNames(dir)
    dir = char(dir);
    dirName = {'/Users/sandy/Dropbox/Caltech/AbArts/artsTask/img/'};
    dirName = fullfile(dirName{1}, dir, '/');
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
end

