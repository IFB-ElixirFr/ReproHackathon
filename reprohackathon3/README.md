# Ce dossier contient les résultats du [ReproHackathon3](../docs/hackathon_3_programme.md)

## Organisation proposée

* Un sous-répertoire par groupe
* Associé à une branche
* Incluant la description
  * des matériels et méthodes utilisés
  * de l'avancement au fur et à mesure
  * un bilan des réalisations en fin de hackathon

## Exemples de lignes de commandes:

* FastTree:
  - Container: `evolbioinfo/fasttree:v2.1.9`
  - Command:
```
	FastTree -nt -gtr -gamma -spr 4 -mlacc 2 -slownni <align.fa> > <output.nhx>
```

* RAxML:

    - Container: `evolbioinfo/raxml:v8.2.0-avx2`
    - Command:
```
raxmlHPC -T <cpus> -p 1 -m GTRGAMMA --no-bfgs -s <align.phy> -n NAME
	mv RAxML_bestTree.NAME raxmloutput.nhx
```

* IQTree:
    - Container: `evolbioinfo/iqtree:v1.4.2`
    - Command:
```
iqtree -m GTR+G4 -s <align.fa> -seed 1 -nt <cpus>
mv <align.fa>.treefile iqtreeoutput.nhx
```

* PhyML:
    - Container: `evolbioinfo/phyml:v3.3.20180129`
    - Command:
```
phyml -i <align.phy> --r_seed 1 -d nt -b 0 -m GTR -f e -c 4 -a e -s SPR --n_rand_starts 1 -o tlr -p --run_id ID
mv *_phyml_tree_ID.txt outputphyml.nhx
```


* Comparer 2 arbres: [gotree](https://github.com/fredericlemoine/gotree)
    - Container: `evolbioinfo/gotree:v0.2.10`
    - Command:
```
gotree compare trees --binary -i <arbre1> -c <arbre2>
```

* Reformater `fasta <=> phylip`: [goalign](https://github.com/fredericlemoine/goalign)
    - Container: `evolbioinfo/goalign:v0.2.9`
    - Commands:
```
# phylip => fasta
goalign reformat fasta -i <align.phy> -p -o align.fa
# fasta => phylip
goalign reformat phylip -i <align.fa> -o align.phy
```

## Participants/Groupes :


## Liens utiles

* Article: [Artzet BioRxiv 2019](https://doi.org/10.1101/805739)
* Appliances disponibles dans Biosphère : [catalogue RAINBio](https://biosphere.france-bioinformatique.fr/catalogue)
  * [Ubuntu-16.04](https://biosphere.france-bioinformatique.fr/catalogue/appliance/88), [Ubuntu-Desktop](https://biosphere.france-bioinformatique.fr/catalogue/appliance/118) : Docker, Ansible, Bioconda, Desktop MATE

## Quelques commandes utiles

* Installation avec conda:
```
# Get the pkglist file
wget
# Create a conda environment
conda create --name phenomenal --file pkglist.txt
```
