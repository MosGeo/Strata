

%% Testing
clear all

age = 0:200;
seaLevel = sin(age/15);
markovMatrices{1} = [.8 .1 .1; .4 .5 .1; .4 .4 .2];
markovMatrices{2} = [.1 .4 .5; .1 .5 .4; 0 .2 .8];


[strata] = simulateStrata(markovMatrices, age, seaLevel);

% Plotting 
[intervalData] = thickness2interval(strata.lithology, true, strata.thickness);
figure('Color', 'White')
subplot(1,2,1)
plot(strata.seaLevel, strata.topDepth);
axis tight
subplot(1,2,2)
plotIntervalTable(intervalData);