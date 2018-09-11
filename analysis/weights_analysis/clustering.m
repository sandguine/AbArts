%%kiigaya@gmail.com

clear all
close all

%%

load('/Users/miles/Dropbox/AbArts/analysis/final_results/w_mturk_fit_ind.mat')


w=WEIGHTS;

w=w';

[pcs, scores]=pca(w);

pc1=pcs(:,1);

pc2=pcs(:,2);


pc3=pcs(:,3);




axis1=find(abs(pc1)==max(abs(pc1)));


axis2=find(abs(pc2)==max(abs(pc2)));

axis3=find(abs(pc3)==max(abs(pc3)));


opts = statset('Display','final');

[idx,C] = kmeans(w,3,'Distance','cityblock',...
    'Replicates',5,'Options',opts);


X=w;

figure;
plot3(X(idx==1,axis1),X(idx==1,axis2),X(idx==1,axis3),'r.','MarkerSize',12)
hold on
plot3(X(idx==2,axis1),X(idx==2,axis2),X(idx==2,axis3),'b.','MarkerSize',12)

plot3(X(idx==3,axis1),X(idx==3,axis2),X(idx==3,axis3),'g.','MarkerSize',12)

plot3(C(:,1),C(:,2),C(:,3),'kx',...
     'MarkerSize',15,'LineWidth',3) 
legend('Cluster 1','Cluster 2','Centroids',...
       'Location','NW')
title 'Cluster Assignments and Centroids'

xlabel(W_names(axis1))
ylabel(W_names(axis2))
zlabel(W_names(axis3))

hold off

figure(2)

biplot(pcs(:,1:3),'Scores',scores(:,1:3));

%%



load('/Users/miles/Dropbox/AbArts/analysis/final_results/w_seven_fit_ind.mat')


w=WEIGHTS;

w=w';

[pcs, scores]=pca(w);

pc1=pcs(:,1);

pc2=pcs(:,2);


pc3=pcs(:,3);




axis1=find(abs(pc1)==max(abs(pc1)));


axis2=find(abs(pc2)==max(abs(pc2)));

axis3=find(abs(pc3)==max(abs(pc3)));


opts = statset('Display','final');

[idx,C] = kmeans(w,3,'Distance','cityblock',...
    'Replicates',5,'Options',opts);


X=w;

figure;
plot3(X(idx==1,axis1),X(idx==1,axis2),X(idx==1,axis3),'r.','MarkerSize',12)
hold on
plot3(X(idx==2,axis1),X(idx==2,axis2),X(idx==2,axis3),'b.','MarkerSize',12)

plot3(X(idx==3,axis1),X(idx==3,axis2),X(idx==3,axis3),'g.','MarkerSize',12)

plot3(C(:,1),C(:,2),C(:,3),'kx',...
     'MarkerSize',15,'LineWidth',3) 
legend('Cluster 1','Cluster 2','Centroids',...
       'Location','NW')
title 'Cluster Assignments and Centroids'

xlabel(W_names(axis1))
ylabel(W_names(axis2))
zlabel(W_names(axis3))

hold off

figure(2)

biplot(pcs(:,1:3),'Scores',scores(:,1:3));
