#!/bin/bash
set -o errexit

## on my ubuntu system the zlib1g-dev is version 1.2.3.4, but new R
## requires zlib version >= 1.2.5.
cd ~/R
wget http://zlib.net/zlib-1.2.8.tar.gz
tar xvf zlib-1.2.8.tar.gz
cd zlib-1.2.8
./configure --prefix=$HOME
make
make install

## same for curl-dev: libcurl4-gnutls-dev 7.22.0 but R needs libcurl
## version >= 7.28.0.
cd ~/R
wget http://curl.haxx.se/download/curl-7.46.0.tar.gz
tar xf curl-7.46.0.tar.gz
cd curl-7.46.0
./configure --prefix=$HOME
make
make install

## Very important: update global ldconfig cache, otherwise ldd will
## not show the correct link to our files under $HOME/lib
sudo ldconfig $HOME/lib
## Otherwise, if we don't have sudo, try setting LD_LIBRARY_PATH.

## bz2, lzma development libraries now required.
sudo aptitude install libbz2-dev liblzma-dev zlib1g-dev libcurl4-gnutls-dev

## Download R-devel source code to ~/R/R-devel
cd ~/R
if [ -f R-devel.tar.gz ];then 
    rm R-devel.tar.gz
fi
wget ftp://ftp.stat.math.ethz.ch/Software/R/R-devel.tar.gz
if [ -d R-devel ];then
    rm -r R-devel
fi
tar xf R-devel.tar.gz

## Build R.
cd ~/R/R-devel
CPPFLAGS="-I$HOME/include -L$HOME/lib" ./configure --prefix=$HOME --with-cairo
make

## Check if the shared libraries are linking to the correct files
## under $HOME/lib:
cd src/modules/internet/
rm libcurl.o 
make
ldd internet.so | grep libcurl

## I don't install R-devel, since I only use it for checking packages
## before submission to CRAN. For the purposes of reproducible
## research I would rather use a specific release version of R
## (e.g. 3.2.2) and mention that explicitly in my code (rather than an
## SVN commit number from R-devel, which can not be easily checked in
## R code).

## If libcurl works in R you should be able to do .Internal(curlDownload("https://www.bioconductor.org/packages/3.0/bioc/src/contrib/PACKAGES", "PACKAGES", FALSE, "w", TRUE))