function interploatedMarkovMatrix = interpMarkovMatrix(markovMatrices, newPosition, matricesPosition)
%% ISMARKOVMATRIX Check if matrix is a valid Markov transition matrix
%
% markovMatrix:         Markov chain transition matrix
%
% Mustafa Al Ibrahim @ 2018
% Mustafa.Geoscientist@outlook.com

%% Preprocessing

% Parameters
if iscell(markovMatrices); markovMatrices = cell2mat(permute(markovMatrices,[1 3 2])); end
nMatrices = numel(markovMatrices);

% Defaults
if ~exist('matricesPosition', 'var'); matricesPosition = (0:(nMatrices-1))/(nMatrices-1); end

% Assertions


%% Main

% Permute to get interpolated dimension first:
markovMatrices = permute(markovMatrices,[3 1 2]);

% Interpolate and recover shape
interploatedMarkovMatrix = interp1(matricesPosition, markovMatrices, newPosition);
interploatedMarkovMatrix = reshape(interploatedMarkovMatrix, 3,3,1);

end