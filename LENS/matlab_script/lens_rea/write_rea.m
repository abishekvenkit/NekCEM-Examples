function write_rea(ref_rea,out_rea,data)
% This function generate .rea file based on an old rea file and modified data
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


fid_ref = fopen(ref_rea,'r');
fid_out = fopen(out_rea,'w');
sec_num(1) = 143; % irrelative lines

sp2 = '  ';
sp4 = '    ';
sp6 = '      ';

fm2 = [sp2 '%.7f' sp6 '%.7f' sp6 '%.7f' sp6 '%.7f'];
fm31 = [sp2 '%d  %d'];
fm32 = [sp2 '%.5E' sp6 '%.5E' sp6 '%.5E' sp6 '%.5E' sp6 '%.5E'];
fm33 = [sp6 '%c \n'];
fm41 = [sp2 '%c'];
fm42 = [sp4 '%d  %d'];
fm43 = [sp4 '%.7f' sp6 '%.4f' sp6 '%.4f' sp6 '%.4f' sp6 '%.4f\n'];

% Sec 1: go through sec 1
for i=1:sec_num(1)
    fline = fgets(fid_ref);
    fprintf(fid_out,fline);
end

% Sec 2: read vertices of elements
fline = fgets(fid_ref);
fprintf(fid_out,fline);
E = data.info.E;

vertex = data.vertex;
str_rea= data.str_rea; 
for e=1:E
    fline = fgets(fid_ref); % do nothing
    fprintf(fid_out,char(str_rea(e)));
    
    fline = fgets(fid_ref); % do nothing
    fprintf(fid_out,fm2,vertex(e,:,1)); 
    fprintf(fid_out,'\n');
    
    fline = fgets(fid_ref); % do nothing
    fprintf(fid_out,fm2,vertex(e,:,2));  
    fprintf(fid_out,'\n');
end

% Sec 3: read special curves
fline = fgets(fid_ref);fprintf(fid_out,fline);
fline = fgets(fid_ref);fprintf(fid_out,fline);
num_c = data.num_c;

edge = data.edge_type;
curve = data.curve;
for i=1:E
    for j=1:4
        if data.bool_curve(i,j)
            fline = fgets(fid_ref); % do nothing
            
            fprintf(fid_out,fm31,j,i);
            fprintf(fid_out,fm32,curve(i,j,:));  
            fprintf(fid_out,fm33,char(edge(i,j)));
        end
    end
end


% Sec 4: read boundary condition
fline = fgets(fid_ref);fprintf(fid_out,fline);
fline = fgets(fid_ref);fprintf(fid_out,fline);

BC = data.BC;
BC_type = data.BC_type;
for i=1:E 
    for j=1:4
        fline = fgets(fid_ref); % do nothing
        fprintf(fid_out,fm41,char(BC_type(i,j)));
        fprintf(fid_out,fm42,i,j);  
        fprintf(fid_out,fm43,BC(i,j,:));
    end
end

fline = fgets(fid_ref);
while fline ~= -1
    fprintf(fid_out,fline);
    fline = fgets(fid_ref);
end

fclose(fid_ref);
end



