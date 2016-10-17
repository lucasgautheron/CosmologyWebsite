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
omega = 1.2
a0 = 1
t0 = 0
splot sqrt(a0*y*(a0-y)) + 0.5*a0**(1.5) * (atan( (a0-2*y)/(2*sqrt(y*(a0-y))) + 3.141592645/2.0 )) - sqrt(omega)*(x-t0) t '\Omega = 1.2', y**(1.5) - (1+1.5*x) t '\Omega = 1', sqrt(a0*y*(a0-y)) - 0.5*a0**(1.5) * (log( 2 * sqrt(a0*y*(a0-y)) + a0)) - sqrt(0.9)*(x-t0) t '\Omega = 0.8'


