function write_gml(gml_struct, filename, indent)
% WRITE_GML(gml_struct, filename, indent) writes gml struct to file. 

% Version: 2.0
% Date: Thu  5 Jul 2018 14:15:23 CEST
% Author: Lucas Jeub
% Email: lucasjeub@gmail.com
if nargin<3
    indent=2;
end
current_indent=0;
f=fopen(filename,'W');
keys=fieldnames(gml_struct);
for i=1:length(keys)
    write_field(f, keys{i}, gml_struct.(keys{i}), current_indent,indent);
end
fclose(f);
end


function write_field(f, key, value,current_indent,indent)
fprintf(f,'%s',blanks(current_indent));
fprintf(f,'%s ',key);
if ischar(value)
    fprintf(f,'"%s"\n', value);
elseif isnumeric(value)&&isscalar(value)
    fprintf(f,'%g\n', value);
elseif isstruct(value)
    keys=fieldnames(value);
    fprintf(f,'[\n');
    for i=1:length(keys)
        for j=1:numel(value.(keys{i}))
            write_field(f, keys{i}, value.(keys{i})(j),current_indent+indent,indent);
        end
    end
    fprintf(f,'%s]\n',blanks(current_indent));
else
    error('unknown value type')
end
end
