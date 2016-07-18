g++ expansion.C -O3 -o expansion -lm

chmod +x expansion
chmod +x video_vitesse.sh
chmod +x video_luminosite.sh

./expansion

./video_luminosite.sh acc 4 40
./video_luminosite.sh dec 4 40

./video_vitesse.sh acc 4 40
./video_vitesse.sh dec 4 40
#./video_vitesse.sh dec 5 15

rm -f *.res
rm -f tmp
rm -f files/*
