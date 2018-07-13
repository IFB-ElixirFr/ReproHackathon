#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.in)

hints:
  - class: DockerRequirement
    dockerPull: debian:stretch-slim

class: CommandLineTool

inputs:
  - id: in
    type: File

outputs:
  - id: out
    type: File
    outputBinding:
      glob: $(inputs.in.basename)

arguments:
  - valueFrom: $(inputs.in.basename)
    position: 0

baseCommand: [cat]
