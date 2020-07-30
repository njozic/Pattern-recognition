function R = myperfmeasures (perfMeasureData)

    cmat = confusionmat(perfMeasureData.y', perfMeasureData.p'); 
    
    tp = cmat(1,1);
    fp = cmat(2,1);
    tn = cmat(2,2);
    fn = cmat(1,2);
    
    % -Average F1 Score (over all classes)
    
    p1 = tp/(tp+fp);    % Precision 1
    p2 = tn/(tn+fn);    % Precision 2
    r1 = tp/tp+tn;      % Recall 1
    r2 = tn/tn+fp;      % Recall 2
    f1_1 = 2*tp/(2*tp+fn+fp);     % F1 Score
    accuracy = trace(cmat)/sum(cmat(:));
   
    precision={};
    precision.positive = tp/(tp+fp);
    precision.negative = tn/(tn+fn);
    
    sensitivity = tp/(tp+fn);
    specificity = tn/(tn+fp);
    f1_score = (2*tp)/((2*tp)+fp+fn);
    error_rate = (fp+fn)/(tp+fp+tn+fn);
    
    R={};
    
    R.accuracy = accuracy;
    R.precision = precision;
    R.sensitivity = sensitivity;
    R.specificity = specificity;
    R.f1_score = f1_score;
    R.error_rate = error_rate;
    

end