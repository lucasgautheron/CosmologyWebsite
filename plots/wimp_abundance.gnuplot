set logscale xy
set xrange [1:1000]
set yrange [10**-20:10**5]

set xlabel 'x = mc^{2}/k_{B}T'
set ylabel 'm n_{X}(x)/n_{eq}(x=1) x 100 GeV'

set format x "10^{%T}" 
set format y "10^{%T}" 

plot 'data/wimp_abundance.res' u 1:(100*$2) t 'n_{eq}(x)/n_{eq}(x=1)' w l, '' u 1:3 t 'm = 1 GeV' w l, '' u 1:4 t 'm = 100 GeV' w l, '' u 1:5 t 'm = 1000 GeV' w l

