#!/bin/bash

x="/home/avenkit/NekCEM-Examples/LENS/DATA/PHI2"

./makenek cylinder.usr

u="_"
gap="46"

for i in {1,10}; do
    rad=(158-$i)
    python makemesh_x.py $rad 46 3 3
    reaname="$rad $u $gap"
    ./nek $reaname 4
    phi="$(python3 analysis.py)"
    echo "$phi" >> "$x"
done
