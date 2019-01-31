function axisHandle = plotStrata(strata, isPlotErosion, isFinalizeStrata, nClasses)
%% PLOTSTRATA  Plot a stratigraphic section
%
% strata:           Strataigraphic table (includes lithology, thickness)
% isPlotErostion:   Plot erosional surfaces in the stratigraphic section
%
% Mustafa Al Ibrahim @ 2018
% Mustafa.Geoscientist@outlook.com

%% Preprocessing

% Defaults
if ~exist('isPlotErosion', 'var'); isPlotErosion = true; end
if ~exist('isFinalizeStrata', 'var'); isFinalizeStrata = true; end

% Assertions
assert(exist('strata', 'var')==true, 'strata must be provided');
assert(isa(isPlotErosion, 'logical') && isscalar(isPlotErosion), 'isPlotErosion must be logical scalar');

% Parameters
isLithologyComp = ~isvector(strata.lithology);

% Defaults 2
if ~exist('nClasses', 'var') && ~isLithologyComp; nClasses = numel(unique(strata.lithology)); end 
if ~exist('nClasses', 'var') && isLithologyComp; nClasses = numel(strata.lithology(1,:)); end 


%% Main

% Finalize strata if requested
if isFinalizeStrata
    strata = finalizeStrata(strata);
end

% Initial needed parameters
colors = gray(nClasses);
[topDepth, baseDepth] = analyzeStrataThickness(strata, ~isPlotErosion);

% Plot deposits
nDeposits   = sum(strata.thickness>0);
indDeposits = find(strata.thickness>0);

for iDeposit = 1:nDeposits
       i = indDeposits(iDeposit);
       startYPosition = topDepth(i);
       thickness = baseDepth(i)- topDepth(i);
       
       if ~isLithologyComp
           value = strata.lithology(i);
           endXPosition = baseDepth(1)/5*(value)^.5;
           rectangle('Position',[0 startYPosition endXPosition thickness], 'FaceColor', colors(value,:));
       else
           values = strata.lithology(i,:);
           maxPosition = baseDepth(1)/5*(nClasses)^.5;
           width = values*maxPosition;
           startXPositions = [0, cumsum(width)];
           for i = 1:nClasses
               if width(i) > 0 
                    rectangle('Position',[startXPositions(i) startYPosition width(i) thickness], 'FaceColor', colors(i,:));
               end
           end
           
       end
       hold on;
       
end

% Plot erosion
if isPlotErosion == true
    nErosions   = sum(strata.thickness<=0);
    indErosions = find(strata.thickness<=0);

    for iErosion = 1:nErosions
              i = indErosions(iErosion);
              startYPosition = topDepth(i);
              
              value = 0;
              if i>1 && strata.thickness(i-1)>0
                  value = strata.lithology(i-1);
              elseif i==1
                  value = nClasses;
              end
              
              if isLithologyComp; value = nClasses; end
              endXPosition = baseDepth(1)/5*(value)^.5;
                  
              x =  0:.01:endXPosition;
              y =  startYPosition + sin(x*10)*baseDepth(end)/8;
              plot(x,y,'r', 'LineWidth',2)
    end      
end


% Finalize plot
axis tight; 
%axis equal; 
set(gca,'XTickLabel', []);
set(gca,'yDir', 'reverse')
ylabel('Depth');
xlabel('Lithology');
set(gca, 'FontUnits','points', 'FontWeight','normal', 'FontSize',12, 'FontName','Times')


end