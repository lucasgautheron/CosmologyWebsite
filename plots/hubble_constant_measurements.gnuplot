set xrange [45:105]
set yrange [1964:2020]

set xlabel 'H_{0} [km/s/Mpc]'

plot 'data/hubble_constant_measurements.res' u 2:1:yticlabels(5) pointsize 0.01 t '', '' u 2:1:($2-$3):($2+$4):(0.0):(0.0) lc rgb 'red' pointsize 0.333 pointtype 7 lt 1 with xyerrorbars t ''
