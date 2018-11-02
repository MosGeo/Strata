function  [b,fval,exitflag,output, gammaFit] = fitvariogram(gamma, h, type)
%%

% defaults
if ~exist('h', 'var');    h = 1:numel(gamma); end
if ~exist('type', 'var'); type = 'Spherical'; end

% get requested variogram type
 switch lower(type(1))
     case 's'
         variogramFunction =  @(b,h) b(2)*((3*h./(2*b(1)))-1/2*(h./b(1)).^3);
     case 'e'
         variogramFunction =  @(b,h) b(2)*(1-exp(-h./b(1)));
 end

 objectfun = @(b) sum(((variogramFunction(b,h)-gamma).^2));
 
% create vector with initial values
% b(1) range
% b(2) sill
% b(3) nugget if supplied
 
b0 = [15 .1];
options = optimset('MaxFunEvals',1000000);
[b,fval,exitflag,output] = fminsearch(objectfun,b0,options);

gammaFit = variogramFunction(b,h);


end