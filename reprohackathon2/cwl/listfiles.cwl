class: ExpressionTool
cwlVersion: v1.0
inputs:
  dir: Directory
outputs:
  files: File[]
requirements:
  InlineJavascriptRequirement: {}
expression: |
  ${var files = inputs.dir.listing.filter(
     function(dirent){
       return dirent.class=='File';
     });
     return {'files':files};}

