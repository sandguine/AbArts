image=(imread('../arlequin-dansant-1924.jpg!PinterestLarge.jpg'));
figure;imshow(image);
image = double(image);
% Choose different scales
% Segmentation parameter Q; Q small few segments, Q large may segments
Qlevels=32;%2.^(8:-1:0);
% This creates the following list of Qs [256 128 64 32 16 8 4 2 1]
% Creates 9 segmentations
[maps,images]=srm(image,Qlevels);
% And plot them
srm_plot_segmentation(images,maps);

