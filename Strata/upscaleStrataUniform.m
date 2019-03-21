function strata = upscaleStrataUniform(strata, scale, effectiveLithoType, isAutoUniform)
%% UPSCALESTRATA  Upscale classificaiton
%
% strata:           Strataigraphic table (includes lithology, thickness)
%
% Mustafa Al Ibrahim @ 2018
% Mustafa.Geoscientist@outlook.com

%% Preprocessing

% Defaults
if ~exist('scale', 'var'); scale = 1; end
if ~exist('effectiveLithoType', 'var'); effectiveLithoType = 'Mode'; end
if ~exist('isAutoUniform', 'var'); isAutoUniform = false; end

% Assertions
assert(exist('strata', 'var')==true, 'strata must be provided');
assert(ischar(effectiveLithoType) && ismember(lower(effectiveLithoType), {'mode', 'mean'}), 'type must be mode or mean');

%% Main

% Simple moving mean/mode upscaling
smoothingInterval = 2*scale +1;
switch(lower(effectiveLithoType))
    case 'mode'
         strata = upscaleStrataUniformMode(strata, smoothingInterval, isAutoUniform);     
    case 'mean'
         strata = upscaleStrataUniformMean(strata, smoothingInterval, isAutoUniform);     
end

end