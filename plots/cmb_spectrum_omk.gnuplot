files = system('ls data/output_omk_*.res')
samplefile = system("ls data/output_omk_*.res | head -1| awk '{print $NF}'")
param = system('head -n 1 ' . samplefile . ' | cut -d "#" -f 2 | cut -d "=" -f 1')

set xlabel param
set ylabel ''

set xrange [0:2500]
set yrange [0:]

plot for [file in files] file u 1:2 title system("head -n 1 ".file." | cut -d '#' -f 2") w l
