set xrange [0:250]
set yrange [-5:3.5]
set size ratio 1.4

set xlabel 'A'
set ylabel 'log(n)'

# set fit quiet

E(x) = k*x+p
fit E(x) 'data/nuclei_energies.res' u 1:3 via k, p
A(x) = a*E(x) - b
fit [0:80] A(x) 'data/nuclei_abundances.res' u 1:2 via a,b

plot 'data/nuclei_abundances.res' u 1:2 t 'Exp. (Brown 1949)' lc rgb 'red' pt 1 ps 0.5 lw 0.5, '' u ($1 > 2 && $1 < 12 ? 10000 : $1):2 t '' lc rgb 'red' lt 1 smooth sbezier, A(x) t 'Fit Boltzmann' lt 1 lc rgb 'black'

