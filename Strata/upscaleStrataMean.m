function [strata] = upscaleStrataMean(strata, smoothingInterval, isAutoUniform)
%% UPSCALESTRATA  Upscale classificaiton
%
% strata:           Strataigraphic table (includes lithology, thickness)
%
% Mustafa Al Ibrahim @ 2018
% Mustafa.Geoscientist@outlook.com

%% Preprocessing

% Defaults
if ~exist('smoothingInterval', 'var'); smoothingInterval = 1; end
if ~exist('isAutoUniform', 'var'); isAutoUniform = false; end

% Assertions
assert(exist('strata', 'var')==true, 'strata must be provided');
assert(numel(unique(strata.thickness))==1 || isAutoUniform, 'strata thickness is variable, make uniform or enable isAutoUniform');

%% Main

if ~(numel(unique(strata.thickness))==1) && isAutoUniform
   strata = uniformThicknessStrata(strata); 
end

classification = strata.lithology;
nClasses  = max(classification);

padSize = (smoothingInterval - 1) / 2;   
B = padarray(classification,padSize,'replicate');

meanMatrix = zeros(numel(classification), nClasses);
for j = 1+padSize:padSize+numel(classification)
    currentClasses = B(j-padSize: j+padSize);
    meanMatrix(j-padSize,:) = histcounts(currentClasses, 1-.5:1:nClasses+.5)/smoothingInterval;
end

strata.lithology = meanMatrix;

end