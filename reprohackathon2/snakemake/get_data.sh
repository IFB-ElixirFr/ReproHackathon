#!/bin/bash
if [ ! -d /data ]; then
    mkdir /data
fi
if [ ! -d /data/results ]; then
    mkdir -p /data/results/fasttree
    mkdir -p /data/results/raxml
    mkdir -p /data/results/iqtree
    mkdir -p /data/results/phyml
fi
if [ ! -d /data/single-gene_alignments ]; then
    wget -O /data/single-gene_alignments.tar.bz2 https://ndownloader.figshare.com/files/9473962
    cd /data
    tar xjf single-gene_alignments.tar.bz2
fi
if [ ! -d /data/single-gene_tree ]; then
    wget -O /data/single-gene_tree.tar.bz2 https://ndownloader.figshare.com/files/9473953
    cd /data
    tar xjf single-gene_tree.tar.bz2
fi
