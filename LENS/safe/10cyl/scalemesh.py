#rescaling all the meshes to be the same size

from __future__ import division, print_function, absolute_import

import subprocess

PRETEXSCRIPT = """\
pretex << EOF
{}
   1 READ PREVIOUS PARAMETERS
{}
   1 BUILD FROM FILE
{}
   3 GLOBAL REFINE
  11 STRETCH
   5 Stretch R
{}  Input expansion factor ( =< 0 to abort):
   1 UP MENU
   1 END GLOBAL REFINE
   1 END    ELEMENTS
   1 ACCEPT MATL,QVOL
   1 ACCEPT B.C.s
   1 ACCEPT B.C.s
   1 EXIT      
EOF
"""
for i in range(1, 9):
    s = (65)/(65-i*5)
    subprocess.call(['bash', '-c',
                     PRETEXSCRIPT.format(i,i,i,s)])
