set xrange [-50:300]
set yrange [:] reverse

set xlabel 'Temps (en jours) depuis le maximum de luminosite'
set ylabel 'Magnitude absolue M_{B}'

plot 'data/SN1999ee_lightcurve.res' u 1:2 t 'SN1999ee' ps 0.5, 'data/SN2011fe_lightcurve.res' u 1:2 t 'SN2011fe' ps 0.5, 'data/SN1991bg_lightcurve.res' u 1:2 t 'SN1991bg' ps 0.5, 'data/SN2014J_lightcurve.res' u 1:2 t 'SN2014J' ps 0.5, 'data/SN2012fr_lightcurve.res' u 1:2 t 'SN2012fr' ps 0.5, 'data/SN1998aq_lightcurve.res' u 1:2 t 'SN1998aq' ps 0.5

