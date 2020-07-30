%% Exercise 4:
%
% The goal of this exercise is to implement a support vector machine 
% for regression. (SVM; see help svm in Matlab, especially 
% fitrsvm()). Apply sampling and try to find suited training parameters for
% predicting the validation set as good as possible. Finally, use the
% resulting SVM for evaluating the actual test set.
%
% INFORMATION ON THE USED DATESET:
% As dataset, the public "Energy efficiency" dataset is used. 
% Source: https://archive.ics.uci.edu/ml/datasets/Energy+efficiency
% Its a dataset with 8 features and the goal is to predict the heating and
% cooling load ("how much effort is necessary to heat or cool a building?").
% In the excercises, we will use the heating load as target.
% 

clc; clear variables; close all;

path2tools = '../PR_Toolbox/';
addpath(path2tools);

%% load data
load('heating-train.mat')

%% Plotting the data
% With the function plotRegressionData() from the toolbox you can plot the data. 
% The function is similar to the plotData() function, use the param 
% 'selectedDims' for choosing the dimensions/features to plot. 
plotRegressionData(trainData, [1 2]);

%% Sampling
% TODO: Splitting the data into a train and validation set.
[trainData, validData] = sampling(trainData, 0.7, 'random');

%% Preprocessing
% TODO: What about preprocessing (scaling) here? 
[trainData, coeffs] = scaleArcTan(trainData);
[validData, ~] = scaleArcTan(validData, coeffs);

%% Dimension reduction with PCA
% TODO: what about a PCA for dimension reduction here?
dimReduct = 8; % change the target dimensionality as you like
[trainData, coeffs_PCA] = calcPrincipalComponents(trainData, dimReduct);

if(dimReduct <= 3)
    plotData(trainData);
    title('PCA on train data');
end

[validData] = calcPrincipalComponents(validData, dimReduct, coeffs_PCA);

%% regression with support vector machine
% TODO: train a SVM for regression using only the train data. (Hint:
% fitrsvm()). Examine the possible parameters of the function.
% Try different training parameters (Kernel, etc.) manually by
% monitoring the loss on the validation set below.

% train a multiclass-SVM with the traindata
% tmp_svm = templateSVM('KernelFunction', 'gaussian');

% classify the validation set using the trained SVM
Mdl = fitrsvm(trainData.x, trainData.y,'PredictorNames',trainData.header','KernelFunction', 'polynomial','KernelScale','auto','Standardize',true);

%% plot partial dependencies
% TODO: Use MATLAB's plotPartialDependence() function for examining the partial
% dependence of each single feature on the target variable.
% Hint: Since this is a 8-dimensional dataset, you might want to use two
% 2x2 subplots (subplot()).
figure
for i=1:4
    subplot(2,2,i)
    plotPartialDependence(Mdl,i);
end

figure
for i=1:4
    subplot(2,2,i)
    plotPartialDependence(Mdl,i+4);
end

%% Evaluation of the validation set
% TODO: Predict the target variable of the validation set and evaluate the
% regression result. Use the loss for manually adapting and optimizing the
% training parameters (Kernel, BoxContraint, Preprocessing, etc..)
% You can use the plotregression() function for plotting the targets vs the
% predictions
% Hints: predict(), loss(), plotregression()

validData.p = predict(Mdl,validData.x);
validData.l = loss(Mdl,validData.x,validData.y);
fprintf('Valid Data Loss = %.2f\n',validData.l);

figure
plotregression(validData.p,validData.y)

%% Final evaluation of the test set
% TODO: If you have finished your optimization (= you have found good 
% training parameters), perform the final evaluation on the test-set. 
% Again, output the loss (Mean Squared Error by default).

load('heating-test.mat');

[validData, ~] = scaleArcTan(validData, coeffs);
[validData] = calcPrincipalComponents(validData, dimReduct, coeffs_PCA);
validData.l = loss(Mdl,validData.x,validData.y);

fprintf('Loss: %.2f\n',validData.l);
