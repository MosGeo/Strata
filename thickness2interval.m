function [intervalData] = thickness2interval(value, isMerge, thickness)
%% Preprocessing 

% Defaults
if ~(exist('thickness', 'var')); thickness = ones(size(value)); end
if ~(exist('isMerge', 'var')); isMerge = true; end

% Assertions
assert(iscolumn(value) && iscolumn(thickness), 'value and thickness must be column vectors');

%% Main

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
intervalData(2:end,1) = intervalData(1:end-1,2);

end