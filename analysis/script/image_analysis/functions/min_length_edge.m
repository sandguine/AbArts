function [l_out,contrast] = min_length_edge(variable,image_x)
%UNTITLED Summary of this function goes here
a=variable(1);
b=variable(2);

l_x=length(image_x);


x1=floor(l_x/(1+exp(-a)))+1;

x2=floor(l_x/(1+exp(-a-b)))+1;


if x1==x2
    contrast=0;
else
    contrast=max(image_x(x1:x2))-min(image_x(x1:x2));
end

if contrast >0.95
    l_out=x2-x1;
else
    l_out=l_x;
end

end

