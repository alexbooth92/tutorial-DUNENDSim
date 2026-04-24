#!/usr/bin/env bash


# Configure the output file handling. 
export ND_PRODUCTION_OUT_DIR=${PWD}/outputs
export ND_PRODUCTION_OUT_FILE_STUB="dunend_genie"


# Configure GENIE physics.
export ND_PRODUCTION_DET_LOCATION="DUNEND"
export ND_PRODUCTION_DK2NU_FILE="${PWD}/inputs/g4lbne_v3r5p10_QGSP_BERT_OfficialEngDesignSept2021_OnAxis_neutrino_00000.dk2nu.root"
export ND_PRODUCTION_EXPOSURE="1E15"
export ND_PRODUCTION_GEOM="${PWD}/inputs/nd_hall_with_lar_tms_sand_drift1_v2025.08.11.gdml"
export ND_PRODUCTION_RUN_NUMBER=1
export ND_PRODUCTION_TOP_VOLUME="volArgonCubeDetector75"
export ND_PRODUCTION_TUNE="AR23_20i_00_000"
export ND_PRODUCTION_XSEC_FILE="${PWD}/inputs/gxspl-NUsmall.xml"


# Specify location of beam xml. 
export GXMLPATH=$PWD/inputs  


# Build array of compulsory arguments for GENIE executable.
args_gevgen_fnal=( \
    -o "${ND_PRODUCTION_OUT_DIR}/${ND_PRODUCTION_OUT_FILE_STUB}" \
    -e "${ND_PRODUCTION_EXPOSURE}" \ 
    -f "${ND_PRODUCTION_DK2NU_FILE},${ND_PRODUCTION_DET_LOCATION}" \
    -g "${ND_PRODUCTION_GEOM}" \
    -r "${ND_PRODUCTION_RUN_NUMBER}" \
    --seed "${ND_PRODUCTION_RUN_NUMBER}" \
    --cross-sections "${ND_PRODUCTION_XSEC_FILE}" \
    --tune "${ND_PRODUCTION_TUNE}" \
    -L cm -D g_cm3 \
    )


# Add any arguments which are optional to the argument array.
[ -n "${ND_PRODUCTION_EVENT_GEN_LIST}" ] && args_gevgen_fnal+=( --event-generator-list "${ND_PRODUCTION_EVENT_GEN_LIST}" )
[ -n "${ND_PRODUCTION_TOP_VOLUME}" ] && args_gevgen_fnal+=( -t "${ND_PRODUCTION_TOP_VOLUME}" )


# Run GENIE executable.
gevgen_fnal "${args_gevgen_fnal[@]}"


# Convert output file from GENIE from GHEP to GTRAC format.
gntpc \
    -i ${ND_PRODUCTION_OUT_DIR}/${ND_PRODUCTION_OUT_FILE_STUB}.${ND_PRODUCTION_RUN_NUMBER}.ghep.root \
    -f rootracker \
    -o ${ND_PRODUCTION_OUT_DIR}/${ND_PRODUCTION_OUT_FILE_STUB}.${ND_PRODUCTION_RUN_NUMBER}.gtrac.root


# Tidy up unnecessary outputs.
rm ${PWD}/genie-mcjob-${ND_PRODUCTION_RUN_NUMBER}.status


echo ""
echo ""
echo ""
echo "ALL DONE!!!"
echo ""
echo ""
