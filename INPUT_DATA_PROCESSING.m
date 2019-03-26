
%% Program for finding ALPHA, BETA and Theta values
function [ DATASET_NEW, ROW, COL] = INPUT_DATA_PROCESSING(DATASET)

%%Segregating the DATABASE

[ROW, COL] = size(DATASET);
Healthy_count = 0;
for ii = 1: ROW                                                             %Make all the labels [2,3,4] as 0
    if(DATASET(ii,COL)~=1)
        DATASET(ii,COL)=0;
        Healthy_count = Healthy_count+1;                                    %count number of healthy patients                                           
    end
end  
Deceased_count = ROW-Healthy_count;                                         %count number of deceased patients

%% Calculating the training or testing vectors
v1 = zeros(ROW,6);
v2 = zeros(ROW,6);
v3 = zeros(ROW,6);
ENERGY = zeros(ROW,1);
HOMOGENEITY = zeros(ROW,1);
CORRELATION = zeros(ROW,1);
Label = zeros(ROW,1);
for ii=1:ROW
    % calculating THETA parameters
    a2=fir1(10,[0.03125 0.0625],'bandpass');  %%% THETA%%
    b2=filter(a2,1,DATASET(ii,1:COL-1));
    meantheta=mean2(b2) ;                   %% MEAN%%
    squared_dif = (b2 - meantheta).^2;
    variancetheta = mean2(squared_dif);     %% VARIANCE %%                             %%%%%% calculate mean %%%%%%%%%%                            %%%%%%calculate variance %%%%%%%%%%
    stddevtheta=std2(b2);                   % standard deviation %
    maxValuetheta= max(b2(:));            %maximum value %
    minValuetheta = min(b2(:))  ;           %% minimum value%%
    Ts=0.00390;   %Sampling time 
    Fs=1/Ts;    % Sampling period
    powertheta= (norm(b2)^2)/length(b2) ;   %% POWER%%
    v1(ii,1)=meantheta; 
    v1(ii,2)=variancetheta; 
    v1(ii,3)=stddevtheta; 
    v1(ii,4)=maxValuetheta; 
    v1(ii,5)=minValuetheta; 
    v1(ii,6)=powertheta; 
    
    % calculating ALPHA parameters
    a3=fir1(10,[0.0625 0.1093],'bandpass'); %%% ALPHA %%%
    b3=filter(a3,1,DATASET(ii,1:COL-1));
    meanalpha=mean2(b3);  
    squared_dif = (b3 - meanalpha).^2;
    
    variancealpha = mean2(squared_dif);                             %%%%%%calculate variance %%%%%%%%%%
    stddevalpha=std2(b3) ;                      %%%calculate standard deviation %%%%%%%%%%
    maxValuealpha = max(b3(:)) ;           %%%%%%calculate maximum value %%%%%%%%%%
    minValuealpha = min(b3(:)) ;
    Ts=0.00390;   %Sampling time 
    Fs=1/Ts;    % Sampling period
    % t=[0:Ts:T]; %define simulation time
    poweralpha = (norm(b3)^2)/length(b3);
    %v2=[meanalpha,variancealpha,stddevalpha,maxValuealpha,minValuealpha,poweralpha] ;
    v2(ii,1)=meanalpha; 
    v2(ii,2)=variancealpha; 
    v2(ii,3)=stddevalpha; 
    v2(ii,4)=maxValuealpha; 
    v2(ii,5)=minValuealpha; 
    v2(ii,6)=poweralpha; 
    
    % calculating BETA parameters
    a4=fir1(10,[0.1093 0.2343],'bandpass');
    b4=filter(a4,1,DATASET(ii,1:COL-1));
    meanbeta=mean2(b4) ;%%%%%% calculate mean %%%%%%%%%%
    squared_dif = (b4 - meanbeta).^2;
    variancebeta = mean2(squared_dif) ;                            %%%%%%calculate variance %%%%%%%%%%
    stddevbeta=std2(b4);                       %%%calculate standard deviation %%%%%%%%%%
    maxValuebeta = max(b4(:)) ;           %%%%%%calculate maximum value %%%%%%%%%%
    minValuebeta = min(b4(:)) ;  
    Ts=0.00390;   %Sampling time 
    Fs=1/Ts;    % Sampling period
    % t=[0:Ts:T]; %define simulation time
    powerbeta = (norm(b4)^2)/length(b4);
    %v3=[meanbeta,variancebeta,stddevbeta,maxValuebeta,minValuebeta,powerbeta];
    v3(ii,1)=meanbeta; 
    v3(ii,2)=variancebeta; 
    v3(ii,3)=stddevbeta; 
    v3(ii,4)=maxValuebeta; 
    v3(ii,5)=minValuebeta; 
    v3(ii,6)=powerbeta; 
    x=DATASET(ii,1:COL-1);
    
    % Calculating GLCM parameters
    glcm = graycomatrix(x);
    stats1 = graycoprops(glcm,{'energy'});
    stats2 = graycoprops(glcm,{'homogeneity'});
    stats3 = graycoprops(glcm,{'correlation'});
    ENERGY(ii) = stats1.Energy;
    HOMOGENEITY(ii) = stats2.Homogeneity;
    CORRELATION(ii) = stats3.Correlation;
    
    %% preparing a Label Matrix
    Label(ii,1) = DATASET(ii,COL);
end

DATASET_NEW = cat(2,v1,v2,v3,ENERGY,HOMOGENEITY,CORRELATION,Label);
%DATASET_NEW2 = cat(2,v1,v2,v3,Label);
end