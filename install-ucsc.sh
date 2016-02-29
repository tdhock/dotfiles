#!/bin/bash
set -o errexit
mkdir -p ~/bin
cd ~/bin
wget http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/bigWigToBedGraph
wget http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/bedToBigBed
chmod a+x bigWigToBedGraph
chmod a+x bedToBigBed
