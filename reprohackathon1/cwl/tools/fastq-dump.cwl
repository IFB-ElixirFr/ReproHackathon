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
  fastqFile-read1:
    type: File
    outputBinding:
      glob: "*_1.fastq.gz"
  fastqFile-read2:
    type: File
    outputBinding:
      glob: "*_2.fastq.gz"
