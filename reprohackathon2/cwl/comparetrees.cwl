cwlVersion: v1.0
class: CommandLineTool
requirements:
  - class: InlineJavascriptRequirement
hints:
  - class: DockerRequirement
    dockerPull: evolbioinfo/gotree:v0.2.10
#echo !{id} !{method} $(gotree compare trees --binary -i !{tree} -c !{besttree} | tail -n +2 | cut -f 2) > comp
#baseCommand: gotree
baseCommand: ''
arguments: ['compare', 'trees', '--binary']
inputs:
  tree:
    type: File
    inputBinding:
      prefix: -i
      position: 1
  besttree:
    type: File
    inputBinding:
      prefix: -c
      position: 2
stdout: $(inputs.tree.nameroot + '.csv')
outputs: 
  report:
    type: stdout
