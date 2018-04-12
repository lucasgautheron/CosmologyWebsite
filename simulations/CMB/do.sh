git clone https://github.com/cmbant/CAMB.git
cd CAMB
git pull
git checkout 6bb93a47a2fcbaad236b27c3dd2709db3474e313
make
cd ..
php run.php
rm -rf CAMB
rm params_*.ini
