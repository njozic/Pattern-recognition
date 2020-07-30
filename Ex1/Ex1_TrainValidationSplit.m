%% Exercise 1: 
% The goal of this exercise is to implement a function for splitting a
% dataset into a train and a validation set. Furthermore, different scaling methods
% (intervalFit, zScore, arcTan) should be applied and understood (basic idea).
%
% - Generate data with 3 dimensions (features) by using "generateData()".
%   Choose mean and variance as you like. Save the data and use it
%   throughout this exercise.
%
% - Plot the data according to the instruction given at the section
%   %%Plotting data. Check how the function works.
%
% - Implement a function for random train/validation splitting. An input parameter should be
%   used to define the percentage of data that will become training and
%   validation data respectively (1-%). The procedure thus, splits the input data
%   set into two structs holding training and validation data and returns 
%   them. Take care so that each class is represented with about the same
%   percentage ('stratified sampling'). One might use the function randperm
%   to generate a randomised list of the data in each class from which to
%   use the first p percent for training. Don't forget to set the targets
%   (data.y) accordingly!
%
% - Apply and understand the 3 different scaling functions (fit to interval, 
%   z-score, arctan) for rescaling and normalizing the data.
%   Store the coefficients to perform the operations also for new data (or
%   the sampled validation data).
%
% Data format should be consistent and contains following fields:
%   .header     cellarray with dimension/column description {'Dim1',...}
%   .x          input data/features in (nSamples x nDimensions)
%   .y          output/target variables (0,1,2,...)
%   .p          predicted variables = outcome of a classifier (0,1,2,...)
%
%
% Important matlab functions to use: randperm, varargin

clc; 
clear; 
close all;

% TODO
%modify according to your operating system and local folder structure
path2tools = '../PR_Toolbox';
addpath(path2tools);

% TODO
% generate some 3-dimensional random data, adapt values if you like
data = generateData([2 4 5; 5 7 3], [1 2 3; 0.5 3 2.5], [100, 150]);

%% Plotting data
%  The function plots data corresponding to targets (data can be 1D, 2D and 3D)

plotData(data);
title('Original data');

% TODO
% plot in 2D, dimensions are selectable (check the plotData() function!)
% e.g. plot dimension 2 vs. 3

plotData(data,[2,3]);
title('OD - Dimension 2 vs. 3');

% TODOCo
% plot dimension 1 vs. 3

plotData(data,[1,3]);
title('OD - Dimension 1 vs. 3');

% TODO
% plot each single dimension on its own

plotData(data,1);
title('OD - Dimension 1');
plotData(data,2);
title('OD - Dimension 2');
plotData(data,3);
title('OD - Dimension 3');

%% TODO
% train/validation split: split data into training and validation data. 
% Implement two types of sampling:
% random: 
%    shuffle through the data and just take the first e.g. 70% for training 
%    and the other 30% as validation set
% stratified:
%    as above, but also ensures that the original class ratio stays
%    the same in the two different sets
%    (E.g.: If 2/5 of your data is of class 0 and 3/5 of class 1, then
%    you should ensure having 2/5 of class 0 in train and validation set
%    too!)
% Hints: 
%    randperm(), work with indices, make sure to keep data.x and data.y synched
% type = 'random'; 
type = 'stratified';
[trainData, validData] = sampling(data, 0.7, type); % use 70% for training, 30% for validation

% plot training and testdata
plotData(trainData);
title('Train data');
plotData(validData);
title('Validation data');

%%
% TODO:  fit to interval: normalize the data to the interval [0 1]
[intervalTrainData, coeffs] = scaleInterval(trainData, [0 1]);
plotData(intervalTrainData);
title('Interval Scaling: Train Data');

% TODO: fit to interval: also normalize test data with the SAME
% coefficients as normalization of the training data has been done
[intervalValidData, ~] = scaleInterval(validData, [0 1], coeffs);
plotData(intervalValidData);
title('Interval Scaling : Validation Data');

% TODO:  z-score: use z-score transformation
[zScoreTrainData, coeffs] = scaleZScore(trainData);
plotData(zScoreTrainData);
title('Z-Score Standardization: Train Data');

% z-score: transform test/new data with the SAME coefficients as
% standardization has been done with training data
[zScoreValidData, ~] = scaleZScore(validData, coeffs);
plotData(zScoreValidData);
title('Z-Score Standardization: Validation Data');

% TODO: arctan: shrink each dimension with arc-tan-function to [-1 1] interval
[arcTanTrainData, coeffs] = scaleArcTan(trainData);
plotData(arcTanTrainData);
title('ArcTan Transformation: Train Data');

% arctan: transform test data with the SAME coefficients as has been done
% with training data
[arcTanDataTest, coeffs] = scaleArcTan(validData, coeffs);
plotData(arcTanDataTest);
title('ArcTan Transformation: Validation Data');
