cwlVersion: v1.0
class: CommandLineTool
hints:
  - class: DockerRequirement
    dockerPull: evolbioinfo/fasttree:v2.1.9
#baseCommand: fasttree
baseCommand: ''
arguments: ['-nt', '-gtr', '-gamma' ,'-spr', '4', '-mlacc', '2', '-slownni']
inputs:
  alig:
    type: File
    inputBinding:
      position: 1
outputs: 
  tree:
    type: stdout
