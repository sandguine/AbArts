function [ pvalue_mean ] = permutation_test_mean(x1,x2, n_perm )
%UNTITLED17 Summary of this function goes here
%   Detailed explanation goes here

x1(isnan(x1))=[];
x2(isnan(x2))=[];

original_matrix=[x1;x2];
%diffs0=std(nicep(:,i))-std(nastyp(:,i));
diffs0_mean=mean(x1)-mean(x2);
n_elements1=length(x1);
n_elements2=length(x2);
%eps=NaN(1,n_perm);
eps_mean=NaN(1,n_perm);
for i=1:n_perm
    index=randperm(n_elements1+n_elements2);
    new_matrix=original_matrix(index,1);
    new_x1=new_matrix(1:n_elements1,1);
    new_x2=new_matrix(n_elements1+1:end,1);
    %diffs=std(new_mean_happys)-std(new_mean_nastys);
    
    diffs_mean=mean(new_x1)-mean(new_x2);
    %eps(i)=diffs;
    eps_mean(i)=diffs_mean;
    %diffs2(i)=diffs(2);
end

pvalue_mean=min(sum(eps_mean>diffs0_mean)/n_perm,sum(eps_mean<diffs0_mean)/n_perm);
%figure
%hist(eps_mean)


end

