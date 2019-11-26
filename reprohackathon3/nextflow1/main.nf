params.rownum=6
params.data="/ifb/data/public/teachdata/reprohack3/ARCH2016-04-15/ZA16_organized_database.csv"
params.binaries='/ifb/data/public/teachdata/reprohack3/ARCH2016-04-15/binaries'
params.calibration='/ifb/data/public/teachdata/reprohack3/ARCH2016-04-15/calibration'


rownum=params.rownum
header = Channel.fromPath(params.data).splitText(by: 1, limit: 1 ).map{it -> it.trim()}
id = 0
lines  = Channel.fromPath(params.data).splitText(by: 1, limit: 10).map{it -> id++; [id,it.trim()]}.buffer(size: 1, skip:1).map{it -> [it[0][0], it[0][1]]}

//lines.subscribe{println it}

binaries=params.binaries
calibration=params.calibration

process multiview {
	publishDir 'results', mode: 'copy'

	conda 'env.yaml'

	input:
	val rownum
	val h from header.first()
	set val(id), val(l) from lines
	val binaries
	val calibration

	output:
	file "*.ply" into meshout
	file "*.npz" into voxel

	shell:
	'''
	echo -e "!{h}\n!{l}" > in.csv
	# Plant number
	echo "!{l}" | cut -d ";" -f 10
	multiview.py in.csv '!{binaries}' '!{calibration}' '!{id}'
	rm in.csv
	'''
}

process segmentation {
        publishDir 'results', mode: 'copy'

        conda 'env.yaml'

	input:
	file vox from voxel

	shell:
	'''
	voxel.py !{vox}
	'''
}

//
//outchan.subscribe{
//	println(it)
//}