#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
print(args)
library("ggplot2")
library(reshape2)
comp=read.table(args[1])
colnames(comp)=c("gene","method","found")
cast=dcast(comp, method ~ found, function(x) length(x))
total=(cast$false+cast$true)
cast$false = cast$false/total
cast$true = cast$true/total
svg(args[2])
ggplot(cast, aes(method,true))+geom_bar(stat="identity")
dev.off()
