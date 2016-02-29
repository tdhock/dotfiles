#!/bin/bash
cd
wget http://hgdownload.soe.ucsc.edu/admin/jksrc.zip
unzip jksrc.zip
export MACHTYPE=$(uname -m)
mkdir -p ~/bin/$MACHTYPE
cd kent/src/lib
mkdir -p $MACHTYPE
make
cd ../jkOwnLib
make
sudo apt-get install libmysqlclient-dev
cd ../utils
for util in bigWigToBedGraph bedToBigBed; do
    cd $util
    make
    cd ..
done
## binaries installed to ~/bin/$MACHTYPE so add that to your PATH!
echo ~/bin/$MACHTYPE
