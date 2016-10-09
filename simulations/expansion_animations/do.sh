g++ expansion.C -O3 -o expansion -lm

chmod +x expansion
chmod +x velocity_video.sh
chmod +x luminosity_video.sh

mkdir -p files

./expansion

printf "Generating luminosity distance in accelerated expansion anim...\n"
./luminosity_video.sh acc 4 40 > /dev/null

printf "Generating luminosity distance in decelerated expansion anim...\n"
./luminosity_video.sh dec 4 40 > /dev/null

printf "Generating recession velocity in accelerated expansion anim...\n"
./velocity_video.sh acc 4 40 > /dev/null

printf "Generating recession velocity in decelerated expansion anim...\n"
./velocity_video.sh dec 4 40 > /dev/null
#./velocity_video.sh dec 5 15

rm -f *.res
rm -f tmp
rm -f files/*
