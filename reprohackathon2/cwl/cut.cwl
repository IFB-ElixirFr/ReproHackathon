cwlVersion: v1.0
class: CommandLineTool
baseCommand: 'cut'
arguments: 
  - '-f'
  - '2'
inputs:
  infile:
    type: File
    inputBinding:
      position: 1
stdout: 'cutout.txt'
outputs: 
  outfile:
    type: stdout
