#!/usr/bin/env python
# coding: utf-8

# # Multi-view reconstruction and Meshing
#
# ## 0. Import

# In[2]:



import cv2

import openalea.phenomenal.data as phm_data
import openalea.phenomenal.display as phm_display
import openalea.phenomenal.object as phm_obj
import openalea.phenomenal.multi_view_reconstruction as phm_mvr
import openalea.phenomenal.mesh as phm_mesh
import openalea.phenomenal.segmentation as phm_seg
import openalea.phenomenal.display.notebook as phm_display_notebook

import datacloud as dc

# ## 1. Prerequisites
#
# ### 1.1 Load data

# In[3]:
def _routine_select_ref_angle(bin_side_images):

    max_len = 0
    max_angle = None

    for angle in bin_side_images:

        x_pos, y_pos, x_len, y_len = cv2.boundingRect(cv2.findNonZero(bin_side_images[angle]))

        if x_len > max_len:
            max_len = x_len
            max_angle = angle

    return max_angle


def segmentation(row):

    bin_images = dc.get_bin_images(row)
    calibrations = dc.get_calibrations(row)

    refs_angle_list = [_routine_select_ref_angle(bin_images["side"])]

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


    # ### 2.2 Do multi-view reconstruction
    voxels_size = 16 # mm
    error_tolerance = 0
    voxel_grid = phm_mvr.reconstruction_3d(image_views,
                                           voxels_size=voxels_size,
                                           error_tolerance=error_tolerance)


    #phm_display_notebook.show_voxel_grid(voxel_grid, size=1)




    # ## 4. Skeletonization
    #
    # ### 4.1 Compute Graph and the skeleton
    # Compute the skeleton of the plant voxelgrid

    # In[12]:


    graph = phm_seg.graph_from_voxel_grid(voxel_grid, connect_all_point=True)
    voxel_skeleton = phm_seg.skeletonize(voxel_grid, graph)




    # ### 2.3 Clean skeleton (filter small elements)

    # In[14]:


    # Select images
    image_projection = list()
    for angle in bin_images["side"]:
        projection = calibrations["side"].get_projection(angle)
        image_projection.append((bin_images["side"][angle], projection))

    voxel_skeleton_denoised = phm_seg.segment_reduction(
        voxel_skeleton, image_projection, required_visible=5, nb_min_pixel=400)


    #phm_display_notebook.show_skeleton(voxel_skeleton_denoised, size=1)


    # ## 5. Maize Segmentation
    #
    # ### 5.1 Process
    #
    # Voxel skeleton are segmented in several label "stem", "mature_leaf", "growing_leaf" and "unknow"

    # In[16]:


    vms = phm_seg.maize_segmentation(voxel_skeleton_denoised, graph)
    vmsi = phm_seg.maize_analysis(vms)
    return vmsi

#phm_display_notebook.show_segmentation(vmsi, size=1)
def plant_seg(row):
    try:
        vmsi = segmentation(row)
    except:
        vmsi = None
    return vmsi
