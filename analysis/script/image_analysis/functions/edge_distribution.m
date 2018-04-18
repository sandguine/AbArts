function [ max_k ] = edge_distribution( input_image )
% input must be GRB
%x=mean(input_image,3);  % brightness

alpha=0.2;
f = fspecial('laplacian',alpha);

for k=1:3
    x=input_image(:,:,k);
    
    y=imgaussfilt(x);
    
    z= imfilter(y,f,'replicate');
    
    z_s(:,:,k)=abs(z);
    
    clearvars x y z
end

edge_image=mean(z_s,3);

edge_x=sum(edge_image,1);
edge_y=sum(edge_image,2);

norm_edge_x = (edge_x - min(edge_x)) / ( max(edge_x) - min(edge_x) );
norm_edge_y = (edge_y - min(edge_y)) / ( max(edge_y) - min(edge_y) );
    





end

