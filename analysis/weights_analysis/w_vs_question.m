clear all
close all



load('/Users/miles/Dropbox/AbArts/analysis/final_results/w_mturk_fit_ind.mat')

load('/Users/miles/Dropbox/AbArts/analysis/questionairre_analysis/clean_survey_data.mat')

qs=load('/Users/miles/Dropbox/AbArts/analysis/questionairre_analysis/clean_survey_data.mat')

w=WEIGHTS;

w=w';



z= array2table([w(:,[5,18,22,31]),ad(:,2),age,deg,mus,ra],'VariableNames', {'conc','valence','temp','dyn','adeg','age','deg','mus','race'});


%z2=table([w,ad,age,deg,deg,mus,ra]);

%Z=join(z1, z2);

%Z.Properties.VariableNames =[W_names; fieldnames(qs)]'

figure(1)
corrplot(z,'testR','on')



z= array2table([w(:,1:4),ad(:,2),age,deg,mus,ra],'VariableNames', {'size2ndL','Entropy2N','Satcon','BRcon','adeg','age','deg','mus','race'});


%z2=table([w,ad,age,deg,deg,mus,ra]);

%Z=join(z1, z2);

%Z.Properties.VariableNames =[W_names; fieldnames(qs)]'

figure(2)
corrplot(z,'testR','on')


z= array2table([w(:,6:9),ad(:,2),age,deg,mus,ra],'VariableNames', {'Entr','Satu1','Color1','Hue1','adeg','age','deg','mus','race'});

figure(3)
corrplot(z,'testR','on')



%%%

%%



for fi=1:4
    figure(11+fi)

    if fi==1
        y=mus;
        title('museum visits')
    elseif fi==2
        y=ad(:,2);
        title('art degree')
    elseif fi ==3
        y=deg;
        title('level of degree')
    else
        y=age;
        title('age')
    end
        
       
    X=[w(:,1:40),ones(size(w,1),1)];


    [b,bint,r,rint,stats{fi}] = regress(y,X);
    
    b=b(1:end-1)
    
    bint=bint(1:end-1,:)

    

    [~,J] = sort(b,'descend');


    xlabels =W_names(J);


    xticks = 1:size(WEIGHTS,1);

    errorbar(1:size(WEIGHTS,1),b(J),b(J)-bint(J,1),bint(J,2)-b(J),'.'); grid on; set(gca, 'Xtick', xticks, 'XTicklabel', xlabels);xtickangle(45);
    ylabel('Weight of Feature weight');
    xlabel('Feature Weight');
   % title('weights to predict museum visits');
    hold all
    bar(1:40,b(J))
    
    
    if fi==1
       
        title('museum visits')
    elseif fi==2
       
        title('art degree')
    elseif fi ==3
       
        title('level of degree')
    else
      
        title('age')
    end
    
    figure(20)
    subplot(2,2,fi)
    histogram(r)
    if fi==1
       
        title('museum visits')
    elseif fi==2
       
        title('art degree')
    elseif fi ==3
       
        title('level of degree')
    else
      
        title('age')
    end
    
        
end
%%

