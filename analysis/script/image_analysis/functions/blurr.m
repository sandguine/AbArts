function [ max_k ] = blurr( input_image,threshold )
% input must be GRB
x=mean(input_image,3);  % brightness
y=fft2(x);
z=fftshift(y);

imagesc(abs(z).^2/numel(z)>threshold)
n=size(z,1);
m=size(z,2);
       
   
[kx_index, ky_index] = find(abs(z).^2/numel(z)>threshold);

kx_index_unique=unique(kx_index);

ky_index_unique=unique(ky_index);

is_x=1:n;
is_y=1:m;

ks_x=2*(is_x-n/2)/n;
ks_y=2*(is_y-m/2)/m;

max_k=max(max(ks_x(kx_index_unique)),max(ks_y(ky_index_unique)));




end

