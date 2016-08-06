rm -rf files/*

php velocity_plots.php $1 $2

rm "../../videos/$1elerated_redshift.mp4"
rm "../../videos/$1elerated_redshift.webm"
ffmpeg -framerate $3 -i files/%06d.png -c:v libx264 -profile:v high -crf 20 -pix_fmt yuv420p "../../videos/$1elerated_redshift.mp4"
ffmpeg -framerate $3 -i files/%06d.png -c:v libvpx -crf 10 -b:v 1M -c:a libvorbis "../../videos/$1elerated_redshift.webm"
