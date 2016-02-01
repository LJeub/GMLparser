function [ A,node_id ] = gmlstruct2mat( gmlstruct)
% [A,node_id]=GMLSTRUCT2MAT(graph)
%
% GMLSTRUCT2MAT takes a gmlstruct graph and converts it to an adjacency matrix. 

% Version: 1.0
% Date: 05/12/2013
% Author: Lucas Jeub
% Email: jeub@maths.ox.ac.uk

if ~isfield(gmlstruct,'node')
    graph=find_graph(gmlstruct);
else
    graph=gmlstruct;
end

if isempty(graph)
    error('no graph information found')
end


if ~isfield(graph,'directed')
    if isfield(graph,'edgedefault')
        switch graph.edgedefault
            case 'directed'
                graph.directed=true;
            case 'undirected'
                graph.directed=false;
        end
    else
        graph.directed=true;
    end
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

