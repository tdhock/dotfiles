#!/bin/bash
sudo aptitude install libmysqlclient-dev uuid-dev
cd
if [ ! -e jksrc.zip ]; then curl -OL http://hgdownload.soe.ucsc.edu/admin/jksrc.zip;fi
rm -rf kent
unzip jksrc.zip
export MACHTYPE=$(uname -m)
mkdir -p ~/bin/$MACHTYPE
cd kent/src
make libs
cd utils
for util in bigWigToBedGraph bedToBigBed bigWigInfo bedGraphToBigWig; do
    cd $util
    make
    cd ..
done
## binaries installed to ~/bin/$MACHTYPE so add that to your PATH!
echo INSTALLED TO ~/bin/$MACHTYPE
