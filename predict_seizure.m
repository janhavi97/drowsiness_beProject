clc;clear all;close all;
load('SVM_Classifier.mat','trainedClassifier','DATASET_NEW','DATASET');
Val = randi(size(DATASET,1),1);
Reading = DATASET(Val,:);
label = trainedClassifier.predictFcn(DATASET_NEW(Val,1:21));
if(label==1)
    plot(Reading)
    title('The patient can get epeleptic seizures in future')
    disp('The patient can get epeleptic seizures in future')
else
    plot(Reading)
    title('The Patient is healthy')
    disp('The Patient is healthy')
end

xlabel('time');
ylabel('Amplitude')
%title('EEG signal')
axis ( [1 178 min(min(DATASET)) max(max(DATASET))] )
grid on



