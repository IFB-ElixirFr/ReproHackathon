## RNA-Seq patient data analysis in the context of uveal melanoma

### Introduction
In this hackathon, we aim at reproducing the results of [1].
Initial datasets come from [2], in which RNA is sequenced from biological samples of patients suffering from uveal melanoma. 

Samples are gathered in two groups:
1. samples with mutated SF3B1 gene (splicing factor), and 
2. samples without mutation on SF3B1 gene. 

In [2], authors did not find any splicing differences between mutated and non mutated samples (although SF3B1 is known as a splicing factor).
However, authors of [1] re-analysed the same datasets and found differential splicing between the two groups for: 
* ABCC5, 
* CRNDE,
* UQCC,
* GUSBP11,
* ANKHD1,
* ADAM12.

### Datasets 

Datasest are available from SRA
* Mutated samples 
  * [SRR628582](https://www.ncbi.nlm.nih.gov/sra/?term=SRR628582)
  * [SRR628583](https://www.ncbi.nlm.nih.gov/sra/?term=SRR628583)
  * [SRR628584](https://www.ncbi.nlm.nih.gov/sra/?term=SRR628584)
* Non mutated samples 
  * [SRR628585](https://www.ncbi.nlm.nih.gov/sra/?term=SRR628585)
  * [SRR628586](https://www.ncbi.nlm.nih.gov/sra/?term=SRR628586)
  * [SRR628587](https://www.ncbi.nlm.nih.gov/sra/?term=SRR628587)
  * [SRR628588](https://www.ncbi.nlm.nih.gov/sra/?term=SRR628588)
  * [SRR628589](https://www.ncbi.nlm.nih.gov/sra/?term=SRR628589)

### Objectives

We aim at finding again genes with differential splicing between the two conditions, by using a workflow management system and the following tools:
* [STAR](https://github.com/alexdobin/STAR),
* [DEXSeq](http://bioconductor.org/packages/release/bioc/html/DEXSeq.html),
* [SRA toolkit](https://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?view=software)
* [R](https://cran.r-project.org/)
* [Samtools](http://www.htslib.org/download/)

The workflow can be drafted as follows:
![RNA Workflow](hackathon_1_workflow.svg)

## Phylogenetics: simulation and data analysis

### Introduction

Authors of [3] introduced a fast algorithm (UFBoot) aiming at calculating phylogenetic bootstrap. 
UFBoot is compared to other approaches such as SBS, RBS, or Sh-aLRT.

### Objectives

We aim at reprpducing [figure 1](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3670741/figure/mst024-F1). 
The main steps of the workfow comprise:
* simulatiing of 600 bootstraps trees following the Yule-Harding model
* for each tree:
  * simulating 1 alignement with [gotree](https://github.com/fredericlemoine/gotree)
  * infering a tree based on the alignment with [iQTree](http://www.iqtree.org/#download) (1), [RAxML](http://sco.h-its.org/exelixis/web/software/raxml/index.html) (2) et [PhyML](http://www.atgc-montpellier.fr/phyml/) (3)
  * infering 1000 fast bootstrap trees (RAxML) (4);
  * infering 100 classical bootstrap trees (RAxML) (5);
  * calculating bootstrap supports of (2) with (4) and (5), calcultating ultrafast bootstrap supports of (1), and SH-aLRT supports of (3) with PhyML
  * for each branch we know of if it's true or false (from the true tree) and we know its 4 supports (sbs, rbs, ufboot, and alrt)

A script is available [here](https://github.com/fredericlemoine/reprovirtuflow/blob/master/bootstrap/bash_pipeline.sh).

## References
* [1] [Furney et al. (2013)](https://www.ncbi.nlm.nih.gov/pubmed/23861464)
* [2] [Harbour et al. (2013)](https://www.ncbi.nlm.nih.gov/pubmed/23313955)
* [3] [Minh et et al. (2013)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3670741/)
