f(x) = -(2.0/x + 1.0*x**2)
set xrange [0.001:3.25]
set yrange [-10:0.1]
set xlabel 'a'
set ylabel 'E(a) (unite abritraire)'
set style arrow 1 nohead lt 4 lc 'black'

set object circle at first 1.0,f(1.0) radius char 0.5 \
    fillcolor rgb 'black' fillstyle solid noborder


set arrow from 0,f(1.0) to 1,f(1.0) arrowstyle 1
set arrow from 1.0,-10 to 1.0,f(1.0) arrowstyle 1

set label 'E(1) = K' at 0.25,f(1.0)+0.75

plot f(x) t 'Energie potentielle' lc 'black'

