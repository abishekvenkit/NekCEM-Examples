#!/bin/bash
# ./fixrea filename

# filename = $1

sed '1,141d' $1

change = """/
****** PARAMETERS *****
    2.610000     NEKTON VERSION
3 DIMENSIONAL RUN
103 PARAMETERS FOLLOW
  0                             1: ---
  0                             2: ---
  0                             3: ---
  1                             4: ifte (1), iftm (2)
  0                             5: IFSCHROD=10,11,...; IFDRIFT=20,21,....,29(DG); IFDRIFT=30(w/o exciton),31(w/ exciton),39(SEM);
  0                             6: source turn on (1); turn off (0)
  0                             7: inhomogeneous boundary turn on (1)
  0                             8: # of field (default=0)
  0                             9: ---
  0                             10: fintim: final time if positive; overrides nsteps. Ignored if negative.
  50                            11: x NSTEPS: Total # of timesteps
  -0.0002                       12: x DT:  Timestep Size with (-), eg. -0.05; CF
  50                            13: x IOCOMM : Print statement at every IOCOMM s
  0.000000E+00                  14: x OPTIONS: number of periods (nano)
  1000                          15: x IOSTEP : Produce outputs at every IOSTEP
  0                             16: ---
  0                             17: x Timestepping: -1(EIG),0 or 45(RK45),44(rk4
  0                             18: x Filter: 0 (no filter), 1 (turn on filter)
  0                             19: x FLUXES: 0 (upwind flux), 1 (central flux)
  5.00000                       20: x ORDER (MESH): positive value
  0                             21: x GMRES(0), CG(1)
  0                             22: ---
  0              p23 NPSCAL
  0                             24: ---
  0                             25: ---
  0                             26: ---
  3.00000                       27: x TORDER
  0.000000E+00                  28: x TMESH
  0.000000E+00                  29: ---
  0.000000E+00                  30: ---
  0.000000E+00                  31: ---
  0.000000E+00                  32: ---
  0                             33: ---
  0                             34: ---
  0                             35: ---
  0                             36: ---
  0                             37: ---
  0.000000E+00                  38: ---
  0.000000E+00                  39: ---
  0.000000E+00                  40: ---
  0.000000E+00                  41: ---
  0.000000E+00                  42: ---
  0                             43: ---
  0.000000E+00                  44: ---
  0.000000E+00                  45: ---
  0.000000E+00                  46: ---
  0.000000E+00                  47: ---
  0.000000E+00                  48: ---
  0.140000                      49: ---
  0.000000E+00                  50: ---
  0.000000E+00                  51: ---
  0.000000E+00                  52: ---
  0.000000E+00                  53: ---
  0.000000E+00                  54: ---
  0.000000E+00                  55: ---
  0.000000E+00                  56: ---
  0                             57: ---
  0                             58: ---
  0                             59: ---
  0                             60: ---
  0                             61: ---
  0                             62: ---
  0                             63: ---
  0                             64: ---
  0                             65: ---
  0                             66: ---
  0                             67: ---
  0                             68: ---
  0                             69: ---
  0                             70: ---
  0                             71: ---
  0                             72: ---
  0                             73: ---
  0                             74: ---
  0                             75: ---
  0                             76: ---
  1.000000E+00                  77: x PMLTHICK : thickness of the PML in levels
  2.000000E+00                  78: x PMLORDER : polynomial order of the grading
  1.000000E-05                  79: x PMLREFERR : PML reflection error
  4                             80: x I/O: total (exact) number of output fields
  0                             81: x I/O: 0 (no output), 1 (fld),2 (posix ascii
  1                             82: x I/O: the number of outputfiles per timeste
  0                             83: x I/O: frequency of restart output files, 0
  0                             84: x RESTART (should be 0 for non-mpi run): inv
  0                             85: x computation trace active if positive numbe
  0                             86: x io trace active if positive number
  0                             87: x I/O: "1" on BGP ;if >0, write/read restart
  0                             88: ---
  0                             89: ---
  0                             90: ---
  0                             91: ---
  0                             92: ---
  1                             93: x ifdielec  0: false 1: true
  0                             94: x ific      0: false 1: true
  0                             95: x ifpoisson 0: false 1: true
  0                             96: ---
  0                             97: --- x ifarpack 0: false 1: true
  0                             98: ---
  0                             99: ---
  0                             100: x 0: default, 1: ifscat, 2: ifsftf
  0                             101: x ifdrude 0: false 1: true
  0                             102: ---
  0                             103: ---
			4  Lines of passive scalar data follows2 CONDUCT; 2RHOCP
   1.00000       1.00000       1.00000       1.00000       1.00000
   1.00000       1.00000       1.00000       1.00000
   1.00000       1.00000       1.00000       1.00000       1.00000
   1.00000       1.00000       1.00000       1.00000
13 LOGICAL SWITCHES FOLLOW
  T     IFFLOW
  F     IFHEAT
  T                             3: IFTRAN
  F                             4: IFSRC
  T                             5: IFCENTRAL
  F                             6: IFUPWIND
  F                             7: IFTM (2D only)
  T                             8: IFTE (2D only)
  F                             9: IFDEALIAS
  F                             10: IFRK4
  T                             11: IFEXP
  F                             12: IFEIG
  F                             13: IFNM
"""

sed -i '1 $change' $1
