#!/usr/bin/env nextflow


tsv_path = params.tsv
tsv_file = file(tsv_path)
rna_meta = Channel.create() 
rna_meta = extract_meta(tsv_file)

params.genome = ""
params.out = "~/data/results"
out_dir = params.out

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
    set sra_id, status, file(sra_file) from sra_files

  output:
    set sra_id, status, file("${sra_id}_1.fastq.gz"), file("${sra_id}_2.fastq.gz") into fastq_files

  // when: step == 'preprocessing'

  shell:
  """
  fastq-dump --gzip --split-files !{sra_file}
  """

}

process downloadRefTrans {
  
  output:
  file "transcripts.fa" into ref

  shell:
  '''
  wget ftp://ftp.ensembl.org/pub/release-75/fasta/homo_sapiens/cdna/Homo_sapiens.GRCh37.75.cdna.all.fa.gz
  gunzip -c Homo_sapiens.GRCh37.75.cdna.all.fa.gz > transcripts.fa 
  '''
}

process kallIndex {

    input:
	file transcript_fa from ref	
    output:
	file "transcripts.idx" into idx_trans
    shell:
'''        
    kallisto index -i transcripts.idx !{transcript_fa}
'''
}

process quant {
  input:
      set sra_id, status, file(fastq1), file(fastq2) from fastq_files	
      file(idx) from idx_trans
  output:
      file "output/*" into reads_quant
  shell:
'''
      mkdir output
      kallisto quant -i transcripts.idx -o "output" -b 100 !{sra_id}_1.fastq.gz !{sra_id}_2.fastq.gz
'''
}

//process sleuth {

//
//	input:
//
//	output:
//
//	shell:
//	'''
//	#!/usr/bin/env Rscript
//	suppressMessages({
//  		library("sleuth")
//	})

//	tx2gene <- function(){
//	mart <- biomaRt::useMart(biomart = "ensembl", dataset = "hsapiens_gene_ensembl")
//	t2g <- biomaRt::getBM(attributes = c("ensembl_transcript_id", "ensembl_gene_id",
//            	"external_gene_name"), mart = mart)
//	t2g <- dplyr::rename(t2g, target_id = ensembl_transcript_id,
//                 	ens_gene = ensembl_gene_id, ext_gene = external_gene_name)
//	return(t2g)
//	}

//	t2g <- tx2gene()	
//	'''
//}

  
def extract_meta(tsv_file) {
  // Reading samples metadata
  // Format is: "SRA_ID Status"
  return sample_info = Channel
    .from(tsv_file.readLines())
    .map{line ->
      list = line.split()
      sra_id = list[0]
      status = list[1]

      [ sra_id, status ]
    }
}
