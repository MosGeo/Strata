function [newState, binaryNewState] = sampleMarkovChain(previousState, markovMatrix, nStep)
%% SAMPLEMARKOVCHAIN Sample using a transition (Markov) matrix
%
% previousState:        Previous state (can be a number or binary)
% markovMatrix:         Markov chain transition matrix
%
% Mustafa Al Ibrahim @ 2018
% Mustafa.Geoscientist@outlook.com

%% Preprocessing

% Defaults
if ~exist('nStep', 'var'); nStep = 1; end

% Assertions
assert(isMarkovMatrix(markovMatrix), 'markovMatrix must be valid');
assert(all(size(previousState) == [1, size(markovMatrix,1)]) || (isscalar(previousState) && previousState<=size(markovMatrix,1)), 'previousState is not valid');

% Parameters
nStates = size(markovMatrix,1);
if isscalar(previousState)
   binaryPreviousState = zeros(1,nStates);
   binaryPreviousState(previousState) = 1;
else
   binaryPreviousState = previousState;
end

%% Main

% Sample from transition matrix
binaryPreviousState = binaryPreviousState * (markovMatrix^nStep);
cdfVector = cumsum(binaryPreviousState);
rndValue = rand();
newState = find(rndValue <= cdfVector,1);

% Convert to binary if needed
binaryNewState =  zeros(1,nStates);
binaryNewState(newState) = 1;


end