function [ F ] = hue_model_i( input_image,X)
% input must be HSL, M x N x 3, X is angle but from - inf to +inf. this is
% the i type

hue=input_image(:,:,1);
satulation=input_image(:,:,2);

hue=hue*2*pi/360;    % change hue to radian

alpha=2*pi/(1+exp(-X));   % radian

%ETs=hue.*0;

theta=18/360*2*pi;

bound1= alpha;
bound2= alpha+theta;


distance=  min(min(min(min(min(abs(hue-bound1), abs(hue-(bound1-2*pi))),abs(hue-(bound1+2*pi))),...
    abs(hue-bound2)), abs(hue-(bound2-2*pi))),abs(hue-(bound2+2*pi))); %% I think it's a little stupid. 

index= (~isbetween_bounds(hue,bound1,bound2)).*(~isbetween_bounds(hue,bound1-2*pi,bound2-2*pi)).*(~isbetween_bounds(hue,bound1+2*pi,bound2+2*pi) );

%index=logical(index);
ETs= distance.*index ;

F = sum(sum(ETs.*satulation));
   

end

