function plotRegressionData(data, selectedDims)

%plots the given regression data. With the optional parameter selectedDims, 
%the plotted dimensions can be chosen.
%
% Examples:
%       Plot all dimensions (only works for <= 3 dim ;)): plotRegressionData(data);
%       Plot only the second dim: plotData(data,2);
%       Plot Dim2 vs Dim3: plotData(data,[2 3]);
%  

% Markers can be customized... see MATLAB documentation for more info
MarkerSize= 20;

if nargin==1  % got no selectedDims, plot everything if possible
    selectedDims=1:size(data.x(1,:),2);
end

dimensions=length(selectedDims);

figure; %open empty figure
    
if dimensions==1
    scatter(data.x(:,selectedDims(1)),zeros(size(data.x(:,selectedDims(1)),1),1),MarkerSize,data.y,'filled');
    colorbar
    xlabel(data.header{selectedDims(1)});
    grid on;
elseif dimensions==2
    scatter(data.x(:,selectedDims(1)),data.x(:,selectedDims(2)),MarkerSize,data.y,'filled'); 
    colorbar
    xlabel(data.header{selectedDims(1)});
    ylabel(data.header{selectedDims(2)});
    grid on;
elseif dimensions==3
    scatter3(data.x(:,selectedDims(1)),data.x(:,selectedDims(2)),data.x(:,selectedDims(3)),MarkerSize,data.y,'filled');
    colorbar
    xlabel(data.header{selectedDims(1)});
    ylabel(data.header{selectedDims(2)});
    zlabel(data.header{selectedDims(3)});
    grid on
elseif dimensions >3
        disp('Cannot plot more than 3 dimensions');
end

end %function end