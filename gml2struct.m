function [gmlstruct]=gml2struct(filename)

file=fopen(filename);

% initialise variables
level=1;
gmlstruct=[];
multiplicity={};
currentpos={};

tline=(fgetl(file));
while ischar(tline)
    tline=strtrim(tline);
    if ~isempty(tline)  %ignore empty lines
        switch tline(1)
            case '#'
                tline=[]; %ignore comment lines
                
            case '['
                % checks for increment of level
                level=level+1;
                tline=strtrim(tline(2:end));
            case ']'
                % checks for decrement of level
                level=level-1;
                tline=strtrim(tline(2:end));
        end
        if level==0
            error('tree level reached 0, root is at level 1. Check file for missing [,],"')
        end
    end
    
    if ~isempty(tline)
        % get key
        it=0;
        while (it<length(tline))&&~(tline(it+1)==' ')
            it=it+1;
        end
        key=tline(1:it);
        if ~isvarname(key)
            varkey=genvarname(key);
            warning('%s is not a valid field name for a struct, changed it to %s\n',key,varkey);
            key=varkey;
        end
        tline=strtrim(tline(it+1:end));
        
        % keep track of multiple fields with same name (such as all the nodes)
        % currentpos tracks the position in the tree
        if length(multiplicity)<level||length(currentpos)<2*level % key is new at this level
            multiplicity{level}.(key)=1;
        elseif isfield(multiplicity{level},key) % check if key exists
            multiplicity{level}.(key)=multiplicity{level}.(key)+1; % track number of times key has appeared
        else % key is new
            multiplicity{level}.(key)=1;
        end
        currentpos{2*level-1}=key;
        
        
        % deal with quirks in matlab structure
        
        % if field is new
        if multiplicity{level}.(key)==1
            currentpos=currentpos(1:2*level-1);
        else
            % if field already exists
            currentpos{2*level}={multiplicity{level}.(key)};
            currentpos=currentpos(1:2*level);
        end
        
        % insert index for fields created at the last step
        if level>1
            if isempty(currentpos{2*level-2})
                currentpos{2*level-2}={1};
            end
        end
    end
    
    % get value of key
    if ~isempty(tline)
        % value is a string
        if tline(1)=='"'
            tline=tline(2:end);
            if isempty(tline)
                tline=fgetl(file);
                if ~ischar(tline)
                    error('file ended while reading string');
                else
                    tline=strtrim(tline);
                end
            end
            it=1;
            value=[];
            while tline(it)~='"'
                if length(tline)==it
                    value=[value,{tline}];
                     tline=fgetl(file);
                    if ~ischar(tline)
                        error('file ended while reading string');
                    else
                        tline=strtrim(tline);
                    end
                    it=1;
                else
                    it=it+1;
                end
            end
            value=[value,{tline(1:it-1)}];
            tline=strtrim(tline(it+1:end));
        else
            % extract value if it is numeric
            [value,~,~,index]=sscanf(tline, '%f',1);
            tline=tline(index:end);    % index gives first non-whitespace character after extracted value
        end
        gmlstruct=setfield(gmlstruct,currentpos{:},value);
    end
            
    if isempty(tline)
        tline=fgetl(file);
    end
end
end

