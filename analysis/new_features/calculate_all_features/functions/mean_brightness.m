function [ output ] = mean_brightness( input_image_RGB )
% input must be RGB, M x N x 3

output = mean(mean(mean(input_image_RGB)));


end

