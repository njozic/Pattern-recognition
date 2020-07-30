%% Exercise 5: 
% The goal of this exercise is to implement a outlier detection to identify
% unseen events that are differing significantly from the majority of seen
% data. One common algorithm for outlier detection is one-class SVM.
% 
% In this example we use a original Cardiotocography (Cardio) dataset
% provided by the UCI machine learning repository. It consists of
% measurements of fetal heart rate (FHR) and uterine contraction (UC)
% features on cardiotocograms classified by expert obstetricians. This is a
% classification dataset, where the classes are normal and pathologic. For
% outlier detection, the normal class formed the inliers and the pathologic
% the outliers. For more information:
% http://odds.cs.stonybrook.edu/cardiotocogrpahy-dataset/
%
% Features of the dataset:
% LB - FHR baseline (beats per minute) 
% AC - # of accelerations per second 
% FM - # of fetal movements per second 
% UC - # of uterine contractions per second 
% DL - # of light decelerations per second 
% DS - # of severe decelerations per second 
% DP - # of prolongued decelerations per second 
% ASTV - percentage of time with abnormal short term variability 
% MSTV - mean value of short term variability 
% ALTV - percentage of time with abnormal long term variability 
% MLTV - mean value of long term variability 
% Width - width of FHR histogram 
% Min - minimum of FHR histogram 
% Max - Maximum of FHR histogram 
% Nmax - # of histogram peaks 
% Nzeros - # of histogram zeros 
% Mode - histogram mode 
% Mean - histogram mean 
% Median - histogram median 
% Variance - histogram variance 
% Tendency - histogram tendency 

clc, clear variables, close all;

path2tools = '../PR_Toolbox/';
addpath(path2tools);

% load data
load('cardioData.mat');

%% Examining the data
plotData(data,[9 10 11 ])

%% Sampling
% TODO: Splitting the trainData into a train and validation set.
[trainData, validData] = sampling(data, 0.7, 'random');

%% Preprocessing
% TODO: What about preprocessing (scaling) here? 
% [trainData, coeffs] = scaleArcTan(trainData);
% [validData, ~] = scaleArcTan(validData, coeffs);

%% Dimension reduction with PCA
% TODO: what about a PCA for dimension reduction here?
dimReduct = 5; % change the target dimensionality as you like
[trainData, coeffs_PCA] = calcPrincipalComponents(trainData, dimReduct);

if(dimReduct <= 3)
    plotData(trainData);
    title('PCA on train data');
end

[validData] = calcPrincipalComponents(validData, dimReduct, coeffs_PCA);

%% TASK1: Outlier Detection with one-class SVM
% TODO: Estimate the outlier-rate from the trainData and make the trainData
% to a one-class dataset (just by setting trainData.y of all train samples 
% to the same "inlier" class 0). Then, train a one-class SVM classifier by 
% specifiying your predefined outlier-rate (param 'OutlierFraction'). 
% Hint: fitcsvm with appropriate parameters
olf = sum(trainData.y)/size(trainData.y,1);
trainData.y = zeros(numel(trainData.y),1);
SVMModel = fitcsvm(trainData.x,trainData.y,'KernelScale','auto','Standardize',true,...
     'OutlierFraction',olf, 'Nu',0.75);

%% TASK2: study the following code and the corresponding plot for a 2-dimensional setting (PCA!)
% TODO: explain in the next lesson
% Plot the observations and flag the support vectors and potential outliers
if(size(trainData.x,2) == 2) % only works for two dimensions
    svInd = SVMModel.IsSupportVector;
    h = 0.2; % Mesh grid step size
    [X1,X2] = meshgrid(min(trainData.x(:,1)):h:max(trainData.x(:,1)),...
        min(trainData.x(:,2)):h:max(trainData.x(:,2)));
    [~,score] = predict(SVMModel,[X1(:),X2(:)]);
    scoreGrid = reshape(score,size(X1,1),size(X2,2));

    figure
    plot(trainData.x(:,1),trainData.x(:,2),'k.')
    hold on
    plot(trainData.x(svInd,1),trainData.x(svInd,2),'ro','MarkerSize',10)

    contour3(X1,X2,scoreGrid,150)

    zlim([0 max(max(scoreGrid))]) % don't show contours below 0 ( = outliers)

    colorbar;
    title('{\bf Outlier Detection Contours Plot}')
    xlabel(trainData.header(1,1))
    ylabel(trainData.header(1,2))
    legend('Observation','Support Vector')
    hold off
end

%% TASK3: predict the outliers of the validation set and evaluate the classifier (confusion matrix + performance measures)
% Hint: An outlier is detected if the predicted score of a sample is below 0. 
% Therefore use predict() to get the scores and override validData.p 
% accordingly (1=outlier, 0=inlier)
[validData.p, score] = predict(SVMModel, validData.x);
validData.p(score < 0) = 1; validData.p(score > 0) = 0;
myperfmeasures(validData);
plotconfusion(TargetMapper(validData.y)', TargetMapper(validData.p)');

%% TASK4: Try to optimize for a high recall of the outlier class (1)
% Which parameter have you adapted for that optimization and why?

fprintf("The parameters for one-class-learning consist of Nu and a scalar greater than 0. \n")
fprintf("Nu is also greater than 0 and may not be greater than 1. In order to minimize the \n")
fprintf("weights in the score function, Nu must be set so that most training examples are \n")
fprintf("in the positive class.\n")


