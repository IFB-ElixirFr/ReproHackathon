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

## References
* [1] [Furney et al. (2013)](https://www.ncbi.nlm.nih.gov/pubmed/23861464)
* [2] [Harbour et al. (2013)](https://www.ncbi.nlm.nih.gov/pubmed/23313955)
