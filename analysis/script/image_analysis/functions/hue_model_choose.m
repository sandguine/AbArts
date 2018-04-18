function [ best_k, F_k, best_angles ] = hue_model_choose( input_image, n_sample)
% input must be HSL, n_sample is n of runs for fminsearch

function_name={'hue_model_i','hue_model_ii','hue_model_v','hue_model_Y','hue_model_L','hue_model_X','hue_model_T'};
n_variable=1;

for k=1:7
    
    function_current=function_name{k};
    
    y=NaN(n_sample,n_variable);
    fval=10000000*ones(1,n_sample);
    
    
     for sample = 1:n_sample
        initial=-4+8*rand(1,n_variable); 
        %options = optimset('MaxFunEvals', 100000,'MaxIter',20000);      
        [y(sample,1),fval(sample)]=fminsearch(@(x)  feval(function_current, input_image, x), initial);

     end

    best=y(fval==min(fval),1);
    best_angles{k}=mod(best(1,1), 2*pi);
    F_k(k,1)=min(fval);
   

end


best_k=find(F_k==min(F_k));






end

