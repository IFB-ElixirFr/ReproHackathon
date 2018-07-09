# Ce dossier contient les résultats du [ReproHackathon2](../docs/hackathon_2_programme.md)

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

## Participants/Groupes :


## Liens utiles

* Article: [Zhou MBE 2018](https://academic.oup.com/mbe/article/35/2/486/4644721)
* Images Docker utiles: [evolbioinfo](https://hub.docker.com/r/evolbioinfo/)
* Données de l'article: [FigShare](https://figshare.com/projects/Evaluating_fast_maximum_likelihood-based_phylogenetic_programs_using_empirical_phylogenomic_data_sets/22040)

## Quelques commandes utiles
