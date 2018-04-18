function [ output ] = hue_model( input_image,n_bin,threshold, X)
% input must be HSL, M x N x 3, 0<threshould<1, unit is radian

hue=input_image(:,:,1);

hue=hue*2*pi/360;

alpha=2*pi/(1+exp(-X));   % radian


for k=1:7
    
    alpha_current=alpha(k);
    
    if k==1 % i-type
        ETs=hue;
        theta=5/360*2*pi;
        bound1= alpha_current;
        bound2= alpha_current+theta;
       
        dist= min(abs(hue-bound1), abs(hue-(bound1-2*pi)),abs(hue-(bound1+2*pi)),...
            abs(hue-bound2), abs(hue-(bound2-2*pi)),abs(hue-(bound2+2*pi))); %% I think it's a little stupid. 
        
        index= (~isbetween(hue,bound1,bound2) && ~isbetween(hue,bound1-2*pi,bound2-2*pi) && ~isbetween(hue,bound1+2*pi,bound2+2*pi) );
        
        ETs(index) = dist(index) ;
        
       
    
    
end
    




target_saturation= (input_image(:,:,2) > 0.2);
target_value= (input_image(:,:,3) > 0.15 & input_image(:,:,3) < 0.95 );

index=target_saturation.*target_value;

hue_to_analyze=hue(index>0);

h=histogram(hue_to_analyze, n_bin);
counts=h.BinCounts;
Q=max(counts);

noticable_hues=(counts>threshold*Q);

noticable_hues=[noticable_hues,noticable_hues];

angles=[0:2*pi/n_bin:4*pi-2*pi/n_bin];

noticable_hue_angles=noticable_hues.*angles;

noticable_hue_angles=noticable_hue_angles(noticable_hue_angles>0);

diffs=diff(noticable_hue_angles);

if max(diffs) > pi
    output=2*pi-max(diffs);
else
    output=max(diffs);
end

end

