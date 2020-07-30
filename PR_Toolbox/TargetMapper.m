function [mapped]= TargetMapper(data)
    datasize= size(data,1);
    classes= unique(data);
    numclasses= length(classes);

    mapped= zeros(datasize, numclasses);

    for i=1:numclasses
        index= find(data== classes(i));
        mapped(index,i)= 1;
    end
end