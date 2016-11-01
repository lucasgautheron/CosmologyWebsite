set contour
set cntrparam levels discrete 0
set view map
unset surface
unset clabel

set isosamples 1000,1000
set xrange [-1:1]
set yrange [0:2]
set xlabel "H_{0} t"
set ylabel "a(H_{0} t)"
omega_close = 2
omega_open = 0.2

splot 1.0/(1-omega_close) * (sqrt((1-omega_close)*y**2.0 + omega_close) - 1.0) - x t '\Omega = 2', y**(2.0) - (1+2*x) t '\Omega = 1.0', 1.0/(1-omega_open) * (sqrt((1-omega_open)*y**2.0 + omega_open) - 1.0) - x t '\Omega = 0.2'


