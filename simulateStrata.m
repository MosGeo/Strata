function [strata] = simulateStrata(markovMatrices, age, seaLevelAge, seaLevelHeight, depositionalRates, matricesPosition)
%% simulateStrata   Simulate interval using Markov chains with sequence stratigraphic framework
%
% Mustafa Al Ibrahim @ 2018
% Mustafa.Geoscientist@outlook.com

%% Preprocessing

% Assertions
assert(exist('age', 'var')==true && iscolumn(age) && isnumeric(age), 'age is not valid');
assert(exist('markovMatrices', 'var')==true,'markovMatrices must be provided');

% Preprocessing
if isscalar(age); age = (1:age)'; end
if ~iscell(markovMatrices); markovMatrices = {markovMatrices}; end
nLithologies = size(markovMatrices{1},1);
nTimeIntervals = numel(age)-1;
nMatrices   = numel(markovMatrices);

% Defaults
if ~exist('seaLevelAge', 'var'); seaLevelAge = age; end
if ~exist('seaLevelHeight', 'var'); seaLevelHeight = ones(numel(age),1); end
if ~exist('depositionalRates', 'var'); depositionalRates = ones(nLithologies,1); end
if ~exist('matricesPosition', 'var'); matricesPosition = (0:(nMatrices-1))/(nMatrices-1); end

% Assertions
assert(iscolumn(seaLevelHeight) && iscolumn(seaLevelAge), 'Sea level age and height must be columns')

%% Main

% Sea level
[age] = sort(age,'descend');
seaLevel = interp1(seaLevelAge, seaLevelHeight, age);

% Initialize the lithology
initialLithology = round(rand()*(nLithologies-1) + 1);
binaryLithology = zeros(1,nLithologies);
binaryLithology(initialLithology) = 1;

% Calculate time
intervalTime = -diff(age);
startDepositionTime = age(1:end-1);
endDepositionTime   = age(2:end);

% Calculate sea level
midDepositionTime   = (startDepositionTime +  endDepositionTime)/2;
midSeaLevel         = interp1(age, seaLevel,midDepositionTime);
normalizedSeaLevel  = (midSeaLevel - min(seaLevel))/( max(seaLevel)- min(seaLevel));

% Simulate deposition
lithology = zeros(nTimeIntervals,1);
for i = 1:nTimeIntervals
    currentTransitionMatrix = interpMarkovMatrix(markovMatrices, normalizedSeaLevel(i), matricesPosition);
    [lithology(i), binaryLithology] = sampleMarkovChain(binaryLithology, currentTransitionMatrix);        
end

% Calculate thicknesses and depth
thickness  = depositionalRates(lithology) .* intervalTime;
totalThickness = cumsum(thickness);
topDepth = max(totalThickness)-totalThickness;
baseDepth = [max(totalThickness); topDepth(1:end-1)]; 

% Organize output
strata = table(startDepositionTime, endDepositionTime, baseDepth, topDepth, thickness, lithology, midSeaLevel);

end

    
