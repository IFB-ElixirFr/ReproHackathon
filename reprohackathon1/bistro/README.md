* Développement

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


* Déroulement

** Jour 1

- implémentation du pipeline complet en collant au script nextflow
  fourni par Frédéric
- les premiers runs montrent que l'espace disque est limitant sur les
  VMs (qui sont munies de 48 Go)
  - 5 Go de système
  - 15 Go de données
  - 30 Go d'index STAR
- implémentation d'un mode "test" permettant de lancer le pipeline sur
  un seul chromosome et les n premières lectures des échantillons


** Jour 2

- le temps de calcul sur un seul chromosome est beaucoup plus long
  qu'attendu
- test sur une machine mon labo : c'est le fait de travailler avec une
  majorité de lectures ne s'alignant pas sur la référence qui rend les
  temps de calcul très longs
- wrapping d'une méthode alternative de découverte de variants:
  kissplice
