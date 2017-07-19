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

E = data.info.E;



fid_ref = fopen(ref_rea,'r');
fid_out = fopen(out_rea,'w');
sec_num(1) = 143; % irrelative lines

% define format
if E < 1000
    fm31 = ['%3d%3d']; %I3 I3
    fm42 = ['%3d%3d'];
elseif E < 1000000
    fm31 = ['%2d%6d']; %I2 I6
    fm42 = ['%5d%1d'];
else
    fm31 = ['%2d%12d']; %I2 I12
    fm42 = ['%12d%1d'];
end
% Sec 2: MESH DATA
% Sec 3: CURVED SIDE DATA
% Sec 4: BOUNDARY-FLUID
sp1 = ' ';
sp2 = '  ';
sp3 = '   ';
sp4 = '    ';
sp5 = '     ';
sp6 = '      ';
sp7 = '       ';

fm2 = [sp1 '% .7f' sp5 '% .7f' sp5 '% .7f' sp5 '% .7f'];
fm32 = [sp1 '% 1.6f' sp5 '% 1.6f' sp5 '% 1.6f' sp5 '% 1.6f' sp5 '% 1.6f'];
fm33 = [sp1 '%c\n'];
fm41 = [sp1 '%c' sp2];
fm43 = ['\n'];


% Sec 1: go through sec 1
for i=1:sec_num(1)
    fline = fgets(fid_ref);
    fprintf(fid_out,fline);
end


% Sec 2: vertices of elements
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

% Sec 3: spetial curves
fline = fgets(fid_ref);fprintf(fid_out,fline);
fline = fgets(fid_ref);fprintf(fid_out,fline);
num_c = data.num_c;

edge = data.edge_type;
curve = data.curve;
for i=1:E
    for j=1:4
        if data.bool_curve(i,j)
            fline = fgets(fid_ref); % do nothing
%             switch char(edge(i,j))
%                 case 'm' % midle pt
%                     next_ind = mod(j,4)+1;
%                     curve(i,j,1:2) = 0.5*(vertex(i,next_ind,1:2) + vertex(i,j,1:2));
%                 case 'C' % circle
%                     minus = sign(curve(i,j,1)); % adjust "-"
%                     curve(i,j,1) = sqrt(sum(vertex(i,j,:).^2));
%                     curve(i,j,2:end) = 0;
%             end
            fprintf(fid_out,fm31,j,i);
            out_str = f_format(curve(i,j,:),7,'F');
            fprintf(fid_out,out_str);  
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
        out_str = f_format(BC(i,j,:),6,'F');
        fprintf(fid_out,out_str); 
        fprintf(fid_out,fm43);
    end
end

fline = fgets(fid_ref);
while fline ~= -1
    fprintf(fid_out,fline);
    fline = fgets(fid_ref);
end

fclose(fid_ref);
end


