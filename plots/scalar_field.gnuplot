set xrange [-2:2]
set yrange [0:5]

set xlabel '{/Symbol p}'
set ylabel 'V({/Symbol p})'

# set format x " " 
# set format y " "

f(x) = x**6-3*x**4+1.5*x**2+2

plot f(x) t ''

