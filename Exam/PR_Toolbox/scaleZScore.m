function [scaledData, coeffs] = scaleZScore(data, coeffs)
%scales the data into a given interval

scaledData = data;

if nargin < 2
    coeffs.mean = mean(data.x); % mean for all dimensions (row vector)
    coeffs.std = std(data.x); % std for all dimensions (row vector)
end

for dim=1:size(data.x,2)
    scaledData.x(:,dim) = (data.x(:,dim) - coeffs.mean(dim)) / coeffs.std(dim);
end

end

