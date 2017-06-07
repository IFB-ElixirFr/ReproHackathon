#!/usr/bin/Rscript

suppressMessages(library("sleuth"));
suppressMessages(library("getopt"));

args = matrix(c(
  'help', 'h', 0, 'logical',
  'Displays help message, then quits',

  'quant_files', 'q', 1, 'character',
  'Comma separated list of abundacies h5',

  'design', 'd', 1, 'character',
  'Comma separated list of conditions per sample',

  'transcript_table', 't', 2, 'character',
  'Path to the trancript to gene table',

  'output', 'o', 2, 'character',
  'Path to output file'),
  ncol = 5, byrow = TRUE);

opt <- getopt(args);
print(opt);

if (!is.null(opt$help)) {
  cat(getopt(args, usage=TRUE));
}

if (is.null(opt$output)) {
  opt$output <- getwd();
}

output_table = paste0(opt$output,
                      "_transcripts_table.tsv");
output_genes = paste0(opt$output,
                      "genes_table.tsv")

print("1 Arguments parsed");

samples_id <- sapply(opt$quant_files, function(id) basename(dirname(id)));
quant_files <- unlist(strsplit(opt$quant_files, ","));
design <- unlist(strsplit(opt$design, ","));

s2c <- data.frame(sample=samples_id, condition=design, path=quant_files);
s2c$path <- as.character(s2c$path);
print("2 Design parsed")

if (is.null(opt$transcript_table)) {
  so <- sleuth_prep(s2c, ~ condition);
} else {
  t2g <- read.table(as.character(opt$transcript_table));
  colnames(t2g) <- c("target_id", "ens_gene", "ext_gene");
  so <- sleuth_prep(s2c, ~ condition, target_mapping=t2g);
}
print("3 Data Prepared");

so <- sleuth_fit(so);
so <- sleuth_fit(so, ~1, 'reduced');

ref_cond <- paste0("condition", design[length(exp_design)]);
so <- sleuth_wt(so, which_beta = ref_cond);
print("4 Wald Test over");

results_table <- sleuth_results(so, ref_cond);
write.table(results_table, file = output_table,
            quote = FALSE, row.names = FALSE, sep = "\t");

if (!is.null(opt$transcript_table)) {
  results_genes <- sleuth::sleuth_gene_table(
    so, ref_cond, 'wt', 'full', 'ext_gene'
  );
  sorted <- results_genes[with(results_genes, order(pval)), ];
  write.table(sorted, file = output_genes,
              quote = FALSE, row.names = FALSE, sep = "\t");
}

saveRDS(so, file = paste0(opt$output, ".rds"));
print("5 Data saved");
# Exiting with null status
q(status = 0);
