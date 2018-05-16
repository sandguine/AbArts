function [ diff_n_regions] = kernel_graphcut_relabel_v2( image_path, target_n_regions,smoooth_weight, initial_n_label, max_smooth)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here
%n_label, re_labeled_L
%This code implements multi-region graph cut image segmentation according
%to the kernel-mapping formulation in M. Ben Salah, A. Mitiche, and 
%I. Ben Ayed, Multiregion Image Segmentation by Parametric Kernel Graph
%Cuts, IEEE Transactions on Image Processing, 20(2): 545-557 (2011).
%The code uses Veksler, Boykov, Zabih and Kolmogorov’s implementation
%of the Graph Cut algorithm. Written in C++, the graph cut algorithm comes
%bundled with a MATLAB wrapper by Shai Bagon (Weizmann). The kernel mapping
%part was implemented in MATLAB by M. Ben Salah (University
%of Alberta). If you use this code, please cite the papers mentioned in the
%accompanying bib file (citations.bib).

%%%%%%%%%%%%%%%%%%%%%%%%%%%Requirements%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This code was tested with:
% • MATLAB Version: 7.12.0.635 (R2011a) for 32-bit wrapper
% • Microsoft Visual C++ 2010 Express

%%%%%%%%%%%%%%%%%%%Generating the mex files in MATLAB%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%>>mex -g GraphCutConstr.cpp graph.cpp GCoptimization.cpp GraphCut.cpp LinkedBlockList.cpp maxflow.cpp

%>>mex -g GraphCutMex.cpp graph.cpp GCoptimization.cpp GraphCut.cpp LinkedBlockList.cpp maxflow.cpp

%%%%%%%%%%%%%%%%%%%%%%%Main inputs and parameters%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Note: The RBF-kernel parameters are given in function kernel RBF.m%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%Example with a color image%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%path = 'Images/Color_image.jpg';
%path='/Users/sandy/Dropbox/Caltech/AbArts/artsScraper/database/AbstractArt/000/2005-60-80.jpg!PinterestLarge.jpg'
%path='/Users/miles/Dropbox/AbArts/artsScraper/database/AbstractArt/000/2005-60-80.jpg!PinterestLarge.jpg'
%path='/Users/miles/Dropbox/AbArts/ArtsScraper/database/Cubism/000/crane-and-pitcher-1945.jpg!PinterestLarge.jpg'

addpath /Users/miles/Dropbox/AbArts/analysis/script/image_analysis/Kernel_GraphCuts
%path='/Users/miles/Dropbox/AbArts/ArtsScraper/database/Impressionism/000/chestnut-trees-louveciennes-spring-1870.jpg!PinterestLarge.jpg'
%path= '/Users/miles/Dropbox/AbArts/ArtsScraper/database/Cubism/a-blue-fan-1915.jpg!PinterestLarge.jpg'

path=image_path;
im = im2double(imread(path)); 
alpha = max_smooth/(1+exp(-smoooth_weight))+1; %The weight of the smoothness constraint;
k = initial_n_label; %The number of regions

 
%addpath D:\Dropbox\AbArts\papers\arts_ml\GCMex


%%%%%%%Example with a SAR image corrupted with a multiplicative noise%%%%%%
%%%%%%%%%%%%%%%%Uncomment the following to run the example)%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% path = 'Images/Sar_image.tif';
% im = im2double(imread(path));
% alpha=1;
% k =4;

%%%%%%%%%%%%%%%%%%%%%%%%%%Example with a brain image%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%Uncomment the following to run the example)%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%path = 'Images\Brain_image.tif';
%im = im2double(imread(path));
%alpha=0.1;
%k =4;


sz = size(im);
Hc=ones(sz(1:2));
Vc=Hc;
i_ground = 0; % rank of the bakground for plotting, 0: the darkest; 
%k-1 the brightest; 99: nowhere

diff=10000;
an_energy=999999999;
iter=0;
iter_v=0;
energy_global_min=99999999;

distance = 'sqEuclidean'; % Feature space distance

%% Initialization: cluster the data into k regions
%tic,
%disp('Start kmeans');
data = ToVector(im);
[idx c] = kmeans(data, k, 'distance', distance,'EmptyAction','drop','maxiter',100);
c=c(find(isfinite(c(:,1))),:);
k=size(c,1);
k_max=k;
%kmean_time=toc,

Dc = zeros([sz(1:2) k],'single');   


%%
if k>1

    while iter < 5 && k>1
        iter=iter+1;
        clear Dc
        clear K
        c;
        %% data term
        for ci=1:k    %% loop over region-index, k in total
            K=kernel_RBF(im,c(ci,:));  %% c(ci,:) is a centroid value (in R,G,B) of each cluster
            Dc(:,:,ci)=1-K;   %% max of K is 1, flipping sign to make it as cost. It's the cost that each pixel takes label ci. 
        end   
        clear Sc
        clear K
        %% The smoothness term
        Sc = alpha*(ones(k) - eye(k));   %% off-diagonals are all alpha. the same cost between different labels.
        gch = GraphCut('open', Dc, Sc, Vc, Hc);   %% create a new graph object
        
        [gch L] = GraphCut('swap',gch);           %% do swap operations until it converges. L is the labels for all pixels.
        [gch se de] = GraphCut('energy', gch);    %% get parameters se: Smoothness energy term.      - de: Data energy term.      - e = se + de
        nv_energy=se+de;                          %% data term + smooothness term
        gch = GraphCut('close', gch);

        if (nv_energy<=energy_global_min)   %% hit a global minimum
            diff=abs(energy_global_min-nv_energy)/energy_global_min;
            energy_global_min=nv_energy;
            L_global_min=L;
            k_max=k;

           % nv_energy;
            iter_v=0;
            % Calculate region Pl of label l
            if size(im, 3)==3 % Color image
            for l=0:k-1    %% loop over labels
                Pl=find(L==l);   %% indices of pixels for label l (vector)
                card=length(Pl);
                K1=kernel_RBF(im(Pl),c(l+1,1));K2=kernel_RBF(im(Pl),c(l+1,2));K3=kernel_RBF(im(Pl),c(l+1,3));   %% gaussian distance from centroid in R,G,B, space for region l
                smKI(1)=sum(im(Pl).*K1); smKI(2)=sum(im(Pl+prod(sz(1:2))).*K2); smKI(3)=sum(im(Pl+2*prod(sz(1:2))).*K3);  %% prod(sz(1:2))=n_pixels, PL is in R space, PL+prod(sz(1:2)) is in G space
                smK1=sum(K1);smK2=sum(K2);smK3=sum(K3);
                if (card~=0)
                    c(l+1,1)=smKI(1)/smK1;c(l+1,2)=smKI(2)/smK2;c(l+1,3)=smKI(3)/smK3;   %% estimated centroid in RGB space.
                else
                    c(l+1,1)=999999999;c(l+1,2)=999999999;c(l+1,3)=999999999;
                end
            end
            end

            if size(im, 1)==1 % Gray-level image
            for l=0:k-1
                Pl=find(L==l);
                card=length(Pl);
                K=kernel_RBF(im(Pl),c(l+1,1));
                smKI=sum(im(Pl).*K);
                smK=sum(K);
                if (card~=0)
                    c(l+1,1)=smKI/smK;
                else
                    c(l+1,1)=999999999;
                end
            end
            end


            c=c(find(c(:,1)~=999999999),:);
            c_global_min=c;
            k_global=length(c(:,1));   %% updated number of clusters
            k=k_global;

        else     %% not hit the global min
            iter_v=iter_v+1;            %% if not hit the global minimum 5 times, finish loop.
            %---------------------------------
            %       Begin updating labels
            %---------------------------------
            % Calculate region Pl of label l
            if size(im, 3)==3 % Color image 
            for l=0:k-1           
                Pl=find(L==l);
                card=length(Pl);
                K1=kernel_RBF(im(Pl),c(l+1,1));K2=kernel_RBF(im(Pl),c(l+1,2));K3=kernel_RBF(im(Pl),c(l+1,3));
                smKI(1)=sum(im(Pl).*K1); smKI(2)=sum(im(Pl+prod(sz(1:2))).*K2); smKI(3)=sum(im(Pl+2*prod(sz(1:2))).*K3);
                smK1=sum(K1);smK2=sum(K2);smK3=sum(K3);
                % Calculate contour Cl of region Pl
                if (card~=0)
                    c(l+1,1)=smKI(1)/smK1;c(l+1,2)=smKI(2)/smK2;c(l+1,3)=smKI(3)/smK3;
                else
                    c(l+1,1)=999999999;c(l+1,2)=999999999;c(l+1,3)=999999999;
                    area(l+1)=999999999;
                end
            end
            end

            if size(im, 3)== 1 % Gray-level image 
            for l=0:k-1           
                Pl=find(L==l);
                card=length(Pl);
                K=kernel_RBF(im(Pl),c(l+1,1));
                smKI=sum(im(Pl).*K);
                smK=sum(K);
                % Calculate contour Cl of region Pl
                if (card~=0)
                    c(l+1,1)=smKI/smK;
                else
                    c(l+1,1)=999999999;
                    area(l+1)=999999999;
                end
            end
            end

            c=c(find(c(:,1)~=999999999),:);
            k=length(c(:,1));
        end
    end

    L=L_global_min;
    energy_global_min;
    c=c_global_min;


    %iter;
    %%
    %Show the results
    % 
    % if size(im, 3)==3 % Color image 
    % img=zeros(sz(1),sz(2),3);
    % j=1;
    % imagesc(im); axis off; hold on; 
    % 
    % for i=0:k_max-1   %% loop over labels
    %     LL=(L_global_min==i);
    %     is_zero=sum(sum(LL));
    %     if is_zero
    %          img(:,:,1)=img(:,:,1)+LL*c(j,1);    %% inserting centroid color to cluster locations
    %          img(:,:,2)=img(:,:,2)+LL*c(j,2);
    %          img(:,:,3)=img(:,:,3)+LL*c(j,3);
    %          j=j+1;
    %     end
    %     
    %     if i~=i_ground
    %         color=[rand rand rand];
    %         contour(LL,[1 1],'LineWidth',2.5,'Color',color); hold on;
    %     end
    % end
    % figure(2);
    % imagesc(img); axis off;
    % end
    % 
    % if size(im, 3)==1 % Gray-level image 
    % img=zeros(sz(1),sz(2));
    % j=1;
    % imagesc(im); axis off; hold on; colormap gray; 
    % 
    % for i=0:k_max-1
    %     LL=(L_global_min==i);
    %     is_zero=sum(sum(LL));
    %     if is_zero
    %          img(:,:,1)=img(:,:,1)+LL*c(j,1);
    %          j=j+1;
    %     end
    %     if i~=i_ground
    %         color=[rand rand rand];
    %         contour(LL,[1 1],'LineWidth',2.5,'Color',color); hold on;
    %     end
    % end
    % figure(2);
    % imagesc(img); axis off;
    % end


    %%
    %figure(3)


    if size(im, 3)==3 % Color image 
    %img=zeros(sz(1),sz(2),3);
    %j=1;
    %imagesc(im); axis off; hold on; 

    for i=0:k_max-1   %% loop over labels
        LL=(L_global_min==i);

        is_zero=sum(sum(LL));
        if is_zero
             LLL(:,:,i+1)=(bwlabel(LL)*20*(i+1)^2+1).^2;

           %  figure(100+i)
           %  color=[rand rand rand];
           %  contour(LLL(:,:,i+1))


        end


    end

    end
    new_L=prod(LLL+1,3);


    index=unique(reshape(new_L,[],1));

    re_labeled_L=new_L;

    for i=1:length(index)
       re_labeled_L( new_L==index(i) ) = i-1;
    end


    %%
    % figure(5);
    % if size(im, 3)==3 % Color image 
    % img=zeros(sz(1),sz(2),3);
    % j=1;
    % imagesc(im); axis off; hold on; 
    % 
    n_label=length(index);
    % 
    % 
    % for i=0:length(index)-1   %% loop over labels
    %     LL=( re_labeled_L==i);
    %     is_zero=sum(sum(LL));
    %     if is_zero
    %          img(:,:,1)=img(:,:,1)+LL*rand;    %% inserting centroid color to cluster locations
    %          img(:,:,2)=img(:,:,2)+LL*rand;
    %          img(:,:,3)=img(:,:,3)+LL*rand;
    %          j=j+1;
    %     end
    %     
    %     if i~=i_ground
    %         color=[rand rand rand];
    %         contour(LL,[1 1],'LineWidth',2.5,'Color',color); hold on;
    %     end
    % end
    % figure(6);
    % imagesc(img); axis off;
    % end



    diff_n_regions=(n_label-target_n_regions)^2;
    
    if n_label==1
         diff_n_regions=1000;
%     elseif  n_label==2
%        
%         diff_n_regions=100;
%     elseif  n_label==3
%        
%         diff_n_regions=50;
    end
        
    
        
else
    diff_n_regions=1000;
end

end


