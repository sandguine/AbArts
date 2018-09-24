function [ ratio ] = edge_distribution( input_image,n_sample )
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
    

n_variable=2;

for i=1:2
    if i==1
        input=norm_edge_x;
    else
        input=norm_edge_y;
    end
    yy=NaN(n_sample,n_variable);
    fval=10000000*ones(1,n_sample);

    n_variable=2;
     for sample = 1:n_sample
        initial=-4+8*rand(1,n_variable); 
        %options = optimset('MaxFunEvals', 100000,'MaxIter',20000);      
        [yy(sample,:),fval(sample)]=fminsearch(@(x0)  feval('min_length_edge', x0, input), initial);

     end

    l_min(i)=min(fval);
end

ratio=l_min(1)*l_min(2)/(length(edge_x)*length(edge_y));





end

