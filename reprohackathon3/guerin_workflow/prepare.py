import cv2
import os
import datetime
import pandas
from openalea.phenomenal.calibration import CalibrationCamera




selection_plants= [2000, 1, 2, 3]


for select_id in selection_plants:
    select_loc=df.loc[select_id]
    select_task= select_loc["task"]
    select_file_name="{2}/task_{0}_id_{1}".format(select_task,select_id,local_indexes)
    select_loc.to_csv(select_file_name,sep=";", index=False)



dftest = pandas.read_csv(select_file_name,sep=';',index_col=0)



## read index
def read_index(index_file):
	df = pandas.read_csv(index_file,sep=';')
	for col in ('path_http','camera_angle', 'dates', 'view_type'):
		df.loc[:,col] = map(eval, df.loc[:,col])
	return df