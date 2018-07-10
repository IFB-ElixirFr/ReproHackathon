class: Workflow
cwlVersion: v1.0
requirements:
  ScatterFeatureRequirement: {}
inputs:
  dir:
    type: Directory
outputs:
  aligfiles:
    type: File[]
    outputSource: listfiles/files
  treefiles:
    type: File[]
    outputSource: fasttree/tree   
steps:
  listfiles:
    run: listfiles.cwl
    in:
      dir: dir
    out: 
      - id: files
  fasttree:
    run: fasttree.cwl
    scatter: alig
    in:
      alig: listfiles/files
    out:
      - id: tree 
