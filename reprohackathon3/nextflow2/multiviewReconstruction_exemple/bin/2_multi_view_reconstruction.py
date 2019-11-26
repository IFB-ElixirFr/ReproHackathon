#!/usr/bin/env python
import sys
import pickle
import cv2

import openalea.phenomenal.object as phm_obj
import openalea.phenomenal.multi_view_reconstruction as phm_mvr


# Associate images and projection function
def routine_select_ref_angle(bin_side_images):

    max_len = 0
    max_angle = None
    
    for angle in bin_side_images:
    
        x_pos, y_pos, x_len, y_len = cv2.boundingRect(cv2.findNonZero(bin_side_images[angle]))

        if x_len > max_len:
            max_len = x_len
            max_angle = angle

    return max_angle
    
stdin = list()
for line in sys.stdin:
    stdin.append(line.strip())

plant_number = int(stdin[0])
with open(stdin[1], 'r') as fd:
    bin_images = pickle.load(fd)
with open(stdin[2], 'r') as fd:    
    calibrations = pickle.load(fd)
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

# Do multi-view reconstruction
voxels_size = 16 # mm
error_tolerance = 0
voxel_grid = phm_mvr.reconstruction_3d(image_views, 
                                       voxels_size=voxels_size,
                                       error_tolerance=error_tolerance)

# Save / Load voxel grid
voxel_tar_file = '/home/ubuntu/multiviewReconstruction/plant_{}_size_{}.npz'.format(plant_number, voxels_size)
voxel_grid.write(voxel_tar_file)

print(voxel_tar_file)
