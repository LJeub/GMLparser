function data=get_node_data(gml,field)

graph=find_graph(gml);
if ischar(graph.node(1).(field))
    data={graph.node.(field)};
else
    data=[graph.node.(field)];
end
end
