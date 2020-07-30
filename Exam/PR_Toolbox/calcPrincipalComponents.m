function [pcaData, coeffs] = calcPrincipalComponents(data, dimReduct, coeffs)
% The PCA analyzes the variance of the dataset. Assumption: Dimensions with
% a high variance contains more information than dimensions with a low one.
% It transforms the data into a complete different space, keeping the
% vectors with the highest variance and forming a basis with them. 
% The dimensions with low variance can then be removed from the data to 
% achieve a lower dimensionality. Notice: For some datasets the assumption 
% "variance = information" does not hold. 
% Hint: It is recommended to keep a total variance of > 90% in the resulting
% data. 

pcaData.y = data.y;

for d=1:dimReduct
    pcaData.header{d} = ['PC ' num2str(d)]; 
end

if nargin<3 % calculate principal components

    coeffs.mean = mean(data.x,1);
    
    % subtract the mean in each coordinate
    Xcentered = data.x - ones(size(data.x,1),1) * coeffs.mean;

    % calculate the covariance matrix
    Sigma = cov(Xcentered);

    % compute eigenvalues and eigenvectors
    [EVe, EVa]= eig(Sigma);

    % we take out the eigenvalues from the diagonal matrix and sort them
    % idx contains the sorting index which we need to sort the
    % eigenvectors in the same order
    [EVa, idx] = sort(diag(EVa), 'descend');
%     EVa

    fprintf('The first %i dimension(s) exhibit %.4f %% of the data variance\n',dimReduct, sum(EVa(1:dimReduct))/sum(EVa)*100);
  
    % lets resort the eigenvectors
    coeffs.EVe = EVe(:, idx); % neat , isn’t it ?

else % use existing coeffs
    % subtract the mean in each coordinate
    Xcentered = data.x - ones(size(data.x,1),1) * coeffs.mean;
end
    
% now transform the data to the new coordinates by multiplying
x_PCA =(coeffs.EVe'* Xcentered')';

pcaData.x = x_PCA(:,1:dimReduct);

end

