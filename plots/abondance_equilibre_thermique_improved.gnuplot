set xrange [0:250]
set yrange [-5:3.5]
set size ratio 1.4

set xlabel 'A'
set ylabel 'log(n)'

# set fit quiet

E(x,y) = k-p*x**(-0.333333)-l*y**2/(x**(1.333))-m*(x-2*y)**2/x**2
fit E(x,y) 'data/noyaux_energies.res' u 1:2:4:(1) via k,p,l,m
F(x) = E(x,x/(2.0+n*x**(0.66667)))
fit F(x) 'data/noyaux_energies.res' u 1:4 via n
A(x) = a*F(x) - b
fit A(x) 'data/noyaux_abondances.res' u 1:2 via a,b

plot 'data/noyaux_abondances.res' u 1:2 t 'Exp. (Brown 1949)' lc rgb 'red' pt 1 ps 0.5 lw 0.5, 'data/noyaux_abondances.res' u ($1 > 2 && $1 < 12 ? 10000 : $1):2 t '' lc rgb 'red' lt 1 smooth sbezier, A(x) t 'Fit Boltzmann' lt 1 lc rgb 'black'
