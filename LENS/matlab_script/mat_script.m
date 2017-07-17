 clear all
 close all

% file 
%	in
fide=fopen('rea_a.nel','r');
fidv=fopen('rea_a.xy','r');
%	out
fid_out=fopen('rea_n.xy','w');

formatd=' %d ';
formatf=' %f ';
formats=' %s ';

A = fscanf(fide,formatd)'; 

E= A(1); ndim = A(2); nelg=A(3);

vertex = zeros(2,4); % element, vertex, xy
for e=1:E;
    fline = fgets(fidv); % read first line
    str = fline; % string
    
    fline = fgets(fidv); % read second line
    vertex(1,:) = sscanf(fline,'%f',[1,4]); % x
    
    fline = fgets(fidv); % read third line
    vertex(2,:) = sscanf(fline,'%f',[1,4]); % y

    cylinder(e).str = str;  % structure 
    cylinder(e).vertex = vertex;
end



% plot
figure(1)

for e=1:E
    v = cylinder(e).vertex;
    plot([v(1,:),v(1,1)],[v(2,:),v(2,1)],'ob-'); hold on
end













%  = fscanf(fidv,formats)'; 
% A = fscanf(fidv,formatf)'; 
%
% fprintf(fide,'%3d \n',nel1,e,nel2);

%fid0=fopen('rea.xy','w'); fid1=fopen('rea.cs','w'); end;
%      s1= '            ELEMENT';
%      s2= '[    1a]    GROUP     0';
%      fprintf(fid0,'%s%5d %s\n',s1,e,s2);
%      fprintf(fid0,'%16.8e %16.8e %16.8e %16.8e\n',x(1),x(2),x(3),x(4));
%      fprintf(fid0,'%16.8e %16.8e %16.8e %16.8e\n',y(1),y(2),y(3),y(4));


