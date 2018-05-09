#!/bin/bash
m=0
limit=30
while [ "$m" -le "$limit" ]
do
alat=`echo "8.84+$m*0.01" | bc -l`
cat > scf.in << EOF
&control
    calculation='scf'
    restart_mode='from_scratch'
    pseudo_dir = '/home/raja/pseudo'
    outdir='./'
    disk_io='none'
    tstress=.true.
    tprnfor=.true.
    etot_conv_thr=1.0d-05
    forc_conv_thr=1.0d-04
/
&system
    ibrav=0
    celldm(1)=$alat
    nat=6
    ntyp=2
    nbnd=24
    ecutwfc=60.0
    occupations='fixed'
/
 &electrons
    conv_thr = 2.0d-9
    mixing_beta = 0.7
/
&ions
    ion_dynamics='damp'
    pot_extrapolation='second_order'
    wfc_extrapolation='second_order'
/
ATOMIC_SPECIES
  Sn  118.71  Sn.pbe-mt_fhi.UPF
  O   15.999  O.pbe-mt_fhi.UPF
CELL_PARAMETERS {alat}
   1.0  0.0  0.00000
   0.0  1.0  0.00000
   0.0  0.0  0.67262
ATOMIC_POSITIONS {crystal}
  Sn  0.000    0.000  0.00
  Sn  0.500    0.500  0.50
  O   0.307    0.307  0.00
  O   0.693    0.693  0.00
  O   0.193    0.807  0.50
  O   0.807    0.193  0.50
K_POINTS {automatic}
 8 8 12 1 1 1
EOF
 pw.x < scf.in > scf.out
te=`grep ! scf.out | tail -1 | awk '{print $5}'`
echo "$alat $te" >> etot.dat
mv scf.in scf$m.in
mv scf.out scf$m.out
let m=$m+1
done

