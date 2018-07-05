function gml=read_gml(file)
% gml=READ_GML(file) reads data from gml file and returns it as a struct.

% Version: 2.0
% Date: Thu  5 Jul 2018 14:15:23 CEST
% Author: Lucas Jeub
% Email: lucasjeub@gmail.com
f=fopen(file);
gml=parse_gml(createBuffer(f));

fclose(f);
end

function gml=parse_gml(buffer)
gml=struct();
while ~(buffer.peekNext()==']')&&~buffer.eof()
    key=parse_key(buffer);
    if isfield(gml,key)
        gml.(key)=[gml.(key),parse_value(buffer)];
    else
        gml.(key)=parse_value(buffer);
    end
    buffer.trimSpace();
end
buffer.nextChar();
end

function key=parse_key(buffer)
buffer.trimSpace();
key=parse_token(buffer,@(c) isspace(c)||c=='['||c=='#');
if ~isvarname(key)
    error('invalid key');
end
end

function value=parse_value(buffer)
buffer.trimSpace();
switch buffer.peekNext()
    case '['
        buffer.nextChar();
        value=parse_gml(buffer);
    case '"'
        buffer.nextChar();
        value=parse_string(buffer);
    otherwise
        value=parse_numeric(buffer);
end
end

function value=parse_string(buffer)
    value=parse_token(buffer,@(c) c=='"');
    buffer.nextChar();
end

function value=parse_numeric(buffer)
    numTerm=@(c) isspace(c)||c==']'||c=='#';
    str=parse_token(buffer,numTerm);
    value=str2num(str);
    if isempty(value)
        error('invalid numeric value');
    end
end

function buffer=createBuffer(f)
buffer_text=fgets(f);
pos=1;
    function c=nextChar()
        c=buffer_text(pos);
        pos=pos+1;
        if pos>numel(buffer_text)
            buffer_text=fgets(f);
            pos=1;
        end
    end
    function skipLine()
        buffer_text=fgets(f);
    end
    function c=peekNext()
        c=buffer_text(pos);
    end
    function trimSpace()
        c=peekNext();
        while isspace(c)||c=='#'
            if c=='#'
                skipLine();
                c=peekNext();
            else
                nextChar();
                c=peekNext();
            end
        end
    end
    function eof=iseof()
        eof=~ischar(buffer_text);
    end

buffer=struct('nextChar',@nextChar,'skipLine',@skipLine,'peekNext',@peekNext,...
    'trimSpace',@trimSpace,'eof',@iseof);
end

function str=parse_token(buffer,termFun)
    str='';
    while ~termFun(buffer.peekNext())
        c=buffer.nextChar();
        if ~ischar(c)
            error('end of file reached while reading value');
        end
        str=[str,c];
    end
end
