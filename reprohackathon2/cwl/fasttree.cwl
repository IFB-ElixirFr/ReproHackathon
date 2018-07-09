cwlVersion: v1.0
class: CommandLineTool
requirements:
- class: InlineJavascriptRequirement
hints:
  - class: DockerRequirement
    dockerPull: evolbioinfo/fasttree:v2.1.9
baseCommand: ['FastTree', '-nt', '-gtr', '-gamma' ,'-spr', '4', '-mlacc', '2', '-slownni']
inputs:
  chr:
    type: align
    inputBinding:
      position: 1
outputs: 
  tree:
    type: stdout
