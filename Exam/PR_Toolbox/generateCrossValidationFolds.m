function validIndiciesForEveryFold = generateCrossValidationFolds(data, k)

    idx = find(data.y(:,1));
    c=1;
    
    for i = 1:numel(data.y)
        idx(i,2)=c;
        if c==10
            c=1;
        else
            c=c+1;
        end
    end
    
    tmp = idx(:,2);
    tmp = tmp(randperm(numel(tmp)));
    idx(:,2)=tmp;
    
    validIndiciesForEveryFold = {};
    
    for i=1:k
        validIndiciesForEveryFold{i}=idx(idx(:,2)==i, 1);
    end
     
end