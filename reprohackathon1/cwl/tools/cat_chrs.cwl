cwlVersion: v1.0
class: CommandLineTool
requirements:
- class: InlineJavascriptRequirement
baseCommand: gunzip
arguments: ['-c']
inputs:
  fastaGzFiles:
    type: {type: array, items: File}
outputs: 
  fastaFile:
    type: stdout
