#require "bistro core"

open Core.Std

module Star = struct
  let index =
    workflow ~descr:"star.index" ~np:8 ~mem:(10 * 1024) [
      cmd "STAR" [
        opt "--runThreadN" int np ;
        opt "--runMode" string "genomeGenerate" ;
        opt "--genomeDir" ident dest ;
        opt "--genomeFastaFiles" dep fa ;
      ]
    ]

end

type condition =
  | Mutated
  | WT

let srr_samples = function
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

let genome = Ucsc_gb.fetch_genome `hg19

let star_index = Star.index genome
