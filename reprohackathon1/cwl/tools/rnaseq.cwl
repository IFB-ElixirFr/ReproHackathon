#!/usr/bin/env cwl-runner
class: Workflow
cwlVersion: v1.0

requirements:
  - class: ScatterFeatureRequirement

inputs:
  - id: sraids
    type: {type: array, items: string}

outputs:
  - id: fastqFiles
    type: {type: array, items: File}
    outputSource: fastq-dump/fastqFile

steps:
  - id: get_sra
    run: get_sra.cwl
    scatter: get_sra/sraid
    in:
      sraid: sraids
    out: [sraFile]
  - id: fastq-dump
    run: fastq-dump.cwl
    in:
      sraFile: get_sra/sraFile
    out: [fastqFile]
