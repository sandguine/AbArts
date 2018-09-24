function [masks] = srm_masks(im)
    addpath('./srm');
    % figure;imshow(im);
    if size(im,3) ~= 3
        masks = nan;
    end

    im = double(im);
    num_segs = 0;
    pwr = 4;
    while num_segs < 3 
        Qlevels = 2.^pwr;
        [maps,~]=srm(im,Qlevels);
        num_segs = length(unique(maps{1,1}));
        pwr = pwr+1;
    end
    % Iedge = srm_plot_segmentation(images,maps);
    % figure;imshow(im); hold on; imshow(Iedge); hold off;
    masks = maps{1,1};
end