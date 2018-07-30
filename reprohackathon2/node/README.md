# NodeJS 

Running bioinformatic pipeline using JS micro services (**MS**)
  * A scheduler **MS**
  * The pipeline runner **MS**

## Installation

### Deploy the scheduler

```
git clone ms-jobmanager
cd ms-jobmanager
npm install
tsc
cd build
node tests/engineBasic.js -e emulate -k 2323 -n 8 -c ~/tmp
```

We now have a scheduler **MS** running with following properties:

* POSIX threads will be used for computations (the *emulate* flag)
* A maximum of 8 jobs can run in parrallel
* A cache is located at `~/tmp`
* job are submitted through port 2323

### Creating the pipeline

You can deploy and run a preset pipeline that compares *iqtree*, *raxml* and *fasttree* using *raxml* as the golden-standard.
```
    git clone https://github.com/glaunay/reproPhylo
    cd reproPhylo
    npm install
    tsc
    cd build
    node index.js -i [ALN_FOLDER]
```

Where `[ALN_FOLDER]` is a folder containing `*.aln` files.
Sample folders are provided in the `data/` directory.

## Illustrating pipeline definition and execution

To illustrate the approach the present repo provides the preset index.ts file.
