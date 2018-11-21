function [age, height] =  haqSeaLevel(minAge, maxAge, dt, isPlot)

%% Preprocessing

% Defaults
if ~exist('minAge', 'var'); minAge = -inf; end
if ~exist('maxAge', 'var'); maxAge = inf; end
if ~exist('maxAge', 'var'); dt = nan; end
if ~exist('isPlot', 'var'); isPlot = false; end


%% Main

% Data
fileNames = {'Haq87_Longterm.dat', 'Haq87_Longterm_Normalized.dat', ...
    'Haq87_HighResolution.dat', 'Haq87_HighResolution_Filtered.dat'};

i = 2;
% Import data
rawData = importdata(fileNames{i});
age = rawData(:,1);
height = rawData(:,2);

% Filter data
indexToKeep = age>=minAge & age<=maxAge;
age = age(indexToKeep);
height = height(indexToKeep);

% Resample if needed
if exist('dt', 'var') && ~isnan(dt)
    ageResampled = min(age):dt:max(age);
    heightResampled = interp1(age,height, ageResampled);
    age = ageResampled;
    height = heightResampled;
end


% Plotting
if isPlot
    figure('Color', 'White')
    plot(height, age, 'LineWidth', 2)
    set(gca, 'yDir', 'reverse')
    ylim([min(age), max(age)])
    xlabel('Age')
    ylabel('Height')
end

end