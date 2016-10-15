set xrange [0.8:2.2]
set yrange [-15:-21] reverse

set xlabel '\Delta m_{15} (B)'
set ylabel 'M_{B}'

plot 'data/SNIa_deltam15.res' u 1:( $3-15 < 3 ? $2 : NaN) t 'correlation'
