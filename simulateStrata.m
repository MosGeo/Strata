function [depth, age, strata] = simulateStrata(markovTM, age, seaLevel, depositionalRates, markovTBPosition)
%% simulateStrata   Simulate interval using Markov chains with sequence stratigraphic framework
%
% Mustafa Al Ibrahim @ 2018
% Mustafa.Geoscientist@outlook.com

%% Testing

age = [1 2 3 4];
seaLevel = [.5, 1, .2 .8];
markovTM{1} = [.8 .1 .1; .3 .6 .1; .2 .2 .6];



%% Preprocessing

% Parameters
nLithologies = size(markovTM,1);
nTimeIntervals = numel(age)-1;

% Defaults
if ~exist('markovTBPosition', 'var'); markovTBPosition = (0:nLithologies)/nLithologies; end
if ~exist('depositionalRates', 'var'); depositionalRates = ones(nLithologies,1); end
if ~exist('seaLevel', 'var'); seaLevel = ones(numel(age),1); end

%% Main

% Sort by descending age
[age,I] = sort(age,'descend')
seaLevel = seaLevel(I);

% Initialize the output
strata = zeros(nTimeIntervals,1);
height = zeros(nTimeIntervals,1);
time   = zeros(nTimeIntervals,1); 

% Initialize the lithology
initialLithology = round(rand()*(nLithologies-1) + 1);
v = zeros(1,nLithologies);
v(initialLithology) = 1;


intervalTime = -diff(age)

startDepositionTime = zeros(nTimeIntervals,1);
endDepositionTime   = zeros(nTimeIntervals,1);
lithology           = zeros(nTimeIntervals,1);
thickness           = zeros(nTimeIntervals,1);

for i = 1:nTimeIntervals
    currentIntervalTime = intervalTime(i);
    startDepositionTime(i) = age(i);
    endDepositionTime(i)   = age(i+1);
    
    P = markovTM{1};
    
    v = v * P;
    cdfVector = cumsum(v);
    rndValue = rand(1,1);
    sample = find(rndValue <= cdfVector,1);
    v =  zeros(1,numel(v));
    v(sample) = 1;
    lithology(i) = sample;
    
    currentDepositionalRate = depositionalRates(sample);
    
    thickness(i) = currentDepositionalRate*currentIntervalTime;
    
    
end
    
    



end