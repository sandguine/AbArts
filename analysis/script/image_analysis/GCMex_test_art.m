clear all
close all
%%

%addpath /Users/sandy/Dropbox/Caltech/AbArts/papers/arts_ml/gco-v3.0/matlab
addpath D:\Dropbox\AbArts\papers\arts_ml\GCMex

addpath('./functions')

%image_file = '/Users/miles/Dropbox/AbArts/ArtsScraper/database/AbstractArt/000/2005-60-80.jpg!PinterestLarge.jpg'



%image_file = 'D:/Dropbox/AbArts/ArtsScraper/database/AbstractArt/000/2005-60-80.jpg!PinterestLarge.jpg';

%image_file = '/Users/sandy/Dropbox/Caltech/AbArts/ArtsScraper/database/Impressionism/a-cloudy-day-bluebonnets-near-san-antonio-texas-1918.jpg!PinterestLarge.jpg';

image_file = 'D:\Dropbox\AbArts\ArtsScraper\database\Impressionism\a-cloudy-day-bluebonnets-near-san-antonio-texas-1918.jpg!PinterestLarge.jpg';


im = imread(image_file); 



image(im)

im = double(im)/255;  %% RGB 0 to 1

im_color_1=im(:,:,1);
%%
W = size(im,2);
H = size(im,1);


segclass = zeros(W*H,1);
pairwise = sparse(W*H,W*H);
unary = zeros(7,H*W/2);
[X Y] = meshgrid(1:7, 1:7);
labelcost = min(4, (X - Y).*(X - Y));

for row = 0:H-1
  for col = 0:W-1
    pixel = 1+ row*W + col;
    %pixel = im_color_1(row+1,col+1);
    if row+1 < H, pairwise(pixel, 1+col+(row+1)*W) = 1; end
    if row-1 >= 0, pairwise(pixel, 1+col+(row-1)*W) = 1; end 
    if col+1 < W, pairwise(pixel, 1+(col+1)+row*W) = 1; end
    if col-1 >= 0, pairwise(pixel, 1+(col-1)+row*W) = 1; end 
    if pixel < 25
      unary(:,pixel) = [0 10 10 10 10 10 10]'; 
    else
      unary(:,pixel) = [10 10 10 10 0 10 10]'; 
    end
  end
end

[labels E Eafter] = GCMex(segclass, single(unary), pairwise, single(labelcost),0);

fprintf('E: %d (should be 260), Eafter: %d (should be 44)\n', E, Eafter);
fprintf('unique(labels) should be [0 4] and is: [');
fprintf('%d ', unique(labels));
fprintf(']\n');
