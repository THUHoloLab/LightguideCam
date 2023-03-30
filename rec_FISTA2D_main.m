%% add paths
clear;clc
addpath('.\measurement\')
addpath('.\src\')
load("PSF_distribution_interp.mat")  % calibrated weight

%% parameters and preprocessing
flag=1;                 % 1:RGB  2:mono
resize_ratio=1;         % Reduce image size with rate           0<resize_ratio<1
distance=0.5;           % reconstruction distance (m) 
PSF_fitting_num=200;    % Number of equivlant sub-cameras       0<PSF_fitting_num<200
tau=1e-3;               % Regularization term weight
iter_num=50;            % Max iterations of the main loop

measurement=imread('flower.bmp'); 
measurement=double(imresize(measurement,'OutputSize',2*round([2056,2464]./resize_ratio./2)));
measurement=measurement./max(max(measurement));

switch flag
    case 1 % RGB
        for channel=1:3
        measurement_channel=squeeze(measurement(:,:,channel));
        A = @(x) (forward_model_2D(x,PSF_distribution_interp,PSF_fitting_num,distance));
        AT = @(x) (forward_model_2D_transpose(x,PSF_distribution_interp,PSF_fitting_num,distance)); 
        tic;    v=FISTA(measurement_channel,A,AT,tau,iter_num);    toc
        rec(:,:,channel)=v;
        end
    case 2 % mono-chorme       
        measurement=rgb2gray(measurement);
        A = @(x) (forward_model_2D(x,PSF_distribution_interp,PSF_fitting_num,distance));
        AT = @(x) (forward_model_2D_transpose(x,PSF_distribution_interp,PSF_fitting_num,distance));  
        tic;    v=FISTA(2,measurement,A,AT,tau,iter_num);    toc   
        rec=v;
end

rec=uint8(rec);
save("results\flower_rec.mat","rec")

%% Display

addpath("colorplus\")
figure(1)
set(gcf,'Units','centimeter','Position',[1 1 2 2.4]*6);
subplot('Position',[0,0,1,1])
imagesc(rot90(measurement,3))
set(gca,'xtick',[],'ytick',[])
box off
if flag==2; colormap("gray"); end

figure(2)
set(gcf,'Units','centimeter','Position',[1 1 2 2.4]*6);
subplot('Position',[0,0,1,1])
imagesc(rot90(rec,3))
set(gca,'xtick',[],'ytick',[])
box off
if flag==2; colormap("gray"); end
