class: CommandLineTool
cwlVersion: v1.0
requirements:
  InlineJavascriptRequirement: {}
hints:
  - class: DockerRequirement
    dockerPull: evolbioinfo/raxml:v8.2.0-avx2
baseCommand: raxmlHPC
#baseCommand: ''
# -T !{task.cpus} -p 1 -m GTRGAMMA --no-bfgs -s !{align} -n !{align}
arguments: 
  - '-T' 
  - '4' 
  - '-p'
  - '1' 
  - '-m' 
  - 'GTRGAMMA' 
  - '--no-bfgs' 
  - '-s' 
  - $(inputs.alig.path) 
  - '-n'
  - $(inputs.alig.nameroot) 
inputs:
  alig:
    type: File
outputs: 
  tree:
    type: File
    outputBinding:
      glob: ${return 'RAxML_bestTree.'+ inputs.alig.nameroot}
      #glob: ${return inputs.alig.nameroot+ '.nhx'}
