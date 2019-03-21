function [strata] = upscaleStrataRandomMean(strata, nIntervals, isAutoUniform)
%% UPSCALESTRATARANDOMMEAN  Upscale classificaiton on random intervals
%
% strata:           Strataigraphic table (includes lithology, thickness)
%
% Mustafa Al Ibrahim @ 2019
% Mustafa.Geoscientist@outlook.com

%% Preprocessing

% Defaults
if ~exist('nIntervals', 'var'); nIntervals = 2; end
if ~exist('isAutoUniform', 'var'); isAutoUniform = false; end

% Assertions
assert(exist('strata', 'var')==true, 'strata must be provided');
assert(numel(unique(strata.thickness))==1 || isAutoUniform, 'strata thickness is variable, make uniform or enable isAutoUniform');
assert(isscalar(nIntervals) && isnumeric(nIntervals) && nIntervals>=1, 'nIntervals >=1');

%% Main

% Make uniform
if ~(numel(unique(strata.thickness))==1) && isAutoUniform
   strata = uniformThicknessStrata(strata); 
end

% Special case, no need for upscaling
nPoints = size(strata,1);
if nPoints == 1; return; end

% Sample cutoff locations
cutoffs      = sort(round((nPoints-1-2).*rand(nIntervals-1,1) + 2));
cutoffsStart = [1; cutoffs];
cutoffsEnd   = [cutoffs-1; nPoints];
cutoffs = [cutoffsStart, cutoffsEnd];

% Upscale
classification = strata.lithology;
nClasses  = max(classification);

meanMatrix = zeros(nPoints, nClasses);
for i =1:nIntervals
    currentInterval = cutoffs(i,1):cutoffs(i,2);
    currentClasses = classification(currentInterval);
    meanMatrix(currentInterval,:) = repmat(histcounts(currentClasses, 1-.5:1:nClasses+.5)/numel(currentClasses), numel(currentClasses),1);
end

strata.lithology = meanMatrix;

end