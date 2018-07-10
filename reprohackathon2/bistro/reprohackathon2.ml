(*

   data: https://ndownloader.figshare.com/files/9473962

*)

#require "bistro bistro.bioinfo bistro.unix bistro.ppx"

open Core_kernel
open Bistro
open Shell_dsl

module Dataset = struct
  type t = [`SongD1]

  let to_string = function
    | `SongD1 -> "SongD1"

  let alignments d =
    Bistro_unix.wget "https://ndownloader.figshare.com/files/9473962"
    |> Bistro_unix.tar_xfj
    |> Fn.flip select (selector ["single-gene_alignments" ; to_string d ])
    |> glob ~pattern:"*"

  let best_trees d =
    Bistro_unix.wget "https://ndownloader.figshare.com/files/9473953"
    |> Bistro_unix.tar_xfj
    |> Fn.flip select (selector ["single-gene_trees" ; to_string d ])
    |> glob ~pattern:"*"

end

module Raxml = struct
  let env = docker_image ~account:"pveber" ~name:"raxml" ~tag:"8.2.9" ()

  let hpc alignment =
    shell ~descr:"raxmlhpc" ~np:4 [
      docker env (
        and_list [
          cd tmp ;
          cmd "raxmlHPC" [
            opt "-T" ident np ;
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
            opt "-s" ident tmp_ali ;
            string "-seed 1" ;
            opt "-nt" ident np ;
          ] ;
          mv (tmp // (tmp_ali_fn ^ ".treefile")) dest ;
        ]
      )
    ]
end

module PhyML = struct
  let env = docker_image ~account:"pveber" ~name:"phyml" ~tag:"3.3.20180129" ()

  let phyml alignment =
    let tmp_ali_fn = "alignment" in
    let tmp_ali = tmp // tmp_ali_fn in
    shell ~descr:"phyml" [
      docker env (
        and_list [
          cd tmp ;
          cmd "ln" [ string "-s" ; dep alignment ; tmp_ali ] ;
          cmd "/usr/local/bin/phyml" [
            opt "-i" ident tmp_ali ;
            string "--r_seed 1 -d nt -b 0 -m GTR -f e -c 4 -a e -s SPR --n_rand_starts 1 -o tlr -p --run_id ID" ;
          ] ;
          mv (tmp // (tmp_ali_fn ^ "*_phyml_tree_ID.txt")) dest ;
        ]
      )
    ]
end

module Goalign = struct
  let env = docker_image ~account:"pveber" ~name:"goalign" ~tag:"0.2.9" ()

  let phylip_of_fasta fa =
    shell ~descr:"goalign.reformat" [
      cmd "goalign" ~env [
        string "reformat phylip" ;
        opt "-i" dep fa ;
        opt "-o" ident dest ;
      ]
    ]
end

module Gotree = struct
  let env = docker_image ~account:"pveber" ~name:"gotree" ~tag:"0.2.10" ()

  let compare_trees ~input ~reference =
    shell ~descr:"gotree.compare" [
      cmd "/usr/local/bin/gotree" ~stdout:dest ~env [
        string "compare trees --binary" ;
        opt "-i" dep input ;
        opt "-c" dep reference ;
      ]
    ]
end


let tree_inference meth fa = match meth with
  | `Fasttree -> Fasttree.fasttree fa
  | `RAXML -> Raxml.hpc fa
  | `IQTree -> IQTree.iqtree fa
  | `PhyML -> PhyML.phyml (Goalign.phylip_of_fasta fa)

let inferred_trees d meth =
  map_workflows (Dataset.alignments d) ~f:(tree_inference meth)

let comparisons d meth =
  map2_workflows
    (inferred_trees d meth)
    (Dataset.best_trees d)
    ~f:(fun input reference -> Gotree.compare_trees ~input ~reference)

let%bistro concat results =
  List.map [%deps results] ~f:(fun fn ->
      In_channel.read_lines fn
      |> Fn.flip List.nth_exn 1
    )
  |> Out_channel.write_lines [%dest]

let random_alignment = input "single-gene_alignments/SongD1/gene100.aln"

let repo = Repo.[
    item ["random_tree.nhx"] (tree_inference `PhyML random_alignment) ;
    item ["random_comparison"] (Gotree.compare_trees ~input:(tree_inference `IQTree random_alignment) ~reference:(tree_inference `RAXML random_alignment)) ;
    item ["concatenated_comps"] (concat (comparisons `SongD1 `Fasttree)) ;
  ]

let () = Repo.build ~loggers:[console_logger ()] ~np:4 ~mem:(`GB 4) ~outdir:"res" repo
