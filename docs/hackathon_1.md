## Analyse de données RNA-Seq issues de patients atteints de mélanome uvéal

### Introduction
Dans ce hackathon, nous tenterons de reproduire les résultats de [1].
Les données originales proviennent de [2], où les auteurs ont séquencé l’ARN d’échantillons de patients atteints de mélanome uvéal. Ces patients appartiennent à deux groupes:

1. patients mutés pour le gène SF3B1 (facteur d’épissage) et
2. patients non mutés pour ce gène. 

Dans [2], les auteurs n’ont pas trouvé de différences d’épissage entre les patients mutés et les non mutés (bien qu’il s’agisse d’un facteur d’épissage).
En revanche, les auteurs de [1] ont réanalysé les mêmes données, et ont trouvé les gènes suivants épissés différemment entre les deux conditions: 
* ABCC5, 
* CRNDE,
* UQCC,
* GUSBP11,
* ANKHD1,
* ADAM12.

### Données

Les données sont accessibles sur SRA
* Patients mutés 
  * [SRR628582](https://www.ncbi.nlm.nih.gov/sra/?term=SRR628582)
  * [SRR628583](https://www.ncbi.nlm.nih.gov/sra/?term=SRR628583)
  * [SRR628584](https://www.ncbi.nlm.nih.gov/sra/?term=SRR628584)
* Patients non mutés
  * [SRR628585](https://www.ncbi.nlm.nih.gov/sra/?term=SRR628585)
  * [SRR628586](https://www.ncbi.nlm.nih.gov/sra/?term=SRR628586)
  * [SRR628587](https://www.ncbi.nlm.nih.gov/sra/?term=SRR628587)
  * [SRR628588](https://www.ncbi.nlm.nih.gov/sra/?term=SRR628588)
  * [SRR628589](https://www.ncbi.nlm.nih.gov/sra/?term=SRR628589)

### Objectif

Nous tenterons de retrouver les gènes différentiellement épissés entre les deux conditions, en utilisant un système de workflow et les outils suivants:
* [STAR](https://github.com/alexdobin/STAR),
* [DEXSeq](http://bioconductor.org/packages/release/bioc/html/DEXSeq.html),
* [SRA toolkit](https://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?view=software)
* [R](https://cran.r-project.org/)
* [Samtools](http://www.htslib.org/download/)

### Références
* [1] [Furney et al. (2013)](https://www.ncbi.nlm.nih.gov/pubmed/23861464)
* [2] [Harbour et. al (2013)](https://www.ncbi.nlm.nih.gov/pubmed/23313955)
