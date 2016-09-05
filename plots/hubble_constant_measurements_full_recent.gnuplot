set xrange [1980:2011]
set yrange [25:125]

set ylabel 'H_{0} [km/s/Mpc]'

plot 'data/hubble_constant_measurements_full.res' u 4:1:(0.0):(0.0):($1+$2):($1+$3) lc rgb 'black' pointsize 0.2 pointtype 7 with xyerrorbars t ''
