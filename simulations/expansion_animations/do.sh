g++ expansion.C -O3 -o expansion -lm

chmod +x expansion
chmod +x velocity_video.sh
chmod +x luminosity_video.sh

mkdir -p files

./expansion

./luminosity_video.sh acc 4 40
./luminosity_video.sh dec 4 40

./velocity_video.sh acc 4 40
./velocity_video.sh dec 4 40
#./velocity_video.sh dec 5 15

rm -f *.res
rm -f tmp
rm -f files/*
