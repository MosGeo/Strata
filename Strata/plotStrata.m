function axisHandle = plotStrata(strata, isPlotErosion)

%% Preprocessing

% Defaults
if ~exist('isPlotErosion', 'var'); isPlotErosion = true; end

%% Main

nIntervals = size(strata,1);
nClasses = numel(unique(strata.lithology));
colors = gray(nClasses);

[topDepth, baseDepth] = analyzeStrataThickness(strata, ~isPlotErosion);

nDeposits   = sum(strata.thickness>0);
indDeposits = find(strata.thickness>0);
for iDeposit = 1:nDeposits
       i = indDeposits(iDeposit);
       startYPosition = topDepth(i);
       thickness = baseDepth(i)- topDepth(i);
       value = strata.lithology(i);
       endXPosition = baseDepth(1)/5*(value)^.5;
       
       rectangle('Position',[0 startYPosition endXPosition thickness], 'FaceColor', colors(value,:));
       hold on;
        
end


if isPlotErosion == true
    nErosions   = sum(strata.thickness<=0);
    indErosions = find(strata.thickness<=0);

    for iErosion = 1:nErosions
              i = indErosions(iErosion);
              startYPosition = topDepth(i);
              
              if i>1
                  value = strata.lithology(i-1);
              else
                  value = nClasses;
              end
              endXPosition = baseDepth(1)/5*(value)^.5;

              x =  0:.01:endXPosition;
              y =  startYPosition + sin(x*10)*baseDepth(end)/200;
              plot(x,y,'r', 'LineWidth',2)
    end     
   
end
       
axis tight; axis equal; set(gca,'XTickLabel', []);
set(gca,'yDir', 'reverse')
ylabel('Depth');
xlabel('Lithology');


end