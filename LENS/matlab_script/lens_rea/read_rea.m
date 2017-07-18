function data = read_rea(filename)
% This function read rea file and grep the data of elements.
%
% data.info.E:      num of element
% data.info.ndim:   dimension
% data.info.nelg:   nelg
% data.info.vertex: (E, v1~v4, x or y)
% data.str_rea:     '      ELEMENT          1 [    0a]    GROUP     0'
% data.num_c:       num of special curves
% data.bool_curve:  if is special curve, 1/0
% data.edge_type:   m: mid point, c: circle
% data.curve:       parameters of curves
% data.BC_type:     type of BC, P/E/...
% data.BC:          parameters of BC


fid = fopen(filename,'r');
sec_num(1) = 143; % irrelative lines


% Sec 1: go through sec 1 and do nothing
for i=1:sec_num(1)
    fline = fgets(fid);
end

% Sec 2: read vertices of elements
fline = fgets(fid);
vec = sscanf(fline,'%d');
E= vec(1); ndim = vec(2); nelg=vec(3);
info.E = E;
info.ndim = ndim;
info.nelg = nelg;
data.info = info;

vertex = zeros(E,4,2); 
str_rea = cell(E,1);
for e=1:E
    fline = fgets(fid); % read first line
    str_rea(e) = {fline};
    
    fline = fgets(fid); % read second line
    vertex(e,:,1) = sscanf(fline,'%f',[1,4]); % x
    
    fline = fgets(fid); % read third line
    vertex(e,:,2) = sscanf(fline,'%f',[1,4]); % y
end
data.vertex = vertex;
data.str_rea = str_rea;

% Sec 3: read spetial curves
fline = fgets(fid);
fline = fgets(fid);
num_c = sscanf(fline,' %d '); % number of curves (the rest are straight line?)

bool_curve = zeros(E,4);
curve = zeros(E,4,5);
edge = cell(E,4);
for i=1:num_c
    fline = fgets(fid);
    vec_int = sscanf(fline,'%d %d');
    vec = sscanf(fline,'%d %d %f %f %f %f %f');
    str = sscanf(fline,'%s');

    bool_curve(vec_int(2),vec_int(1)) = 1;
    curve(vec_int(2),vec_int(1),:) = vec(3:7); 
    edge (vec_int(2),vec_int(1)) = {str(end)};
end
data.num_c = num_c;
data.edge_type = edge;
data.curve = curve;
data.bool_curve = bool_curve;

% Sec 4: read boundary condition
fline = fgets(fid);
fline = fgets(fid);

BC = zeros(E,4,5);
BC_type = cell(E,4);
for i=1:E 
    for j=1:4
        fline = fgets(fid);
        vec = sscanf(fline,'%*s %f %f %f %f %f %f %f',[1,7]);
        str = sscanf(fline,'%s1');

        BC(i,j,:) = vec(3:7);
        BC_type(i,j) = {str};
    end
end
data.BC_type = BC_type;
data.BC = BC;

fclose(fid);
end