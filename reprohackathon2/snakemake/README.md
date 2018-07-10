Rules à commenter:
* phyml
* fasta2phylip
* raxml

Dataset utilisé: **XiD4**

```
sh install_singularity.sh
mkdir /data
mv Snakefile /data
mv get_data.sh /data
snakemake --cores 32 --use-singularity
```

```
cd /data/results/fasttree/
cat Cluster*.txt | cut -f 2 | sort | uniq -c
cd /data/results/iqtree/
cat Cluster*.txt | cut -f 2 | sort | uniq -c
```