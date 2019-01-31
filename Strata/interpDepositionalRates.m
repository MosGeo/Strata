function interploatedDepositionRates = interpDepositionalRates(depositionalRates,  newPosition, matricesPosition)
%% ISMARKOVMATRIX Check if matrix is a valid Markov transition matrix
%
% depositionalRates:         Depositional rates (cell array)
%
% Mustafa Al Ibrahim @ 2018
% Mustafa.Geoscientist@outlook.com

%% Preprocessing

% Parameters
if iscell(depositionalRates); depositionalRates = cell2mat(permute(depositionalRates,[1 3 2])); end
nVectors = size(depositionalRates,3);
nStates   = numel(depositionalRates(:,:,1));


% Defaults
if ~exist('matricesPosition', 'var'); matricesPosition = (0:(nVectors-1))/(nVectors-1); end

% Assertions


%% Main

% Special case, no need for interpolation
if nVectors == 1
    interploatedDepositionRates = depositionalRates;
    return
end

% Permute to get interpolated dimension first:
depositionalRates = permute(depositionalRates,[3 1 2]);

% Interpolate and recover shape
interploatedDepositionRates = interp1(matricesPosition, depositionalRates, newPosition);
interploatedDepositionRates = reshape(interploatedDepositionRates, 1,nStates,1);


end