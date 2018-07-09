cwlVersion: v1.0
class: CommandLineTool

requirements:
- $import: types.yml
#- class: DockerRequirement
#  dockerPull: flemoine/sratoolkit
- class: InlineJavascriptRequirement

baseCommand: fastq-dump

#arguments: ['--gzip', '--split-files']
arguments: ['--split-files']

inputs:
  sraFile:
    type: File
    inputBinding:
      position: 1

outputs:
  fastqFile-reads:
    type: types.yml#fastqPairedFiles
    outputBinding:
      #glob: [ '*_1.fastq.gz', '*_2.fastq.gz' ]
      glob: [ '*_1.fastq', '*_2.fastq' ]
      outputEval: |
        ${ return {
             "class": "types.yml#fastqPairedFiles",
             "read_1": self[0],
             "read_2": self[1]
               }; }
