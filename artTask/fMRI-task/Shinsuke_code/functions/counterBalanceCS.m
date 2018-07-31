function [CSAL_image,CSAR_image,CSBL_image,CSBR_image,CSm_image,list] = counterBalanceCS(participantID)

% this randomization is not compleate (otherwise 144 lists would be
% necessary) but it makes sure that each color equally corresponded to one
% Pavolvian role

if participantID == 1 || mod((participantID - 1),5) == 0;
    list = 1;
    
    CSAL_image = imread('red_im.jpg');
    CSAR_image = imread('green_im.jpg');
    CSBL_image = imread('yellow_im.jpg');
    CSBR_image = imread('violet_im.jpg'); 
    CSm_image = imread('blue_im.jpg');
    
    
elseif participantID == 2 || mod((participantID - 2),5) == 0;
    list = 2;
    
    CSAL_image = imread('blue_im.jpg');
    CSAR_image = imread('yellow_im.jpg'); 
    CSBL_image = imread('violet_im.jpg');
    CSBR_image = imread('green_im.jpg');
    CSm_image = imread('red_im.jpg');
    
elseif participantID == 3 || mod((participantID - 3),5) == 0;
    list = 3;
    
    CSAL_image = imread('violet_im.jpg');
    CSAR_image = imread('red_im.jpg');
    CSBL_image = imread('yellow_im.jpg');
    CSBR_image = imread('blue_im.jpg'); 
    CSm_image = imread('green_im.jpg');
    
elseif participantID == 4 || mod((participantID - 4),5) == 0;
    list = 4;
    
    CSAL_image = imread('yellow_im.jpg');
    CSAR_image = imread('blue_im.jpg');
    CSBL_image = imread('green_im.jpg');
    CSBR_image = imread('red_im.jpg'); 
    CSm_image = imread('violet_im.jpg');
    
elseif participantID == 5 || mod((participantID - 5),5) == 0;
    list = 5;

    CSAL_image = imread('green_im.jpg');
    CSAR_image = imread('violet_im.jpg');
    CSBL_image = imread('red_im.jpg');
    CSBR_image = imread('blue_im.jpg'); 
    CSm_image = imread('yellow_im.jpg');
    
end


end

