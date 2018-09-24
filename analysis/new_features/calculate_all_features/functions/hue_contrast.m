function [ output ] = hue_contrast( input_image,n_bin,threshold)
% input must be HSV, M x N x 3, 0<threshould<1, unit is radian

hue=input_image(:,:,1);

target_saturation= (input_image(:,:,2) > 0.2);
target_value= (input_image(:,:,3) > 0.15 & input_image(:,:,3) < 0.95 );

index=target_saturation.*target_value;

hue_to_analyze=hue(index>0);

h=histogram(hue_to_analyze, n_bin);
counts=h.BinCounts;
Q=max(counts);

noticable_hues=(counts>threshold*Q);

noticable_hues=[noticable_hues,noticable_hues];

angles=[0:2*pi/n_bin:4*pi-2*pi/n_bin];

noticable_hue_angles=noticable_hues.*angles;

noticable_hue_angles=noticable_hue_angles(noticable_hue_angles>0);

diffs=diff(noticable_hue_angles);

if max(diffs) > pi
    output=2*pi-max(diffs);
else
    output=max(diffs);
end


if isempty(output)
    output=0;
end
end

