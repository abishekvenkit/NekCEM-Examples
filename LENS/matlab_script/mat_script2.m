 clear all
 close all
 new_rad = input('What is your new radius? (0.5 to keep the same)')
 new_gap = input('What is your new gap? (0.10435 to keep the same)')
% rea_a.nel = input('What is your original 
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


% Step 2 Identify points
rad = 0.5 %radius of original cylinder mesh
gap = .10435 %gap of original cylinder mesh
for e = 1:E;
    v = cylinder(e).vertex;
    for i = 1:4;
        if ((sqrt(v(1,i).^2+v(2,i).^2)-rad)<.01)
	  cir(i) = 1;
        else 
	  cir(i) = 0;
        end
    end
cylinder(e).cir = cir;
end

for e = 1:E;
    v = cylinder(e).vertex
    for i = 1:4;
        if (cylinder(e).cir(i) == 1)
	  v(1,i) = (new_rad/rad)*v(1,i)
	  v(2,i) = (new_rad/rad)*v(2,i)
	else
	  v(1,i) = (new_gap/gap)*v(1,i)
	  v(2,i) = (new_gap/gap)*v(2,i)
        end
    end
    cylinder(e).new_vertex = v;
end
 
       
% Step 3: plotting
figure(1)

for e=1:E
    v = cylinder(e).vertex;
    plot([v(1,:),v(1,1)],[v(2,:),v(2,1)],'ob-'); hold on
end


figure(2)

for e=1:E
    v = cylinder(e).new_vertex;
    plot([v(1,:),v(1,1)],[v(2,:),v(2,1)],'ob-'); hold on
end

% Step 4: output 
%fid_out=fopen(fid_out,'w'); % create a file

%for e=1:E
%    fprintf(fid_out,cylinder(e).str); % print first line
%    fprintf('\n');
%    
%    fprintf(fid_out,'\t %f \t %f \t %f \t %f \n',cylinder(e).vertex(1,:));
%    fprintf(fid_out,'\t %f \t %f \t %f \t %f \n',cylinder(e).vertex(2,:));
%end
%fclose(fid_out);% close a file



