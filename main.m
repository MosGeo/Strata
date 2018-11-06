%% Testing
clear all

% Parameters
age = (0:100)';
seaLevelAge = age;
seaLevelHeight = sin(seaLevelAge/10);
markovMatrices{1} = [.1 .4 .5; .1 .5 .4; 0 .2 .8];
markovMatrices{2} = [.8 .1 .1; .4 .5 .1; .4 .4 .2];
depositionalRates = [.5, .8, 1]';

% Simulate
strata = simulateStrata(markovMatrices, age, seaLevelAge, seaLevelHeight, depositionalRates);

% Plotting 
[intervalData] = thickness2interval(strata.lithology, true, strata.thickness);
figure('Color', 'White')
subplot(1,2,1)

plot(strata.midSeaLevel, strata.topDepth);
set(gca, 'yDir', 'reverse')
xlabel('Relative sea-level'); ylabel('Depth')
axis tight
subplot(1,2,2)
plotIntervalTable(intervalData);