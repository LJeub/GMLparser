function graph=find_graph(gmlstruct)
% graph=find_graph(gmlstruct) finds graph in gmlstruct
%
% Recursively iterates through gmlstruct until it finds the graph and
% returns it. If no graph is found, returns empty array.

% Version: 1.0
% Date: 05/12/2013
% Author: Lucas Jeub
% Email: jeub@maths.ox.ac.uk
graph=[];
if isstruct(gmlstruct)
    if isfield(gmlstruct,'node')
        % gmlstruct is already a graph
        graph=gmlstruct;
    elseif~isfield(gmlstruct,'graph')
        % no graph at top level
        fields=fieldnames(gmlstruct);
        i=1;
        while isempty(graph)&&i<=length(fields)
            graph=find_graph(gmlstruct.(fields{i}));
            i=i+1;
        end
    else
        % graph at top level
        graph=gmlstruct.graph;
    end
end
end
