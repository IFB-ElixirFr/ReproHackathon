import cv2
import os
import datetime
import pandas
from openalea.phenomenal.calibration import CalibrationCamera


PREFIX='/ifb/data/public/teachdata/reprohack3/ARCH2016-04-15/binaries'

## read index
def read_index(prefix=os.path.join(PREFIX,'..')):
	df = pandas.read_csv(os.path.join(prefix, 'ZA16_organized_database.csv'),sep=';')
#	for col in ('path_http','camera_angle', 'dates', 'view_type'):
#		df.loc[:,col] = map(eval, df.loc[:,col])
	return df

## binary path
def get_remote_path_bin(row, prefix=PREFIX, delta=0):
    pot_number = int(row["plant"][:4])

    date = datetime.datetime.strptime(row["date"], "%Y-%m-%d %H:%M:%S.%f")
    date = date + datetime.timedelta(seconds=delta)
    str_date = date.strftime('%Y-%m-%d_%H-%M-%S')

    str_views = ['sv' if v == 'side' else 'tv' for v in eval(row["view_type"])]

    filenames = list()
    for filename, view, angle, date in zip(eval(row["path_http"]),
                                           str_views,
                                           eval(row["camera_angle"]),
                                           eval(row["dates"])):

        r = filename.split('/')


        # ZA16
        f = (prefix+
            '/task_{task}/'
            't-{task}_p-{pot}_{view}{angle}_{date}_bin.png'.format(
                name_exp=r[5],
                task=r[6],
                pot=pot_number,
                view=view,
                angle=angle,
                date=str_date))

        filenames.append(f)

    return filenames


def get_bin_images(row, prefix=PREFIX):
	#find filenames
	for delta in [0, -1, 1, -2, 2, -3, 3, -4, 4]:
		filenames = get_remote_path_bin(row, prefix=prefix,delta=delta)
		if os.path.exists(filenames[0]):
			break
	if delta == 4:
		raise ValueError('Can not find binaries')
	imdict={t:{} for t in set(eval(row.view_type))}
	for view, angle, path in zip(eval(row.view_type),eval(row.camera_angle),filenames):
		imdict[view][angle]=cv2.imread(path, cv2.IMREAD_UNCHANGED)
	return imdict


def get_calibrations(row, prefix=os.path.join(PREFIX,'..','calibration')):
	calib = {}
	for view in set(eval(row.view_type)):
		path = os.path.join(prefix, (row.cabin + '_' + view + '_1_1_wide.json'))
		calib[view] = CalibrationCamera.load(path)
	return calib
