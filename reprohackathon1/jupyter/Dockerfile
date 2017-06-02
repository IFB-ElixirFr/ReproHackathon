FROM jupyter/datascience-notebook
MAINTAINER Loic Pauleve <loic.pauleve@lri.fr>
ENV ASCPKEY $HOME/.aspera/connect/etc/asperaweb_id_dsa.openssh
ENV PATH /bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:$HOME/.aspera/connect/bin/:/opt/sratoolkit:/opt/STAR:/opt/samtools

USER root

##
# adapted from fredericlemoine/{star,sratoolkit,R,sam}
##

RUN apt-get update --fix-missing \
    && apt-get install -y \
        libbz2-dev \
        zlib1g-dev

# STAR
RUN wget -O - https://github.com/alexdobin/STAR/archive/2.5.1b.tar.gz \
    | tar xz -C /opt/ && \
      mkdir /opt/STAR && \
        cp /opt/STAR-2.5.1b/bin/Linux_x86_64_static/* /opt/STAR/ && \
          rm -rf /opt/STAR-2.5.1b/

# sra toolkit
RUN wget -O - http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.5.7/sratoolkit.2.5.7-ubuntu64.tar.gz \
    | tar xz -C /opt/ \
    && mkdir /opt/sratoolkit \
    && ln -s /opt/sratoolkit.2.5.7-ubuntu64/bin/* /opt/sratoolkit/

# R+DEXSeq
COPY dexseq.patch /tmp
RUN \
    conda config --add channels bioconda && \
    conda install --quiet --yes  \
        bioconductor-dexseq \
    && pip2 install \
        'htseq' \
    && chmod +x /usr/local/lib/R/library/DEXSeq/python_scripts/* && \
    mkdir -p /opt/dexseq && ln -s /usr/local/lib/R/library/DEXSeq/python_scripts/ /opt/dexseq \
    && patch -i /tmp/dexseq.patch /usr/local/lib/R/library/DEXSeq/python_scripts/dexseq_prepare_annotation.py

# samtools
RUN cd /tmp && \
  wget -O - http://github.com/samtools/samtools/releases/download/1.3.1/samtools-1.3.1.tar.bz2 \
  | tar xj \
  && cd samtools-1.3.1 \
  && ./configure \
  && make \
  && mkdir /opt/samtools/ \
  && mv samtools /opt/samtools/ \
  && cd .. \
  && rm -rf samtools-*

# jupyter related installs
RUN conda install --quiet --yes \
    'ipyparallel' \
    && conda clean -tipsy \
    && ipcluster nbextension enable

USER $NB_USER
RUN cd $HOME \
    && wget -O - http://download.asperasoft.com/download/sw/connect/3.6.2/aspera-connect-3.6.2.117442-linux-64.tar.gz \
    | tar xz && sh aspera-connect-3.6.2.117442-linux-64.sh \
    && rm aspera-connect-3.6.2.117442-linux-64.tar.gz

#RUN apt-get install -q -y  wget g++ gcc make bzip2 libncurses5-dev 

