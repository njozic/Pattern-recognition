function data=generateData(mu, sigma, nSamples)

%generates data from a normal distribution. mu and sigma have to be
%specified in the following way:
%
% e.g.: to generate 3-dimensional data (3 features) with 2 classes (0 and 1)
%       with 100 samples for class 0 and 150 samples for class 1:
%
%       mu:       [2 4 5; 5 7 3]
%       sigma:    [1 2 3; 0.5 3 2.5]
%       nSamples: [100, 150]
%
%  

dims=size(mu,2);
classes=size(mu,1);

data.x=[];
data.y=[];

for ncla=1:classes
   % generate data for class
   ndata=nSamples(ncla);
   randData=randn(ndata,dims);  % N(0,1) numbers
   for i=1:dims
       randData(:,i) = randData(:,i)*sqrt(sigma(ncla,i))+mu(ncla,i); 
   end
   data.x=[data.x ; randData];
   data.y=[data.y ; ones(ndata,1)*(ncla)-1 ]; % 0,1,...
end

for i=1:dims
    data.header{i}=['Dim ',num2str(i)];
end

