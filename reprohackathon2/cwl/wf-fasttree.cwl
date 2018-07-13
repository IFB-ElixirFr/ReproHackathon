class: Workflow
cwlVersion: v1.0
requirements:
  ScatterFeatureRequirement: {}
  SubworkflowFeatureRequirement: {}
  MultipleInputFeatureRequirement: {}
  StepInputExpressionRequirement: {}
inputs:
  aligdir:
    type: Directory
  besttreedir:
    type: Directory
  treeext: 
    type: string
outputs:
  plotfile:
    type: File
    outputSource: [plot/plotfile]
  table:
    type: File
    outputSource: [echo/outfile]
steps:
  listaligfiles:
    run: listfiles.cwl
    in:
      dir: aligdir
    out: [files]
  listbesttrees:
    run: getbesttree.cwl
    scatter: [aligfile]
    in:
      aligfile: listaligfiles/files
      treedir: besttreedir
      treeext: treeext
    out: [treefile]
  fasttree-compare:
    scatter: [aligfile, besttreefile]
    scatterMethod: dotproduct
    in:
      aligfile: listaligfiles/files
      besttreefile: listbesttrees/treefile
    out: [line]
    run: 
      class: Workflow
      cwlVersion: v1.0
      requirements:
        StepInputExpressionRequirement: {}
      inputs:
        aligfile:
          type: File
        besttreefile:
          type: File
      outputs:
        line:
          type: string
          outputSource: comparetrees/line
      steps:
        fasttree:
          run: fasttree.cwl
          in:
            alig: aligfile
          out: [tree]
        comparetrees:
          run: comparetrees.cwl
          in:
            tree: fasttree/tree
            besttree: besttreefile
            method: 
              valueFrom: "fasttree"
          out: [line]
  raxml-compare:
    scatter: [aligfile, besttreefile]
    scatterMethod: dotproduct
    in:
      aligfile: listaligfiles/files
      besttreefile: listbesttrees/treefile
    out: [line]
    run: 
      class: Workflow
      cwlVersion: v1.0
      requirements:
        StepInputExpressionRequirement: {}
        InlineJavascriptRequirement: {}
      inputs:
        aligfile:
          type: File
        besttreefile:
          type: File
      outputs:
        line:
          type: string
          outputSource: comparetrees/line
      steps:
        raxml:
          run: raxml.cwl
          in:
            alig: aligfile
          out: [tree]
        cp:
          run: cp.cwl
          in:
            infile: raxml/tree
            outfilename:
              valueFrom: ${return inputs.infile.nameext.slice(1) + '.nhx';}
          out: [outfile]
        comparetrees:
          run: comparetrees.cwl
          in:
            tree: cp/outfile
            besttree: besttreefile
            method: 
              valueFrom: "raxml"
          out: [line]
  iqtree-compare:
    scatter: [aligfile, besttreefile]
    scatterMethod: dotproduct
    in:
      aligfile: listaligfiles/files
      besttreefile: listbesttrees/treefile
    out: [line]
    run: 
      class: Workflow
      cwlVersion: v1.0
      requirements:
        StepInputExpressionRequirement: {}
        InlineJavascriptRequirement: {}
      inputs:
        aligfile:
          type: File
        besttreefile:
          type: File
      outputs:
        line:
          type: string
          outputSource: comparetrees/line
      steps:
        iqtree:
          run: iqtree.cwl
          in:
            alig: aligfile
          out: [tree]
        comparetrees:
          run: comparetrees.cwl
          in:
            tree: iqtree/tree
            besttree: besttreefile
            method: 
              valueFrom: "iqtree"
          out: [line]
  phyml-compare:
    scatter: [aligfile, besttreefile]
    scatterMethod: dotproduct
    in:
      aligfile: listaligfiles/files
      besttreefile: listbesttrees/treefile
    out: [line]
    run: 
      class: Workflow
      cwlVersion: v1.0
      requirements:
        StepInputExpressionRequirement: {}
        InlineJavascriptRequirement: {}
      inputs:
        aligfile:
          type: File
        besttreefile:
          type: File
      outputs:
        line:
          type: string
          outputSource: comparetrees/line
      steps:
        goalign-reformat:
          run: goalign-reformat.cwl
          in:
            infile: aligfile
          out: [outfile]
        phyml:
          run: phyml.cwl
          in:
            alig: goalign-reformat/outfile
          out: [tree]
        cp:
          run: cp.cwl
          in:
            infile: phyml/tree
            outfilename:
              valueFrom: ${return inputs.infile.basename.split('.')[0] + '.nhx';}
          out: [outfile]
        comparetrees:
          run: comparetrees.cwl
          in:
            tree: cp/outfile
            besttree: besttreefile
            method: 
              valueFrom: "phyml"
          out: [line]
  echo:
    run: echo.cwl
    in:
      words: 
        source: [fasttree-compare/line, raxml-compare/line, iqtree-compare/line, phyml-compare/line]
        linkMerge: merge_flattened
    out: [outfile]
  plot:
    run: plot.cwl
    in:
      infile: 
        source: echo/outfile
      outfilename:
        valueFrom: "plot.svg"
    out: [plotfile]
