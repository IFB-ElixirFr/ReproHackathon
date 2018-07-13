class: ExpressionTool
cwlVersion: v1.0
inputs:
  treedir: Directory
  aligfile: File
  treeext: string
outputs:
  treefile: File
requirements:
  InlineJavascriptRequirement: {}
expression: |
  ${var location = inputs.treedir.location + '/' + inputs.aligfile.nameroot + inputs.treeext;
    return {'treefile':{'class':'File', 'location':location}};
    }
