function strata = upscaleStrataMode(strata, smoothingInterval, type)
%% UPSCALESTRATA  Upscale classificaiton
%
% strata:           Strataigraphic table (includes lithology, thickness)
%
% Mustafa Al Ibrahim @ 2018
% Mustafa.Geoscientist@outlook.com

%% Preprocessing

% Defaults
if ~exist('smoothingInterval', 'var'); smoothingInterval = 1; end
if ~exist('type', 'var'); type = 'Mode'; end

% Assertions
assert(exist('strata', 'var')==true, 'strata must be provided');
assert(ischar(type) && ismember(lower(type), {'mode', 'mean'}), 'type must be mode or mean');

%% Main

switch(lower(type))
    case 'mode'
         strata = upscaleStrataMode(strata, smoothingInterval);     
    case 'mean'
         strata = upscaleStrataMean(strata, smoothingInterval);     
end

end