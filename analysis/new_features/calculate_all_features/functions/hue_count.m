function [ output ] = hue_count( input_image,n_bin, threshold )
% input must be HSV, M x N x 3, 0<threshould<1

hue=input_image(:,:,1);

target_saturation= (input_image(:,:,2) > 0.2);
target_value= (input_image(:,:,3) > 0.15 & input_image(:,:,3) < 0.95 );

index=target_saturation.*target_value;

hue_to_analyze=hue(index>0);

h=histogram(hue_to_analyze, n_bin);
counts=h.BinCounts;
Q=max(counts);

output=sum(counts>threshold*Q);



end

