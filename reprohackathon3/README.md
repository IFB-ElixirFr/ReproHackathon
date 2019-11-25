# Ce dossier contient les résultats du [ReproHackathon3](../docs/hackathon_3_programme.md)

## Organisation proposée

* Un sous-répertoire par groupe
* Associé à une branche
* Incluant la description
  * des matériels et méthodes utilisés
  * de l'avancement au fur et à mesure
  * un bilan des réalisations en fin de hackathon


## Participants/Groupes :


## Liens utiles

* Article: [Artzet BioRxiv 2019](https://doi.org/10.1101/805739)
* Dépôt [git Phenomenal](https://github.com/openalea/phenomenal)
* Appliances disponibles dans Biosphère : [catalogue RAINBio](https://biosphere.france-bioinformatique.fr/catalogue)
  * [Ubuntu-16.04](https://biosphere.france-bioinformatique.fr/catalogue/appliance/88), [Ubuntu-Desktop](https://biosphere.france-bioinformatique.fr/catalogue/appliance/118) : Docker, Ansible, Bioconda, Desktop MATE

## Installation avec conda sur l'image Ubuntu 16.04

```
# Get the pkglist file
wget https://raw.githubusercontent.com/pradal/ReproHackathon/master/reprohackathon3/pkglist.txt
# Create a conda environment
conda create --name phenomenal --file pkglist.txt
```
