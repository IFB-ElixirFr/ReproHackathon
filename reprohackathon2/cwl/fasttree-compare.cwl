class: Workflow
cwlVersion: v1.0
requirements:
  StepInputExpressionRequirement: {}
inputs:
  aligfile:
    type: File
  besttreefile:
    type: File
outputs:
  line:
    type: string
    outputSource: comparetrees/line
steps:
  fasttree:
    run: fasttree.cwl
    in:
      alig: aligfile
    out: [tree]
  comparetrees:
    run: comparetrees.cwl
    in:
      tree: fasttree/tree
      besttree: besttreefile
      method: 
        valueFrom: "fasttree"
    out: [line]
