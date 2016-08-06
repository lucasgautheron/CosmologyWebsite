g++ mass.C -o mass -O3 -lm -fopenmp
g++ profile.C -o profile -O3 -lm -fopenmp

chmod +x mass
chmod +x profile

./mass
./profile

cp mass_radius.res ../../plots/data/wd_mass_radius.res
cp mass_radius_relativistic.res ../../plots/data/wd_mass_radius_relativistic.res
cp mass_100.00000.res ../../plots/data/wd_profile.res

#rm -f *.res
