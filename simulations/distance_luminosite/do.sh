gcc simulation.C -O3 -o simulation -lm

chmod +x simulation

./simulation

cp einstein_desitter.res ../../plots/data/dl_EdS.res
cp planck.res ../../plots/data/dl_planck.res
cp hoyle.res ../../plots/data/dl_hoyle.res

rm -f *.res
