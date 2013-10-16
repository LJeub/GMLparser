function [datastruct]=gml_to_matlab(filename)

file=fopen(filename);


% initialise variables
level=1;
datastruct=[];
multiplicity={};
lastfield={};

tline=fgetl(file);
while ischar(tline)
    tline=strtrim(tline);
    if ~isempty(tline)  %ignore empty lines
        if strncmp(tline,'#',1) %ignore comment lines
            tline=[];
        else
            [field,~,~,index]=sscanf(tline,'%s',1);
            
            % checks for increment/decrement of level ([,]), anything that follows a bracket will be ignored
            if strcmp(field,'[')
                level=level+1;
                tline=strtrim(tline(2:end));
            elseif strcmp(field,']')
                level=level-1;
                tline=strtrim(tline(2:end));
            else
                
                % keep track of multiple fields with same name (such as all the nodes)
                % lastfield tracks the position in the tree
                if length(multiplicity)<level||length(lastfield)<2*level % field is new
                    multiplicity{level}.(field)=1;
                elseif isfield(getfield(datastruct,lastfield{1:2*level-2}),field) % check if field exists
                    multiplicity{level}.(field)=multiplicity{level}.(field)+1;
                else % field is new
                    multiplicity{level}.(field)=1;
                end
                lastfield{2*level-1}=field;
                
                
                % deal with quirks in matlab structure
                
                % if field is new
                if multiplicity{level}.(field)==1
                    lastfield=lastfield(1:2*level-1);
                else
                    % if field already exists
                    lastfield{2*level}={multiplicity{level}.(field)};
                    lastfield=lastfield(1:2*level);
                end
                
                % insert index for fields created at the last step
                if level>1
                    if isempty(lastfield{2*level-2})
                        lastfield{2*level-2}={1};
                    end
                end
                
                tline=tline(index:end);
                
                % get value of key (if two values specified only second is
                % kept)
                while ~isempty(tline)
                    
                    % extract field if it is numeric
                    [field,~,~,index]=sscanf(tline, '%f',1);
                    tline=tline(index:end);    % if not numeric index gives first non-whitespace character
                    if ~isempty(field)
                        datastruct=setfield(datastruct,lastfield{:},field);
                        
                        % extract field if it is a string delmited by ""
                    elseif strcmp(tline(1),'"')
                        index=2;
                        it=1;
                        while (~strcmp(tline(index),'"'))&&(index<=length(tline))
                            field(it)=tline(index);
                            index=index+1;
                            it=it+1;
                        end
                        index=index+1;
                        datastruct=setfield(datastruct,lastfield{:},char(field));
                        
                        % checks for increment/decrement of level ([,]), anything that follows a bracket will be ignored
                    else
                        [field,~,~,index]=sscanf(tline, '%s',1);
                        if strcmp(field,'[')
                            level=level+1;
                            tline=strtrim(tline(2:end));
                            break
                        elseif strcmp(field,']')
                            level=level-1;
                            tline=strtrim(tline(2:end));
                            break
                        end
                    end
                    tline=tline(index:end);
                end
            end
        end
    end
    
    if isempty(tline)
        tline=fgetl(file);
    end
end

end