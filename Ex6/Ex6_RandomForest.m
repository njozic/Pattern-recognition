%% Exercise 6: 
% The goal of this exercise is to implement a Classification And Regression
% Tree (CART). To reduce some of the disadvantages (like overfitting, low
% prediction accuracy, ...) ensemble methods (boosting, bagging) can be
% used. One common algorithm for a CART with bagging is the random forest.
%
% INFORMATION ON THE USED DATESET:
% As dataset, the public "German Credit Data" dataset is used. 
% Source: https://archive.ics.uci.edu/ml/datasets/statlog+(german+credit+data)
% Its a 2-class dataset and it classifies people by a set of attributes as
% good (class 1) or bad (class 2) credit risks. Therefore, it the classifier 
% outputs class 1, the person would get a credit, and vice versa.
%
% To compare the result we also compute a svm-classifier on the same
% dataset.

clc, clear variables, close all;
% find tree viewer figure if open and close it
hTree=findall(0,'Tag','tree viewer');
close(hTree)

path2tools = '../PR_Toolbox/';
addpath(path2tools);

% load data
% Comment: data.x is a table containing category features (strings) as well
% (no one-hot encoding needed here)
load('german-train-table.mat')
load('german-valid-table.mat')

disp('-------------------------');
disp('----- Random Forest -----');
disp('-------------------------');

%% Random Forest - Training
% TODO: Choose the number of trees for the random forest
iNumBags = 50;

% TODO: Train a ensemble of decision trees for classification with
% out-of-bag error optimization (Hint from lecture: TreeBagger)
rng(1); % for reproducibility
mdl = TreeBagger(iNumBags,trainData.x,trainData.y,'OOBPrediction','On',...
    'Method','classification')
%% Random Forest - Visualization
% TODO: view a visualization of the first tree
view(mdl.Trees{1},'Mode','graph');

% TODO: plot the Out-Of-Bag-error over the number of grown classification trees
figure;
oobErrorBaggedEnsemble = oobError(mdl);
plot(oobErrorBaggedEnsemble)
xlabel 'Number of grown trees';
ylabel 'Out-of-bag classification error';

%% Random Forest - Prediction
% TODO: predict the target values
% Hint: if predict returns a cell our function TargetMapper and
% myperfmeasures doesn't work, so you have to convert the cell with
% cell2mat and the resulting chars with str2num (both on validData.p)
[validData.p, score] = predict(mdl, validData.x);
validData.p = str2num(cell2mat(validData.p));

%% Random Forest - Evaluation of the prediction
% TODO: plotconfusion + myperfmeasures
figure()
plotconfusion(TargetMapper(validData.y)', TargetMapper(validData.p)');

%% SVM - load data once more
clear

% load data (here categories are already one-hot encoded)
load('german-train.mat')
load('german-valid.mat')

disp('---------------');
disp('----- SVM -----');
disp('---------------');

%% SVM - Preprocessing
% TODO: What about preprocessing (scaling) here? 
[trainData, coeffs] = scaleZScore(trainData);
[validData, ~] = scaleZScore(validData, coeffs);

%% SVM - Dimension reduction with PCA
% TODO: what about a PCA for dimension reduction here?
dimReduct=40; % change the target dimensionality as you like
[trainData, coeffs_PCA] = calcPrincipalComponents(trainData, dimReduct);
[validData] = calcPrincipalComponents(validData, dimReduct, coeffs_PCA);

if(dimReduct <= 3)
    plotData(trainData);
    title('PCA on train data');
end

%% SVM - classification with support vector machine
% TODO: train with appropriate parameter set and predict
rng(1);
mdl = fitcsvm(trainData.x,trainData.y, 'KernelFunction', 'linear',...
'Standardize', false, 'BoxConstraint', 0.11430); % KernelScale NaN PolynomialOrder

validData.p = predict(mdl, validData.x);

%% SVM - Evaluation of the prediction
% TODO: plotconfusion + myperfmeasures
figure()
plotconfusion(TargetMapper(validData.y)', TargetMapper(validData.p)');
myperfmeasures(validData);
