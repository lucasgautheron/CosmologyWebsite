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
r_close = sqrt((omega_close-1.0)/omega_close)

omega_open = 0.2
r_open = sqrt((1.0-omega_open)/omega_open)

f(x,y) = r_close**(-3.0) * (sqrt(y)*r_close*sqrt(1-(sqrt(y)*r_close)**2) - asin(sqrt(y)*r_close) - r_close*sqrt(1-(r_close)**2) + asin(r_close)) + sqrt(omega_close)*x

g(x,y) = y**(1.5) - 1 - 1.5*x

h(x,y) = r_open**(-3.0) * (sqrt(y)*r_open*sqrt(1+(sqrt(y)*r_open)**2) - asinh(sqrt(y)*r_open) - r_open*sqrt(1+(r_open)**2) + asinh(r_open)) - sqrt(omega_open)*x

splot f(x,y) t '\Omega = 2', g(x,y) t '\Omega = 1.0', h(x,y) t '\Omega = 0.2'


