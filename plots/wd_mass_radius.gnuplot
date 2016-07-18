set xrange [ 0 : 17500 ]
set yrange [ 0 : 1.5 ]

set xtics 2500

set xlabel 'R (km)'
set ylabel 'M/M_{soleil}'

f(x) = a + b*x**2 + c*x**4

fit [200:1000] f(x) 'data/wd_mass_radius.res' u ($2 * 696000):3 via a,b,c

plot 'data/wd_mass_radius_relativistic.res' u ($2 * 696000):($4 > 0.01 ? $4 : NaN) t 'Relat. Générale' w l lt 1, 'data/wd_mass_radius.res' u ($2 * 696000):($3 > 0.01 ? $3 : NaN) t 'Grav. Newton' w l lt 2 lc rgb 'black'

