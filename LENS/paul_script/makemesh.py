# python makemesh.py rad gap lev_lens lev_buff
from __future__ import division, print_function, absolute_import

import sys
import subprocess

rad, gap, ll, lb = [int(x) for x in sys.argv[1:]]
xy = ((rad+gap/2.0)/rad)*0.5 #using inputs of rad gap to get the proper stretch of mesh gap

# build mesh based on radius gap ratio using PRETEXSCRIPT
PRETEXSCRIPT = """\
pretex << EOF
newmesh
   1 READ PREVIOUS PARAMETERS
original
   1 BUILD FROM FILE
original
   3 GLOBAL REFINE
  11 STRETCH
   7 Stretch Outside Circle
.5  Input protected radius:
 -{}  {} Input new xminxmax (0,0 to scale): old -x; old +x
 -{}  {} Input new yminymax (0,0 to scale): old -y; old +y
   1 UP MENU
   1 END GLOBAL REFINE
   4 CURVE SIDES
   8 Convert Midside to Circle
500  Input maxium radius:
   1 BUILD MENU
   1 END    ELEMENTS
   1 ACCEPT MATL,QVOL
   1 ACCEPT B.C.s
   1 ACCEPT B.C.s
   1 EXIT      
EOF
""".format(xy, xy, xy, xy)
subprocess.call(['bash', '-c', PRETEXSCRIPT])

#DEFINING LAYERS OF PML, BUFFER, AND LENS BELOW

pml = 2 #number of pml layers
num_lev = ((2*pml)+ll+(2*lb)) #number of layers total in mesh
lmbda = 633.0 #wavelength of incoming wave
h = 155.0 #height of lens
lay = [0] #first layer

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
newmesh 
newmesh3d
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
