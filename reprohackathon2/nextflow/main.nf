// Reprohackathon 2
// https://github.com/IFB-ElixirFr/ReproHackathon/tree/master/reprohackathon2

params.resultdir= ["$baseDir", "results"].join(File.separator)
resultdir = file(params.resultdir)

resultdir.with {
    mkdirs()
}

process getalignments {
	publishDir "$resultdir/aligns"

	output:
	file "single-gene_alignments/SongD1/gene*.aln" into align mode flatten

	shell:
	'''
	wget -O single-gene_alignments.tar.bz2  https://ndownloader.figshare.com/files/9473962
	tar -xjvf single-gene_alignments.tar.bz2 single-gene_alignments/SongD1/
	'''
}

process getbesttrees {
	publishDir "$resultdir/trees_best"

	output:
	file "single-gene_trees/SongD1/Best_observed/*" into besttree mode flatten

	shell:
	'''
	wget -O single-gene_trees.tar.bz2 https://ndownloader.figshare.com/files/9473953
	tar -xjf single-gene_trees.tar.bz2 single-gene_trees/SongD1/
	'''
}

