#!/usr/bin/env bash


# Specify the run number.
export ND_PRODUCTION_RUN_NUMBER=1


# Configure the input / output file handling. 
export ND_PRODUCTION_OUT_DIR=${PWD}/outputs
export ND_PRODUCTION_OUT_FILE="dunend_spill.${ND_PRODUCTION_RUN_NUMBER}.hdf5"
export ND_PRODUCTION_IN_FILE="dunend_spill.${ND_PRODUCTION_RUN_NUMBER}.root"


# Necessary due to ROOT versioning :shrug:.
export CPATH=$EDEPSIM/include/EDepSim:$CPATH


# Execute the conversion script.
./includes/convert_edepsim_roottoh5.py --input_file ${ND_PRODUCTION_OUT_DIR}/${ND_PRODUCTION_IN_FILE} --output_file ${ND_PRODUCTION_OUT_DIR}/${ND_PRODUCTION_OUT_FILE}


echo ""
echo ""
echo ""
echo "ALL DONE!!!"
echo ""
echo ""
echo ""
