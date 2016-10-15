set xrange [-1.75:1.75]
set yrange [0:4]

set xlabel '\phi'
set ylabel 'V(\phi)'

# set format x " " 
# set format y " "

f(x) = x**4-2*x**2+1

plot f(x) t ''

