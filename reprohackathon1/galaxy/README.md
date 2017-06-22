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

# Analysis

1. Prepare reference genomes
    1. Merge the chromosome sequences together
    2. Prepare the GTF with annotation to be used with DEXSeq
2. Download the input data using the SRA ids
2. Extract count tables for each sample (workflow)
    1. Transform SRA to FastQ 
    2. De-interlace the generated FastQ into 2 FastQ files with paired-end
    3. Control the sequence quality of both paired-end files with FastQC
    4. Trim the paired-end files with Trim Galore!
    5. Map on the reference genome with STAR
    6. Infer the library type
        1. Extract 200,000 reads
        2. Map on the reference genome with STAR
        3. Infer the library type with `infer_experiment` with RSeQC
    7. Count the with DEXSeq
3. Run the differential transcript analysis

# Automatic launch of the analysis

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
    1. Prepare the reference genomes

        ```
        $ snakemake --snakefile src/run_analysis.py prepare_ref_genome
        ```

    3. Download the input data using the SRA ids

        ```
        $ snakemake --snakefile src/run_analysis.py download_input_data
        ```

    2. Extract count tables for each sample (not tested)

        ```
        $ snakemake --snakefile src/run_analysis.py extract_sample_count_tables
        ```

    3. Run the differential transcript analysis (not developed)

        ```
        $ snakemake --snakefile src/run_analysis.py run_differential_analysis
        ```
