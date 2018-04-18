function [ output ] = mean_s( input_image )
% input must be HSL, M x N x 3

output = mean(mean(input_image(:,:,2)));


end

