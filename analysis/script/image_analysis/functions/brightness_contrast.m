function [ contrast ] = brightness_contrast( input_image, n_bin )
% input must be GRB
x=mean(input_image,3);  % brightness
h=histogram(x, n_bin);
counts=h.BinCounts;

max_bin=find(counts==max(counts));

fraction =max(counts)/sum(counts);
k=1;
while fraction <0.98
    
    current_total=sum(counts(max(max_bin-k,1):min(max_bin+k,h.NumBins)));
    fraction=current_total/sum(counts);
    k=k+1;
    
end


contrast=(min(max_bin+k,h.NumBins)-(max(max_bin-k,1)+1))*h.BinWidth;

end

