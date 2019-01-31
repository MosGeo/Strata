function strata = finalizeStrata(strata, isMerge, isErode, isRemoveErosionLayers)
%% FINALIZESTRATA  Finalize the stratigraphic section
%
% Mustafa Al Ibrahim @ 2018
% Mustafa.Geoscientist@outlook.com

%% Preprocessing

% Defaults
if ~exist('isMerge', 'var'); isMerge = true; end
if ~exist('isErode', 'var'); isErode = true; end
if ~exist('isRemoveErosionLayers', 'var'); isRemoveErosionLayers = false; end

% Assertions
assert(isa(isMerge, 'logical') && isscalar(isMerge), 'isMerge must be a logical scalar');
assert(isa(isErode, 'logical') && isscalar(isErode), 'isErode must be a logical scalar');
assert(isa(isRemoveErosionLayers, 'logical') && isscalar(isRemoveErosionLayers), 'isMerge must be a logical scalar');

%% Main

% Perform erosion
if isErode == true   
    strata = erodeStrata(strata);
end

% Remove erosion layers
if isRemoveErosionLayers==true
    strata = removeErodedStrata(strata);
end

% Merge layers
if isMerge == true
   strata = mergeStrata(strata);
end


end





