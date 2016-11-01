files = system('ls data/output_scalar_amp*.res')
samplefile = system("ls data/output_scalar_amp*.res | head -1| awk '{print $NF}'")
param = system('head -n 1 "' . samplefile . '" | cut -d "#" -f 2 | cut -d "=" -f 1')

set title param
set xlabel 'l'
set ylabel 'D_{l}'

set xrange [0:2500]

set logscale y

plot for [file in files] file u 1:2 title system("head -n 1 '".file."' | cut -d '#' -f 2") w l
