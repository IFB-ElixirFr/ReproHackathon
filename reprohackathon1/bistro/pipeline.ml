#require "bistro core"

open Core.Std

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

let genome = Ucsc_gb.
