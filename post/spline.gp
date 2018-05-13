set sample 401
set format y '%18.10f'
set format x '%10.5f'
set table 'fit.dat'
plot 'etot.dat' smooth cspline noti
unset table
