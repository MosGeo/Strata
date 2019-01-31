%% Generate strata (Mode)
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

figure('Color', 'White')
stratas = [];
for i = 1:nScales

    smoothingInterval = smoothingIntervals(i);
    strata = upscaleStrata(strata, smoothingInterval, 'mode');
    stratas{i} = strata;
    
    subplot(1,nScales+1,i+1)
    plotStrata(strata, true, true, size(markovMatrices{1},1));
    title(['Scale: ', num2str(smoothingInterval)])
    set(gca,'YTicklabel', [])
    ylabel('')
end

subplot(1,nScales+1,1)
plot(seaLevelHeight, seaLevelAge, 'LineWidth',2)
set(gca, 'yDir', 'reverse')
xlabel('Normalized relative sea-level'); ylabel('Depth')
axis tight

%% Set up the models

% Set up the model
PMDirectory = 'C:\Program Files\Schlumberger\PetroMod 2017.1\WIN64\bin';
PMProjectDirectory = 'C:\EFacies BPSM\Tests';
PM = PetroMod(PMDirectory, PMProjectDirectory);
formationName = 'Source';
PM.loadLithology();

lithologyNames = {'Shale (organic rich, typical)', 'Siltstone (organic lean)', 'Sandstone (typical)'}';
TOCL = [6,0,0]';
HIL  = [600, 0, 0]';
Kin = {'03d79ac0-208f-4480-890c-efbcaaba9b0a', '',''};

lithoPMIds = [];
for i = 1:numel(lithologyNames)
lithoPMIds{i}   = PM.Litho.getLithologyId(lithologyNames{i});
end

age = [200 300];
depth = (4000:4199)';

% Create PetroMod Table
for i = 1:nScales
    
    class = stratas{i}.lithology;
    classesLevel = smoothingIntervals(i);
    [intervalTable] = point2Interval(class, depth, age,false);

    nRows = size(intervalTable,1);

    TopID  = num2cell((100:100+nRows-1)');
    TopAge = num2cell(intervalTable.EndAge);
    TopName = numberString([formationName '_' num2str(i)], nRows);
    PresentDayDepth = num2cell(intervalTable.StartDepth);
    PresentDayThickness = num2cell((intervalTable.EndDepth - intervalTable.StartDepth)/3.2808399);
    EventType = num2cell(zeros(nRows,1));
    LayerName = TopName;
    LayerType = repmat({'Deposition'}, nRows,1);
    PaleoDifference = num2cell(repmat(99999, nRows,1));
    PaleoBalance = num2cell(repmat(99999, nRows,1));
    Lithology = num2cell(cellfun(@eval, lithoPMIds(intervalTable.Class)))';
    PSE = num2cell(2*ones(nRows,1));
    KineticUUID = Kin(intervalTable.Class)';
    TOC = num2cell(TOCL(intervalTable.Class));
    HI = num2cell(HIL(intervalTable.Class));
    ColorLayer = num2cell(repmat(-1, nRows,1));
    ColorFacies = num2cell(repmat(-1, nRows,1));
    ToolUsage   = num2cell(repmat(-1, nRows,1));
    ThrustFromAge = num2cell(repmat(99999, nRows,1));

    highResPMTable = [TopID, TopAge, TopName, PresentDayDepth, PresentDayThickness, EventType, LayerName,...
        PaleoDifference, PaleoBalance, Lithology, PSE, KineticUUID, TOC, HI, ColorLayer,...
        ColorFacies, ToolUsage, ThrustFromAge];

    % Model modification

    templateModel = 'strataTemplate';
    newModel = ['strataTemplate_', num2str(classesLevel)];
    nDim = 1;

    % Load and dublicate the model
    PM = PetroMod(PMDirectory, PMProjectDirectory);
    PM.deleteModel(newModel, nDim);
    PM.dublicateModel(templateModel, newModel, nDim);
    model = Model1D(newModel, PMProjectDirectory);

    % Update the number of runs (needed to be high for high resolution modeling
    % in order for the results to converge.
    % model.printTable('Simulation')
    model.updateData('Simulation', 50, 'Ooru');
    model.updateData('Simulation', 0, 'Opor');

    % Find the Shublik Formation
    %model.printTable('Main');

    mainData = model.getData('Main');
    formationIndex = find(ismember(mainData(:,3), 'Source'));
    mainData(formationIndex,:)=[];

    % Inserting the new rows
    highResPMTable = insertRow(mainData, highResPMTable, formationIndex);
    model.updateData('Main', highResPMTable);
    model.updateModel();

end

%% Simulate Models
nScales = numel(smoothingIntervals);
for i = 1:nScales
    
    classesLevel = smoothingIntervals(i);
    newModel = ['strataTemplate_', num2str(classesLevel)];
    nDim = 1;
    [output] = PM.simModel(newModel, nDim, true);

end

%% Run scripts

layerNumbers = [7, 22, 92, 98, 104, 17, 20];
layerNames   = {'Depth','PorePressure', 'TR', 'PorosityEffec', 'So', 'Overpressure', 'MudWeightPP'};
data = [];
for i = 1:nScales
   
    classesLevel = smoothingIntervals(i);
    newModel = ['strataTemplate_', num2str(classesLevel)];
    
    data{i} = []; 
    layers=[];
    for iLayer = 1:numel(layerNumbers)
        %[cmdout, status] = PM.runScript(newModel, 1, 'demo_opensim_output_3rd_party_format', '1000', false)

        [cmdout, status] = PM.runScript(newModel, 1, 'demo_opensim_output_3rd_party_format', num2str(layerNumbers(iLayer)), false); 
        [id, value, layer, unit] = readDemoScriptOutput('demo_1.txt');
        data{i} = [data{i}, value];
        layers{iLayer} = layer;
    end
end

delete('demo_1.txt')

%% Plotting

meanValues = [];
figure('Color', 'White')
layerIndex = 7
legendText = [];
for i = 1:nScales
    classesLevel =  i ;
    
    depthToPlot = [data{classesLevel}(:,1)];
    dataToPlot = data{classesLevel}(:,layerIndex);
    
        
    indexToKeep = depthToPlot>= 4000 & depthToPlot<= 4200;
    depthToPlot = depthToPlot(indexToKeep);
    dataToPlot  = dataToPlot(indexToKeep);
    
    
    stairs(dataToPlot, depthToPlot, 'LineWidth',2);
    hold on
    meanValues(i) = mean(dataToPlot);
    legendText{i} = ['Smoothing: ' num2str(smoothingIntervals(i))];
end

set(gca, 'yDir', 'reverse')
ylim([4000, 4200])
legend(legendText)
title(layers{layerIndex})
ylabel('Depth')