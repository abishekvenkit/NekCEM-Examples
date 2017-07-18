% Script to make array of meshes with varying radii and gap

rea_file = input('Original .rea filename? (must be in same folder):  ', 's');
dim_arrayx = input('What is the x dimension of array? (radius change axis)');
dim_arrayy = input('What is the y dimension of array? (gap change axis)');
interval_rad = input( 'What interval of rad change?   ');
interval_gap = input('What interval of gap change?   ');

rad = 0.5; %original mesh dimensions
gap = .10435; %original mesh dimensions

mesh_count = 1;
for e = 1: dim_arrayx;
    for i = 1: dim_arrayy; 
        new_rad = rad+((e-1)*interval_rad);
	new_gap = gap+((i-1)*interval_gap);
        rea_str = rea_file(1:end-4);
        int_str = int2str(mesh_count);
        count_str = rea_str+int_str;
	out_file = strcat(rea_file,count_str);
        lens_mesh(rea_file,out_file,new_rad,new_gap);
	mesh_count = mesh_count+1;
    end
end
