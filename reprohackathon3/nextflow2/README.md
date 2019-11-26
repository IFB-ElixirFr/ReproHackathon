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

Par exemple reconstruction 3D de la plante et construire des triangles pour l'interception de la lumière pour les autres exemples voir [github openalea phenomenal](https://github.com/openalea/phenomenal/tree/master/examples)

### Multi-view reconstruction and Meshing

#### 0. Import


```python
%matplotlib notebook

import cv2

import openalea.phenomenal.data as phm_data 
import openalea.phenomenal.display as phm_display
import openalea.phenomenal.object as phm_obj
import openalea.phenomenal.multi_view_reconstruction as phm_mvr
import openalea.phenomenal.mesh as phm_mesh
import openalea.phenomenal.display.notebook as phm_display_notebook
```

#### 1. Prerequisites

##### 1.1 Load data


```python
plant_number = 2# Available : 1, 2, 3, 4 or 5
bin_images = phm_data.bin_images(plant_number=plant_number)
calibrations = phm_data.calibrations(plant_number=plant_number)

phm_display.show_images(bin_images['side'].values() + bin_images['top'].values())
```


    <IPython.core.display.Javascript object>



<img src="data:image/png;base64,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" width="952">


#### 2. Multi-view reconstruction

##### 2.1 Associate images and projection function


```python
def routine_select_ref_angle(bin_side_images):

    max_len = 0
    max_angle = None
    
    for angle in bin_side_images:
    
        x_pos, y_pos, x_len, y_len = cv2.boundingRect(cv2.findNonZero(bin_side_images[angle]))

        if x_len > max_len:
            max_len = x_len
            max_angle = angle

    return max_angle
```


```python
refs_angle_list = [routine_select_ref_angle(bin_images["side"])]

image_views = list()
for id_camera in bin_images:
    for angle in bin_images[id_camera]:
        projection = calibrations[id_camera].get_projection(angle)
    
        image_ref = None
        if id_camera == "side" and angle in refs_angle_list:
            image_ref = bin_images[id_camera][angle]
        
        inclusive = False
        if id_camera == "top":
            inclusive = True
            
        image_views.append(phm_obj.ImageView(
            bin_images[id_camera][angle], 
            projection, 
            inclusive=inclusive, 
            image_ref=image_ref))
```

##### 2.2 Do multi-view reconstruction


```python
voxels_size = 16 # mm
error_tolerance = 0
voxel_grid = phm_mvr.reconstruction_3d(image_views, 
                                       voxels_size=voxels_size,
                                       error_tolerance=error_tolerance)
```

##### 2.3 Save / Load voxel grid


```python
voxel_grid.write("plant_{}_size_{}.npz".format(plant_number, voxels_size))
```


```python
voxel_grid = phm_obj.VoxelGrid.read("plant_{}_size_{}.npz".format(plant_number, voxels_size))
```

##### 2.4 Viewing


```python
phm_display_notebook.show_voxel_grid(voxel_grid, size=1)
```


    VkJveChjaGlsZHJlbj0oRmlndXJlKGFuZ2xleD0xLjU3MDc5NjMyNjc5NDg5NjYsIGNhbWVyYV9jZW50ZXI9WzAuMCwgMC4wLCAwLjBdLCBoZWlnaHQ9NTAwLCBtYXRyaXhfcHJvamVjdGlvbj3igKY=



### 3.Meshing


```python
vertices, faces = phm_mesh.meshing(voxel_grid.to_image_3d(),
                                   reduction=0.90,
                                   smoothing_iteration=5,
                                   verbose=True)

print("Number of vertices : {nb_vertices}".format(nb_vertices=len(vertices)))
print("Number of faces : {nb_faces}".format(nb_faces=len(faces)))
```

    ================================================================================
    Marching cubes : 
    	Iso value :0.5
    
    	There are 10106 points.
    	There are 20076 polygons.
    ================================================================================
    ================================================================================
    Smoothing : 
    	Feature angle :120.0
    	Number of iteration :5
    	Pass band : 0.01
    
    ================================================================================
    ================================================================================
    Decimation : 
    	Reduction (percentage) :0.9
    
    	Before decimation
    	-----------------
    	There are 10106 points.
    	There are 20076 polygons.
    
    	After decimation
    	-----------------
    	There are 0.9 points.
    	There are 10106 polygons.
    ================================================================================
    Number of vertices : 1017
    Number of faces : 2007


##### 3.2 Viewing


```python
phm_display_notebook.show_mesh(vertices, faces)
```  

VkJveChjaGlsZHJlbj0oRmlndXJlKGFuZ2xleD0xLjU3MDc5NjMyNjc5NDg5NjYsIGNhbWVyYV9jZW50ZXI9WzAuMCwgMC4wLCAwLjBdLCBoZWlnaHQ9NTAwLCBtYXRyaXhfcHJvamVjdGlvbj3igKY=


Chemin des données d'images de phénotypage du maïs sur l'appliance
     
     /home/ubuntu/data/public/teachdata/reprohack3/ARCH2016-04-15/binaries

## Install Java & Nextflow

```
# Install Java
sudo apt install default-jdk 

# Set up NextFlow
curl -s https://get.nextflow.io | bash

## Run a small NextFlow

