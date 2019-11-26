# Ce dossier contient les résultats du [ReproHackathon3](../docs/hackathon_3_programme.md)

## Organisation proposée

* Un sous-répertoire par groupe
* Associé à une branche
* Incluant la description
  * des matériels et méthodes utilisés
  * de l'avancement au fur et à mesure
  * un bilan des réalisations en fin de hackathon


## Participants/Groupes :


## Liens utiles

* Présentations :
  - IFB [Cloud Biosphère](https://box.in2p3.fr/index.php/s/3jMBqcK5R3FE28a)
  - Usecase, [Phenomics@Lepse](2019_Phenoarch@ReproHackaton.pdf)
  - Article: [Artzet BioRxiv 2019](https://doi.org/10.1101/805739)
* Cloud IFB-Biosphère
  - [Se connecter](https://biosphere.france-bioinformatique.fr/cloud),
  - Appliances disponibles : [catalogue RAINBio](https://biosphere.france-bioinformatique.fr/catalogue)
    - [Ubuntu-16.04](https://biosphere.france-bioinformatique.fr/catalogue/appliance/88), [Ubuntu-Desktop](https://biosphere.france-bioinformatique.fr/catalogue/appliance/118) : Docker, Ansible, Bioconda, Desktop MATE
* Dépôt [git Phenomenal](https://github.com/openalea/phenomenal)
* Données de travail 
  - Créer sa VM sur le site **ifb-core-cloud**
  - dans sa VM, les données sont dans le répertoire
```
/ifb/data/public/teachdata/reprohack3/
```

## Installation avec conda sur l'image Ubuntu 16.04

```
# Get the pkglist file
wget https://raw.githubusercontent.com/pradal/ReproHackathon/master/reprohackathon3/pkglist.txt
# Create a conda environment
conda create --name phenomenal --file pkglist.txt
```
# Install on another image

```
# Install OpenGL on the system
sudo apt-get install freeglut3-dev
# Create a new conda environment and activate it
conda create -n phenomenal pandas=0.24.2 vtk=8.2.0 opencv=4.1.0 networkx=2.2 scikit-image=0.14.2 scikit-learn=0.20.3 scipy=1.2.1 cython=0.29.7 numba=0.43.1 numpy=1.15.4 matplotlib=2.2.3 python=2.7.16  openalea.deploy openalea.phenomenal -c openalea
conda activate phenomenal
# install jupyter and ipyvolume to play notebook example from phenomenal repository
conda install jupyter
conda install -c conda-forge ipyvolume
# Download repository and run test to valid installation
git clone https://github.com/openalea/phenomenal/
cd phenomenal/test
nosetests
# Run notebook exemple
cd ../example
jupyter notebook
```
On your local terminal, redirect the flow of the 8888 port from the IP of IFB VM
```
ssh -L 8888:localhost:8888 ubuntu@{IP_IFB_VM}
```

To access to notebooks run your browser at the http://localhost:8888/ address


# Acces aux données

Sur une machine de l'ifb-core::

    cd /ifb/data/public/teachdata/reprohack3/ARCH2016-04-15/binaries

In the file data/datacloud.py, functions are implemented to access data.

::
    import datacloud as dc
    db = dc.read_index()
    row_number = 2000# Available : 0, 1, 2, 3, 4 or 5, or  ... 57436
    row = db.loc[row_number]
    bin_images = dc.get_bin_images(row)
    calibrations = dc.get_calibrations(row)
