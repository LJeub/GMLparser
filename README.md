# GMLparser

## Read and write graphs in GML format

`GMLparser` provides functions for reading and writing graph data (such as the networks on [Mark Newman's website](http://www-personal.umich.edu/~mejn/netdata/)) in the [GML](http://www.fim.uni-passau.de/index.php?id=17297&L=1) format. The functions support reading and writing arbitrary Struct data, thus preserving any metadata that may be present in the GML file. 

## Usage

### File IO

To read a GML formatted file`'file.gml'`, use
```Matlab
	gml = read_gml('file.gml')
```

which returns the data as a struct array `gml`. To write struct data back to a GML formatted file use
```Matlab
	write_gml('file.gml', gml)
```

Optionally, one can control the amount of indentation per level of the GML tree using
```Matlab
	write_gml('file.gml', gml, indent)
```

where `indent` is the number of additional spaces to add to the beginning of the line for each level. By default `indent=2`. If file size is an issue, one can set `indent=0` to eliminate unnecessary white space.


### Adjacency matrix

Use
```Matlab
	[A, nodes] = gml2mat(gml)
```

to extract the adjacency matrix `A` from the `gml` structure. `nodes` returns the node ids as a Matlab array (if the ids are numeric) or cell array (if the ids are strings). 

To convert an adjacency matrix to a `gml` structure, use
```Matlab
	gml = mat2gml(A)
```

Optionally, one can specify node ids using
```Matlab
	gml = mat2gml(A, node_ids)
```

`node_ids` defaults to a zero-based numerical index. 


### Node and edge data

Node metadata can be extracted from the `gml` structure using
```Matlab
	data = get_node_data(gml, field)
```

where `field` is the attribute name to be extracted. For numeric data `data` is an array and for string data `data` is a cell array.

Similary, edge metadata can be extracted using
```Matlab
	data = get_edge_data(gml, field)
```


### Find graph

```Matlab
	graph = find_graph(gml)
```

recursively iterates through the `gml` struct to find the graph information. This is called internally by the other functions but it may be usefull to call this directly occasionally.
