
function [backmapped]= TargetMapper(data)

    datasize= size(data,1);
    numclasses= size(data,2);
    

    backmapped= zeros(datasize, 1);

    for i=1:datasize
        index= find(data(i,:)== 1);
        backmapped(i)= index-1;
    end
end