git clone https://github.com/cmbant/CAMB.git
cd CAMB
git pull
make
cd ..
php run.php
rm -rf CAMB
rm params_*.ini