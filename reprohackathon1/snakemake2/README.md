
## Participants :

Mathieu VALADE
Laurent BOURI
Hugo PEREIRA

## Travail effectué

Ecriture du workflow présenté en Snakemake.

Le développement du workflow Snakemake a été réalisé en séparant les régèles de l'écriture de l'enchainement d'étapes.

Chaque règle peut être retrouvée dans un fichier .rules. Le workflow est présent dans le fichier ReproHackathon.wf.

Il nécessite pour être éxécuter un fichier de configuration.yml comme présent dans le dossier, et également des fichier tables.gtf et tables_names.txt pour l'éxécution de la règle PrepareAnnotation.rules.

La commande pour lancer le workflow :

    snakemake -s $PWD/ReproHackathon.wf --configfile $PWD/configuration.yml -j 1 -k --printshellcmds
    
## Option de la commande
- s : fichier snakefile pour éxécuter un workflow, ici comme le nom du fichier n'est pas Snakefile, il est nécessaire de l'indiquer et ainsi de lui donner le PATH absolu pour aucune erreur.
- configfile : fichier de configuration essentiel au bon déroulement du workflow, à indiquer avec son PATH absolu.
- j : nombre de job à lancer en meme temps. Ici 1 pour ne pas surchager la machine avec le multithreading de STAR.
- k : pour poursuivre l'éxécution du workflow meme si une erreur survient. Possibilité de lancer les jobs non impacter par les dépendances du job qui à échouer.
- printshellcmds : pour visualiser et vérifier le lancement des commandes shell à l'intérieur de chaque règle.
