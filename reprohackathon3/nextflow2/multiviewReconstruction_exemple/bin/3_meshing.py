#!/usr/bin/env python
import sys
import openalea.phenomenal.mesh as phm_mesh
import openalea.phenomenal.object as phm_obj
import openalea.phenomenal.display as phm_display

for line in sys.stdin:
    voxel_tar_file = line.strip()

voxel_grid = phm_obj.VoxelGrid.read(voxel_tar_file)
vertices, faces = phm_mesh.meshing(voxel_grid.to_image_3d(),
                                   reduction=0.90,
                                   smoothing_iteration=5,
                                   verbose=True)

print("Number of vertices : {nb_vertices}".format(nb_vertices=len(vertices)))
print("Number of faces : {nb_faces}".format(nb_faces=len(faces)))

phm_display.show_mesh(vertices, faces)
