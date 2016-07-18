f(x) = ((3.0/2.0) * x)**(2.0/3.0)
set xrange [0:1]
set yrange [0:1.3]
set xlabel 'H_0 t'
set ylabel 'a(t)'

set style arrow 1 nohead lt 4 lc 'black'

set object circle at first 0.67,1 radius char 0.5 \
    fillcolor rgb 'black' fillstyle solid noborder


set arrow from 0,1 to 0.67,1 arrowstyle 1
set arrow from 0.67,0 to 0.67,1 arrowstyle 1

set label 'présent' at 0.6,1.1

plot f(x) t "facteur d'échelle en fonction du temps normalisé" lc 'black'

