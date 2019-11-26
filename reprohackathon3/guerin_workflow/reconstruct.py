db = dc.read_index()
row_number = 2000# Available : 0, 1, 2, 3, 4 or 5, or  ... 57436
row = db.loc[row_number]
bin_images = dc.get_bin_images(row)
calibrations = dc.get_calibrations(row)
#==============================================================================
#MODULES
#==============================================================================
import datacloud as dc

import cv2
import os
import datetime
import pandas
from openalea.phenomenal.calibration import CalibrationCamera

#==============================================================================
#FUNCTIONS
#==============================================================================

## read index
def read_index_chunk(index_file):
    df = pandas.read_csv(index_file, sep=';')
    for col in ('path_http','camera_angle', 'dates', 'view_type'):
        exec("templist="+df.loc[0][col])
        df.loc[0][col] = templist
	return df


#==============================================================================
#ARGUMENTS
#==============================================================================
parser = argparse.ArgumentParser(description='DEMORT - DEmultiplexing MOnitoring Report Tool')
parser.add_argument("-i","--index_file", type=str)
parser.add_argument("-o","--output_print", type=str)


args = parser.parse_args()
index_file = args.index_file
output_print = args.output_print

index_file="./indexes/ligne_2000.csv"

selection_plants= [2000, 1, 2, 3]


dbc=read_index_chunk(index_file)

row = dbc.loc[0]
bin_images = dc.get_bin_images(row)
calibrations = dc.get_calibrations(row)