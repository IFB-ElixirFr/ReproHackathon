#!/usr/bin/env nextflow

process import_mc_cormik_data {
    output:
    stdout data

    shell:
    '''
    #!/usr/bin/env python
    import openalea.phenomenal.data as phm_data
    import os, pickle
    vertices_file = "/tmp/vertices.txt"
    faces_file    = "/tmp/faces.txt"
    colors_file   = "/tmp/colors.txt"
    vertices, faces, colors = phm_data.mesh_mccormik_plant(plant_number=2) # only 1 or 2 available

    f_file=open(faces_file, "w")
    pickle.dump(faces,f_file)
    v_file=open(vertices_file, "w")
    pickle.dump(vertices,v_file)
    c_file=open(colors_file, "w")
    pickle.dump(colors,c_file)


    print  vertices_file + "," + faces_file +  "," + colors_file
    '''
}


process Voxelization_mc_cormik_data {
    echo true
    input:
    stdin data

    output:
    stdout out

    '''
    #!/usr/bin/env python
    import os, pickle, sys, numpy
    import openalea.phenomenal.mesh as phm_mesh
    import openalea.phenomenal.object as phm_obj

    voxels_size = 4.0

    for line in sys.stdin:
        items = line.strip().split(",")

        v_file = open(items[0], 'rb')
        vertices = pickle.load(v_file)
        v_file.close()
        f_file = open(items[1], 'rb')
        faces=pickle.load(f_file)
        f_file.close()
        c_file = open(items[2], 'rb')
        colors=pickle.load(c_file)
        c_file.close()

        voxels_position = phm_mesh.from_vertices_faces_to_voxels_position(
        vertices, faces, voxels_size=voxels_size)
        voxels_position = numpy.array(voxels_position)
        voxel_grid = phm_obj.VoxelGrid(voxels_position, voxels_size)

    '''
}

