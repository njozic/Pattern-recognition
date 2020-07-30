function [trainData, validData] = getTrainAndValidDataForCrossValidation(data, idx)
    
    train_idx = [];
    
    for i = 1:size(data.x,1)
        if ~ismember(i,idx)
            train_idx =[train_idx,i];
        end
    end
    
    train_idx = train_idx(randperm(length(train_idx)));
    
    trainData.header = data.header;
    trainData.x = data.x(train_idx, :);
    trainData.y = data.y(train_idx, :);
    
    validData.header = data.header;
    validData.x = data.x(idx, :);
    validData.y = data.y(idx, :);
   
end