 clear all
 close all

% file 
%	in
file_nel = 'rea_a.nel';
file_xy = 'rea_a.xy';
%	out
fid_out = 'output_filename'; % < put your output filename here


% Step 1: read files
% read "nel" file
fide=fopen(file_nel,'r'); % open a file
fline = fgets(fide);
    A = sscanf(fline,'%d'); 
    E= A(1); ndim = A(2); nelg=A(3);
fclose(fide); % close a file if knowing not gonna use it is a good habit

% read "nel" file
fidv=fopen(file_xy,'r'); % open a file
vertex = zeros(2,4); % element, vertex, xy
for e=1:E;
    fline = fgets(fidv); % read first line
    str = fline; 
    
    fline = fgets(fidv); % read second line
    vertex(1,:) = sscanf(fline,'%f',[1,4]); % x
    
    fline = fgets(fidv); % read third line
    vertex(2,:) = sscanf(fline,'%f',[1,4]); % y

    cylinder(e).str = str;  % structure 
    cylinder(e).vertex = vertex;
end
fclose(fide);% close a file


% Step 2: plotting
figure(1)

for e=1:E
    v = cylinder(e).vertex;
    plot([v(1,:),v(1,1)],[v(2,:),v(2,1)],'ob-'); hold on
end


% Step 3: output 
fid_out=fopen(fid_out,'w'); % create a file

for e=1:E
    fprintf(fid_out,cylinder(e).str); % print first line
    fprintf('\n');
    
    fprintf(fid_out,'\t %f \t %f \t %f \t %f \n',cylinder(e).vertex(1,:));
    fprintf(fid_out,'\t %f \t %f \t %f \t %f \n',cylinder(e).vertex(2,:));
end
fclose(fid_out);% close a file



