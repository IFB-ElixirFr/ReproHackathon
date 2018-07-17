cwlVersion: v1.0
class: CommandLineTool
baseCommand: 'echo'
arguments: ['-e']
inputs:
  words:
    type: string[]
    inputBinding:
      position: 1
      itemSeparator: '\n'
stdout: 'echoout.txt'
outputs: 
  outfile:
    type: stdout
