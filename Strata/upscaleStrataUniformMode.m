function [strata] = upscaleStrataUniformMode(strata, intervalThickness, isAutoUniform)
%% UPSCALESTRATARANDOMMEAN  Upscale classificaiton on random intervals
%
% strata:           Strataigraphic table (includes lithology, thickness)
%
% Mustafa Al Ibrahim @ 2019
% Mustafa.Geoscientist@outlook.com

%% Preprocessing

% Defaults
if ~exist('intervalThickness', 'var'); intervalThickness = 2; end
if ~exist('isAutoUniform', 'var'); isAutoUniform = false; end

% Assertions
assert(exist('strata', 'var')==true, 'strata must be provided');
assert(numel(unique(strata.thickness))==1 || isAutoUniform, 'strata thickness is variable, make uniform or enable isAutoUniform');
assert(isscalar(intervalThickness) && isnumeric(intervalThickness) && intervalThickness>=1, 'nIntervals >=1');

%% Main

% Make uniform
if ~(numel(unique(strata.thickness))==1) && isAutoUniform
   strata = uniformThicknessStrata(strata); 
end

% Special case, no need for upscaling
nPoints = size(strata,1);
if nPoints == 1 || intervalThickness==1; return; end

% Sample cutoff locations
cutoffs      = ((1+intervalThickness):intervalThickness:(nPoints-1))';
cutoffsStart = [1; cutoffs];
cutoffsEnd   = [cutoffs-1; nPoints];
cutoffs = [cutoffsStart, cutoffsEnd];

% Upscale
classification = strata.lithology;

for i =1:size(cutoffs,1)
    currentInterval = cutoffs(i,1):cutoffs(i,2);
    currentClasses = classification(currentInterval);
    classification(currentInterval,:) = mode(currentClasses);
end

strata.lithology = classification;

end