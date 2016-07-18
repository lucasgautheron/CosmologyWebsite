set xlabel 'log(n)'
set ylabel 'log(P)'

set xrange [-20:16]
set yrange [-40:35]

set style fill transparent solid 0.2 border
set style data lines

A(x) = a*x+b
B(x) = c*x+d
C(x) = k*x+l

fit [-20:-14] A(x) 'data/fermi_state.res' u (log($4)):(log($5)) via a,b
fit [-25:-18] B(x) 'data/fermi_state.res' u (log($2)):(log($3)) via c,d
fit [9:16] C(x) 'data/fermi_state.res' u (log($4)):(log($5)) via k,l

set label '.' at -5,-20 

plot 'data/fermi_state.res' u (log($2)):(log($3)) t 'fermi-dirac' w l lt 1 lc rgb 'black', '' u (log($4)):(log($5)) t 'full degenerate' w filledcurve x1 lt 1 lw 2.0, '' u (log($4)):(log($4) > 0 ? C(log($4)) : NaN) t 'pente 4/3' lt 2 lc rgb 'black', '' u (log($4)):(log($4) < 0 ? A(log($4)) : NaN) t 'pente 5/3' lt 3 lc rgb 'black' 

