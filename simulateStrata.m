function [depth, age, strata] = simulateStrata(markovMatrices, age, seaLevel, depositionalRates, markovTBPosition)
%% simulateStrata   Simulate interval using Markov chains with sequence stratigraphic framework
%
% Mustafa Al Ibrahim @ 2018
% Mustafa.Geoscientist@outlook.com

%% Testing

age = 0:200;
seaLevel = sin(age/5);
markovMatrices{1} = [.8 .1 .1; .4 .5 .1; .4 .4 .2];
markovMatrices{2} = [.1 .4 .5; .1 .5 .4; 0 .2 .8];

%% Preprocessing

% Preprocessing
if isscalar(age); age = 1:age; end
if ~iscell(markovMatrices); markovMatrices = {markovMatrices}; end

% Parameters
nLithologies = size(markovMatrices{1},1);
nTimeIntervals = numel(age)-1;
nMatrices   = numel(markovMatrices);

% Defaults
if ~exist('matricesPosition', 'var'); matricesPosition = (0:(nMatrices-1))/(nMatrices-1); end
if ~exist('depositionalRates', 'var'); depositionalRates = ones(nLithologies,1); end
if ~exist('seaLevel', 'var'); seaLevel = ones(numel(age),1); end

%% Main

% Sort by descending age
[age,I] = sort(age,'descend');
seaLevel = seaLevel(I);

% Initialize the lithology
initialLithology = round(rand()*(nLithologies-1) + 1);
v = zeros(1,nLithologies);
v(initialLithology) = 1;

intervalTime = -diff(age);

% Initialize the output
startDepositionTime = zeros(nTimeIntervals,1);
endDepositionTime   = zeros(nTimeIntervals,1);
strata           = zeros(nTimeIntervals,1);
thickness           = zeros(nTimeIntervals,1);
currentSeaLevel     = zeros(nTimeIntervals,1);
top  = zeros(nTimeIntervals,1);

totalThickness      = 0;

for i = 1:nTimeIntervals
    currentIntervalTime = intervalTime(i);
    startDepositionTime(i) = age(i);
    endDepositionTime(i)   = age(i+1);
    
    midDepositionTime = (startDepositionTime(i) +  endDepositionTime(i) )/2;
    currentSeaLevel(i) = interp1(age, seaLevel,midDepositionTime);
    
    newPosition = (currentSeaLevel(i) - min(seaLevel))/( max(seaLevel)- min(seaLevel));
    
    P = interpMarkovMatrix(markovMatrices, newPosition, matricesPosition);
    
    [sample, v] = sampleMarkovChain(v, P);
    strata(i) = sample;
    
    currentDepositionalRate = depositionalRates(sample);
    
    thickness(i) = currentDepositionalRate*currentIntervalTime;
    totalThickness = totalThickness + thickness(i);
    top(i) = totalThickness;

end
    bottom = [0; top(1:end-1)];



% Plotting 
[intervalData] = thickness2interval(strata, true, thickness);
figure('Color', 'White')
subplot(1,2,1)
plot(currentSeaLevel, top);
axis tight
subplot(1,2,2)
plotIntervalTable(intervalData);


end

    
