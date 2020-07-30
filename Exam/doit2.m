clc, clear variables, close all, format compact;

%% load data and set path for toolbox
path2tools = 'PR_Toolbox/';
addpath(path2tools);
load('data.mat');
rng(0);

%% Sampling (stratified)
[trainData, validData] = sampling(data, 0.6, 'stratified');

%% Preprocessing
[trainData, coeffs] = scaleArcTan(trainData);
[validData, ~] = scaleArcTan(validData, coeffs);

%% PCA
dimReduct = 2;
[trainData, coeffs_PCA] = calcPrincipalComponents(trainData, dimReduct);
[validData] = calcPrincipalComponents(validData, dimReduct, coeffs_PCA);

%% SVM Classifier and plot
mdl = fitcsvm(trainData.x, trainData.y,'KernelFunction','rbf','cost',[0 1; 8 0]);
[validData.p, score] = predict(mdl, validData.x);
mdl_perf = myperfmeasures(validData);

fprintf("Sensitivity = %.2f%%\n", mdl_perf.sensitivity*100);
fprintf("Specificity = %.2f%%\n", mdl_perf.specificity*100);
fprintf("Pos. Precision= %.2f%%\n", mdl_perf.precision.positive*100);
fprintf("Neg. Precision= %.2f%%\n", mdl_perf.precision.negative*100);