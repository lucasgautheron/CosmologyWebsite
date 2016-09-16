set xrange [:]
set yrange [:] reverse

set xlabel 'Delta m_{15} (B)'
set ylabel 'M_{B}'

plot 'data/SNIa_deltam15.res' u 1:($3-15 < 0.5 ? $2 : NaN)
