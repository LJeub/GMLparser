function [ A ] = gmlstruct_to_adjacency( graph, index_fun)
%GMLSTRUCT_TO_ADJACENCY Takes a gmlstruct graph and converts it to an
%adjacency matrix. 
% index_fun converts node_indices to range from 1:N
if nargin<2
    index_fun=@(i) i+1;
end

if ~isfield(graph,'directed')
    graph.directed=0;
end

node_index=index_fun(extract_field(graph,'id','node'));

N=length(node_index);

source_index=index_fun(extract_field(graph,'source','edge'));
target_index=index_fun(extract_field(graph,'target','edge'));

if isfield(graph.edge,'value')
    values=extract_field(graph,'value','edge');
else
    values=1;
end


A=sparse(target_index,source_index,values,N,N);

if ~graph.directed
    A=A+sparse(source_index,target_index,values,N,N);
end
    
    

end

