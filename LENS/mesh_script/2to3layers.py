# python makemesh.py rad gap lev_lens lev_buff
# This script uses original.rea. If you want to use a different original mesh,
# you can change original to your .rea name in lines 17 and 19
# The output mesh file is newmesh3d.rea. To change, change line 83
from __future__ import division, print_function, absolute_import

import sys
import subprocess

ll, lb = [int(x) for x in sys.argv[1:]]

#DEFINING LAYERS OF PML, BUFFER, AND LENS BELOW

pml = 2 #number of pml layers
num_lev = ((2*pml)+ll+(2*lb)) #number of layers total in mesh
lmbda = 633.0 #wavelength of incoming wave
h = 155.0 #height of lens
lay = [0] #first layer
rad = 120

for i in range(1, num_lev):	 
    if i < pml+1 or i > num_lev-pml: #PML layers
	lay.append(lay[i-1]+(((lmbda/2)/pml)/rad)*0.5)
    elif (i > pml and i < (pml+lb+1)) or (i > (num_lev-pml-lb) and i < (num_lev-pml+1)):  #Buffers
	lay.append(lay[i-1]+((lmbda/lb)/rad)*0.5)
    else: #lens
	lay.append(lay[i-1]+((h/ll)/rad)*0.5)

zmax = (((3*lmbda)+h)/rad)*0.5 #total height of mesh

lay.append(zmax)

with open('layers', 'w') as f:
    for i in range(num_lev+1):
        f.write('{}\n'.format(lay[i]))

        
# THE FOLLOWING ARE THE QUESTIONS THAT N2TO3SCRIPT GIVES ANSWERS TO	 
# Input old (source) file name:
# Input new (output) file name:
# For ASCII output only: 0; For .rea/.re2: 1
# input number of levels: (1, 2, 3,...; < 0 for circular sweep.):
# input z min:
# input z max:
# input gain (0=custom,1=uniform,other=geometric spacing):
# input file containing ASCENDING z-values:
# This is for CEM: yes or no:
# Enter Z (5) boundary condition (P,PEC,PMC,PML):
# Enter Z (6) boundary condition (PEC,PMC,PML):

N2TO3SCRIPT = """\
n2to3 << EOF
original1 
original1_3d
0
{}
0
{}
0
layers
yes
PML
PML
EOF
""".format(num_lev, zmax)
subprocess.call(['bash', '-c', N2TO3SCRIPT])
