function [USname_1, USname_2, USlabel_1, USlabel_2] = uploadUSmovies (var)

% last modifed on sept 2016 

% I want to keep the script open to the possibility of choosing two sweets
% outcomes and two savory outcomes in case a participants
% hates all sweets and or all savory options

switch var.favoriteUS_1
    
 % sweet options   
    case 1 % case participant likes the most REWARD 1
        USname_1 = 'sweet_skittles.mp4';
        USlabel_1 = 'skittles';
    case 2 % case participant likes the most REWARD 2
        USname_1 = 'sweet_raisins.mp4';
        USlabel_1 = 'raisins';
    case 3 % case participant likes the most REWARD 3
        USname_1 = 'sweet_choco_raisins.mp4'; 
        USlabel_1 = 'chocolate coverted raisin';
    case 4 % case participant likes the most REWARD 4
        USname_1 = 'sweet_vanilla_raisins.mp4'; 
        USlabel_1 = 'yogurt covered raisins';
    case 5 % case participant likes the most REWARD 5
        USname_1 = 'sweet_MMs.mp4';
        USlabel_1 = 'M&Ms';
    case 6 % case participant likes the most REWARD 6
        USname_1 = 'sweet_choco_coco.mp4';
        USlabel_1 = 'chocolate covered cereals';
    case 7 % case participant likes the most REWARD 7
        USname_1 = 'sweet_choco_rise.mp4';
        USlabel_1 = 'rise covered in chocolate';
    case 8 % case participant likes the most REWARD 8
        USname_1 = 'sweet_choco_almond.mp4';
        USlabel_1 = 'almond covered in chocolate';
    case 9 % case participant likes the most REWARD 9
        USname_1 = 'sweet_dark_chocolate.mp4';
        USlabel_1 = 'dark chocolate drop';
        
% savory options         
    case 10 % case participant likes the most REWARD 10
        USname_1 = 'savory_pretzel_stick.mp4';
        USlabel_1 = 'pretzel stick';
    case 11 % case participant likes the most REWARD 11
        USname_1 = 'savory_patato_stick.mp4';
        USlabel_1 = 'potato stick';
    case 12 % case participant likes the most REWARD 12
        USname_1 = 'savory_mini_pretzel.mp4';
        USlabel_1 = 'mini pretzel';
    case 13 % case participant likes the most REWARD 13
        USname_1 = 'savory_ritz.mp4';
        USlabel_1 = 'ritz';      
    case 14 % case participant likes the most REWARD 14
        USname_1 = 'savory_cracker.mp4';
        USlabel_1 = 'cracker';     
    case 15 % case participant likes the most REWARD 15
        USname_1 = 'savory_popcorn.mp4';
        USlabel_1 = 'popcorn';
    case 16 % case participant likes the most REWARD 16
        USname_1 = 'savory_cashew.mp4';
        USlabel_1 = 'cashew';
    case 17 % case participant likes the most REWARD 17
        USname_1 = 'savory_chaddar_cracker.mp4';
        USlabel_1 = 'cheddar cracker';
    case 18 % case participant likes the most REWARD 18
        USname_1 = 'savory_peanuts.mp4';
        USlabel_1 = 'peanuts';   
        
end
    

switch var.favoriteUS_2
    
 % sweet options   
    case 1 % case participant likes the most REWARD 1
        USname_2 = 'sweet_skittles.mp4';
        USlabel_2 = 'skittles';
    case 2 % case participant likes the most REWARD 2
        USname_2 = 'sweet_raisins.mp4';
        USlabel_2 = 'raisins';
    case 3 % case participant likes the most REWARD 3
        USname_2 = 'sweet_choco_raisins.mp4'; 
        USlabel_2 = 'chocolate coverted raisin';
    case 4 % case participant likes the most REWARD 4
        USname_2 = 'sweet_vanilla_raisins.mp4'; 
        USlabel_2 = 'yogurt covered raisins';
    case 5 % case participant likes the most REWARD 5
        USname_2 = 'sweet_M&Ms.mp4';
        USlabel_2 = 'M&Ms';
    case 6 % case participant likes the most REWARD 6
        USname_2 = 'sweet_choco_coco.mp4';
        USlabel_2 = 'chocolate covered cereals';
    case 7 % case participant likes the most REWARD 7
        USname_2 = 'sweet_choco_rise.mp4';
        USlabel_2 = 'rise covered in chocolate';
    case 8 % case participant likes the most REWARD 8
        USname_2 = 'sweet_choco_almond.mp4';
        USlabel_2 = 'almond covered in chocolate';
    case 9 % case participant likes the most REWARD 9
        USname_2 = 'sweet_dark_chocolate.mp4';
        USlabel_2 = 'dark chocolate drop';
        
% savory options         
    case 10 % case participant likes the most REWARD 10
        USname_2 = 'savory_pretzel_stick.mp4';
        USlabel_2 = 'pretzel stick';
    case 11 % case participant likes the most REWARD 11
        USname_2 = 'savory_patato_stick.mp4';
        USlabel_2 = 'potato stick';
    case 12 % case participant likes the most REWARD 12
        USname_2 = 'savory_mini_pretzel.mp4';
        USlabel_2 = 'mini pretzel';
    case 13 % case participant likes the most REWARD 13
        USname_2 = 'savory_ritz.mp4';
        USlabel_2 = 'ritz';      
    case 14 % case participant likes the most REWARD 14
        USname_2 = 'savory_cracker.mp4';
        USlabel_2 = 'cracker';     
    case 15 % case participant likes the most REWARD 15
        USname_2 = 'savory_popcorn.mp4';
        USlabel_2 = 'popcorn';
    case 16 % case participant likes the most REWARD 16
        USname_2 = 'savory_cashew.mp4';
        USlabel_2 = 'cashew';
    case 17 % case participant likes the most REWARD 17
        USname_2 = 'savory_chaddar_cracker.mp4';
        USlabel_2 = 'cheddar cracker';
    case 18 % case participant likes the most REWARD 18
        USname_2 = 'savory_peanuts.mp4';
        USlabel_2 = 'peanuts';
end     
        
        
end

