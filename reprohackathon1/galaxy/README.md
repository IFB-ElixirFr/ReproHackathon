Galaxy infrastructure for the ReproHackathon1
=============================================

# Local usage 

- Create the Docker image

    ```
    $ docker build -t reprohackathon .
    ```

- Launch a Docker container

    ```
    $ docker run -d -p 8080:80 reprohackathon
    ```

> Because we've used an Ubuntu 14:04 . We have to modify /etc/default/docker file 
> `DOCKER_OPTS="--dns 8.8.8.8 --dns 8.8.4.4 --storage-driver=devicemapper"`

# Automatic running

## Requirements

- conda
- Creation of the `conda` environment with all the requirements

    ```
    $ conda env create -f environment.yml
    ```

- Add the URL and the API key to the launched Docker container in [`config.yaml`](config.yaml)

## Usage

- Launch the `conda` environment

    ```
    $ source activate neuromac
    ```

- Reproduce the analysis

    ```
    $ snakemake --snakefile src/run_analysis.py
    ```