function [ output_args ] = relabel_disconnected_regions( labels )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

[l_h,l_w]=size(labels);
n_labels=length(unique(labels));

for h_i=1:l_h
    
    uni_labels=unique(labels(h_i,:));
    
    n_label_row=length(uni_labels);
    
    if n_label_row>1
        
        label_current_row=labels(h_i,:);
        
        for j_label=1:n_label_row
            
            current_label=uni_labels(j_label);
            
            xs=find(label_current_row==current_label);
            
            find(diff(xs)>1)
        
        
        
    


end

