%% Testing
clear 
clc

% Parameters
maxAge= 100;
age = (0:maxAge)';
seaLevelAge = 0:.01:maxAge;
seaLevelHeight = sin(seaLevelAge/18);
markovMatrices{1} = [.1 .4 .5 0; .1 .495 .4 .005; 0 .15 .7 .15; 0 .1, .4, .5]; % Shallow
markovMatrices{2} = [.8 .1 .1 0; .4 .5 .1 0; .4 .4 .2 0; 0 0 .7 .3];  % Deep
depositionalRates = [1, 1, .5, 0];
nRealizations=4;

figure('Color', 'White')

for i = 1:nRealizations
    
% Simulate
strata = simulateStrata(markovMatrices, age, seaLevelAge, seaLevelHeight, depositionalRates);
strataOrig = strata;
strata = mergeStrata(strata, true);

% Plotting 
subplot(3,nRealizations,[i, i+nRealizations])
plotStrata(strata, true);
title(['Realization ', num2str(i)])
    
hold on
end

subplot(3,nRealizations,2*nRealizations+1:3*nRealizations)
%[topDepth, baseDepth, totalThickness] = analyzeStrataThickness(strataOrig);
%plot(strataOrig.midSeaLevel, baseDepth-(baseDepth-topDepth)/2, 'LineWidth', 2);
plot(seaLevelAge,seaLevelHeight, 'LineWidth',2)
set(gca, 'xDir', 'reverse')
ylabel('Normalized relative sea-level'); xlabel('Age')
axis tight