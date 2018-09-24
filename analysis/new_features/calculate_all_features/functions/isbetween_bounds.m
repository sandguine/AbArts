function [tf] = isbetween_bounds(x,bound1, bound2)
% test if x is between bound1 and bound2
tf = (bound1<=x & x<= bound2);
end

