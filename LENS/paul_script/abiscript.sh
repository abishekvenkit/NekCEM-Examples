#./makemesh rad gap levels_lens levels_buff

# rad = $1
# gap = $2
# levels_lens = $3
# levels_buffer = $4

xy = (($1+$2/2)/$1)*0.5

pretex << MID
newmesh
   1 READ PREVIOUS PARAMETERS
original
   1 BUILD FROM FILE
original
   3 GLOBAL REFINE
  11 STRETCH
   7 Stretch Outside Circle
.5  Input protected radius:
 -$xy  $xy Input new xminxmax (0,0 to scale): old -x; old +x
 -$xy  $xy Input new yminymax (0,0 to scale): old -y; old +y
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
MID

# rad = $1
# gap = $2
# levels_lens = $3
# levels_buffer = $4

pml = 2
num_lev = 4+$3+(2*$4)
lamda = 633
h = 155
lay[1] = 0 #first layer

for i in {2..$num_lev}; do	 
    if [ i --ls $pml+1 || i --gt $num_lev-$pml] #PML layers
    then
	lay[i] = lay[i-1]+(i-1)*(($lamda/4)/$1)*0.5
    elif [ (i --gt $pml && i --ls ($pml+1+$4)) || (i --gt ($num_lev-$pml-$4) && i --lt ($num_lev-$pml)) ] #Buffer
    then
	lay[i] = lay[i-1]+(i-1)*(($lamda/3)/$1)*0.5
    else #lens
	lay[i] = lay[i-1]+(i-1)*(($h/3)/$1)*0.5
    fi
done


zmax = (((3*$lamda)+$h)/$1)*0.5

for i in {1..$num_lev}; do
    echo $lay[i] > layers
done
	 
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

	 
n2to3 << EOF
newmesh 
newmesh3d
0
$num_lev
0
$zmax
0
layers
yes
PML
PML
EOF
