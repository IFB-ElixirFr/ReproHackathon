class: Workflow
cwlVersion: v1.0
requirements:
  ScatterFeatureRequirement: {}
inputs:
  dir:
    type: Directory
#    aligarray:
#      type: File[]
outputs: []
#  treearray:
#    type: File[]
#    outputSource: step1/files #fasttree/tree   
steps:
  step1:
    run: listfiles.cwl
    in:
      dir: dir
    out: 
      - id: files
