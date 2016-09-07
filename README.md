# History of Cosmology

http://cosmology.education/

Status : http://cosmology.education/graph.html

Archive : http://cosmology.education/archive.tar.gz

[![Build Status](https://travis-ci.org/lucasgautheron/CosmologyWebsite.svg?branch=master)](https://travis-ci.org/lucasgautheron/CosmologyWebsite) [![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/lucasgautheron/CosmologyWebsite?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## Build instructions

### First build

 * Clone the repository
```
git clone https://github.com/lucasgautheron/CosmologyWebsite.git
```
 * Install the dependencies :
 
```
apt-get install basex default-jre gnuplot libcurl3 libsaxonb-java php-cli
```

In order to generate the animations and run the simulations the following packages are also required :
```
apt-get install ffmpeg build-essential
```

### Compiling
 * Update and compile :

```
git pull

# For the first build or if a simulation has to be re-run
php compile.php -V -S
# otherwise
php compile -V
```

