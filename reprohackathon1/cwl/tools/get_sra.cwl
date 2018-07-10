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
      #valueFrom: $('http://appliances.france-bioinformatique.fr/reprohackathon/' + inputs.sraid + '.sra')
      valueFrom: $('ftp://ftp.sra.ebi.ac.uk/vol1/srr/SRR628/' + inputs.sraid)
outputs: 
  sraFile:
    type: File
    outputBinding:
      glob: $(inputs.sraid)
