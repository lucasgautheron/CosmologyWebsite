g++ masse.C -o masse -O3 -lm -fopenmp
g++ profil.C -o profil -O3 -lm -fopenmp

chmod +x masse
chmod +x profil

./masse
./profil

cp masse_rayon.res ../../plots/data/wd_mass_radius.res
cp masse_rayon_relativistic.res ../../plots/data/wd_mass_radius_relativistic.res
cp masse_100.00000.res ../../plots/data/wd_profile.res

rm -f *.res
