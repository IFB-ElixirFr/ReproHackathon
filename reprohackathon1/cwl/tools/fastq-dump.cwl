cwlVersion: v1.0
class: CommandLineTool
requirements:
- class: DockerRequirement
  dockerPull: flemoine/sratoolkit
- class: InlineJavascriptRequirement
baseCommand: fastq-dump
arguments: ['--gzip', '--split-files']
inputs:
  sraFile:
    type: File
    inputBinding:
      position: 1
outputs: 
  fastqFile:
    type: File
    outputBinding:
      glob: '*.fa.gz'
