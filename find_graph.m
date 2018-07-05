function graph=find_graph(gmlstruct)
% graph=find_graph(gmlstruct) finds graph in gmlstruct
%
% Recursively iterates through gmlstruct until it finds the graph and
% returns it. If no graph is found, returns empty array.

% Version: 2.0
% Date: Thu  5 Jul 2018 14:15:23 CEST
% Author: Lucas Jeub
% Email: lucasjeub@gmail.com
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
