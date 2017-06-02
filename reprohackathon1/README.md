Ce dossier contient les résultats du ReproHackathon1

## Organisation proposée

* Un sous-répertoire par groupe
* Associé à une branche
* Incluant la description
  * des matériels et méthodes utilisés
  * de l'avancement au fur et à mesure
  * un bilan des réalisations en fin de hackathon

## Participants/Groupes :

* [bistro](https://github.com/pveber/bistro) (OCaml library for distributed workflows)
  * Philippe Veber
* galaxy
  * *Prénom Nom?*
* nextflow
  * *Prénom Nom?*
* snakemake1
  * *Prénom Nom?*
* snakemake2
  * *Prénom Nom?*
* jupyter
  * Loïc Paulevé
* NodeJS
  - Guillaume Launay
  - Mélanie Garnier
* *groupe ?*
  - Victoria Dominguez del Angel 
  - Bérénice Batut


## Liens utiles

* Une vidéo pour montrer comment [lancer l'appliance docker ReproHackathon dans Biosphère](https://www.youtube.com/watch?v=0B5GoaD58Cc)
* [Documentation du Cloud IFB](http://www.france-bioinformatique.fr/fr/cloud/doc-du-cloud), avec des principes généraux
* [Tutoriels pour l'utilisation du cloud IFB/StratusLab](http://www.france-bioinformatique.fr/fr/evenements/IFB-IBI)
* [Documentation du cloud GenoStack](http://www.genouest.org/outils/genostack/getting-started.html) (IFB-GenOuest)
  * example de commande : ssh -A -t cloud-username@openstack.genouest.org ssh root@192.168.101.XX
* Images Docker
    * STAR	:	['flemoine/star'](https://hub.docker.com/r/flemoine/star/)
    * SRA Toolkit: 	['flemoine/sratoolkit'](https://hub.docker.com/r/flemoine/sratoolkit/)
    * R/DEXSeq	:	['flemoine/r-rnaseq'](https://hub.docker.com/r/flemoine/r-rnaseq/)
    * SAMTOOLS	['flemoine/samtools'](https://hub.docker.com/r/flemoine/samtools/)
* [Exemple de workflow](https://github.com/fredericlemoine/rna-pipeline/tree/master/pmid_23313955)
* [Données à traiter](http://appliances.france-bioinformatique.fr/reprohackathon/)

## Quelques commandes utiles?
### Fix Docker net host
```bash
iptables -I FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
```
### Get public IP
```PUBLIC_IP=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)```

### Téléchargement fichiers
```bash
for sraid in SRR628582 SRR628583 SRR628584 SRR628585 SRR628586 SRR628587 SRR628588 SRR628589
do
wget http://appliances.france-bioinformatique.fr/reprohackathon/${sraid}.sra
done
```
### Conversion en FASTQ
```bash
for sraid in SRR628582 SRR628583 SRR628584 SRR628585 SRR628586 SRR628587 SRR628588 SRR628589
do
fastq-dump --gzip --split-files ${sraid}.sra
done
```
=> Pour gagner de la place, supprimer les SRA peut être…

### Téléchargement génomes
```bash
for chr in chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chrM chrX chrY
do
wget http://hgdownload.soe.ucsc.edu/goldenPath/hg19/chromosomes/${chr}.fa.gz
done
```
### Création index STAR
```bash
mkdir ref
gunzip -c *.fa.gz > ref.fa
STAR --runThreadN 10 --runMode genomeGenerate --genomeDir ref/ --genomeFastaFiles ref.fa
rm -f ref.fa
```

* Fichiers en sortie
```
ref/
├── chrLength.txt
├── chrNameLength.txt
├── chrName.txt
├── chrStart.txt
├── Genome
├── genomeParameters.txt
├── SA
└── SAindex
```

### Alignement
```bash
for sraid in SRR628582 SRR628583 SRR628584 SRR628585 SRR628586 SRR628587 SRR628588 SRR628589
do
STAR --outSAMstrandField intronMotif \
     --outFilterMismatchNmax 4 \
     --outFilterMultimapNmax 10 \
     --genomeDir ref \
     --readFilesIn <(gunzip -c ${sraid}_1.fastq.gz) <(gunzip -c ${sraid}_2.fastq.gz) \
     --runThreadN 10  \
     --outSAMunmapped None \
     --outSAMtype BAM SortedByCoordinate \
     --outStd BAM_SortedByCoordinate \
     --genomeLoad NoSharedMemory \
     --limitBAMsortRAM 3000000000 > ${sraid}.bam
done
```

Si besoin les bam sont également disponibles ici:
```bash
for sraid in SRR628582 SRR628583 SRR628584 SRR628585 SRR628586 SRR628587 SRR628588 SRR628589
do
wget http://appliances.france-bioinformatique.fr/reprohackathon/${sraid}.bam
done
```

### Comptages

Pour DEXseq, il est demandé si la librarie est spécifique à un brin. Pour avoir cette information, on peut inférer cette information

1. Mapper un échantillon des reads sur le génome de référence
2. Inférer les statistiques du type de librairies avec `infer_experiment.py` de [RSeQC](http://rseqc.sourceforge.net/) à partir du reads pré-mappés et les annotations des gènes (fichier GTF)

   Tableau de correspondance:

   Sequencing type | **Infer Experiment** | **TopHat** | **HISAT2** | **htseq-count** | **featureCounts**
   --- | --- | --- | --- | --- | ---
   Paired-End (PE) | "1++,1--,2+-,2-+" | "FR Second Strand" | "Second Strand F/FR" | "yes" | "1"
   PE | "1+-,1-+,2++,2--" | "FR First Strand" | "First Strand R/RF" | "reverse" | "2"
   Single-End (SE) | "++,--" | "FR Second Strand" | "Second Strand F/FR" | "yes" | "1"
   SE | "+-,-+" | "FR First Strand" | "First Strand R/RF" | "reverse" | "2"
   SE,PE | undecided | "FR Unstranded" | default | "no" | "0"
