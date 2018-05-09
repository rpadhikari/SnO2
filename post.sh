#!/bin/bash
rm -rf etot.dat
rm -rf stress.dat force.dat
m=0
limit=30
while [ "$m" -le "$limit" ]
do
alat=`echo "8.84+$m*0.01" | bc -l`
te=`grep ! scf$m.out | tail -1 | awk '{print $5}'`
ft=`grep 'l fo' scf$m.out|awk '{print $4}'`
sxx=`grep -A1 'l   s' scf$m.out|tail -1|awk '{print $4}'`
szz=`grep -A3 'l   s' scf$m.out|tail -1|awk '{print $6}'`
echo "$alat  $te" >> etot.dat
echo "$alat  $sxx  $szz" >> stress.dat
echo "$alat  $ft" >> force.dat
let m=$m+1
done

