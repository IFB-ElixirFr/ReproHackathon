#require "bistro core"

open Core.Std
open Bistro.Std
open Bistro.EDSL
open Bistro_bioinfo.Std

module Star = struct
  let env = docker_image ~account:"flemoine" ~name:"star" ()

  let index fa =
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
  Sra.fetch_srr x
  |> Sra_toolkit.fastq_dump_pe

let genome = Ucsc_gb.genome_sequence `hg38

let star_index = Star.index genome

let mapped_reads x =
  Star.map star_index (sample x)
