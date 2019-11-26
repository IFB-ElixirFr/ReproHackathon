import datacloud as dc
db = dc.read_index()
row_number = 2000# Available : 0, 1, 2, 3, 4 or 5, or  ... 57436
row = db.loc[row_number]
bin_images = dc.get_bin_images(row)
calibrations = dc.get_calibrations(row)

