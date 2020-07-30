function plotDataClass(data, meshdata)
% Plots the classification boundary for 2D and 3D

dimensions=size(data.x(1,:),2);

if not(isfield(data,'x')&& isfield(data,'y') && isfield(data,'header'))
   error('Please check if needed fields: .x, .y and .header are found in input datastructure'); 
end

% Markers can be customized... see MATLAB documentation for more info
MarkerSize= 20;
% predefined class colors, if there are more than 8 classes, add more here
colors = {'b','r','g','y','m','c','w','k'};

classes = unique(data.y);

if dimensions==2
    figure; %open empty figure
    
    for c=1:length(classes)
        idx = find(data.y == classes(c));
        scatter(data.x(idx,1),data.x(idx,2),MarkerSize,colors{c},'filled');
        hold on;
        pidx = find(meshdata.p == classes(c));
        scatter(meshdata.x(pidx,1),meshdata.x(pidx,2),[],colors{c},'+');
    end
    
    xlabel(data.header{1});
    ylabel(data.header{2});
    axis([min(meshdata.x(:,1)) max(meshdata.x(:,1)) min(meshdata.x(:,2)) max(meshdata.x(:,2))]);
    
    set(gca,'Color',[ 0.5 0.5 0.5]);
elseif dimensions == 3
    figure;
    
    for c=1:length(classes)
        idx = find(data.y == classes(c));
        scatter3(data.x(idx,1),data.x(idx,2), data.x(idx,3),MarkerSize,colors{c},'filled');
        hold on;
        pidx = find(meshdata.p == classes(c));
        scatter3(meshdata.x(pidx,1),meshdata.x(pidx,2),meshdata.x(pidx,3),3,colors{c},'+');
    end
    
    xlabel(data.header{1});
    ylabel(data.header{2});
    zlabel(data.header{3});
    axis([min(meshdata.x(:,1)) max(meshdata.x(:,1)) min(meshdata.x(:,2)) max(meshdata.x(:,2)) min(meshdata.x(:,3)) max(meshdata.x(:,3))]);
    
    set(gca,'Color',[ 0.5 0.5 0.5])
else
    % no output
    disp('Just 2D supported'); 
end


end %function end