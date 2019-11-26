#!/usr/bin/env nextflow


process load_data {
	echo true
	
    output:
    stdout data_loads
 
    script:
    '''
    1_load_data.py
    '''
}
 
 
process multi_view_reconstruction {
 
    input:
    stdin data_loads
    output:
    stdout voxel_tar_file
    
    script:
    '''
    2_multi_view_reconstruction.py
    '''
 
}

process meshing {
 
    input:
    stdin voxel_tar_file
    
    script:
    '''
    3_meshing.py
    '''
 
}
