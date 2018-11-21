%% Testing
clear 
clc

% Parameters
maxAge= 100;
age = (0:maxAge)';
seaLevelAge = 0:.01:maxAge;
seaLevelHeight = sin(seaLevelAge/18)*0+1;
markovMatrices{1} = [.1 .4 .5 0; .1 .495 .4 .005; 0 .15 .7 .15; 0 .1, .4, .5]; % Shallow
%markovMatrices{2} = [.8 .1 .1 0; .4 .5 .1 0; .4 .4 .2 0; 0 0 .7 .3];  % Deep
 
depositionalRates = [1, .7, .5, -.1];
depositionalRates = [1, 1, 1, 1];

%% Multiple realizations

nRealizations=5;
figure('Color', 'White')

for i = 1:nRealizations
    
% Simulate
strata = simulateStrata(markovMatrices, age, seaLevelAge, seaLevelHeight, depositionalRates);
strata = upscaleStrataMean(strata, 11)

% Plotting 
subplot(3,nRealizations,[i, i+nRealizations])
plotStrata(finalizeStrata(strata), true, size(markovMatrices{1}, 1));
title(['Realization ', num2str(i)])
    
hold on
end

subplot(3,nRealizations,2*nRealizations+1:3*nRealizations)
plot(seaLevelAge,seaLevelHeight, 'LineWidth',2)
set(gca, 'xDir', 'reverse')
ylabel('Normalized relative sea-level'); xlabel('Age')
axis tight

%% Upscaling example (Mode)

% Parameters
maxAge= 200;
age = (0:maxAge)';
seaLevelAge = 0:.01:maxAge;
seaLevelHeight = sin(seaLevelAge/20) +  .25*sin(seaLevelAge/5);
markovMatrices{1} = [.1 .4 .5; .1 .5 .4; 0 .3 .7];   % Shallow
markovMatrices{2} = [.7 .2 .1; .4 .5 .1; .4 .4 .2];  % Deep
depositionalRates = [1, 1, 1];

% Simulate
strata = simulateStrata(markovMatrices, age, seaLevelAge, seaLevelHeight, depositionalRates);
smoothingIntervals = [1 3 5 7 9 11 13 15];
nScales = numel(smoothingIntervals);

figure('Color', 'White')

for i = 1:nScales

    smoothingInterval = smoothingIntervals(i);
    strata = upscaleStrata(strata, smoothingInterval, 'mode');

    subplot(1,nScales+1,i+1)
    plotStrata(strata, true, true, size(markovMatrices{1},1));
    title(['Scale: ', num2str(smoothingInterval)])

end

subplot(1,nScales+1,1)
plot(seaLevelHeight, seaLevelAge, 'LineWidth',2)
set(gca, 'yDir', 'reverse')
xlabel('Normalized relative sea-level'); ylabel('Depth')
axis tight

%% Upscaling example (Mean)

% Parameters
maxAge= 200;
age = (0:maxAge)';
seaLevelAge = 0:.01:maxAge;
seaLevelHeight = sin(seaLevelAge/20) +  .25*sin(seaLevelAge/5);
markovMatrices{1} = [.1 .4 .5; .1 .5 .4; 0 .3 .7];   % Shallow
markovMatrices{2} = [.7 .2 .1; .4 .5 .1; .4 .4 .2];  % Deep
depositionalRates = [1, 1, -1];

% Simulate
strata = simulateStrata(markovMatrices, age, seaLevelAge, seaLevelHeight, depositionalRates);
smoothingIntervals = [1 3 5 7 9 11 13 17 25];

nScales = numel(smoothingIntervals);

figure('Color', 'White')

for i = 1:nScales

    smoothingInterval = smoothingIntervals(i);
    strataUpscaled = upscaleStrata(strata, smoothingInterval, 'mean');

    subplot(1,nScales+1,i+1)
    plotStrata(strataUpscaled, true, true, size(markovMatrices{1},1));
    title(['Scale: ', num2str(smoothingInterval)])

end

subplot(1,nScales+1,1)
plot(seaLevelHeight, seaLevelAge, 'LineWidth',2)
set(gca, 'yDir', 'reverse')
xlabel('Normalized relative sea-level'); ylabel('Depth')
axis tight