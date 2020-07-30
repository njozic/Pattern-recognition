function [trainData, validData] = sampling(data, p, type)
    
    trainData.header = data.header;
    validData.header = data.header;
        
    if type == "random"
        
        N = size(data.x,1);
        n = floor(N*p);
        i = randperm(N,N);
        train_i = i(1:n);
        test_i = i((n+1):N);
        
        trainData.x = data.x(train_i,:);
        trainData.y = data.y(train_i,:);
        
        validData.x = data.x(test_i,:);
        validData.y = data.y(test_i,:);
        
    elseif type == "stratified"
        tmp_a.x = data.x(data.y ~= 1,:);
        tmp_a.y = data.y(data.y ~= 1,:);
        
        tmp_b.x = data.x(data.y == 1,:);
        tmp_b.y = data.y(data.y == 1,:);
        
        A = size(tmp_a.x,1);
        B = size(tmp_b.x,1);
        
        a = floor(A*p);
        b = floor(B*p);
        
        i_a = randperm(A,A);
        i_b = randperm(B,B);
        
        train_i_a = i_a(1:a);
        train_i_b = i_b(1:b);
        test_i_a = i_a(a+1:A);
        test_i_b = i_b(b+1:B);
        
        train_a.x = tmp_a.x(train_i_a,:);
        train_a.y = tmp_a.y(train_i_a,:);
        train_b.x = tmp_b.x(train_i_b,:);
        train_b.y = tmp_b.y(train_i_b,:);
        
        test_a.x = tmp_a.x(test_i_a,:);
        test_a.y = tmp_a.y(test_i_a,:);
        test_b.x = tmp_b.x(test_i_b,:);
        test_b.y = tmp_b.y(test_i_b,:);
        
        trainData.x = cat(1,train_a.x,train_b.x);
        trainData.y = cat(1,train_a.y,train_b.y);
        
        validData.x = cat(1,test_a.x,test_b.x);
        validData.y = cat(1,test_a.y,test_b.y);
        
    else
        fprintf("Type ""%s"" is not defined. Available types are ""random"" or ""stratified"".\n",type);
    end

end