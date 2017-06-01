#!/usr/bin/env cwl-runner
class: Workflow
cwlVersion: v1.0

requirements:
  - class: ScatterFeatureRequirement

inputs:
  - id: sraids
    type: {type: array, items: string}

outputs:
  - id: sraFiles
    type: {type: array, items: File}
    outputSource: get_sra/sraFile

steps:
  - id: get_sra
    run: get_sra.cwl
    scatter: "#get_sra/sraid"
    in:
      sraid:
        source: "#sraids"
    out: [sraFile]
