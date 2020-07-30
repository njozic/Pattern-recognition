%% Exercise 4:
%
% Now, use the hyperparameter-optimization functionality of fitrsvm() for
% finding even better training parameters. No sampling is needed here,
% since the hyperparameter-optimization uses a 5-fold cross validation by
% default. Therefore, use directly the trainData from "heating-train.mat"
% for training.
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

%% Preprocessing
% TODO: What about preprocessing (scaling) here? 
[trainData, validData] = sampling(trainData, 0.7, 'random');
[trainData, coeffs] = scaleArcTan(trainData);
[validData, ~] = scaleArcTan(validData, coeffs);

%% Dimension reduction with PCA
% TODO: what about a PCA for dHyperparameterOptimizationOptionsimension reduction here?
dimReduct = 8; % change the target dimensionality as you like
[trainData, coeffs_PCA] = calcPrincipalComponents(trainData, dimReduct);

if(dimReduct <= 3)
    plotData(trainData);
    title('PCA on train data');
end

[validData] = calcPrincipalComponents(validData, dimReduct, coeffs_PCA);

%% regression with support vector machine
% TODO: train a SVM for regression using only the train data.
% Find a good setup by hyperparameter-optimization (an option of
% fitrsvm). Compare those with your previous setup. Which one is better? ;)
Mdl = fitrsvm(trainData.x,trainData.y,'OptimizeHyperparameters','all',...
    'HyperparameterOptimizationOptions',struct('MaxObjectiveEvaluations',...
    50,'AcquisitionFunctionName','expected-improvement-plus', 'UseParallel', true))

%% plot partial dependencies
% Use MATLAB's plotPartialDependence() function for examining the partial
% dependence of each single feature on the target variable
figure
for i=1:4
    subplot(2,2,i)
    plotPartialDependence(Mdl,i);
end

% figure
% for i=1:4
%     subplot(2,2,i)
%     plotPartialDependence(Mdl,i+4);
% end

%% Final evaluation of the test set
% TODO: If you have finished your optimization, perform the final evaluation 
% on the test-set. Again, output the loss (Mean Squared Error by default).
% In your final submission, make sure that your best model is saved and can 
% be loaded like below.
% Hints: predict(), loss(), plotregression()

validData.p = predict(Mdl, validData.x);
validData.l = loss(Mdl, validData.x, validData.y);

save('my-best-heating-model.mat','Mdl');
% load('my-best-heating-model.mat')
load('heating-test.mat')

plotregression(validData.p, validData.y);

[testData, ~] = scaleArcTan(testData, coeffs);
[testData] = calcPrincipalComponents(testData, dimReduct, coeffs_PCA);
testData.l = loss(Mdl,testData.x, testData.y);

fprintf('Loss: %.2f\n',testData.l);
