function [ A,node_id ] = gmlstruct2mat( graph)
%GMLSTRUCT2MAT Takes a gmlstruct graph and converts it to an
%adjacency matrix. 


if ~isfield(graph,'directed')
    graph.directed=1;
end

N=length(graph.node);

if ischar(graph.node(1).id)
  
    sources={graph.edge.source};
    targets={graph.edge.target};
else
    
    sources=[graph.edge.source];
    targets=[graph.edge.target];
end

[node_id,~,index]=unique([sources,targets]);
source_index=index(1:length(sources));
target_index=index(length(sources)+1:end);

if isfield(graph.edge,'value')
    values=[graph.edge.value];
else
    values=1;
end


A=sparse(target_index,source_index,values,N,N);

if ~graph.directed
    A=A+sparse(source_index,target_index,values,N,N);
end
    
    

end

