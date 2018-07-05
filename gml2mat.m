function [A, nodes] = gml2mat(gmlstruct)
% [A,node_id]=GMLSTRUCT2MAT(graph)
%
% GML2MAT takes a gmlstruct graph and converts it to an adjacency matrix. 

% Version: 1.0
% Date: 05/12/2013
% Author: Lucas Jeub
% Email: jeub@maths.ox.ac.uk


graph=find_graph(gmlstruct);
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
    nodes={graph.node.id};
    nodeMap=containers.Map(nodes,1:numel(nodes));
    mapFun=@(kcell) cellfun(@(k) nodeMap(k),kcell);
    sources=mapFun({graph.edge.source});
    targets=mapFun({graph.edge.target});
else
    nodes=[graph.node.id];
    nodeMap=containers.Map(nodes,1:numel(nodes));
    mapFun=@(kvec) arrayfun(@(k) nodeMap(k),kvec);
    sources=mapFun([graph.edge.source]);
    targets=mapFun([graph.edge.target]);
end

if isfield(graph.edge,'value')
    values=[graph.edge.value];
else
    values=1;
end


A=sparse(targets,sources,values,N,N);

if ~graph.directed
    A=A+sparse(sources,targets,values,N,N);
end
    
end


