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
    outputBinding:
      outputEval: |
        ${ return {
             "class": "types.yml#fastqPairedFiles",
             "read_1": {
               "class": "File",
               "path": runtime.outdir + "/" + inputs.sraFile.nameroot + "_1.fastq.gz",
               },
             "read_2": {
               "class": "File",
               "path": runtime.outdir + "/" + inputs.sraFile.nameroot + "_2.fastq.gz",
               } }; }
  fastqFile-reads2:
    type: types.yml#fastqPairedFiles
    # another option
    outputBinding:
      glob: [ '*_1.fastq.gz', '*_2.fastq.gz' ]
      outputEval: |
        ${ return {
             "class": "types.yml#fastqPairedFiles",
             "read_1": self[0],
             "read_2": self[1]
               }; }
