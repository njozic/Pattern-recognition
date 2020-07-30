function [scaledData, coeffs] = scaleInterval(data, interval, coeffs)
%scales the data into a given interval

    scaledData = data;

    if nargin < 3
        coeffs.min = min(data.x); % min for all dimensions (row vector)
        coeffs.max = max(data.x); % max for all dimensions (row vector)
    end

    if nargin==1 % no interval given
        a = 0;
        b = 1;
    else
        a = interval(1);
        b = interval(2);
    end

    for dim=1:size(data.x,2)
        scaledData.x(:,dim) = (data.x(:,dim) - coeffs.min(dim)) / (coeffs.max(dim) - coeffs.min(dim));
        scaledData.x(:,dim) = a + (b - a) * scaledData.x(:,dim);
    end

end

