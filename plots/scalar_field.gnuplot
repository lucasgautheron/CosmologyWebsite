set xrange [-2:2]
set yrange [0:5]

set xlabel '\phi'
set ylabel 'V(\phi)'

# set format x " " 
# set format y " "

f(x) = x**6-3*x**4+1.5*x**2+2

plot f(x) t ''

