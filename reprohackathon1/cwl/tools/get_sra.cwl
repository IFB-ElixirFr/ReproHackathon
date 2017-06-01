cwlVersion: v1.0
class: CommandLineTool
requirements:
- class: InlineJavascriptRequirement
baseCommand: wget
inputs:
  sraid:
    type: string
    inputBinding:
      position: 1
      valueFrom: $('http://appliances.france-bioinformatique.fr/reprohackathon/' + inputs.sraid + '.sra')
outputs: 
  sraFile:
    type: File
    outputBinding:
      glob: $(inputs.sraid + '.sra')
