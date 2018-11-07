function [topDepth, baseDepth, totalThickness] = analyzeStrataThickness(strata, isKeepErosion, oldLayerPosition)



%% Preprocessing
if ~exist('isKeepErosion' ,'var'); isKeepErosion = false; end
if ~exist('oldLayerPosition' ,'var'); oldLayerPosition = 'top'; end


%% Main

thickness = strata.thickness;

if isKeepErosion; thickness = abs(thickness); end

if strcmp(oldLayerPosition, 'top')
    totalThickness = cumsum(thickness);
    topDepth = max(totalThickness)-totalThickness;
    baseDepth = [max(totalThickness); topDepth(1:end-1)];
elseif strcmp(oldLayerPosition, 'bottom')
    thickness = flipud(thickness);
    totalThickness = cumsum(thickness);
    topDepth = flipud(max(totalThickness)-totalThickness);
    baseDepth = flipud([max(totalThickness); topDepth(1:end-1)]);
    totalThickness = flipud(totalThickness);
end

end