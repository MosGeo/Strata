markovMatrices{1} = [.1 .4 .5; .1 .5 .4; 0 .3 .7];   % Shallow
markovMatrices{2} = [.7 .2 .1; .4 .5 .1; .4 .4 .2];  % Deep
matricesPosition = [0, 1];


markovMatrices{1}+ (markovMatrices{2}-markovMatrices{1}) *.5


newPosition = .5
interploatedMarkovMatrix = interpMarkovMatrix(markovMatrices, newPosition, matricesPosition)