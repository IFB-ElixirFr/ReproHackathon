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
  let env = docker_image ~account:"pveber" ~name:"raxml" ~tag:"8.2.9" ()

  let hpc alignment =
    shell ~descr:"raxmlhpc" ~np:4 [
      docker env (
        and_list [
          cd tmp ;
          cmd "raxmlHPC" [
            opt "-T" (fun x -> x) np ;
            string "-p 1 -m GTRGAMMA --no-bfgs" ;
            opt "-s" dep alignment ;
            string "-n NAME" ;
          ] ;
        ]
      ) ;
      mv (tmp // "RAxML_bestTree.NAME") dest ;
    ]
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

module IQTree = struct
  let env = docker_image ~account:"pveber" ~name:"iqtree" ~tag:"1.4.2" ()

  let iqtree fa =
    let tmp_ali_fn = "data.fa" in
    let tmp_ali = tmp // tmp_ali_fn in
    shell ~descr:"iqtree" [
      docker env (
        and_list [
          cmd "ln" [ string "-s" ; dep fa ; tmp_ali ] ;
          cmd ~env "/usr/local/bin/iqtree" [ (* iqtree save its output right next to its input, hence this mess *)
            string "-m GTR+G4" ;
            opt "-s" (fun x -> x) tmp_ali ;
            string "-seed 1" ;
            opt "-nt" (fun x -> x) np ;
          ] ;
          mv (tmp // (tmp_ali_fn ^ ".iqtree")) dest ;
        ]
      )
    ]
end

module PhyML = struct
  let env = docker_image ~account:"pveber" ~name:"phyml" ~tag:"3.3.20180129" ()

  let phyml alignment =
    shell ~descr:"phyml" [
      docker env (
        and_list [
          cd tmp ;
          cmd "/usr/local/bin/phyml" [
            opt "-i" dep alignment ;
            string "--r_seed 1 -d nt -b 0 -m GTR -f e -c 4 -a e -s SPR --n_rand_starts 1 -o tlr -p --run_id ID" ;
          ] ;
          mv (tmp // "*_phyml_tree_ID.txt") dest ;
        ]
      )
    ]
end

let tree_inference fa = function
  | `Fasttree -> Fasttree.fasttree fa
  | `RAXML -> Raxml.hpc fa
  | `IQTree -> IQTree.iqtree fa
  | `PhyML -> PhyML.phyml fa

(* let gene_alignments = glob dataset  *)

let random_alignment = input "single-gene_alignments/SongD1/gene100.aln"

let repo = Repo.[
    item ["random_tree.nhx"] (tree_inference random_alignment `IQTree) ;
  ]

let () = Repo.build ~loggers:[console_logger ()] ~np:4 ~mem:(`GB 4) ~outdir:"res" repo
