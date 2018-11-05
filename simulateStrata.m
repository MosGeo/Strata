function [depth, age, strata] = simulateStrata(markovTM, age, seaLevel, depositionalRates, markovTBPosition)
%% simulateStrata   Simulate interval using Markov chains with sequence stratigraphic framework
%
% Mustafa Al Ibrahim @ 2018
% Mustafa.Geoscientist@outlook.com

%% Testing

age = 0:200;
seaLevel = sin(age/10);
markovTM{1} = [.8 .1 .1; .4 .5 .1; .4 .4 .2];
markovTM{2} = [.1 .4 .5; .1 .5 .4; 0 .2 .8];



%% Preprocessing

% Preprocessing
if isscalar(age); age = 1:age; end
if ~iscell(markovTM); markovTM = {markovTM}; end

% Parameters
nLithologies = size(markovTM{1},1);
nTimeIntervals = numel(age)-1;
nMarkovTM   = numel(markovTM);

% Defaults
if ~exist('markovTBPosition', 'var'); markovTBPosition = (0:(nMarkovTM-1))/(nMarkovTM-1); end
if ~exist('depositionalRates', 'var'); depositionalRates = ones(nLithologies,1); end
if ~exist('seaLevel', 'var'); seaLevel = ones(numel(age),1); end

%% Main

% Sort by descending age
[age,I] = sort(age,'descend');
seaLevel = seaLevel(I);

% Initialize the output
strata = zeros(nTimeIntervals,1);
height = zeros(nTimeIntervals,1);
time   = zeros(nTimeIntervals,1); 

% Initialize the lithology
initialLithology = round(rand()*(nLithologies-1) + 1);
v = zeros(1,nLithologies);
v(initialLithology) = 1;


intervalTime = -diff(age);

startDepositionTime = zeros(nTimeIntervals,1);
endDepositionTime   = zeros(nTimeIntervals,1);
lithology           = zeros(nTimeIntervals,1);
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
    
    P = interpP(markovTM, markovTBPosition, newPosition);
    
    v = v * P;
    cdfVector = cumsum(v);
    rndValue = rand(1,1);
    sample = find(rndValue <= cdfVector,1);
    v =  zeros(1,numel(v));
    v(sample) = 1;
    lithology(i) = sample;
    
    currentDepositionalRate = depositionalRates(sample);
    
    thickness(i) = currentDepositionalRate*currentIntervalTime;
    totalThickness = totalThickness + thickness(i);
    top(i) = totalThickness;
end

bottom = [0; top(1:end-1)];

intervalData = [bottom, top, lithology];

[intervalData] = thickness2interval(lithology, true, thickness);

figure('Color', 'White')
subplot(1,2,1)
plot(currentSeaLevel, top);
axis tight
subplot(1,2,2)
plotIntervalTable(intervalData);


end

    
