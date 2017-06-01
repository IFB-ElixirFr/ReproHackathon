# ReproHackaton1/Jupyter

Authors: Loïc Paulevé <loic.pauleve@lri.fr>

## Usage

### Build Docker image

```
docker build -t reprohackaton1_jupyter .
```

### Start Docker image

Binding a local directory as the working directory, allow sudo, no web password:
```
docker run -d -p 8888:8888 --volume $PWD/nb:/nb -w /nb  -e GRANT_SUDO=yes reprohackaton1_jupyter start-with-ipcluster.sh --NotebookApp.token=''
```

Then, connect to http://IP:8888

## Notes


### TODO

- [ ] Dockerfile
- [X] Workflow part 1
- [X] Workflow part 2
- [ ] Workflow part 3 (Counting)
- [ ] Workflow part 4 (DEXSeq)

### BUGS

