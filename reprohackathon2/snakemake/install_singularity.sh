#!/bin/bash
apt update -y
apt-get install -y libarchive-dev
VERSION=2.5.1
wget https://github.com/singularityware/singularity/releases/download/$VERSION/singularity-$VERSION.tar.gz
tar xvf singularity-$VERSION.tar.gz
cd singularity-$VERSION
./configure --prefix=/usr/local
make
sudo make install
#conda install -y -c bioconda -c conda-forge snakemake
