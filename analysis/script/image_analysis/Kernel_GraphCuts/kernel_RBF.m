function K=kernel_RBF(Img,value)

% RBF-kernel parameters
a = 2;
b = 1;
sigma = .5;

sz=size(Img);

if length(sz)==3  %loop over color
    for k=1:3
        Kint(:,:,k)=Img(:,:,k)-value(k);   %% distance between pixel and (normally) centroids in R,G,B space (if value spesify the centroid).
    end
    Kint=Kint.^a;  %% euclid distance if a=2
    Kint=squeeze(sum(Kint,3));  %% just sume over color
    K=exp(-Kint/sigma^2);     %% projection to kernel gaussian space
else
    K=exp(-(Img-value).^a/sigma^2);  
end