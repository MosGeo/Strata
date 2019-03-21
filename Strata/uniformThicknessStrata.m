function strataUniform = uniformThicknessStrata(strata, layerThickness)
%% UNIFORMTHICKNESSSTRATA   Resample the strata to uniform thickness
%
% Mustafa Al Ibrahim @ 2019
% Mustafa.Geoscientist@outlook.com

%% Preprocessing

% Assertions
assert(exist('strata', 'var')==true, 'strata must be provided');

% Defaults
if ~exist('layerThickness', 'var'); layerThickness= min(strata.thickness); end

% Assertions
assert(layerThickness <= min(strata.thickness), 'layerThickness <= minimum strata thickness');

% Parameters
isLithologyComp = ~isvector(strata.lithology);

%% Main

strataFlipped = flipud(strata);
cumsumThickness = cumsum(strataFlipped.thickness);

uniformCumsumThickness = (layerThickness:layerThickness:max(cumsumThickness))';

startTime    = interp1(cumsumThickness, strataFlipped.startTime, uniformCumsumThickness);
endTime      = interp1(cumsumThickness, strataFlipped.endTime, uniformCumsumThickness);
midSeaLevel  = interp1(cumsumThickness, strataFlipped.midSeaLevel, uniformCumsumThickness);
thickness    = ones(size(uniformCumsumThickness))*layerThickness;

if ~isLithologyComp
    lithology     = interp1(cumsumThickness, strataFlipped.lithology, uniformCumsumThickness, 'nearest');
else
   
   nonUniformLithology = strataFlipped.lithology;
   nLitho = size(nonUniformLithology,2);
   nPoints = numel(uniformCumsumThickness);
   nonUniformLithology = permute(nonUniformLithology,[1, 3, 2]);
   interploatedMarkovMatrix = interp1(cumsumThickness, nonUniformLithology, uniformCumsumThickness);
   lithology = reshape(interploatedMarkovMatrix, [nPoints, nLitho]);
   
end
    
strataUniform = flipud(table(startTime, endTime, thickness, lithology, midSeaLevel));

end