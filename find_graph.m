function graph=find_graph(gmlstruct)
graph=[];
if ~isfield(gmlstruct,'graph')
    fields=fieldnames(gmlstruct);
    for i=1:length(fields)
        graph=find_graph(gmlstruct.(fields{i}));
    end
else
    graph=gmlstruct.graph;
end
end
