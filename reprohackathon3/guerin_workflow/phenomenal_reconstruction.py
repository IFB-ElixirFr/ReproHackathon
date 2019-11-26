## Multi-view reconstruction and Meshing 

### Import
%matplotlib notebook

import cv2

import openalea.phenomenal.data as phm_data 
import openalea.phenomenal.display as phm_display
import openalea.phenomenal.object as phm_obj
import openalea.phenomenal.multi_view_reconstruction as phm_mvr
import openalea.phenomenal.mesh as phm_mesh
import openalea.phenomenal.display.notebook as phm_display_notebook


## Prerequisites
###############################################################################
## LOAD DATA
plant_number = 2# Available : 1, 2, 3, 4 or 5
bin_images = phm_data.bin_images(plant_number=plant_number)
calibrations = phm_data.calibrations(plant_number=plant_number)

phm_display.show_images(bin_images['side'].values() + bin_images['top'].values())

## Multi-view reconstruction
###############################################################################
### Associate images and projection function
def routine_select_ref_angle(bin_side_images):
    max_len = 0
    max_angle = None    
    for angle in bin_side_images:    
        x_pos, y_pos, x_len, y_len = cv2.boundingRect(cv2.findNonZero(bin_side_images[angle]))
        if x_len > max_len:
            max_len = x_len
            max_angle = angle
    return max_angle

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

##### Do multi-view reconstruction
voxels_size = 16 # mm
error_tolerance = 0
voxel_grid = phm_mvr.reconstruction_3d(image_views, 
                                       voxels_size=voxels_size,
                                       error_tolerance=error_tolerance)



###### Save / Load voxel grid
voxel_grid.write("plant_{}_size_{}.npz".format(plant_number, voxels_size))
voxel_grid = phm_obj.VoxelGrid.read("plant_{}_size_{}.npz".format(plant_number, voxels_size))

##### Viewing
phm_display_notebook.show_voxel_grid(voxel_grid, size=1)


## meshing
vertices, faces = phm_mesh.meshing(voxel_grid.to_image_3d(),
                                   reduction=0.90,
                                   smoothing_iteration=5,
                                   verbose=True)

print("Number of vertices : {nb_vertices}".format(nb_vertices=len(vertices)))
print("Number of faces : {nb_faces}".format(nb_faces=len(faces)))

## viewing
phm_display_notebook.show_mesh(vertices, faces)
