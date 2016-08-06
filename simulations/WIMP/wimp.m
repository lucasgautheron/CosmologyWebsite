(* ::Package:: *)

gX := 2.
sigmav := 2
gS[x_] := 10.+90.*(1.+Tanh[mass/x-0.5])
Yeq[x_] := 0.145 * gX/gS[x] * x^1.5 * Exp[-x]
lambda := 2.76*10^9*mass*sigmav

(*dgS[x_?NumericQ] := Evaluate[D[Log[10.+90.*(1.+Tanh[x-0.5])],x]]/x*)
dgS[x_?NumericQ] := (90*Sech[x-0.5]/(10.+90.*(1.+Tanh[x-0.5])))/x
dgSx[x_] := dgS[mass/x]

xmin := 1
xmax := 2000
cell[x_, y_] := 1.*Evaluate[xmin+x*(xmax-xmin)/Npts]
cell[x_, y_] := 1.*Evaluate[(xmax/xmin)^((x+1)/Npts)]

Npts := 500
testing = Array[cell, {Npts, 6}, {0, 0}]


For[i = 0, i <= Npts, i++, testing[[i,2]] = Evaluate[Yeq[testing[[i,1]]]/Yeq[1.]]]

mass = 1.
sol = NDSolve[{W'[x] == (lambda/(x*x)) * (1.+3.*dgSx[x]) * (Exp[2*Log[Yeq[x]]-W[x]] - Exp[W[x]] ) , W[xmin] == Log[Yeq[xmin]]}, W, {x, xmin, xmax}]
For[i = 0, i <= Npts, i++, testing[[i,3]] = mass*Evaluate[Exp[W[testing[[i,1]]]]/Yeq[1.] /. sol][[1]]]

Clear[sol];
Clear[W];
mass = 100.
sol = NDSolve[{W'[x] == (lambda/(x*x)) * (1.+3.*dgSx[x]) * (Exp[2*Log[Yeq[x]]-W[x]] - Exp[W[x]] ) , W[xmin] == Log[Yeq[xmin]]}, W, {x, xmin, xmax}]
For[i = 0, i <= Npts, i++, testing[[i,4]] = mass*Evaluate[Exp[W[testing[[i,1]]]]/Yeq[1.] /. sol][[1]]]

Clear[sol];
Clear[W];
mass = 1000.
sol = NDSolve[{W'[x] == (lambda/(x*x)) * (1.+3.*dgSx[x]) * (Exp[2*Log[Yeq[x]]-W[x]] - Exp[W[x]] ) , W[xmin] == Log[Yeq[xmin]]}, W, {x, xmin, xmax}]
For[i = 0, i <= Npts, i++, testing[[i,5]] = mass*Evaluate[Exp[W[testing[[i,1]]]]/Yeq[1.] /. sol][[1]]]

Clear[sol];
Clear[W];
mass = 10000.
sol = NDSolve[{W'[x] == (lambda/(x*x)) * (1.+3.*dgSx[x]) * (Exp[2*Log[Yeq[x]]-W[x]] - Exp[W[x]] ) , W[xmin] == Log[Yeq[xmin]]}, W, {x, xmin, xmax}]
For[i = 0, i <= Npts, i++, testing[[i,6]] = mass*Evaluate[Exp[W[testing[[i,1]]]]/Yeq[1.] /. sol][[1]]]

Clear[sol];
Clear[W];
mass = 50000.
sol = NDSolve[{W'[x] == (lambda/(x*x)) * (1.+3.*dgSx[x]) * (Exp[2*Log[Yeq[x]]-W[x]] - Exp[W[x]] ) , W[xmin] == Log[Yeq[xmin]]}, W, {x, xmin, xmax}]
For[i = 0, i <= Npts, i++, testing[[i,6]] = mass*Evaluate[Exp[W[testing[[i,1]]]]/Yeq[1.] /. sol][[1]]]

(*LogLogPlot[Evaluate[Exp[W[x]]/Yeq[1.] /. s], {x, xmin, xmax}, PlotRange -> All]*)

Export["wimp_abundance.res", testing, "Table"]


