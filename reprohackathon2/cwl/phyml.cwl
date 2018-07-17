class: CommandLineTool
cwlVersion: v1.0
requirements:
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing:
      - $(inputs.alig)
hints:
  - class: DockerRequirement
    dockerPull: evolbioinfo/phyml:v3.3.20180129
#baseCommand: 'phyml'
baseCommand: ''
arguments: ['-i', $(inputs.alig.path), '--r_seed', '1', '-d', 'nt', '-b', '0', '-m', 'GTR', '-f', 'e', '-c', '4', '-a', 'e', '-s', 'SPR', '--n_rand_starts', '1', '-o', 'tlr', '-p', '--run_id', 'ID']
inputs:
  alig:
    type: File
outputs: 
  tree:
    type: File
    outputBinding:
      glob: $(inputs.alig.basename)_phyml_tree_ID.txt
