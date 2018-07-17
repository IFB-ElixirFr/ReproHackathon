cwlVersion: v1.0
class: CommandLineTool
requirements:
  - class: InlineJavascriptRequirement
hints:
  - class: DockerRequirement
    dockerPull: evolbioinfo/gotree:v0.2.10
#baseCommand: gotree
baseCommand: ''
arguments: 
  - 'compare'
  - 'trees'
  - '--binary'
  - '-i'
  - $(inputs.tree.path)
  - '-c'
  - $(inputs.besttree.path)
inputs:
  tree:
    type: File
  besttree:
    type: File
  method:
    type: string?
stdout: 'output.txt'
outputs: 
  line:
    type: string
    outputBinding:
      glob: 'output.txt'
      loadContents: true
      outputEval: |
        ${return inputs.tree.nameroot + '\t' + inputs.method + '\t' + self[0].contents.split(/[\n\t]+/).slice(-2)[0];}
