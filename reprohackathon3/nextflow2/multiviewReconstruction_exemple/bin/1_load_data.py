#!/usr/bin/env python

import sys
import pickle
import openalea.phenomenal.data as phm_data 
import json
import pandas

output_files = {'bin_images': '/home/ubuntu/multiviewReconstruction/bin_images.pkl',
                'calibrations': '/home/ubuntu/multiviewReconstruction/calibrations.pkl'
               }

plant_number = 2# Available : 1, 2, 3, 4 or 5
bin_images = phm_data.bin_images(plant_number=plant_number)
calibrations = phm_data.calibrations(plant_number=plant_number)

with open(output_files['bin_images'], 'w') as fd:
    pickle.dump(bin_images, fd)
with open(output_files['calibrations'], 'w') as fd:
    pickle.dump(calibrations, fd)

print('{}\n{}\n{}'.format(plant_number, output_files['bin_images'], output_files['calibrations']))
