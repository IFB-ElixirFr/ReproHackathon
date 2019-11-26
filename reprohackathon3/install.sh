## en dehors de la VM
### creer une cle ssh
ssh-keygen -t rsa

## ouvrir jupyter de la VM sur ma machine locale
ssh -L 8888:localhost:8888 ubuntu@134.158.247.12

## connexion VM
ssh ubuntu@134.158.247.12
###############################################################################
## installer les deps
sudo apt-get install freeglut3-dev
conda create -n phenomenal pandas=0.24.2 vtk=8.2.0 opencv=4.1.0 networkx=2.2 scikit-image=0.14.2 scikit-learn=0.20.3 scipy=1.2.1 cython=0.29.7 numba=0.43.1 numpy=1.15.4 matplotlib=2.2.3 python=2.7.16 openalea.deploy openalea.phenomenal -c openalea
conda activate phenomenal
git clone https://github.com/openalea/phenomenal.git
conda install -c openalea openalea.phenomenal
conda install -c conda-forge ipyvolume
###############################################################################
conda activate phenomenal
jupyter notebook

###############################################################################
## Sur une machine de l'ifb-core::
## localisation des donnees a tester
cd /ifb/data/public/teachdata/reprohack3/ARCH2016-04-15/binaries
###############################################################################
## install singularity
sudo apt-get install -y libarchive-dev
VERSION=2.5.1
wget https://github.com/singularityware/singularity/releases/download/$VERSION/singularity-$VERSION.tar.gz
tar xvf singularity-$VERSION.tar.gz
cd singularity-$VERSION
./configure --prefix=/usr/local
make
sudo make install
## install snakemake
conda install -y -c bioconda -c conda-forge snakemake