# Galaxy - ASaiM
#
# VERSION 0.2

FROM bgruening/galaxy-stable:17.05

MAINTAINER Bérénice Batut, berenice.batut@gmail.com; Victoria, 

# Enable Conda dependency resolution
ENV GALAXY_CONFIG_BRAND="ReproHackathon"

# Install tools
COPY tools.yaml $GALAXY_ROOT/tools.yaml
RUN install-tools $GALAXY_ROOT/tools.yaml && \
    /tool_deps/_conda/bin/conda clean --tarballs --yes > /dev/null && \
    rm /export/galaxy-central/ -rf && \
    mkdir -p $GALAXY_ROOT/workflows

# Import data libraries workflows and start the data managers
COPY workflows/* $GALAXY_ROOT/workflows/
COPY data-library.yaml $GALAXY_ROOT/data-library.yaml
COPY data-managers.yaml $GALAXY_ROOT/data-managers.yaml
RUN startup_lite && \
    sleep 30 && \
    setup-data-libraries -i $GALAXY_ROOT/data-library.yaml -g $galaxy_instance -u $GALAXY_DEFAULT_ADMIN_USER -p $GALAXY_DEFAULT_ADMIN_PASSWORD && \
    workflow-install --workflow_path $GALAXY_ROOT/workflows/ -g http://localhost:8080 -u $GALAXY_DEFAULT_ADMIN_USER -p $GALAXY_DEFAULT_ADMIN_PASSWORD && \
    run-data-managers --config $GALAXY_ROOT/data_managers.yaml -g http://localhost:8080 -u $GALAXY_DEFAULT_ADMIN_USER -p $GALAXY_DEFAULT_ADMIN_PASSWORD


    

