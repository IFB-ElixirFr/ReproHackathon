params.rownum=6
params.data="/ifb/data/public/teachdata/reprohack3/ARCH2016-04-15/ZA16_organized_database.csv"
params.binaries='/ifb/data/public/teachdata/reprohack3/ARCH2016-04-15/binaries'
params.calibration='/ifb/data/public/teachdata/reprohack3/ARCH2016-04-15/calibration'


rownum=params.rownum
data=file(params.data)
binaries=params.binaries
calibration=params.calibration

process mutiview{
	conda 'env.yaml'

	input:
	val rownum
	file data
	val binaries
	val calibration


	shell:
	'''
	multiview.py !{data} !{binaries} !{calibration}
	'''
}

//outchan.subscribe{
//	println(it)
//}