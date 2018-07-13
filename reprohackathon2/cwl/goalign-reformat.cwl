class: CommandLineTool
cwlVersion: v1.0
requirements:
  InlineJavascriptRequirement: {}
hints:
  - class: DockerRequirement
    dockerPull: evolbioinfo/goalign:v0.2.8a
#baseCommand: 'goalign'
baseCommand: ''
arguments: ['reformat', 'phylip', '-i', $(inputs.infile.path), '-o', $(inputs.infile.nameroot).phy]
inputs:
  infile:
    type: File
    inputBinding:
      position: 1
      prefix: -i
outputs: 
  outfile:
    type: File
    outputBinding:
      glob: $(inputs.infile.nameroot).phy
