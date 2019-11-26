## Import packages
%matplotlib notebook

import cv2
import matplotlib.pyplot

import openalea.phenomenal.data as phm_data
import openalea.phenomenal.display as phm_display
import openalea.phenomenal.calibration as phm_calib

## Detect chessboard corners in the images
##  Load Images
plant_number = 1
chessboard_images = phm_data.chessboard_images(plant_number=plant_number)[0]
phm_display.show_image(chessboard_images['side'][42])

## Create chessboard object

square_size_of_chessboard = 47 # In mm
square_shape_of_chessboard = (8, 6) # (8 square x 6 square on chessboard)

# BUILD CHESSBOARD OBJECT
chessboard = phm_calib.Chessboard(square_size_of_chessboard, 
                                  square_shape_of_chessboard)

# DISPLAY IT
print chessboard

## Detect corners from images
for id_camera in chessboard_images:
    for angle in chessboard_images[id_camera]:
        im = chessboard_images[id_camera][angle]
        found = chessboard.detect_corners(id_camera, angle, im)
        print("Angle {} - Chessboard corners {}".format(angle, "found" if found else "not found"))

## Display chessboard corners on images
angle = 42
img = chessboard_images["side"][angle].copy()

# DRAW RED POINT ON IMAGE CORNERS POSITION
points_2d = chessboard.image_points[id_camera][angle].astype(int)
for x, y in zip(points_2d[:, 0, 1], points_2d[:, 0, 0]):
    cv2.circle(img, (y, x), 5, (255, 0, 0), -1)

phm_display.show_image(img)

## Dump & load
chessboard.dump('chessboard.json')
chessboard = phm_calib.Chessboard.load('chessboard.json')
Multi-camera calibration


### Load chessboard object with all corners points

# Load chessboard object
chessboards = phm_data.chessboards(plant_number=plant_number)

chessboards_image_points_side_42 = chessboards[0].image_points[id_camera][42].copy()

# Remove some angle to optimize time processing, keep only the 30 modulo image
id_camera = "side"
for angle in range(0, 360, 3):
    if not (angle % 30 == 0):
        chessboards[0].image_points[id_camera].pop(angle, None)
        chessboards[1].image_points[id_camera].pop(angle, None)

# Used angle :
print chessboards[0].image_points[id_camera].keys() + chessboards[1].image_points[id_camera].keys()

[0.0, 30.0, 60.0, 90.0, 270.0, 180.0, 210.0, 240.0]

## Do calibration


# Define size image of image chessboard to calibrate
size_image = (2056, 2454)

# Calibrate
id_camera = "side"
calibration = phm_calib.CalibrationCameraSideWith2TargetYXZ()
err = calibration.calibrate(chessboards[0].get_corners_2d(id_camera), 
                            chessboards[0].get_corners_local_3d(),
                            chessboards[1].get_corners_2d(id_camera), 
                            chessboards[1].get_corners_local_3d(),
                            size_image,
                            number_of_repetition=0, # repetion here is 0 to optimize time consuming (for better result put 4)
                            verbose=False)

# Error of reprojection (in pixel distance) for all point in the target (48)
# So real error is err / 48
print err

#Dump & load

## Dump
calibration.dump('calibration_camera_side.json')
## Load
calibration = phm_calib.CalibrationCameraSideWith2Target.load('calibration_camera_side.json')

## Viewing calibration result
### Show chessboard image with corners projection
angle = 42
circle_radius = 5
img = chessboard_images['side'][angle].copy()

# RED POINTS ARE POINTS POSITIONS DETECTED BY OPENCV CHESSBOARD DETECTION 
pt_2d = chessboards_image_points_side_42.astype(int)
for x, y in zip(pt_2d[:, 0, 1], pt_2d[:, 0, 0]):
    cv2.circle(img, (y, x), circle_radius, (255, 0, 0), -1)

# BLUE POINTS ARE POINTS POSITIONS PROJECTED BY CALIBRATION CHESSBOARD COMPUTATION
points_2d = calibration.get_target_1_projected(42, chessboards[0].get_corners_local_3d())
for x, y in map(lambda x : map(int, tuple(x)), points_2d):
    cv2.circle(img, (x, y), circle_radius, (0, 0, 255), -1)

phm_display.show_image(img)


