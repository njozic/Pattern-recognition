%% Exercise 3:
%
% Now, use the implemented multiclass SVM and create a cross-validation
% pipeline. Use a 10-fold by default.
% Some more explanation: 10-fold means that you divide your dataset into 10 
% equal parts, where each of those parts, once, is used as validation set 
% and the other 9 of 10 parts is used as train set. This means that you 
% train 10 different classifiers.
%

clc;
clear;
close all;

path2tools = '../PR_Toolbox/';
addpath(path2tools);

%% load data
load('forest_dataset.mat');

%% TODO: CROSS VALIDATION: create folds
% It is sufficient to only save the indicies of the validation set, since it is
% clear that the rest has to be part of the train set..
% The function returns a cell array with k elements, each of them storing 
% the validation indicies for the k-th fold
k=10; % nr of folds
validIndiciesForEveryFold = generateCrossValidationFolds(data, k); % implement this function! 

%% OPTIONAL: Simple check that the function above works:
all = [];
for i = 1:length(validIndiciesForEveryFold)
    all = [all; validIndiciesForEveryFold{i}];
end
allSorted = sortrows(all);
if(~isequal(allSorted,(1:size(data.y,1))'))
    disp('Looks like there is an error with your generateCrossValidationFolds() function!');
end

%% CROSS VALIDATION: iterate over folds and do the classification for each fold

for f = 1:k
    
    fprintf('Fold %i out of %i:\n', f, k);
    
    % TODO: Implement function for getting trainData and validData for
    % every fold
    [trainData, validData] = getTrainAndValidDataForCrossValidation(data, validIndiciesForEveryFold{f});
    
    %% TODO: Copy your classification steps from your Ex3_MultiClassSvm script
    % preprocessing
%     [trainData, coeffs] = scaleArcTan(trainData);
    [trainData, coeffs] = scaleInterval(trainData,[0,1]);
    [validData, ~] = scaleInterval(validData,[0,1], coeffs);
    
    % PCA
    dimReduct = 9; % change the target dimensionality as you like
    [trainData, coeffs_PCA] = calcPrincipalComponents(trainData, dimReduct);
    [validData] = calcPrincipalComponents(validData, dimReduct, coeffs_PCA);
    
    % training
    tmp_svm = templateSVM('KernelFunction', 'gaussian');
    class_train = fitcecoc(trainData.x, trainData.y, 'Learners', tmp_svm);
    
    % prediction
    [validData.p,validData.score] = predict(class_train, validData.x);
    
    %% save predictions in data.p for later evaluation
    data.p(validIndiciesForEveryFold{f},1) = validData.p;
end

%% Evaluation of all folds (confusion matrix + performance measures)
% analyse classification rates with the confusion plot and the perfomance
% measures
plotconfusion(TargetMapper(data.y)', TargetMapper(data.p)');
set(findobj(gca,'type','text'),'fontsize',18) % increasing fontsize

% TODO: Adapt your myperfmeasures that in the multiclass-case at least the 
% accuracy is returned (easy task)!
myperfmeasures(data);
