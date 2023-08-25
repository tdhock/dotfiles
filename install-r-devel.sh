#!/bin/bash
set -o errexit

## What I usually do to compile R is similar to
## http://pj.freefaculty.org/blog/?p=315 but I do NOT set PATH nor
## LD_LIBRARY_PATH.

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

## on guillimin there are no bzip2 headers.
cd ~/R
wget http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz
tar xf bzip2-1.0.6.tar.gz
cd bzip2-1.0.6
## /usr/bin/ld: /home/thocking/lib/libbz2.a(bzlib.o): relocation R_X86_64_32S against `.text' can not be used when making a shared object; recompile with -fPIC
# add -fPIC to CFLAGS in Makefile!!!
sed -i 's/^CFLAGS=-Wall/CFLAGS=-fPIC -Wall/' Makefile
make
make install PREFIX=$HOME

## on guillimin R also complains about liblzma (xz)
wget https://tukaani.org/xz/xz-5.2.3.tar.gz
tar xf xz-5.2.3.tar.gz
cd xz-5.2.3
./configure --prefix=$HOME
make
make install

## Very important: update global ldconfig cache, otherwise ldd will
## not show the correct link to our files under $HOME/lib
sudo ldconfig $HOME/lib
## Otherwise, if we don't have sudo, try setting LD_LIBRARY_PATH.

## bz2, lzma development libraries now required. Also install other
## prereq's for compiling R+packages.
sudo aptitude install \
     fortran5 \
     libpcre2-dev \
     r-recommended libtiff-dev libcairo-dev \ #main R
     default-jre default-jdk \ #for java
     libbz2-dev liblzma-dev zlib1g-dev libcurl4-gnutls-dev xorg-dev \ #r
     texlive ghostscript texlive-fonts-extra texinfo \ #r manuals
     libxml2-dev libssl-dev \ #some packages
     texlive-science \ #for algorithm.sty
     r-cran-rgl \ #for 3dviz
     tcl-dev tk-dev #for library(tcltk), library(loon)

##old PCRE for R<4
cd ~/R
wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.41.tar.bz2
tar xf pcre-8.41.tar.bz2
cd pcre-8.41
# The --enable-utf8 flag is essential!! otherwise R configure fails
# with error: pcre >= 8.10 library and headers are required
./configure --enable-utf8 --prefix=$HOME 
make 
make install

##TODO how to compile pcre2?

## Download R-devel source code to ~/R/R-devel
cd ~/R
if [ -f R-devel.tar.gz ];then 
    rm R-devel.tar.gz
fi
##wget https://cloud.r-project.org/src/base-prerelease/R-devel.tar.gz
wget https://cloud.r-project.org/src/base/R-4/R-4.3.1.tar.gz
if [ -d R-devel ];then
    rm -r R-devel
fi
tar xf R-devel.tar.gz

## valgrind instrumentation info from Writing R Extensions: The
## configure option is --with-valgrind-instrumentation=level, where
## level is 0, 1 or 2.

## Level 0 is the default and does not add anything.

## Level 1 will detect some uses (Those in some numeric, logical,
## integer, raw, complex vectors and in memory allocated by R_alloc)
## of uninitialised memory and has little impact on speed (compared to
## level 0).

## Level 2 will detect many other memory-use bugs (including using the
## data sections of R vectors after they are freed) but make R much
## slower when running under valgrind.

sudo apt install valgrind #not snap!!! it does not have headers.

## Build R.
cd ~/R/R-devel
CPPFLAGS=-I$HOME/include LDFLAGS="-L$HOME/lib -Wl,-rpath=$HOME/lib" ./configure --prefix=$HOME --with-cairo --with-blas --with-lapack --enable-R-shlib --with-valgrind-instrumentation=2 --enable-memory-profiling
CFLAGS=-march=core2 CPPFLAGS=-march=core2 ./configure --prefix=$HOME --with-cairo --with-blas --with-lapack --enable-R-shlib --with-valgrind-instrumentation=2 --enable-memory-profiling
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
