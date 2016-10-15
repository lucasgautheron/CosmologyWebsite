files = system('ls data/output_ombh2-omch2_*.res')
samplefile = system("ls data/output_ombh2-omch2_*.res | head -1| awk '{print $NF}'")
param = "{/Symbol O}_{b} h^2, {/Symbol O}_{cdm} h^2"

set xlabel param
set ylabel ''

set xrange [0:2500]
set yrange [0:]

plot for [file in files] file u 1:2 title system("head -n 1 ".file." | cut -d '#' -f 2") w l
