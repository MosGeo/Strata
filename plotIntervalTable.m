function [] = plotIntervalTable(intervalData)
%%

nIntervals = size(intervalData,1);
nClasses = numel(unique(intervalData(:,3)));
colors = gray(nClasses);

totalThickness=  intervalData(end,2);

for i = 1:nIntervals
       startYPosition = intervalData(i,1);
       thickness = intervalData(i,2) - intervalData(i,1);
       value = intervalData(i,3);
       endXPosition = totalThickness/5*(value)^.5;
       rectangle('Position',[0 startYPosition endXPosition thickness], 'FaceColor', colors(value,:));
       hold on;
end

axis tight; axis equal; set(gca,'XTickLabel', []);
set(gca,'YTickLabel', []);

%ylabel('Elevation')
%xlabel('Lithology')
%title('Simulated Lithology from Input')

end