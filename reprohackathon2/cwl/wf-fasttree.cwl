class: Workflow
cwlVersion: v1.0
requirements:
  ScatterFeatureRequirement: {}
  SubworkflowFeatureRequirement: {}
inputs:
  aligdir:
    type: Directory
  besttreedir:
    type: Directory
  treeext: 
    type: string
outputs:
  aligfiles:
    type: File[]
    outputSource: listaligfiles/files
  besttreefiles:
    type: File[]
    outputSource: listbesttrees/treefile
  reports:
    type: File[]
    outputSource: [subwf/report]
steps:
  listaligfiles:
    run: listfiles.cwl
    in:
      dir: aligdir
    out: [files]
  listbesttrees:
    run: getbesttree.cwl
    scatter: [aligfile]
    in:
      aligfile: listaligfiles/files
      treedir: besttreedir
      treeext: treeext
    out: [treefile]
  subwf:
    scatter: [aligfile, besttreefile]
    scatterMethod: dotproduct
    in:
      aligfile: listaligfiles/files
      besttreefile: listbesttrees/treefile
    out: [report]
    run: fasttree-compare.cwl

