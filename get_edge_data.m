function data=get_edge_data(gml,field)
% data=get_edge_data(gml,field) extracts node data from gml struct
%
% Convenience function for extracting edge data. It finds the graph first
% (does not have to be in the top level of 'gml') and returns data as a
% cell array or numeric array depending on the data type.

graph=find_graph(gml);
if ischar(graph.edge(1).(field))
    data={graph.edge.(field)};
else
    data=[graph.edge.(field)];
end
end
