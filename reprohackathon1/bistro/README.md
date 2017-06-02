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
