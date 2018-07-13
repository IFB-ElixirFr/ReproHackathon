cwlVersion: v1.0
class: CommandLineTool
baseCommand: 'tail'
arguments: 
  - '-n'
  - '+2'
inputs:
  infile:
    type: File
    inputBinding:
      position: 1
stdout: 'tailout.txt'
outputs: 
  outfile:
    type: stdout
