clear all
close all

rea_file = input('What is your .rea filename? (must located in same folder):  ','s');
out_file = input('Name the output file:   ','s');

new_rad = input('What is your new radius? (0.5 to keep the same)  ');
new_gap = input('What is your new gap? (0.10435 to keep the same)  ');


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

% Step 3: Modify verticies

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

% Step 4: Modify curve information
de = data.edge_type;
dc = data.curve;
for e = 1:E;
    for i = 1:4;
        s = de(e,i);
        if (strcmp(s,'C'))
           dc(e,i,1) = (new_rad/rad)*dc(e,i,1);
        elseif (cir(e,i))
           dc(e,i,1) = (new_rad/rad)*dc(e,i,1);
           dc(e,i,2) = (new_rad/rad)*dc(e,i,2);
        elseif (strcmp(s, 'm'))
           dc(e,i,1) = (new_gap/gap)*dc(e,i,1);
           dc(e,i,2) = (new_gap/gap)*dc(e,i,2);
        end
    end
end
data.edge_type = de;
data.curve = dc;   


% Step 5: plotting
figure(1)
for e=1:E
    v = data_old.vertex;
    plot([v(e,:,1),v(e,1,1)],[v(e,:,2),v(e,1,2)],'ob-'); hold on
    text(sum(v(e,:,1))/4,sum(v(e,:,2))/4,num2str(e))
end
title('old mesh')
axis equal

figure(2)
for e=1:E
    v = data.vertex;
    plot([v(e,:,1),v(e,1,1)],[v(e,:,2),v(e,1,2)],'ob-'); hold on
    text(sum(v(e,:,1))/4,sum(v(e,:,2))/4,num2str(e))
end
title('new mesh')
axis equal

% Step 6: output
write_rea(rea_file,out_file,data);

