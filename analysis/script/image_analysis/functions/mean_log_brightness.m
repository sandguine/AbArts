function [ output ] = mean_log_brightness( input_image )
% input must be GRB
x=mean(input_image,3);  % brightness
output =1/( numel(x))* sum(sum(log(0.001+x)));


end

