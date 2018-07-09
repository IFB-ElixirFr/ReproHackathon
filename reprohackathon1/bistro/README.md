# Développement

Le pipeline proposé a été implémenté en utilisant la bibliothèque
[bistro](https://github.com/pveber/bistro) écrite pour le langage
[OCaml](http://ocaml.org/). Cette bibliothèque offre une
représentation de haut-niveau pour les chaînes de traitement
typiquement implémentées par un ensemble de scripts shell
interdépendants. Une fois les différents outils déclarés, on peut les
composer avec de simples appels de fonctions et obtenir sans autre
effort un certain nombre de services :
- distribution des calculs sur une machine
- reprise sur erreur
- vérification statique des formats de fichiers
- pas de noms de fichiers à trouver aux cibles intermédiaires

Un certain nombre d'outils nécessaires étaient déjà disponibles et
d'autres ont été réalisé pendant le hackathon. Pour lancer le
pipeline, on invoque :
```
utop pipeline.ml
```


# Déroulement

## Jour 1

- implémentation du pipeline complet en collant au script nextflow
  fourni par Frédéric
- les premiers runs montrent que l'espace disque est limitant sur les
  VMs (qui sont munies de 48 Go)
  - 5 Go de système
  - 15 Go de données
  - 30 Go d'index STAR
- implémentation d'un mode "test" permettant de lancer le pipeline sur
  un seul chromosome et les n premières lectures des échantillons


## Jour 2

- le temps de calcul sur un seul chromosome est beaucoup plus long
  qu'attendu
- test sur une machine mon labo : c'est le fait de travailler avec une
  majorité de lectures ne s'alignant pas sur la référence qui rend les
  temps de calcul très longs
- wrapping d'une méthode alternative de découverte de variants:
  kissplice

## Epilogue

- correction des wrappers qui n'avaient pu être testé pendant le hackathon
- les dernières lignes du script R d'analyse DEXSeq produisent une
  erreur (`Error in plot.new() : figure margins too large`) que je
  n'ai pas réussi à corriger
- les exons différentiellement exprimés sont au nombre de 56 pour une
  FDR à 1%, correspondant à 37 gènes.
```
                 groupID featureID     stat       pvalue         padj
100 chr20_ENSG00000101019-      E001 64.48148 9.744412e-16 2.211888e-10
101 chr20_ENSG00000101019-      E002 64.17605 1.137835e-15 2.211888e-10
102 chr20_ENSG00000101019-      E003 61.86729 3.674026e-15 4.761403e-10
109 chr20_ENSG00000101019-      E011 60.96600 5.806907e-15 5.644154e-10
108 chr20_ENSG00000101019-      E010 57.54909 3.296478e-14 2.563268e-09
105 chr20_ENSG00000101019-      E006 56.82296 4.768667e-14 3.090009e-09
106 chr20_ENSG00000101019-      E007 55.99572 7.262882e-14 4.033898e-09
103 chr20_ENSG00000101019-      E004 51.61269 6.760325e-13 3.285425e-08
112 chr20_ENSG00000101019-      E017 45.24239 1.740959e-11 7.520730e-07
126  chr2_ENSG00000119777+      E024 44.38695 2.694779e-11 1.047700e-06
110 chr20_ENSG00000101019-      E012 40.74513 1.734348e-10 6.129958e-06
127  chr2_ENSG00000119777+      E025 39.20540 3.814831e-10 1.235970e-05
80  chr19_ENSG00000142347-      E034 39.03283 4.167385e-10 1.246334e-05
104 chr20_ENSG00000101019-      E005 38.46694 5.568897e-10 1.546518e-05
111 chr20_ENSG00000101019-      E016 37.33277 9.959712e-10 2.581484e-05
47  chr16_ENSG00000159618+      E022 36.78996 1.315659e-09 3.196961e-05
```
