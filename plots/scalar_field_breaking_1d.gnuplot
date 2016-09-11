set xrange [-1.75:1.75]
set yrange [0:4]

set xlabel '{/Symbol p}'
set ylabel 'V({/Symbol p})'

# set format x " " 
# set format y " "

f(x) = x**4-2*x**2+1

plot f(x) t ''

