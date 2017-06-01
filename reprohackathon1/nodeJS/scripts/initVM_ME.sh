#!/bin/bash

#######################
# FIRST INSTALLATIONS #
#######################

# install NodeJS and NPM
sudo yum install -y gcc-c++ make
curl -sL https://rpm.nodesource.com/setup_6.x | sudo -E bash -
sudo yum install nodejs

# install git
sudo yum -y install git

# install Netcat
sudo yum -y install nc

# install TypeScript
sudo npm install -g typescript

#########################################
# TO HAVE A MASTER EMULATED ENVIRONMENT #
#########################################

# install the git repo of taskObject
cd node_modules
git clone https://github.com/melaniegarnier/taskObject.git

# install dependencies of taskObject
cd taskObject
npm install
cd ../../



