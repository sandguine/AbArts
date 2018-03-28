expt_dir = {'/Users/sandy/Dropbox/Caltech/AbArts/artsScraper/database/ColorFieldPainting'};
arts_wildcard = '*.jpg';

arts_dirs = {};
for d = expt_dir
    fullarts = dir(fullfile(d{1}, arts_wildcard));
    for i = 1 : numel(fullarts)
        arts_dirs = [arts_dirs ...
            fullfile(d{1}, fullarts(i).name)];
    end;
end;

nArts = size(arts_dirs,2);
randomArts = randperm(nArts);
arts200 = randomArts(1:200);
realArts = arts_dirs(arts200);


mkdir real

dir_name='/Users/sandy/Dropbox/Caltech/AbArts/artsScraper/database/ColorFieldPainting/'

dis_dir_name=[dir_name, 'real'];


for i = 1:length(realArts)
    x = realArts(i);
    copyfile(x{1}, dis_dir_name);
end