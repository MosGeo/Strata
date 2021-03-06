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
nMatrices = size(markovMatrices,3);
nStates   = size(markovMatrices(:,:,1),1);

% Defaults
if ~exist('matricesPosition', 'var'); matricesPosition = (0:(nMatrices-1))/(nMatrices-1); end

% Assertions


%% Main

% Special case, no need for interpolation
if nMatrices == 1
    interploatedMarkovMatrix = markovMatrices;
    return
end

% Permute to get interpolated dimension first:
markovMatrices = permute(markovMatrices,[3 1 2]);

% Interpolate and recover shape
interploatedMarkovMatrix = interp1(matricesPosition, markovMatrices, newPosition);
interploatedMarkovMatrix = reshape(interploatedMarkovMatrix, nStates,nStates,1);

end