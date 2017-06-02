# ReproHackaton1/Jupyter

Author: Loïc Paulevé - http://loicpauleve.name

## Usage

### Build Docker image

```
docker build -t reprohackaton1_jupyter .
```

### Start Docker image

No web password:
```
docker run -d -p 8888:8888 reprohackaton1_jupyter start-notebook.sh --NotebookApp.token=''
```

Binding a local directory as the working directory, allow sudo, no web password:
```
docker run -d -p 8888:8888 --volume $PWD/nb:/nb -w /nb  -e GRANT_SUDO=yes reprohackaton1_jupyter start-notebook.sh --NotebookApp.token=''
```

Then, connect to http://IP:8888


## Notes

### TODO

- [ ] Test workflow après calcul des comptages
- [ ] Dockerfile clean (pas le -nonet)
- [ ] Explications des différentes parties
* [ ] Nettoyer script R final
* [ ] Pythoniser certaines parties, échange des counts python -> R en mémoire

### Problèmes rencontrés

Avec l'environnement:

* contraintes réseaux au sein du docker qui bloquent la construction "propre" du
  docker (obligé de pré-télécharger binaires, ...)
* pb espace disque, et calcul interminable pour l'alignement

Avec Jupyter:

* pas accès au stderr avec os.system (mais se corrige facilement avec une
  méthode plus propre, i.e., subprocess)
* parallélisation avec ipyparallel: l'environnement doit être envoyé
  manuellement aux différents nœuds + dépendances des module: pas très
  transparent ; il y a sûrement d'autres méthodes plus simples pour paralléliser (threads, joblib, ...).
* pas de lancement de cellule en parallèle: il faut utilier des notebook
  différents (par exemple pour annotation et genome).



