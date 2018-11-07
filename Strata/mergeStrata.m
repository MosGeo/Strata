function strataMerged = mergeStrata(strata, isApplyErosion, isRemoveErosionLayers)
%% MERGESTRATA  Merges consecutive strata into one interval
%
%
% Mustafa Al Ibrahim @ 2018
% Mustafa.Geoscientist@outlook.com

%% Preprocessing

% Defaults
if ~exist('isMerge', 'var'); isMerge = true; end
if ~exist('isApplyErosion', 'var'); isApplyErosion = true; end
if ~exist('isRemoveErosionLayers', 'var'); isRemoveErosionLayers = false; end

%% Main
lithology     = strata.lithology;
thickness = strata.thickness;
startTime = strata.startTime;
endTime   = strata.endTime;
midSeaLevel  = strata.midSeaLevel;

%% Merging


if isMerge == true
    % Fine indecis
    startInd  = find(diff([nan; lithology]) ~= 0); 
    endInd    = find(diff([lithology; nan]) ~= 0);
    
    nIntervals = sum(startInd);


    lithologyMerged     = lithology(startInd);

    funSum  = @(sInd, eInd) sum(thickness(sInd:eInd));
    thicknessMerged = arrayfun(funSum,  startInd, endInd);

    startTimeMerged = startTime(startInd);
    endTimeMerged   = endTime(endInd);

    funMean      = @(sInd, eInd) sum(midSeaLevel(sInd:eInd).*thickness(sInd:eInd)/sum(thickness(sInd:eInd))) ;
    midSeaLevelMerged  = arrayfun(funMean,  startInd, endInd);

end

%% Erosion (assume the oldest layer is at the top)

if isApplyErosion == true
    erosionLayers = find([0; thicknessMerged(2:end)]<0);
    while(any(erosionLayers))

        erosionInd = erosionLayers;
        erodedInd  = erosionInd-1;
        erosionAmmount = thicknessMerged(erosionInd);

        thicknessMerged(erodedInd) =  thicknessMerged(erodedInd)+ erosionAmmount;
        thicknessMerged(erosionInd) = thicknessMerged(erosionInd) - erosionAmmount;

        erosionLayers = find([0; thicknessMerged(2:end)]<0);
    end
end

%% Build new strata table

strataMerged = table(startTimeMerged, endTimeMerged, thicknessMerged, lithologyMerged, midSeaLevelMerged);
strataMerged.Properties.VariableNames = {'startTime', 'endTime', 'thickness', 'lithology', 'midSeaLevel'};

if (isRemoveErosionLayers==true)
    erodedlayersInd = strataMerged.thicknessMerged <=0;
    strataMerged(erodedlayersInd,:)=[];
end






