#!/usr/bin/env nextflow


tsv_path = params.tsv
tsv_file = file(tsv_path)
rna_meta = Channel.create() 
rna_meta = extract_meta(tsv_file)

params.genome = ""
params.out = "~/data/results"
out_dir = params.out
chrs_list = Channel.from("chr20")

/*
 * 1. PRE-PROCESSING
 */

 /*
 * Download Data 
 */


rna_meta = rna_meta.view {"$it"} // Verbose

process downloadSRA {

  input:
    set sra_id, status from rna_meta

  output:
    set sra_id, status, file("${sra_id}.sra") into sra_files

  // when: step == 'preprocessing'

  script:
  """
  wget http://appliances.france-bioinformatique.fr/reprohackathon/${sra_id}.sra
  """

}

process fastqDump {

  input:
    set sra_id, status, sra_file from sra_files

  output:
    set sra_id, status, file("${sra_id}_1.gz"), file("${sra_id}_2.gz") into fastq_files

  // when: step == 'preprocessing'

  script:
  """
  fastq-dump --gzip --split-files ./$sra_file
  """

}


process downloadRefGenome {

  storeDir '/db/genome'
  input:
  val chr from chrs_list

  output:
  file "${chr}.fa" into ref_genome

  script:
  '''
  wget http://hgdownload.soe.ucsc.edu/goldenPath/hg19/chromosomes/!{chr}.fa.gz | gunzip -c
  '''
}


def extract_meta(tsv_file) {
  // Reading samples metadata
  // Format is: "SRA_ID Status"
  return sample_info = Channel
    .from(tsv_file.readLines())
    .map{line ->
      list = line.split()
      sra_id = list[0]
      status    = list[1]

      [ sra_id, status ]
    }
}