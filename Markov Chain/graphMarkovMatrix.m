function [p1, p2] = graphMarkovMatrix(markovMatrix, stateNames)
%% GRAPHMARKOVMATRIX  Graph a Markov transitional matrix.
%
% Mustafa Al Ibrahim @ 2018
% Mustafa.Geoscientist@outlook.com

%% Preprocessing

% Assertions
assert(exist('markovMatrix', 'var')==true, 'markovMatrix must be provided');
assert(isMarkovMatrix(markovMatrix), 'markovMatrix is not a valid transition matrix');

% Parameters
nStates = size(markovMatrix,1);

% Defaults
if ~exist('stateNames', 'var'); stateNames = cellfun(@num2str, num2cell(1:nStates), 'UniformOutput', false); end

%% Main

% Create column of edges and weights
[y, x] = meshgrid(1:nStates, 1:nStates);
edge1 = x(:);
edge2 = y(:); 
weights = markovMatrix(:);

% Create digraph
G = digraph(edge1,edge2, weights);

% Plotting
figure('Color' , 'White', 'Units','inches', 'Position',[0 0 7 3],'PaperPositionMode','auto');

subplot(1,2,1)
p1 = heatmap(markovMatrix);
p1.XDisplayLabels=stateNames;
p1.YDisplayLabels=stateNames;
p1.XLabel = 'To';
p1.YLabel = 'From';
p1.ColorbarVisible = 'off';
%p1.Colormap = gray;
p1.Position
set(gca,'FontSize',12,... 
    'FontName','Times')

subplot(1,2,2)
p2 = plot(G,'EdgeLabel',G.Edges.Weight,'LineWidth',2);
p2.Marker = 's';
p2.MarkerSize = p2.MarkerSize*2;
p2.NodeColor = [0 0 0];
%p2.EdgeColor = [.3 .3 .3];
p2.NodeLabel = stateNames;
p2.ArrowSize = p2.ArrowSize*2;
set(gca,'Visible','off')
axis equal
axis tight

end