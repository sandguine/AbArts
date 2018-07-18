function [bfm] = loadMoviesByFrame (var)

% bfm = by frame movie
% the PTB3 Video functions do not work on Windows instead, we'll need to
% read the movie frame by frame with Matlab's VideoReader and make
% textures on the fly open video object and read total number of frames
% last modified on Jan 2017, based on Julien Dubois'BangYoureDead script

moviefile_1 = [pwd filesep var.movie_1];
moviefile_2 = [pwd filesep var.movie_2];

movies = {moviefile_1; moviefile_2}; % movies we want to upload
moviesName = {var.movie_1; var.movie_2};

for i = 1:length(movies)
    
    tic; % take time
    
    movieFile                   = char(movies(i));
    movieName                   = char(moviesName(i));
    movieName                   = movieName (8:end-4); % keep the name without suffix and extention
    
    vidObj                      = VideoReader(movieFile); % readframe by frame
    bfm.(movieName).movieWidth  = vidObj.Width;
    bfm.(movieName).movieHeight = vidObj.Height;
    bfm.(movieName).frameRate   = vidObj.FrameRate;
    
    bfm.(movieName).startFrame  = 1;
    bfm.(movieName).startTime   = bfm.(movieName).startFrame/bfm.(movieName).frameRate;
    
    nFrames = 74; % checked all videos 74 is the smalller nframe (76 the max)
    bfm.(movieName).mov        = struct('tex',cell(1,nFrames-bfm.(movieName).startFrame+1),'cdata',cell(1,nFrames-bfm.(movieName).startFrame+1));
    
    fprintf('Loading movie!...\n');
    fprintf('\t video... \t');
    
    k = 1; % cmpt
    while hasFrame(vidObj)
        tmp = readFrame(vidObj);
        if k>=bfm.(movieName).startFrame
            if mod(k,floor(nFrames/10))==1
                fprintf('%d%%',round(k/ceil(nFrames/100)));
            elseif mod(k,floor(nFrames/100))==1
                fprintf('.');
            end
            % memory saving trick: since grayscale, only put 1 frame in memory
            bfm.(movieName).mov(k-bfm.(movieName).startFrame+1).cdata = tmp(:,:,:);
        end
        k = k+1;
    end
    % correct nFrames if it was wrong
    bfm.(movieName).nFrames = length(bfm.(movieName).mov);
    bfm.(movieName).mov = bfm.(movieName).mov(1:bfm.(movieName).nFrames);
    
    elapsed = toc;
    fprintf(' done in %.3fs\n',elapsed);
    
end