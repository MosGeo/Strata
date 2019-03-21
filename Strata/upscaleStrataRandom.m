function strata = upscaleStrataRandom(strata, nIntervals, effectiveLithoType, isAutoUniform)
%% UPSCALESTRATA  Upscale classificaiton
%
% strata:           Strataigraphic table (includes lithology, thickness)
%
% Mustafa Al Ibrahim @ 2018
% Mustafa.Geoscientist@outlook.com

%% Preprocessing

% Defaults
if ~exist('nIntervals', 'var'); nIntervals = 1; end
if ~exist('effectiveLithoType', 'var'); effectiveLithoType = 'Mode'; end
if ~exist('isAutoUniform', 'var'); isAutoUniform = false; end

% Assertions
assert(exist('strata', 'var')==true, 'strata must be provided');
assert(ischar(effectiveLithoType) && ismember(lower(effectiveLithoType), {'mode', 'mean'}), 'type must be mode or mean');

%% Main

% Simple moving mean/mode upscaling
switch(lower(effectiveLithoType))
    case 'mode'
         strata = upscaleStrataRandomMode(strata, nIntervals, isAutoUniform);     
    case 'mean'
         strata = upscaleStrataRandomMean(strata, nIntervals, isAutoUniform);     
end

end