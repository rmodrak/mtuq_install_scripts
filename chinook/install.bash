#!/bin/bash -e

# Creates MTUQ virtual environment on chinook


if [[ ! $HOSTNAME == chinook* ]];
then
    echo ""
    echo "Error: This script works only on chinook*.alaska.edu"
    echo ""
    exit 1
fi


if command -v conda > /dev/null; then
    echo ""
    echo "This installation script uses virtualenv, which is incompatible"\
         "with conda.  Remove conda executables from your system path and"\
         "try again."
    echo ""
    exit 1
fi


# navigate to mtuq_install_scripts/chinook
cd $(dirname ${BASH_SOURCE[0]})
SRC="$PWD/mtuq"
ENV="$PWD/install/mtuq"


if [[ -d $ENV ]];
then
    echo ""
    echo "Error: Virtual environment already exists"
    echo ""
    exit 1
fi


# clone MTUQ
UPSTREAM="https://github.com/uafgeotools/mtuq.git"
if [[ -d $SRC ]];
then
    echo ""
    echo "Warning: Using existing MTUQ repository"
    echo ""
else
    git clone $UPSTREAM $SRC
fi


# load system modules
module load toolchain/pic-intel/2016b
module load lang/Python/3.5.2-pic-intel-2016b


# create virutal environment
mkdir -p $ENV
virtualenv "$ENV"
source "$ENV/bin/activate"
pip --no-cache-dir install mpi4py
pip --no-cache-dir install numpy
pip --no-cache-dir install obspy
export CC=ifort
pip --no-cache-dir install instaseis
export CC=icc


# install mtuq in editable mode
cd $SRC
pip --no-cache-dir install -e .


# adjust matplotlib backend
find $ENV -name matplotlibrc -exec sed -i '/backend *:/s/TkAgg/Agg/' {} +


# unpack examples
./data/examples/unpack.bash
./data/tests/unpack.bash


deactivate


