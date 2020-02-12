#!/bin/bash

# Activates MTUQ virtual environment on chinook
#
# Invoke this script by sourcing it, i.e.
# > source activate.bash


if [ "${BASH_SOURCE[0]}" == "${0}" ];
then
    echo ""
    echo "This script must be sourced"
    echo ""
    exit 1
fi


if [[ ! $HOSTNAME == chinook* ]];
then
    echo ""
    echo "This script works only on chinook*.alaska.edu"
    echo ""
    return 1
fi


if command -v conda > /dev/null; then
    echo ""
    echo "This installation script uses virtualenv, which is incompatible"\
         "with conda.  Remove conda executables from your system path and"\
         "try again."
    echo ""
    return 1
fi


# what is the relative path to mtuq_install_scripts/chinook/?
SETUP=$(dirname ${BASH_SOURCE[0]})


if [[ ! -d $SETUP/install/mtuq  ]];
then
    echo ""
    echo "Virtual environment not found. Run install.bash and try again."
    echo ""
    return 1
fi


# load system modules
module load toolchain/pic-intel/2016b
module load lang/Python/3.5.2-pic-intel-2016b


# activate virutal environment
source $SETUP/install/$VENV/mtuq/bin/activate


