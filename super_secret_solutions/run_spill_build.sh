#!/usr/bin/env bash


# Specify the run number.
export ND_PRODUCTION_RUN_NUMBER=1


# Configure the input / output file handling. 
export ND_PRODUCTION_OUT_DIR=${PWD}/outputs
export ND_PRODUCTION_OUT_FILE="dunend_spill.${ND_PRODUCTION_RUN_NUMBER}.root"
export ND_PRODUCTION_IN_FILE_SAMPLE_A="dunend_edep.${ND_PRODUCTION_RUN_NUMBER}.root"
export ND_PRODUCTION_IN_FILE_SAMPLE_B="NONE"


# Configure spill builder physics.
export ND_PRODUCTION_SPILL_PERIOD="1.2"
export ND_PRODUCTION_SPILL_POT="7.5E13"
export ND_PRODUCTION_SAMPLE_A_POT="1E15"
export ND_PRODUCTION_SAMPLE_B_POT="0"
export ND_PRODUCTION_REUSE_SAMPLE_B="0"


# Excute the spill building macro.
root -l -b -q \
    -e "gSystem->AddDynamicPath(\"$LIBTG4EVENT_DIR\"); \
        gSystem->Load(\"libTG4Event.so\")" \
       "includes/overlaySinglesIntoSpillsSorted.C(\"${ND_PRODUCTION_OUT_DIR}/${ND_PRODUCTION_IN_FILE_SAMPLE_A}\", \"${ND_PRODUCTION_OUT_DIR}/${ND_PRODUCTION_IN_FILE_SAMPLE_B}\", \"${ND_PRODUCTION_OUT_DIR}/${ND_PRODUCTION_OUT_FILE}\", ${ND_PRODUCTION_RUN_NUMBER}, ${ND_PRODUCTION_SAMPLE_A_POT}, ${ND_PRODUCTION_SAMPLE_B_POT}, ${ND_PRODUCTION_SPILL_POT}, ${ND_PRODUCTION_SPILL_PERIOD}, ${ND_PRODUCTION_REUSE_SAMPLE_B})"


echo ""
echo ""
echo ""
echo "ALL DONE!!!"
echo ""
echo ""
echo ""
