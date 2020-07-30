%% Exercise 1: 
% The goal of this exercise is to implement a function for calculating
% different evaluation metrics. 
%
% - Implement a confusion plot for measuring a classifiers performance.
%   Follow the instructions given at the corresponding section
%   in the source code below 
%
% Data format should be consistent and contains following fields:
%   .header     cellarray with dimension/column description {'Dim1',...}
%   .x          input data/features dimSelectorin (nSamples x nDimensions)
%   .y          output/target variables (0,1,2,...)
%   .p          predicted variables = outcome of a classifier (0,1,2,...)
%
%
% Important matlab functions to use:  plotconfusion, confusionmat  

clc; 
clear; 
close all;

% TODO
%modify according to your operating system and local folder structure
path2tools = '../PR_Toolbox';
addpath(path2tools);

%% Performance Measures
% use Matlab's "plotconfusion" to generate a confusion plot

load('perfMeasureData.mat');

figure;
plotconfusion(perfMeasureData.y', perfMeasureData.p');  

% TODO:
% Implement the function "myperfmeasures()" to compute the following 
% performance measures manually and compare their values with Matlab's
% confusion plot:
%
% -Accuracy
% -Error Rate
% -Precision (metric is class-dependent, compute it for both classes!)
% -Recall (for positive class) = Sensitivity = True Positive Rate  
% -Recall (for negative class) = Specificity = True Negative Rate  
% -F1 Score (metric is class-dependent, compute it for both classes!)
% -Average F1 Score (over all classes)
%
% Pay attention to where those performance measures are in the confusion
% plot. The code must only work for a 2-class problem! 
% Hints: 
%     Use confusionmat to get TP,TN,FP,FN (Be careful, transpose the 
%     resulting matrix, otherwise FP+FN are mixed up: confMat=confMat')
%     Formulas for the metrics can be found in the lecture slides

Res = myperfmeasures(perfMeasureData);
