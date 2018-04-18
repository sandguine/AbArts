
clear all
 %% I'm not sure the difference between HSV and HSL
addpath('./functions')

%image_file = '/Users/miles/Dropbox/AbArts/ArtsScraper/database/AbstractArt/000/2005-60-80.jpg!PinterestLarge.jpg'



%image_file = 'D:/Dropbox/AbArts/ArtsScraper/database/AbstractArt/000/2005-60-80.jpg!PinterestLarge.jpg';

image_file = 'D:\Dropbox\AbArts\ArtsScraper\database\Impressionism\a-cloudy-day-bluebonnets-near-san-antonio-texas-1918.jpg!PinterestLarge.jpg';


X = imread(image_file); 

image(X)

X = double(X)/255;  %% RGB 0 to 1

Y=colorspace('rgb->hsl',X);  %% HSL  hue is expressed in dgree 0 - 360. 
%%
%Y = rgb2hsv(X)  ;    %% HSV

Z1 = mean_hue(Y);

Z2 = mean_s(Y);

n_bin=20;
threshold =0.1;
Z3=hue_count( Y,n_bin, threshold );

Z4=number_most_count_hue( Y,n_bin);

Z5= hue_contrast( Y,n_bin,threshold);
n_sample=100;

[Z6, F_k, best_angles]= hue_model_choose( Y, n_sample);

%Z7
%%
Z8=mean_brightness(X);

Z9=mean_log_brightness(X);

n_bin=100;

Z10= brightness_contrast(X, n_bin );

threshold=4;
Z11=blurr( X,threshold );

Z12=
