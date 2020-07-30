%% Exercise 2:
%
% The goal of this exercise is to implement a support vector machine 
% classifier for a 2-class problem. (SVM; see help svm in Matlab, especially 
% fitcsvm()).
% Furthermore, a ROC curve should be plotted.
%
% INFORMATION ON THE USED DATESET:
% As dataset, the public "German Credit Data" dataset is used. 
% Source: https://archive.ics.uci.edu/ml/datasets/statlog+(german+credit+data)
% Its a 2-class dataset and it classifies people by a set of attributes as
% good (class 1) or bad (class 2) credit risks. Therefore, it the classifier 
% outputs class 1, the person would get a credit, and vice versa.
% Since the data consists of categorical attributes as well, those are 
% one-hot encoded below. Please, check the mapping below. You can directly 
% work with the already mapped data, which is a struct in the format we 
% defined in the first excercise.
% The mapped dataset has 59 dimensions. Therefore, you might want to use
% the provided function for dimensionality reduction (via PCA) below.
%

clc;
clear;
close all;

path2tools = '../PR_Toolbox/';
addpath(path2tools);

%% read in data from CSV and map them to our data format (no change needed)
filename = 'german.csv';
fileID = fopen(filename);
headerLine = textscan(fileID, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s', 1, 'delimiter', ',');
content = textscan(fileID, '%s %f %s %s %f %s %s %f %s %s %f %s %f %s %s %f %s %f %s %s %f', 'delimiter', ',', 'HeaderLines', 1);
fclose(fileID);

data.header = headerLine(:,1:end-1);
data.y = content{1,end}(:); % last column contains the target labels (credit: yes or no)
nrOfFeatures = length(data.header)-1; % all columns minus target column

% generate numeric features (textual data is one-hot encoded)
currentDim = 1;
for f=1:nrOfFeatures
    columnData = content{1,f};
    
    if(iscell(columnData)) % textual data
        [uniqueData, ~, index] = unique(columnData);
        featureData = accumarray([(1:numel(index)).' index], 1); % one-hot encoded data with dim > 1
        nrOfNewDims = size(featureData, 2);
    else % numeric data
        featureData = columnData;
        nrOfNewDims = 1;
    end
    
    data.x(:, currentDim:currentDim+nrOfNewDims-1) = featureData(:, 1:nrOfNewDims);
    currentDim = currentDim + nrOfNewDims;
end

%% Sampling
% divide data into training and validation data with the sampling function
% [trainData, validData] = sampling(data, 0.7, 'stratified'); % use 70% for training

[trainData, validData] = sampling(data, 0.7, 'stratified'); % use 70% for training

%% OPTIONAL: Preprocessing
% TODO: What about preprocessing (scaling) here? 
% Check and apply the scaling functions from your toolbox (scaleInterval,
% zScore and atan).. Does it change the results?

[trainData, coeffs] = scaleArcTan(trainData);

% coefficients as normalization of the training data has been done
[validData, ~] = scaleArcTan(validData, coeffs);

%% OPTIONAL: Dimension reduction with PCA
% TODO: what about a PCA for dimension reduction here? Does it change the results?
% With the dimReduct parameter you can select the target dimensionality.
% Hint: The function outputs the resulting data variance via the command
% line. Usually, a data variance of >90 % is recommended. Engineering task!
% (Check the function for more info on that)

dimReduct=29;  
[trainData, coeffs_PCA] = calcPrincipalComponents(trainData, dimReduct);
if(dimReduct <= 3)
    plotData(trainData);
    title('PCA on train data');
end

% apply the PCA function on the validation data (with given coeffs)
[validData] = calcPrincipalComponents(validData, dimReduct, coeffs_PCA);


%% TASK 1: classification with support vector machine
% TODO: train a SVM classifier using only the train data
% Goals: 1. predict the validation set as good as possible and 2.
% optimize the classifier for a high precision of class 1. What does this 
% mean in the context of this dataset? 
% Examine the most important SVM parameters and find a good setup for the 
% given dataset.

% train a SVM with the traindata
svm_model = fitcsvm(trainData.x,trainData.y,'Kernelfunction','gaussian','Cost', [0 1;3 0], 'Standardize', true, 'KernelScale','auto');

% classify the validation set using the trained SVM
[validData.p validData.scores] = predict(svm_model, validData.x);

%% Evaluation of the classifier (confusion matrix + performance measures)
% analyse classification rates with the confusion plot and the perfomance
% measures
plotconfusion(TargetMapper(validData.y)', TargetMapper(validData.p)');
set(findobj(gca,'type','text'),'fontsize',18) % increasing fontsize
Res = myperfmeasures(validData);
fprintf("Accuracy: %g\n",Res(1));

%% TASK 2: ROC PLOT
% TODO: Plot a Receiver Operation Curve (ROC)
% Which performance measures do you need for 1the curve? 
% The implementation is up to you... you can either use existing MATLAB
% functions or calculate the needed performance measures on your own and
% just using the default MATLAB function plot()

figure();
[x y t AUC] = perfcurve(validData.y,validData.scores(:,1),1);
plot(x,y)
title("ROC")
xlabel("FP-Rate");
ylabel("TP-Rate");


%% Plotting classification surface (No change needed here)

ranges= min(validData.x);
ranges(2,:)=max(validData.x);
ranges=ranges';

if size(validData.x,2) == 2
    [X,Y] = meshgrid(linspace(ranges(1,1), ranges(1,2), 100), linspace(ranges(2,1), ranges(2,2), 100));
    meshData.x(:,1) = X(:);
    meshData.x(:,2) = Y(:);
    meshData.p = predict(classifier, meshData.x);

    figure(2);
    plotDataClass(validData, meshData);
    title('2D Classification Surface - SVM Classifier');
elseif size(validData.x,2) == 3
    
    linespace1 = linspace(ranges(1,1), ranges(1,2), 30);
    linespace2 = linspace(ranges(2,1), ranges(2,2), 30);
    linespace3 = linspace(ranges(3,1), ranges(3,2), 30);
    
    [X, Y, Z] = meshgrid(linespace1, linespace2, linespace3);
    meshData.x(:,1) = X(:);
    meshData.x(:,2) = Y(:);
    meshData.x(:,3) = Z(:);
    
    meshData.p = predict(classifier, meshData.x);
    
    figure(2);
    plotDataClass(validData, meshData);
    title('3D Classification Surface - SVM Classifier');
else
    disp('INFO: Cannot plot more than three dimensions');
end
disp('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
