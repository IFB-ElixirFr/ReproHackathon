cwlVersion: v1.0
class: CommandLineTool

requirements:
- $import: types.yml
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
  fastqFile-reads:
    type: types.yml#fastqPairedFiles
    label: paired end reads in FASTQ
