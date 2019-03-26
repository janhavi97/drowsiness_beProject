clc;
clear all;
close all;
DATASET = csvread('data.csv',1,1);                                                        % Define Serial Port Number
%load the UCI dataset
[ROWS,COLS] = size(DATASET);
for ii = 1: ROWS                                                             %Make all the labels [2,3,4] as 0
    if(DATASET(ii,COLS)~=1)
        DATASET(ii,COLS)=0;                                                                            
    end
end 
Training_Set_input = DATASET(1:(0.75*ROWS),:);                                       %Creating a 75:25 training and testing set
Testing_Set_input = DATASET(round(0.75*ROWS)+1:end,:);
%% Create a database for training and testing vectors
[DATASET_NEW, ROW, COL] = INPUT_DATA_PROCESSING(DATASET);

%% Segregating training and testing set
Training_Set = DATASET_NEW(1:round(0.75*ROW),:);                                       %Creating a 75:25 training and testing set
Testing_Set = DATASET_NEW(round(0.75*ROW)+1:end,:);

%% Train the Data
[trainedClassifier, validationAccuracy] = trainClassifier(Training_Set);    %use trained classfier to predict the outcome

save('SVM_Classifier.mat','trainedClassifier','DATASET_NEW','DATASET')
fprintf('The Validation Accuracy is is : %0.2f %% \n',validationAccuracy*100)
labels = trainedClassifier.predictFcn(Testing_Set(:,1:21));
CP = classperf(Testing_Set(:,22),labels);
fprintf('The Testing Accuracy is is : %0.2f %% \n',CP.Correctrate*100)


