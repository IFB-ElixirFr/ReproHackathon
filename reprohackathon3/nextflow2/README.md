# VM Jupyter phenomenal nextflow

## Deploy & connect IFB cloud VM 

 Ubuntu 16.04 (16.04.6) Phenomenal_ubuntu
 
 ![](https://github.com/sidibebocs/ReproHackathon/blob/master/reprohackathon3/nextflow2/IFB_cloud_deploy_appliance.png
 "IFB cloud Ubuntu appliance")
 
```
ssh -L 8888:localhost:8888 ubuntu@134.158.247.155
```

## Install software

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
=> on peut afficher dans un navigateur le notebook

Les données d'images de phénotypage du maïs sont là
     
     /home/ubuntu/data/public/teachdata/reprohack3/ARCH2016-04-15/binaries

