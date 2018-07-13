class: CommandLineTool
cwlVersion: v1.0
requirements:
  - class: InlineJavascriptRequirement
hints:
  - class: DockerRequirement
    dockerPull: evolbioinfo/r-extended:v3.4.3
baseCommand: 'Rscript'
baseCommand: ''
#R CMD BATCH '--args echoout.txt plot.svg' plot.r toto.svg
arguments: 
  - '--vanilla'
  - '-f'
  - $(inputs.script.path)
  - '--args'
inputs:
  script:
    type: File
    default:
      class: File
      location: 'plot.r'
  infile:
    type: File
    inputBinding:
      position: 1
  outfilename:
    type: string
    inputBinding:
      position: 2
outputs: 
  plotfile:
    type: File
    outputBinding:
      glob: $(inputs.outfilename)
