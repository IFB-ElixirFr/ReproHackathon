# VM Jupyter phenomenal NextFlow

## Deploy & connect IFB cloud VM 

A partir du [RAINBio Catalogue des appliances bioinformatiques dans le cloud](https://biosphere.france-bioinformatique.fr/catalogue/)

 Ubuntu 16.04 (16.04.6) Phenomenal_ubuntu
 
 ![](https://github.com/sidibebocs/ReproHackathon/blob/master/reprohackathon3/nextflow2/IFB_cloud_deploy_appliance.png
 "IFB cloud Ubuntu appliance")
 
```
ssh -L 8888:localhost:8888 ubuntu@134.158.247.155
```

## Install open alea phenomenal & jupyter software

```
# Install openGL
sudo apt install freeglut3-dev 

# create environment
conda create -n phenomenal python=2.7

# To activate this environment, use
conda activate phenomenal
# To deactivate an active environment, use
#     $ conda deactivate

# install phenomenal
conda install -c openalea openalea.phenomenal
conda install jupyter
conda install -c conda-forge ipyvolume

# test install with tutorial
git clone https://github.com/openalea/phenomenal.git
cd phenomenal/test
nosetests
```
## Read phenomenal jupyter notebook
```
cd /home/ubuntu
(phenomenal) ubuntu@machine784abada-0e9f-4176-b408-77dad21a0fd7:~$ jupyter notebook
[I 09:20:23.199 NotebookApp] Serving notebooks from local directory: /home/ubuntu
[I 09:20:23.199 NotebookApp] The Jupyter Notebook is running at:
[I 09:20:23.199 NotebookApp] http://localhost:8888/?token=b19825b59604349e1b1c2196d29f3496eaab760257527a99
```
=> on peut afficher le notebook des workflow phenomenal en copiant collant l'adresse http dans un navigateur de son ordinateur personnel 

Par exemple reconstruction 3D de la plante et construire des triangles pour l'interception de la lumière pour les autres exemples voir github openalea phenomenal:

[McCormick_Validation](https://github.com/openalea/phenomenal/blob/master/examples/McCormick_Validation.ipynb)

[Multi-view reconstruction and Meshing](https://github.com/openalea/phenomenal/blob/master/examples/Multi-view%20reconstruction%20and%20Meshing.ipynb)

## Install Java & Nextflow

```
# Install Java
sudo apt install default-jdk 

# Set up NextFlow
curl -s https://get.nextflow.io | bash
```

## Run a small NextFlow

```
cd
conda activate phenomenal
(phenomenal) ubuntu@machine784abada-0e9f-4176-b408-77dad21a0fd7:~$ python --version
Python 2.7.15
./nextflow ReproHackathon/reprohackathon3/nextflow2/mcormil_valid.nf 
N E X T F L O W  ~  version 19.10.0
Launching `ReproHackathon/reprohackathon3/nextflow2/mcormil_valid.nf` [chaotic_mendel] - revision: 6288436889
executor >  local (2)
[e4/9247a8] process > import_mc_cormik_data       [100%] 1 of 1 ✔
[f4/f4a599] process > Voxelization_mc_cormik_data [100%] 1 of 1 ✔
```
