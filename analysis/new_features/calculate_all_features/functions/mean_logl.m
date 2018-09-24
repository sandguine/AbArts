function [ output ] = mean_logl( input_image )
% input must be HSL, M x N x 3
x=input_image(:,:,3);
output =1/( numel(x))* sum(sum(log(0.001+x)));


end

