# ReproHackathon-3, 25-27 novembre 2019

## Analyse de phénotypage à partir d'images issues d'une plateforme de phéotypage haut-débit de plantes.

### Introduction

Dans cette troisième édition du reprohackathon, nous partirons de l'étude de Artzet et al. [1] dans laquelle les auteurs reconstruisent automatiquement la structure des plantes à partir d'images multi-vues.

Les différentes étapes de la chaine de traitement sont:

- binarisation des images (identification des pixels de plantes vs cabine)
- recontruction 3D mutli-vues (calcul du volume de la plante à partir des images segméntées)
- squeletisation (calcul du squelette de la plante)
- ségmentation en organe (identification et labellisation des différents organes de la plante)


### Objectif

Les algorithmes des différentes étapes sont disponibles à partir de la bibliothèque Python **Phenomenal** :

  - Documentation : https://phenomenal.readthedocs.io
  - Code source : https://github.com/openalea/phenomenal.


Des notebooks Jupiter, illustrant les différentes étapes, sont disponibles dans le repertoire examples.


## Références
* [1] [Artzet et al. (bioarxiv, 2019)](https://doi.org/10.1101/805739)

*Cette troisième édition des ReproHackathons est soutenue par le [GDR MaDICS](https://www.madics.fr), le [GDR BIM](http://www.gdr-bim.cnrs.fr) et par l'[Institut Français de Bioinformatique](http://www.france-bioinformatique.fr).*

![MaDICS](https://ifb-elixirfr.github.io/ReproHackathon/logo-madics.png) ![BIM](https://ifb-elixirfr.github.io/ReproHackathon/logo-gdrbim-web.jpg) ![IFB](https://ifb-elixirfr.github.io/ReproHackathon/logo-ifb.png)
