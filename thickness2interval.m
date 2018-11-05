function [intervalData] = thickness2interval(value, isMerge, thickness)
%%

% Default values
if ~(exist('thickness', 'var')); thickness = ones(size(value)); end;
if ~(exist('isMerge', 'var')); isMerge = true; end;

% Make sure that input are columns
value = value(:);
thickness = thickness(:);

% Identify tops
if isMerge == true
    topsIndex = diff([value; nan]) ~= 0;
else
    topsIndex = true(size(value));
end
    
% Identify tops depth
topsLocation = cumsum(thickness);

% Build interval table
nIntervals = sum(topsIndex);
intervalData = zeros(nIntervals,3);
intervalData(:,3) = value(topsIndex);
intervalData(:,2) = topsLocation(topsIndex);
intervalData(2:end,1) = intervalData(1:end-1,2) ;

end