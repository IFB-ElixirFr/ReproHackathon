FROM jupyter/datascience-notebook
MAINTAINER Loic Pauleve <loic.pauleve@lri.fr>
ENV ASCPKEY $HOME/.aspera/connect/etc/asperaweb_id_dsa.openssh
ENV PATH /opt/conda/bin:/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:$HOME/.aspera/connect/bin/:/opt/sratoolkit:/opt/STAR:/opt/samtools

USER root

##
# adapted from fredericlemoine/{star,sratoolkit,R,sam}
##

RUN apt-get update --fix-missing \
    && apt-get install -y \
        libbz2-dev \
        zlib1g-dev

# STAR
RUN wget -O - https://github.com/alexdobin/STAR/archive/2.5.1b.tar.gz \
    | tar xz -C /opt/ && \
      mkdir /opt/STAR && \
        cp /opt/STAR-2.5.1b/bin/Linux_x86_64_static/* /opt/STAR/ && \
          rm -rf /opt/STAR-2.5.1b/

# sra toolkit
RUN wget -O - http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.8.2-1/sratoolkit.2.8.2-1-ubuntu64.tar.gz \
    | tar xz -C /opt/ \
    && mkdir /opt/sratoolkit \
    && mv /opt/sratoolkit.*/bin/* /opt/sratoolkit/

# R+DEXSeq
#    conda config --add channels bioconda && \
COPY dexseq.patch /tmp
RUN conda install --quiet --yes \
        r-xml \
    && Rscript -e 'source("http://bioconductor.org/biocLite.R");biocLite("DEXSeq")' \
    && patch -i /tmp/dexseq.patch /opt/conda/lib/R/library/DEXSeq/python_scripts/dexseq_prepare_annotation.py

RUN pip2 install htseq

# ascp
USER $NB_USER
RUN cd $HOME \
    && wget -O - http://download.asperasoft.com/download/sw/connect/3.6.2/aspera-connect-3.6.2.117442-linux-64.tar.gz \
    | tar xz && bash aspera-connect-3.6.2.117442-linux-64.sh

USER root

# samtools
RUN cd /tmp && \
  wget -O - http://github.com/samtools/samtools/releases/download/1.3.1/samtools-1.3.1.tar.bz2 \
  | tar xj \
  && cd samtools-1.3.1 \
  && ./configure  --without-curses \
  && make \
  && mkdir /opt/samtools/ \
  && mv samtools /opt/samtools/ \
  && cd .. \
  && rm -rf samtools-*

# jupyter related installs
RUN conda install --quiet --yes \
     ipyparallel \
    && conda clean -tipsy \
    && ipcluster nbextension enable


COPY data data/
COPY addGeneNameToUcscGFF.pl .
COPY Reprohackaton.ipynb .
COPY hackathon_1_workflow.svg .

RUN chown -R $NB_USER $HOME

USER $NB_USER

