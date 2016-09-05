set yrange [1950:2020]
plot 'data/hubble_constant_measurements.res' u 2:1:yticlabels(5) pointsize 0.01 t '', '' u 2:1:($2-$3):($2+$4):(0.0):(0.0) lc rgb 'red' pointsize 0.5 pointtype 7 with xyerrorbars t ''
