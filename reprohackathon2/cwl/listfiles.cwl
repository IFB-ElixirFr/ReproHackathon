class: ExpressionTool
cwlVersion: v1.0
inputs:
  dir: Directory
outputs:
  files: File[]
requirements:
  InlineJavascriptRequirement: {}
expression: |
  ${return inputs.dir.listing;}

