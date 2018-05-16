#!/bin/bash
m=0
limit=15
while [ "$m" -le "$limit" ]
do
cbya=`echo "0.676+$m*0.001" | bc -l`
cat > scf.in << EOF
&control
    calculation='relax'
    restart_mode='from_scratch'
    pseudo_dir = '/home/raja/pseudo'
    outdir='./'
!    disk_io='none'
    tstress=.true.
    tprnfor=.true.
    etot_conv_thr=1.0d-05
    forc_conv_thr=1.0d-04
/
&system
    ibrav=0
    celldm(1)=8.9
    nat=6
    ntyp=2
    nbnd=32
    ecutwfc=60.0d0
    ecutrho=600.0d0
    occupations='fixed'
/
 &electrons
    conv_thr = 2.0d-8
    mixing_beta = 0.7
/
&ions
    ion_dynamics='damp'
    pot_extrapolation='second_order'
    wfc_extrapolation='second_order'
/
ATOMIC_SPECIES
  Sn  118.71  Sn.pbesol-dn-rrkjus.UPF
  O   15.999  O.pbesol-nl-rrkjus.UPF
CELL_PARAMETERS {alat}
   1.0  0.0  0.00000
   0.0  1.0  0.00000
   0.0  0.0  0$cbya
ATOMIC_POSITIONS {crystal}
  Sn  0.000    0.000  0.00 0 0 0
  Sn  0.500    0.500  0.50 1 1 1
  O   0.307    0.307  0.00 1 1 1
  O   0.693    0.693  0.00 1 1 1
  O   0.193    0.807  0.50 1 1 1
  O   0.807    0.193  0.50 1 1 1
K_POINTS {automatic}
 4 4 6 1 1 1
EOF
mpirun -np 8 pw.x -npw 8 -inp scf.in > scf.out
te=`grep ! scf.out | tail -1 | awk '{print $5}'`
echo "0$cbya $te" >> etot.dat
mv scf.in scf$m.in
mv scf.out scf$m.out
let m=$m+1
done

