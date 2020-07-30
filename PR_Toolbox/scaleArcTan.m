function [scaledData, coeffs] = scaleArcTan(data, coeffs)
%scales the data into a given interval

if nargin < 2
    [zScoreData, coeffs] = scaleZScore(data);
else
    [zScoreData, coeffs] = scaleZScore(data, coeffs);
end

scaledData = zScoreData;

for dim=1:size(zScoreData.x,2)
    scaledData.x(:,dim) = (2/pi) * atan(zScoreData.x(:,dim));
end

end

