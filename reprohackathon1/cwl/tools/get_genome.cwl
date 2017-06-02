cwlVersion: v1.0
class: CommandLineTool
requirements:
- class: InlineJavascriptRequirement
baseCommand: wget
inputs:
  chr:
    type: string
    inputBinding:
      position: 1
      valueFrom: $('http://hgdownload.soe.ucsc.edu/goldenPath/hg19/chromosomes/' + inputs.chr + '.fa.gz')
outputs: 
  fastaFile:
    type: File
    outputBinding:
      glob: $(inputs.chr + '.fa.gz')
