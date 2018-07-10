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

align.into{alignFASTTREE; alignRAXML; alignPHYML; alignIQTREE}

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

process fasttree {
	publishDir "$resultdir/trees/fasttree"

	tag "$align"

	input:
	file align from alignFASTTREE

	output:
	set val("fasttree"), file("${align}.nhx") into fasttree

	shell:
	'''
	FastTree -nt -gtr -gamma -spr 4 -mlacc 2 -slownni !{align} > !{align}.nhx
	'''
}

process raxml {
	publishDir "$resultdir/trees/raxml"

	tag "$align"

	input:
	file align from alignRAXML

	output:
	set val("raxml"), file("${align}.nhx") into raxml

	shell:
	'''
	raxmlHPC -T !{task.cpus} -p 1 -m GTRGAMMA --no-bfgs -s !{align} -n !{align}
	mv RAxML_bestTree.!{align} !{align}.nhx
	'''
}

process tophylip {

	input:
	file align from alignPHYML

	output:
	file "${align.baseName}.phy" into alignPHYMLPhylip

	shell:
	'''
	goalign reformat phylip -i !{align} -o !{align.baseName}.phy
	'''
}

process phyml {
	publishDir "$resultdir/trees/phyml"

	tag "$align"

	input:
	file align from alignPHYMLPhylip

	output:
	set val("phyml"), file("${align}.nhx") into phyml

	shell:
	'''
	phyml -i !{align} --r_seed 1 -d nt -b 0 -m GTR -f e -c 4 -a e -s SPR --n_rand_starts 1 -o tlr -p --run_id ID
	mv !{align}_phyml_tree_ID.txt !{align}.nhx
	'''
}

process iqtree {
	publishDir "$resultdir/trees/iqtree"

	tag "$align"

	input:
	file align from alignIQTREE

	output:
	set val("iqtree"), file("${align}.treefile") into iqtree

	shell:
	'''
	iqtree -m GTR+G4 -s !{align} -seed 1 -nt !{task.cpus}
	'''
}

// Adding gene ID value
besttree.map{ f -> tuple(f.baseName.replace(".best",""),f) }.into{ best1; best2; best3; best4 }
// Adding gene ID value + join with besttree channel
fastcomp = fasttree.map { it -> tuple(it[1].baseName.replace(".aln",""), it[0], it[1]) }.join(best1)
iqcomp = iqtree.map{ it ->tuple(it[1].baseName.replace(".aln",""), it[0], it[1]) }.join(best2)
raxcomp = raxml.map{ it ->tuple(it[1].baseName.replace(".aln",""), it[0], it[1]) }.join(best3)
phycomp = phyml.map{ it ->tuple(it[1].baseName.replace(".phy",""), it[0], it[1]) }.join(best4)

// Concatenate all channels
compare = fastcomp.mix(iqcomp, raxcomp, phycomp)

// Compare all trees to best tree
process comparetrees {
	input:
	set val(id), val(method), file(tree), file(besttree) from compare

	output:
	file "comp" into compareresult

	shell:
	'''
	echo !{id} !{method} $(gotree compare trees --binary -i !{tree} -c !{besttree} | tail -n +2 | cut -f 2) > comp
	'''
}

// Final result
compareresult.collectFile(name: "comparisons.txt").into{ result1; resultall}

result1.subscribe{
	file -> file.copyTo(resultdir.resolve(file.name))
}

// Plot histograms
process plot {

	publishDir "$resultdir/plots/"

	input:
	file resultall

	output:
	file "*.svg" into plots mode flatten

	shell:
	'''
	#!/usr/bin/env Rscript
	library("ggplot2")
	library(reshape2)
	comp=read.table("!{resultall}")
	colnames(comp)=c("gene","method","found")
	cast=dcast(comp, method ~ found, function(x) length(x))
	total=(cast$false+cast$true)
	cast$false = cast$false/total
	cast$true = cast$true/total
	svg("comparison.svg")
	ggplot(cast, aes(method,true))+geom_bar(stat="identity")
	dev.off()
	'''
}
