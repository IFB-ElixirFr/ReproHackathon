class: Workflow
cwlVersion: v1.0
inputs:
  aligfile:
    type: File
  besttreefile:
    type: File
outputs:
  report:
    type: File
    outputSource: comparetree/report
steps:
  fasttree:
    run: fasttree.cwl
    in:
      alig: aligfile
    out: [tree]
  comparetree:
    run: comparetrees.cwl
    in:
      tree: fasttree/tree
      besttree: besttreefile
    out: [report]
