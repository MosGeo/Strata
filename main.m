%% Multiple realization example
clear 
clc

% Define sea level curve
rng(84282)
maxAge= 200;
age = (0:2:maxAge)';
seaLevelAge = 0:.01:maxAge;
seaLevelHeight = sin(seaLevelAge/20) ;%+  .25*sin(seaLevelAge/5);

% Define transitional matrices
% markovMatrices{1} = [.1 .4 .5; .1 .5 .4; 0 .3 .7];   % Shallow
% markovMatrices{2} = [.7 .2 .1; .4 .5 .1; .4 .4 .2];  % Deep
% depositionalRates = [1, 1, 1];

markovMatrices{1}    = [.1 .4 .5 0; .1 .5 .4 0; 0 .3 .6 .1; 0 0 .9 .1];  % Shallow
markovMatrices{2}    = [.8 .2 .0 0; .6 .3 .1 0; .5 .2 .3 0; 0 0 .9 .1];  % Deep
depositionalRates{1} = [1, 1, 1, -.1];
depositionalRates{2} = [3, 4, 2, -.1];

% Simulate
nScales = 6
figure('Color', 'White', 'Units','inches', 'Position',[3 3 10 4],'PaperPositionMode','auto');
for i = 1:nScales

    strata = simulateStrata(markovMatrices, age, seaLevelAge, seaLevelHeight, depositionalRates);
    subplot(1,nScales+1,i+1)
    plotStrata(strata, true, true, size(markovMatrices{1},1)-1);
    title(['Realization: ', num2str(i)])
    set(gca,'YTicklabel', [])
    ylabel('')

end

subplot(1,nScales+1,1)
plot(seaLevelHeight, seaLevelAge, 'LineWidth',2)
set(gca, 'yDir', 'reverse')
% xlabel(['Normalized relative', char(10), 'sea level'], 'Interpreter', 'latex'); ylabel('Depth')
xlabel(['Sea level'], 'Interpreter', 'latex'); ylabel('Depth')
axis tight
set(gca, 'FontUnits','points', 'FontWeight','normal', 'FontSize',12, 'FontName','Times')


%% Upscaling example (Mode)

rng(842)
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

figure('Color', 'White', 'Units','inches', 'Position',[3 3 10 4],'PaperPositionMode','auto');
for i = 1:nScales

    smoothingInterval = smoothingIntervals(i);
    strata = upscaleStrata(strata, smoothingInterval, 'mode');

    subplot(1,nScales+1,i+1)
    plotStrata(strata, true, true, size(markovMatrices{1},1));
    title(['Scale: ', num2str(smoothingInterval)])
    set(gca,'YTicklabel', [])
    ylabel('')

end

subplot(1,nScales+1,1)
plot(seaLevelHeight, seaLevelAge, 'LineWidth',2)
set(gca, 'yDir', 'reverse')
xlabel('Sea-level'); ylabel('Depth')
axis tight

%% Upscaling example (Mean)
rng(842)

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
smoothingIntervals = [1 3 5 7 9 11 13 17 25];

nScales = numel(smoothingIntervals);
figure('Color', 'White', 'Units','inches', 'Position',[3 3 10 4],'PaperPositionMode','auto');

for i = 1:nScales

    smoothingInterval = smoothingIntervals(i);
    strataUpscaled = upscaleStrata(strata, smoothingInterval, 'mean');

    subplot(1,nScales+1,i+1)
    plotStrata(strataUpscaled, true, true, size(markovMatrices{1},1));
    title(['Scale: ', num2str(smoothingInterval)])
    set(gca,'YTicklabel', [])
    ylabel('')
end

subplot(1,nScales+1,1)
plot(seaLevelHeight, seaLevelAge, 'LineWidth',2)
set(gca, 'yDir', 'reverse')
xlabel('Sea-level'); ylabel('Depth')
axis tight

%% Upscaling example uniform (Mode)

rng(842)

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
smoothingIntervals = [1 3 5 7 9 11 13 17 25];

nScales = numel(smoothingIntervals);
figure('Color', 'White', 'Units','inches', 'Position',[3 3 10 4],'PaperPositionMode','auto');

for i = 1:nScales

    smoothingInterval = smoothingIntervals(i);
    strataUpscaled = upscaleStrataUniform(strata, smoothingInterval, 'mean');

    subplot(1,nScales+1,i+1)
    plotStrata(strataUpscaled, true, true, size(markovMatrices{1},1));
    title(['Scale: ', num2str(smoothingInterval)])
    set(gca,'YTicklabel', [])
    ylabel('')
end

subplot(1,nScales+1,1)
plot(seaLevelHeight, seaLevelAge, 'LineWidth',2)
set(gca, 'yDir', 'reverse')
xlabel('Sea-level'); ylabel('Depth')
axis tight


