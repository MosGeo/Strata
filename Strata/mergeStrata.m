function strata = mergeStrata(strata)
%% MERGESTRATA  Merges consecutive strata into one interval
%
% Mustafa Al Ibrahim @ 2018
% Mustafa.Geoscientist@outlook.com

%% Preprocessing

% Assertions
assert(exist('strata', 'var')== true, 'strata must be provided');

%% Main

% Make sure lithology is a vector
if (~isvector(strata.lithology)); return; end

% Parameters
lithology     = strata.lithology;
thickness     = strata.thickness;
startTime     = strata.startTime;
endTime       = strata.endTime;
midSeaLevel   = strata.midSeaLevel;

% Merge deposits
startInd  = find(diff([nan; lithology]) ~= 0); 
endInd    = find(diff([lithology; nan]) ~= 0);

lithologyMerged     = lithology(startInd);
funSum  = @(sInd, eInd) sum(thickness(sInd:eInd));
thicknessMerged = arrayfun(funSum,  startInd, endInd);

startTimeMerged = startTime(startInd);
endTimeMerged   = endTime(endInd);

funMean      = @(sInd, eInd) sum(midSeaLevel(sInd:eInd).*thickness(sInd:eInd)/sum(thickness(sInd:eInd))) ;
midSeaLevelMerged  = arrayfun(funMean,  startInd, endInd);

strata = table(startTimeMerged, endTimeMerged, thicknessMerged, lithologyMerged, midSeaLevelMerged);
strata.Properties.VariableNames = {'startTime', 'endTime', 'thickness', 'lithology', 'midSeaLevel'};

end