#!/usr/bin/env cwl-runner
class: Workflow
cwlVersion: v1.0

requirements:
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement
  - $import: types.yml

inputs:
  sraids:
    type: {type: array, items: string}
  chrs:
    type: {type: array, items: string}
outputs:
  fastqFile-reads:
    type: {type: array, items: types.yml#fastqPairedFiles}
    outputSource: get_reads/fastqFile-reads

steps:
  - id: get_reads
    run:
      class: Workflow
      inputs:
        sraid: string
      outputs:
        fastqFile-reads:
          type: types.yml#fastqPairedFiles
          outputSource: fastq-dump/fastqFile-reads
      steps:
        - id: get_sra
          run: get_sra.cwl
          in:
            sraid: sraid
          out: [sraFile]
        - id: fastq-dump
          run: fastq-dump.cwl
          in:
            sraFile: get_sra/sraFile
          out: [fastqFile-reads]
    scatter: get_reads/sraid
    in:
      sraid: sraids
    out:
      [fastqFile-reads]
  - id: get_chrs
    run: get_chr.cwl
    in:
      chr: chrs
    scatter: get_chrs/chr
    out:
      [fastaFile]
  - id: cat_chrs
    run: cat_chrs.cwl
    in:
      fastaGzFiles: get_chrs/fastaFile
    out:
      [fastaFile]
