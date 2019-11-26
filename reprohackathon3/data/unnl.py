#import cv2
#import os
#import datetime
#import pandas
#from openalea.phenomenal.calibration import CalibrationCamera
from path import Path
import pandas as pd


PREFIX=Path('/ifb/data/public/teachdata/reprohack3/UNL-3DPPD/10sides_transformed')

# Data are organised in plant/date/view_camera_angle/0_0_0.png

def plants():
    """ return plant paths """
    dirs = PREFIX.listdir()
    return dirs

def dates(plant_dir):
    days = plant_dir.listdir()
    return [d.name for d in days]


def index():
    """ Return a dict

    return Maize or Sorg"""

    data = []

    dirs = PREFIX.listdir()
    for d in dirs:
        plant_name = str(d.name)
        dates = d.listdir()
        for date in dates:
            date_str = str(date.name)
            views = []
            angles = []
            images = []
            for view in date.listdir():
                camera = str(view.name)
                _, view_type, angle = camera.split('_')
                angle = int(angle)
                _images = view.glob('*.png')
                assert(len(_images)==1)
                image = _images[0]
                views.append(view_type)
                angles.append(angle)
                images.append(str(image))

            record = (plant_name, date_str, views, angles, images )
            data.append(record)
    df = pd.DataFrame.from_records(data=data,
                                   columns=('plant', 'date', 'view_type', 'camera_angle', 'path'))
    return df

def read_index(fname):
    df = pd.read_csv(fname, sep=';')

def raw_images(row):
    d = dict(side={}, top={})
    images = eval(row.path)
    angles = eval(row.camera_angle)
    views = eval(row.view_type)

    for img, ang, view in zip(images, angles, views):
        d['side' if view == 'SV' else 'top'][ang]= cv2.imread(img, cv2.IMREAD_UNCHANGED)
    return d
