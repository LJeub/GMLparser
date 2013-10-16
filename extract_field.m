function [ field_cell] = extract_field( struct,field, basefield,iterate_field,range )
%EXTRACT_FIELD creates a cell array containing the values of field for
%struct array struct
%   Detailed explanation goes here
if nargin<3
    basefield={};
end


if ~iscell(basefield)
    basefield={basefield};
end


if nargin<4
    iterate_field=false;
end

if iterate_field
    if ~isempty(basefield)
        fields=fieldnames(getfield(struct,basefield{:}));
    else
        fields=fieldnames(struct);
    end
end


if nargin<5
    if iterate_field
        range=1:length(fields);
    else
       if ~isempty(basefield)
           range=1:length(getfield(struct,basefield{:}));
       else
           range=1:length(struct);
       end
        
    end
end




field_cell=cell(length(range),1);
if ~iscell(field)&&isempty(basefield)
    if iterate_field
        for i=1:length(range)
            field_cell{i}=struct.(fields{i}).(field);
        end
    else
        for i=1:length(range)
            field_cell{i}=struct(i).(field);
        end
    end
else
    if ~iscell(field)
        field={field};
    end
            

   if iterate_field
       for i=1:length(range)
           field_cell{i}=getfield(struct,basefield{:},fields{i},field{:});
       end
   else
       for i=1:length(range)
           field_cell{i}=getfield(struct,basefield{:},{range(i)},field{:});
       end
   end
end

field_array=zeros(length(range),1);

for i=1:length(range)
    if isfloat(field_cell{i})    
        field_array(i)=field_cell{i};
    else
        return
    end
end

    field_cell=field_array;

end

