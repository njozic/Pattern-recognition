%% Exercise 3:
%
% The goal of this exercise is to implement a support vector machine 
% classifier for a multi-class problem. (SVM; see help svm in Matlab, especially 
% fitcecoc()).
%
% INFORMATION ON THE USED DATESET:
% As dataset, the public "Forest type mapping" dataset is used. 
% Source: https://archive.ics.uci.edu/ml/datasets/Forest+type+mapping
% Its a 4-class dataset and classifies Japanese forest areas into four 
% different types. The 27 features are based on spectral data. 
% 
% LET'S DO A CLASSIFICATION CHALLENGE:
% Only 80% of the original dataset is provided for you in the given
% "forest_dataset.mat". The remaining part (20%) are used as a real
% testset. Your submitted classifier implementation (including
% preprocessing, PCA, etc...) will then be evaluated by accuracy using 
% the for you unknown test data. 
% (I will just deactivate the sampling function, use the complete "data" as 
% "trainData" and substitute the "validData" below with the "testData"!)
% The deadline for the submission is therefore 3 days before our next
% excercise session! I will create a highscore list based on the accuracy 
% and together we will have a look at the "winning" solution in the next session.

clc;
clear;
close all;

path2tools = '../PR_Toolbox/';
addpath(path2tools);

%% load data
load('forest_dataset.mat');

%% Sampling
% divide data into training and validation data with the sampling function
[trainData, validData] = sampling(data, 0.7, 'stratified');

%% Preprocessing
% TODO: What about preprocessing (scaling) here? 
% Check and apply the scaling functions from your toolbox (scaleInterval,
% zScore and atan).. Does it change the results?

[trainData, coeffs] = scaleArcTan(trainData);

% coefficients as normalization of the training data has been done
[validData, ~] = scaleArcTan(validData, coeffs);

%% Dimension reduction with PCA
% TODO: what about a PCA for dimension reduction here? Does it change the results?
% With the dimReduct parameter you can select the target dimensionality.
% Hint: The function outputs the resulting data variance via the command
% line. Usually, a data variance of >90 % is recommended. Engineering task!
% (Check the function for more info on that)

dimReduct = 9; % change the target dimensionality as you like
[trainData, coeffs_PCA] = calcPrincipalComponents(trainData, dimReduct);
if(dimReduct <= 3)
    plotData(trainData);
    title('PCA on train data');
end

% apply the PCA function on the validation data (with given coeffs)
[validData] = calcPrincipalComponents(validData, dimReduct, coeffs_PCA);


%% TASK 1: classification with support vector machine
% TODO: train a multiclass-SVM using only the train data. (Hint:
% templateSVM(), fitcecoc(), predict()).
% Examine the possible parameters of the functions. Compare especially the
% two coding types "onevsall" and "onevsone".

% train a multiclass-SVM with the traindata
tmp_svm = templateSVM('KernelFunction', 'gaussian');

% classify the validation set using the trained SVM
class_train = fitcecoc(trainData.x, trainData.y, 'Learners', tmp_svm);
[validData.p validData.score] = predict(class_train, validData.x);

%% Evaluation of the classifier (confusion matrix + performance measures)
% analyse classification rates with the confusion plot and the perfomance
% measures
plotconfusion(TargetMapper(validData.y)', TargetMapper(validData.p)');
set(findobj(gca,'type','text'),'fontsize',18) % increasing fontsize

% TODO: Adapt your myperfmeasures that in the multiclass-case at least the 
% accuracy is returned (easy task)!
Res = myperfmeasures(validData);
fprintf("Accuracy: %g\n",Res(1));

%% Plotting classification surface (No change needed here)
ranges= min(validData.x);
ranges(2,:)=max(validData.x);
ranges=ranges';

if size(validData.x,2) == 2
    [X,Y] = meshgrid(linspace(ranges(1,1), ranges(1,2), 100), linspace(ranges(2,1), ranges(2,2), 100));
    meshData.x(:,1) = X(:);
    meshData.x(:,2) = Y(:);
    meshData.p = predict(classifier, meshData.x);

    plotDataClass(validData, meshData);
    title('2D Classification Surface - SVM Classifier                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              ');
elseif size(validData.x,2) == 3
    
    linespace1 = linspace(ranges(1,1), ranges(1,2), 30);
    linespace2 = linspace(ranges(2,1), ranges(2,2), 30);
    linespace3 = linspace(ranges(3,1), ranges(3,2), 30);
    
    [X, Y, Z] = meshgrid(linespace1, linespace2, linespace3);
    meshData.x(:,1) = X(:);
    meshData.x(:,2) = Y(:);
    meshData.x(:,3) = Z(:);
    
    meshData.p = predict(classifier, meshData.x);
    
    plotDataClass(validData, meshData);
    title('3D Classification Surface - SVM Classifier');
else
    disp('INFO: Cannot plot more than three dimensions');
end
disp('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
