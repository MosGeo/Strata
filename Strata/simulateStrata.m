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
assert(isvector(seaLevelHeight) && isvector(seaLevelAge), 'seaLevelAge, seaLevelHeight, must be vectors')

%% Main

% Deposition rates

% Make sure things are columns
seaLevelHeight = seaLevelHeight(:);
seaLevelAge = seaLevelAge(:);
age = age(:);

% Sea level
[age] = sort(age,'descend');
seaLevel = interp1(seaLevelAge, seaLevelHeight, age);

% Initialize the lithology
initialLithology = round(rand()*(nLithologies-1) + 1);
binaryLithology = zeros(1,nLithologies);
binaryLithology(initialLithology) = 1;

% Calculate time
intervalTime = -diff(age);
startTime = age(1:end-1);
endTime   = age(2:end);

% Calculate sea level
midDepositionTime   = (startTime +  endTime)/2;
midSeaLevel         = interp1(age, seaLevel,midDepositionTime);
normalizedSeaLevel  = (midSeaLevel - min(seaLevel))/( max(seaLevel)- min(seaLevel));

% Simulate deposition
lithology = zeros(nTimeIntervals,1);
thickness = zeros(nTimeIntervals,1);
for i = 1:nTimeIntervals
    currentTransitionMatrix = interpMarkovMatrix(markovMatrices, normalizedSeaLevel(i), matricesPosition);
    currentDepositionRate   = interpDepositionalRates(depositionalRates,  normalizedSeaLevel(i), matricesPosition);
    [lithology(i), binaryLithology] = sampleMarkovChain(binaryLithology, currentTransitionMatrix);
    thickness(i) = currentDepositionRate(lithology(i)) * intervalTime(i);
end

% Organize output
strata = table(startTime, endTime, thickness, lithology, midSeaLevel);

end

    
