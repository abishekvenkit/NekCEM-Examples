#!/bin/bash

################################################
# To run on MCS: use #!/usr/bin/env bash
# To run on Mac:
#    run command for the 2d domain [-2.5, 2.5]^2
#    ./gap.sh 2.5 
################################################

 half_boxsize=$1

 x=$half_boxsize
 y=$half_boxsize

 cp scale_mesh tmp
 tmpfile="tmp"

 xs=$(printf "\055%-12.4e %12.4e Input new xmin/xmax (0,0 to scale):  -6.000000E-01  6.000000E-01" $x $x)
 ys=$(printf "\055%-12.4e %12.4e Input new ymin/ymax (0,0 to scale):  -6.000000E-01  6.000000E-01" $x $x)
 echo $xs
 echo $ys
 sed -r -i "11s@^(.{0})(.*)@\1$xs@" $tmpfile
 sed -r -i "12s@^(.{0})(.*)@\1$ys@" $tmpfile

#copy output to director
 filename=scale_mesh_${half_boxsize}
 mv ${tmpfile} ${filename}

 ./${filename}

 cp a3.rea box_${half_boxsize}.rea

 rm session.name
 rm *dra
 rm fort*
