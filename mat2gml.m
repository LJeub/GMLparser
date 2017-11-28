function gml=mat2gml(A,node_ids)
if nargin<2
    node_ids=0:length(A)-1;
end

[source,target,weight]=find(A);
if isequal(A,A')
    directed=0;
    keep=find(source>target);
    source=source(keep);
    target=target(keep);
    weight=weight(keep);
else
    directed=1;
end

nodes=arrayfun(@(id) struct('id',id),node_ids);
if all(weight==1)
    edges=arrayfun(@(s,t) struct('source',node_ids(s),'target',node_ids(t)),...
        source,target);
else
    edges=arrayfun(@(s,t,w) struct('source',node_ids(s),'target',node_ids(t),...
        'weight',w),source,target,weight);
end

gml.graph=struct('directed',directed,'node',nodes,'edge',edges);

end





