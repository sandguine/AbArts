function [ F ] = hue_model_ii( input_image,X)
% input must be HSL, M x N x 3, X is angle but from - inf to +inf. this is
% the v type

hue=input_image(:,:,1);
satulation=input_image(:,:,2);

hue=hue*2*pi/360;    % change hue to radian

alpha=2*pi/(1+exp(-X));   % radian

ETs=hue.*0;

theta1=18/360*2*pi;

theta2=theta1+(50-(2.5+2.5))/100*2*pi;
theta3= theta2 + 18/360*2*pi;

bound1= alpha;
bound2= alpha+theta1;

bound3= alpha+theta2;
bound4= alpha+theta3;

distance= min(min(min(min(min(min(min(min(min(min(min(abs(hue-bound1), abs(hue-(bound1-2*pi))),abs(hue-(bound1+2*pi))),...
    abs(hue-bound2)), abs(hue-(bound2-2*pi))),abs(hue-(bound2+2*pi))), ...
    abs(hue-bound3)), abs(hue-(bound3-2*pi))),abs(hue-(bound3+2*pi))),...
    abs(hue-bound4)), abs(hue-(bound4-2*pi))),abs(hue-(bound4+2*pi))); %% I think it's a little stupid. 

index= (~isbetween_bounds(hue,bound1,bound2)).*(~isbetween_bounds(hue,bound1-2*pi,bound2-2*pi)).*(~isbetween_bounds(hue,bound1+2*pi,bound2+2*pi)).* ...
  (~isbetween_bounds(hue,bound3,bound4)).*(~isbetween_bounds(hue,bound3-2*pi,bound4-2*pi)).*(~isbetween_bounds(hue,bound3+2*pi,bound4+2*pi) );

ETs = distance.*index ;

F = sum(sum(ETs.*satulation));
   

end

