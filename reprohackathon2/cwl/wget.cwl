cwlVersion: v1.0
class: CommandLineTool
requirements:
- class: InlineJavascriptRequirement
baseCommand: ['wget', '-O', 'downloaded_file']
inputs:
  url:
    type: string
    inputBinding:
      position: 1
outputs: 
  fastaFile:
    type: File
    outputBinding:
      glob: 'downloaded_file'
