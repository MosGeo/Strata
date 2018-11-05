function result = isMarkovMatrix(markovMatrix)
%% ISMARKOVMATRIX Check if matrix is a valid Markov transition matrix
%
% markovMatrix:         Markov chain transition matrix
%
% Mustafa Al Ibrahim @ 2018
% Mustafa.Geoscientist@outlook.com

%% Main

% Intialize input
result = true;

% Check if the matrix is valid
if ~ismatrix(markovMatrix); result = false; end
if size(markovMatrix,1) ~= size(markovMatrix,2); result = false; end
if any(sum(markovMatrix,2)-1>=.001); result = false; end

end