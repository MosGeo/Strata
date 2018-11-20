function markovMatrix  = estimateMarkovMatrix(states, direction)
%% ESTIMATEMARKOVMATRIX  Markov matrix estimation given a states vector
%
% states:           State vector to be used for Markov matrix estimation
% direction:        Direction of examination, top2bottom or bottom2top
%
% Mustafa Al Ibrahim @ 2018
% Mustafa.Geoscientist@outlook.com

%% Preprocessing

% Defaults
if ~exist('direction', 'var'); direction = 'top2bottom'; end

% Assertions
assert(exist('states', 'var')==true && isvector(states), 'states must be a vector');
assert(ischar(direction), 'direction must be a string');
assert(ismember(direction, {'top2bottom', 'bottom2top'}), 'direction must be top2bottom or bottom2top');

%% Main

% Make sure it is a column
states = states(:);

% Initialize the Markov transition matrix
nClasses     = max(states);
markovMatrix = zeros(nClasses, nClasses);

% Build the transition vectors
if strcmp(direction, 'top2bottom')  
    transition = [states(1:end-1) states(2:end)];
elseif strcmp(direction, 'bottom2top')  
    transition = [states(2:end), states(1:end-1)];
end

% Build all transition vectors
classesVector = (1:nClasses)';
combinations = [combnk(classesVector,2); fliplr(combnk(classesVector,2));...
    classesVector classesVector];

% Calculate the number of transitions
for i = 1:size(combinations,1)
   instances = ismember(transition, combinations(i,:),'rows');   
   markovMatrix(combinations(i,1), combinations(i,2)) = sum(instances);
end

% Normalize the matrix to obtain the Markov Matrix
markovMatrix = markovMatrix ./ repmat(sum(markovMatrix,2),1,nClasses);

end