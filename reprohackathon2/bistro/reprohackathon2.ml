(*

   data: https://ndownloader.figshare.com/files/9473962

*)

#require "bistro bistro.bioinfo bistro.unix"

open Bistro
open Shell_dsl

let dataset =
  Bistro_unix.wget "https://ndownloader.figshare.com/files/9473962"
  |> Bistro_unix.bunzip2

module Raxml = struct
  
end

module Fasttree = struct
  let env = docker_image ~account:"pveber" ~name:"fasttree" ~tag:"2.1.10" ()

  let fasttree fa =
    shell ~descr:"fasttree" [
      cmd ~env "/usr/local/bin/FastTree" ~stdout:dest [
        string "-nt -gtr -gamma -spr 4 -mlacc 2 -slownni" ;
        dep fa ;
      ]
    ]
end


let tree_inference fa = function
  | `Fasttree -> Fasttree.fasttree fa

(* let gene_alignments = glob dataset  *)

let random_alignment = input "single-gene_alignments/SongD1/gene100.aln"

let repo = Repo.[
    item ["random_tree.nhx"] (tree_inference random_alignment `Fasttree) ;
    item ["random_ali.nhx"] random_alignment ;
  ]

let () = Repo.build ~loggers:[console_logger ()] ~np:4 ~mem:(`GB 4) ~outdir:"res" repo
