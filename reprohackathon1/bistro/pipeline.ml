#require "bistro bistro.bioinfo core"

open Core.Std
open Bistro.Std
open Bistro.EDSL
open Bistro_bioinfo.Std

module Star = struct
  let env = docker_image ~account:"flemoine" ~name:"star" ()

  let index (fa : fasta workflow) =
    workflow ~descr:"star.index" ~np:8 ~mem:(10 * 1024) [
      cmd "STAR" ~env [
        opt "--runThreadN" ident np ;
        opt "--runMode" string "genomeGenerate" ;
        opt "--genomeDir" ident dest ;
        opt "--genomeFastaFiles" dep fa ;
      ]
    ]

  let map idx (fq1, fq2) : bam workflow =
    workflow ~descr:"star.map"  ~mem:(10 * 1024) [
      cmd "STAR" ~stdout:dest ~env [
        opt "--runThreadN" ident np ;
        opt "--outSAMstrandField" string "intronMotif" ;
        opt "--outFilterMismatchNmax" int 4 ;
        opt "--outFilterMultimapNmax" int 10 ;
        opt "--genomeDir" dep idx ;
        opt "--readFilesIn" ident (seq ~sep:" " [ dep fq1 ; dep fq2 ]) ;
        opt "--outSAMunmapped" string "None" ;
        opt "--outSAMtype" string "BAM SortedByCoordinate" ;
        opt "--outStd" string "BAM_SortedByCoordinate" ;
        opt "--genomeLoad" string "NoSharedMemory" ;
        opt "--limitBAMsortRAM" ident mem ;
      ]
    ]
end

module DEXSeq = struct
  let env = docker_image ~account:"flemoine" ~name:"r-rnaseq" ()
  let count gff bam =
    workflow ~descr:"dexseq.count" [
      cmd "python" ~env [
        string "/usr/local/lib/R/library/DEXSeq/python_scripts/dexseq_count.py" ;
        opt "-p" string "yes" ;
        opt "-r" string "pos" ;
        opt "-s" string "no" ;
        opt "-f" string "bam" ;
        dep gff ;
        dep bam ;
        dest ;
      ]
    ]
end


let dexseq_script = {rscript|
library(DEXSeq)
library(reshape2)
options(bitmapType='cairo')

## Count data
counts<-read.table(acounts)
colnames(counts)=c("cond","sraid","exon","count")
widecount=dcast(counts, exon ~ sraid,value.var="count")
row.names(widecount)=widecount$exon
widecount=widecount[,-1]

## Exon and Gene Names
exons=sapply(strsplit(row.names(widecount), ":"),"[",2)
genes=sapply(strsplit(row.names(widecount), ":"),"[",1)

## Sample Annotation
samples=unique(counts[,c(1,2)])$cond
sampleTable <- data.frame(lapply(unique(counts[,c(1,2)]), as.character),libType="paired-end",stringsAsFactors=FALSE)
row.names(sampleTable)=sampleTable$sraid
sampleTable=sampleTable[,-2]
colnames(sampleTable)=c("condition","libType")
# on remet dans l'ordre
sampleTable=sampleTable[colnames(widecount),]

# Write into individual files
countfiles=paste0(colnames(widecount),".txt")
for(sample in colnames(widecount)){
write.table(file=paste0(sample,".txt"),data.frame(row.names=row.names(widecount),count=widecount[,sample]),row.names=TRUE,col.names=FALSE,quote=FALSE,sep="\t")
}

# Create DEXSeqDataSet
dxd= DEXSeqDataSetFromHTSeq(countfiles,sampleData=sampleTable,design=~sample+exon+condition:exon,flattenedfile="!{annot}")

# Stat analysis
dxd=estimateSizeFactors(dxd)
dxd=estimateDispersions(dxd)

png("dispersion_out.png")
plotDispEsts(dxd)
dev.off()

dxd=testForDEU(dxd)
dxd=estimateExonFoldChanges(dxd,fitExpToVar="condition")
dxr1=DEXSeqResults( dxd )
dxr1=na.omit(dxr1)
#table(dxr1$pvalue<0.1)
write.table(file="diff_exons_out.txt",dxr1[dxr1$padj<0.1,])
#table(tapply(dxr1$padj<0.1,dxr1$groupID,any))

png("maplot_out.png")
plotMA(dxr1,cex=0.8)
dev.off()

for(i in unique(dxr1[dxr1$padj<0.1,"groupID"])){
  png(paste0(i,"_out.png"))
  plotDEXSeq( dxr1,i,legend=TRUE,cex.axis=1.2,cex=1.3,lwd=2,norCounts=TRUE,splicing=TRUE,displayTranscripts=TRUE)
  dev.off()
}
|rscript}

let dexseq_script counts = seq ~sep:"\n" [
    string "#!/usr/bin/env Rscript" ;
    seq ~sep:" " [ string "dest <-" ; dest ] ;
  ]

type condition =
  | Mutated
  | WT

let srr_samples_ids = function
  | Mutated -> [
      "SRR628582" ;
      "SRR628583" ;
      "SRR628584" ;
    ]
  | WT -> [
      "SRR628585" ;
      "SRR628586" ;
      "SRR628587" ;
      "SRR628588" ;
      "SRR628589" ;
    ]

let sample x =
  Sra_toolkit.fastq_dump_pe (Sra.fetch_srr x)


let genome = Ucsc_gb.genome_sequence `hg38

let star_index = Star.index genome

let mapped_reads x =
  Star.map star_index (sample x)
