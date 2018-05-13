set term postscript enhanced color 'Helvetica-Bold,16'
set output 'clat0.ps'
set xr [1.57:1.66]
set yr [-269.605:-269.6020]
set xl 'c/a'
set yl 'Total energy (Ry)'
set format y '%9.4f'
set label 'c/a = 1.61342' at 1.61342,-269.604250 rotate by 90.0
set label 'a = 6.13513 Bohr' at 1.61342,-269.60250
set key top center
#set ytics -269.605, 0.002,-269.597
#unset ytics
set style line 1 lt 1 lw 3 pt 6 ps 2 lc rgb 'blue'
set style line 2 lt 1 lw 2 pt 6 ps 2 lc rgb 'black'
set style line 4 lt 1 lw 2 pt 6 ps 2 lc rgb 'purple'
set style line 3 lt 1 lw 3 pt 6 ps 2 lc rgb 'red'
plot 'etot.dat' u 1:2 w p ti 'data points' ls 1,\
'fit.dat' u 1:2 w l ti 'cspline fit' ls 2,\
 'min.dat' w p noti ls 3
set output
! ps2pdf clat0.ps
! rm clat0.ps

