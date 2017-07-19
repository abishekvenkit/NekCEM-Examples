clear all
close all

% rea_file = input('What is your .rea filename? (must located in same folder):  ','s');
% out_file = input('Name the output file:   ','s');
% 
% new_rad = input('What is your new radius? (0.5 to keep the same)  ');
% new_gap = input('What is your new gap? (0.10435 to keep the same)  ');
rea_file = 'single.rea';
out_file = 'test.rea';

new_rad = 1;
new_gap = 0.20870;

% Step 1: read .rea file
data_old = read_rea(rea_file); % keep old version
data = data_old;
E = data_old.info.E; % number of the element


% Step 2 Identify points <<<<<< main script
rad = 0.5; %radius of original cylinder mesh
gap = .10435; %gap of original cylinder mesh

v = data.vertex;
cir = 0*v;
for e = 1:E;
    for i = 1:4;
        if (sqrt(v(e,i,1).^2+v(e,i,2).^2)-rad) < .01
            cir(e,i) = 1;
        else 
            cir(e,i) = 0;
        end
    end
end

for e = 1:E;
    for i = 1:4;
        if cir(e,i) == 1
            v(e,i,1) = (new_rad/rad)*v(e,i,1);
            v(e,i,2) = (new_rad/rad)*v(e,i,2);
        else
            v(e,i,1) = (new_gap/gap)*v(e,i,1);
            v(e,i,2) = (new_gap/gap)*v(e,i,2);
        end
    end
end
data.vertex = v;

edge = data.edge_type;
curve = data.curve;
vertex = data.vertex;
for i=1:E
    for j=1:4
        if data.bool_curve(i,j)
            switch char(edge(i,j))
                case 'm' % midle pt
                    next_ind = mod(j,4)+1;
                    curve(i,j,1:2) = 0.5*(vertex(i,next_ind,1:2) + vertex(i,j,1:2));
                case 'C' % circle
                    minus = sign(curve(i,j,1)); % adjust "-"
                    curve(i,j,1) = minus*sqrt(sum(vertex(i,j,:).^2));
                    curve(i,j,2:end) = 0;
            end
        end
    end
end
data.curve = curve;

% % Step 3: plotting
% figure(1)
% for e=1:E
%     v = data_old.vertex;
%     plot([v(e,:,1),v(e,1,1)],[v(e,:,2),v(e,1,2)],'ob-'); hold on
%     text(sum(v(e,:,1))/4,sum(v(e,:,2))/4,num2str(e))
% end
% title('old mesh')
% axis equal
% 
% figure(2)
% for e=1:E
%     v = data.vertex;
%     plot([v(e,:,1),v(e,1,1)],[v(e,:,2),v(e,1,2)],'ob-'); hold on
%     text(sum(v(e,:,1))/4,sum(v(e,:,2))/4,num2str(e))
% end
% title('new mesh')
% axis equal

% Step 4: output 
write_rea(rea_file,out_file,data);

