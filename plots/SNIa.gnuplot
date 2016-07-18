set xrange [0:1.1]
set yrange [32:48]

set xlabel 'z'
set ylabel 'm'

plot 'data/SNIa_exp.res' u 1:2:3 w yerrorbars t 'SNIa data', 'data/SNIa_fit.res' u 1:3 t'Best fit' w l lt 1 lc rgb 'black'

