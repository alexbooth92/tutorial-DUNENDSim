#!/usr/bin/env bash


# Specify the run number.
export ND_PRODUCTION_RUN_NUMBER=__CHANGE_ME__


# Configure the input / output file handling. 
export ND_PRODUCTION_OUT_DIR=__CHANGE_ME__
export ND_PRODUCTION_OUT_FILE=__CHANGE_ME__
export ND_PRODUCTION_IN_FILE=__CHANGE_ME__


# Necessary due to ROOT versioning :shrug:.
export CPATH=$EDEPSIM/include/EDepSim:$CPATH


# Execute the conversion script. Only requires an input file path and an output file path.
./includes/convert_edepsim_roottoh5.py __CHANGE_ME__


echo ""
echo ""
echo ""
echo "ALL DONE!!!"
echo ""
echo ""
echo ""
