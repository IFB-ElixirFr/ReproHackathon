cwlVersion: v1.0
class: CommandLineTool
requirements:
  - class: InlineJavascriptRequirement
baseCommand: 'cp'
inputs:
  infile:
    type: File
    inputBinding:
      position: 1
  outfilename:
    type: string
    inputBinding:
      position: 2
outputs: 
  outfile:
    type: File
    outputBinding:
      glob: $(inputs.outfilename)
