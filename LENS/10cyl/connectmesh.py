#rescaling all the meshes to be the same size

from __future__ import division, print_function, absolute_import

import subprocess

#SHIFTING

PRETEXSCRIPT = """\
pretex << EOF
{}
   1 READ PREVIOUS PARAMETERS
{}
   1 BUILD FROM FILE
{}
   3 GLOBAL REFINE
  10 SHIFT
   4 Shift X
.6625  Input X-location separating shifted section.
<   Input "<" or ">" to indicate desired shift section.
    ("=" implies abort.)
{}  Input amount to shift in X-direction
   1 UP MENU
   1 END GLOBAL REFINE
   1 END    ELEMENTS
   1 ACCEPT MATL,QVOL
   1 ACCEPT B.C.s
   1 ACCEPT B.C.s
   1 EXIT      
EOF
"""
for i in range(1, 10):
    s = (10-i)*1.55
    subprocess.call(['bash', '-c',
                     PRETEXSCRIPT.format(i,i,i,s)])

#CONNECTING
#
#PRETEXSCRIPT2 = """\
#pretex << EOF
#final
#   1 READ PREVIOUS PARAMETERS
#10
#   1 BUILD FROM FILE
#10
#  10 IMPORT MESH
#{}  input name of new .rea file
#n   Displace elements in box (y)? Translate?(t) n
#   1 END    ELEMENTS
#   1 ACCEPT MATL,QVOL
#   1 ACCEPT B.C.s
#   2 ABORT     
#EOF
#"""
#for i in range(9, 0, -1):
#    subprocess.call(['bash', '-c',
#                     PRETEXSCRIPT2.format(i)])
