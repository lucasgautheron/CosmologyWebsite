set xrange [-1:1]
set yrange [0:2]

set xlabel "H_{0} t"
set ylabel "a(H_{0} t)"

omega_close = 2
omega_open = 0.2

f(x) = sqrt( (1.0-omega_open)/(omega_open) ) * sinh(sqrt(omega_open)*x + atanh(sqrt(omega_open)))
g(x) = exp(x)
h(x) = sqrt( (omega_close-1.0)/(omega_close) ) * cosh(sqrt(omega_close)*x + atanh(1.0/sqrt(omega_close)))

plot h(x) t '\Omega = 2', g(x) t '\Omega = 1.0', f(x) t '\Omega = 0.2'


