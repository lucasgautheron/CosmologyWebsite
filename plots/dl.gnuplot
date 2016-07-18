set xrange [0:5]

set xlabel 'z'
set ylabel 'd'

plot 'data/dl_EdS.res' t 'EdS' w l, 'data/dl_planck.res' t 'planck' w l, 'data/dl_hoyle.res' t 'hoyle' w l

