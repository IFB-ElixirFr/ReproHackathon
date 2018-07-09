This directory contains the Common Workflow Language implementation of the RNA-seq workflow

# Workflow overview:
![RNA-Seq workflow overview](https://view.commonwl.org/workflows/593ff305857aba000193844b/graph/png)

# Installation of toil (with cwl support) and docker:

	virtualenv venv
    . venv/bin/activate
    pip install toil[aws,mesos,azure,google,encryption,cwl]
	sudo apt install docker

# Running it

    cwl-runner --jobStore file:./results/jobStore --workDir results --restart tools/rnaseq.cwl rnaseq-in.yml
    # --jobStore file:<path> option to specify where the "job store" directory is located
    # --workDir <directory> where to store temp data
    # --restart attempt to restart a workflow at the --jobStore location
