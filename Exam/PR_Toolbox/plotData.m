function plotData(data, selectedDims)

%plots the given data. With the optional parameter selectedDims, 
%the plotted dimensions can be chosen.
%
% Examples:
%       Plot all dimensions (only works for <= 3 dim ;)): plotData(data);
%       Plot only the second dim: plotData(data,2);
%       Plot Dim2 vs Dim3: plotData(data,[2 3]);
%  

% Markers can be customized... see MATLAB documentation for more info
MarkerSize= 20;
% predefined class colors, if there are more than 8 classes, add more here
colors = {'b','r','g','y','m','c','w','k'};

if nargin==1  % got no selectedDims, plot everything if possible
    selectedDims=1:size(data.x(1,:),2);
end

dimensions=length(selectedDims);
classes = unique(data.y);

figure; %open empty figure
    
if dimensions==1
    for c=1:length(classes)
        idx = find(data.y == classes(c));
        scatter(data.x(idx,selectedDims(1)),zeros(size(data.x(idx,selectedDims(1)),1),1),MarkerSize,colors{c},'filled');
        hold on;
    end
    
    xlabel(data.header{selectedDims(1)});
    grid on;
elseif dimensions==2
    for c=1:length(classes)
        idx = find(data.y == classes(c));
        scatter(data.x(idx,selectedDims(1)),data.x(idx,selectedDims(2)),MarkerSize,colors{c},'filled');
        hold on;
    end
    
    xlabel(data.header{selectedDims(1)});
    ylabel(data.header{selectedDims(2)});
    grid on;
elseif dimensions==3
    for c=1:length(classes)
        idx = find(data.y == classes(c));
        scatter3(data.x(idx,selectedDims(1)),data.x(idx,selectedDims(2)),data.x(idx,selectedDims(3)),MarkerSize,colors{c},'filled');
        hold on;
    end
    
    xlabel(data.header{selectedDims(1)});
    ylabel(data.header{selectedDims(2)});
    zlabel(data.header{selectedDims(3)});
    grid on
elseif dimensions >3
        disp('Cannot plot more than 3 dimensions');
end

end %function end