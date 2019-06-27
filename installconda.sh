#!/bin/sh

set -e

CONDA_DIR=${HOME}/.miniconda

# Python
if [ ! -d ${CONDA_DIR} ]; then
  if [ ! -f ./Miniconda3-latest-Linux-x86_64.sh ]; then
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
  fi
  bash Miniconda3-latest-Linux-x86_64.sh -b -p ${CONDA_DIR}
fi

conda env update --quiet -f ./environment.yml -n base
