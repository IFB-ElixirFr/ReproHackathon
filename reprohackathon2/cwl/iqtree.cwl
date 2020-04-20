class: CommandLineTool
cwlVersion: v1.0
requirements:
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing:
      - $(inputs.alig)
hints:
  - class: DockerRequirement
    dockerPull: evolbioinfo/iqtree:v1.4.2
#baseCommand: iqtree
baseCommand: ''
arguments: 
  - '-m' 
  - 'GTR+G4' 
  - '-s'
  - $(inputs.alig.basename) 
  - '-seed' 
  - '1' 
  - '-nt' 
  - '1'
inputs:
  alig:
    type: File
outputs: 
  tree:
    type: File
    outputBinding:
      glob: $(inputs.alig.basename).treefile


$namespaces:
  s: http://schema.org/

$schemas:
- http://schema.org/version/latest/schema.rdf

s:license: http://www.apache.org/licenses/LICENSE-2.0
