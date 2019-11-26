#!/usr/bin/env python

import sys
import openalea.phenomenal.display as phm_display
import openalea.phenomenal.mesh as phm_mesh
import openalea.phenomenal.object as phm_obj
import openalea.phenomenal.segmentation as phm_seg

from funcs import *

voxel_grid = phm_obj.VoxelGrid.read(sys.argv[1])

graph = phm_seg.graph_from_voxel_grid(voxel_grid, connect_all_point=True)
voxel_skeleton = phm_seg.skeletonize(voxel_grid, graph)

