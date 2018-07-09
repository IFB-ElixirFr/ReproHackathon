# Dockerfile
# version 1
# Software: pipeline reprohackathon
# Software version: R-3.4.0
# Software version: Wasabi 0.2
# needs: R: devtools
# Software version: Sleuth 0.29.0
# needs: R: devtools, curl, rhdf5
# Software version: Salmon 0.8.2
# Software version: Sankemake 


FROM ubuntu:latest
MAINTAINER Maude Ardin, Emilie Drouineau, Jeremy Le Coz, Thibault Dayris

# Install R-3.4.0
RUN apt-get update && \
    apt-get install gcc -y && \
    apt-get install gfortran -y && \
    apt-get install g++ -y && \
    apt-get install wget -y && \
    apt-get install bzip2 -y && \
    apt-get install zlib1g-dev -y && \
    apt-get install libbz2-dev -y && \
    apt-get install liblzma-dev -y && \
    apt-get install pcregrep -y && \
    apt-get install libpcre3 -y && \
    apt-get install libpcre3-dev -y && \
    apt-get install libcurl4-openssl-dev -y && \
    apt-get install build-essential -y && \
    wget https://cran.r-project.org/src/base/R-3/R-3.4.0.tar.gz && \
    tar xzvf R-3.4.0.tar.gz && \
    cd R-3.4.0 && \
    ./configure --with-readline=no  --with-x=no --enable-shared --enable-R-shlib && \
    make && \
    make install

# install rpy2 and wasabi and snakemake
RUN apt-get install libreadline-dev -y && \
    apt-get install python3-pip -y && \
    pip3 install --upgrade pip && \
    pip3 install rpy2 --upgrade && \
    apt-get install -y build-essential && \
    apt-get install -y libcurl4-gnutls-dev && \
    apt-get install -y libxml2-dev && \
    apt-get install -y libssl-dev && \
    pip3 install snakemake && \
    R -e "install.packages('devtools', dependencies=TRUE, repos='http://cran.us.r-project.org')" && \
    R -e "install.packages('curl', dependencies=TRUE, repos='http://cran.us.r-project.org')" && \
    R -e 'source("https://bioconductor.org/biocLite.R") ; biocLite("rhdf5")' && \
    R -e 'devtools::install_git("https://github.com/pachterlab/sleuth.git")' && \
    R -e 'devtools::install_git("https://github.com/COMBINE-lab/wasabi.git")' && \
    pip3 install snakemake

# SALMON
RUN apt-get update &&\
    wget https://github.com/COMBINE-lab/salmon/releases/download/v0.8.2/Salmon-0.8.2_linux_x86_64.tar.gz &&\
    tar xvzf Salmon-0.8.2_linux_x86_64.tar.gz && mv Salmon-0.8.2_linux_x86_64 Salmon &&\
    wget https://github.com/IFB-ElixirFr/ReproHackathon/archive/Snakemake1.zip && \
    apt-get install unzip -y && \
    mkdir /repro && \
    unzip Snakemake1.zip && \
    cp /ReproHackathon-Snakemake1/reprohackathon1/snakemake1/* /repro && \
    rm -fr /ReproHackathon-Snakemake1 && \
    pip3 install pyyaml && \
    apt-get install locales && \
    export LANG=C.UTF-8

ENV PATH="/Salmon/bin:${PATH}"
ENV LANG=C.UTF-8
WORKDIR /data
