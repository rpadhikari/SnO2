#!/bin/bash
m=0
limit=4
while [ "$m" -le "$limit" ]
do
alat=`echo "17.95+$m*0.05" | bc -l`
cat > scf.in << EOF
&control
    calculation='scf'
    restart_mode='from_scratch'
    pseudo_dir = '/home/raja/pseudo'
    outdir='./'
    disk_io='none'
    tstress=.true.
    tprnfor=.true.
/
&system
    ibrav=0
    celldm(1)=$alat
    nat=48
    ntyp=2
    nbnd=256
    ecutwfc=60.0d0
    ecutrho=600.0d0
    occupations='fixed'
/
 &electrons
    conv_thr = 2.0d-9
    mixing_beta = 0.70d0
/
&ions
    ion_dynamics='damp'
    pot_extrapolation='second_order'
    wfc_extrapolation='second_order'
/
ATOMIC_SPECIES
  Sn  118.710  Sn.pbesol-dn-rrkjus.UPF
  O   15.9990  O.pbesol-nl-rrkjus.UPF
CELL_PARAMETERS {alat}
   1.0  0.0  0.0000
   0.0  1.0  0.0000
   0.0  0.0  0.6730
ATOMIC_POSITIONS {crystal}
 Sn   0.0000  0.0000  0.00
 Sn   0.5000  0.0000  0.00
 Sn   0.0000  0.5000  0.00
 Sn   0.5000  0.5000  0.00
 Sn   0.0000  0.0000  0.50
 Sn   0.5000  0.0000  0.50
 Sn   0.0000  0.5000  0.50
 Sn   0.5000  0.5000  0.50
 Sn   0.2500  0.2500  0.25
 Sn   0.7500  0.2500  0.25
 Sn   0.2500  0.7500  0.25
 Sn   0.7500  0.7500  0.25
 Sn   0.2500  0.2500  0.75
 Sn   0.7500  0.2500  0.75
 Sn   0.2500  0.7500  0.75
 Sn   0.7500  0.7500  0.75
  O   0.1535  0.1535  0.00
  O   0.6535  0.1535  0.00
  O   0.1535  0.6535  0.00
  O   0.6535  0.6535  0.00
  O   0.1535  0.1535  0.50
  O   0.6535  0.1535  0.50
  O   0.1535  0.6535  0.50
  O   0.6535  0.6535  0.50
  O   0.3465  0.3465  0.00
  O   0.8465  0.3465  0.00
  O   0.3465  0.8465  0.00
  O   0.8465  0.8465  0.00
  O   0.3465  0.3465  0.50
  O   0.8465  0.3465  0.50
  O   0.3465  0.8465  0.50
  O   0.8465  0.8465  0.50
  O   0.0965  0.4035  0.25
  O   0.5965  0.4035  0.25
  O   0.0965  0.9035  0.25
  O   0.5965  0.9035  0.25
  O   0.0965  0.4035  0.75
  O   0.5965  0.4035  0.75
  O   0.0965  0.9035  0.75
  O   0.5965  0.9035  0.75
  O   0.4035  0.0965  0.25
  O   0.9035  0.0965  0.25
  O   0.4035  0.5965  0.25
  O   0.9035  0.5965  0.25
  O   0.4035  0.0965  0.75
  O   0.9035  0.0965  0.75
  O   0.4035  0.5965  0.75
  O   0.9035  0.5965  0.75
K_POINTS {automatic}
 4 4 6 1 1 1
EOF
mpirun -np 4 pw.x -npw 4 -inp scf.in > scf.out
te=`grep ! scf.out | tail -1 | awk '{print $5}'`
echo "$alat $te" >> etot.dat
mv scf.in scf$m.in
mv scf.out scf$m.out
let m=$m+1
done

