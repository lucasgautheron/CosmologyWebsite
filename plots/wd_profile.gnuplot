set xrange [ 0 : 4000 ]
set yrange [ 0 : 35 ]

set xtics 500

set ylabel 'Densité (unité arbitraire)'
set xlabel 'r (km)'

plot 'data/wd_profile.res' u ($1 * 696000):6 t 'Densité' w l lt 1
