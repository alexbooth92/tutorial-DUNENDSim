#!/usr/bin/env bash


# Specify the run number.
export ND_PRODUCTION_RUN_NUMBER=1


# Configure the input / output file handling. 
export ND_PRODUCTION_OUT_DIR=${PWD}/outputs
export ND_PRODUCTION_OUT_FILE="dunend_edep.${ND_PRODUCTION_RUN_NUMBER}.root"
export ND_PRODUCTION_IN_FILE="dunend_genie.${ND_PRODUCTION_RUN_NUMBER}.gtrac.root"


# Configure edep-sim physics.
export ND_PRODUCTION_EDEP_MAC="${PWD}/inputs/dune-nd.mac"
export ND_PRODUCTION_GEOM_EDEP="${PWD}/inputs/nd_hall_with_lar_tms_sand_drift1_v2025.08.11.gdml"


# Grab the number of neutrino interactions from the GTRAC file.
rootCode='
auto t = (TTree*) _file0->Get("gRooTracker");
std::cout << t->GetEntries() << std::endl;'
nEvents=$(echo "$rootCode" | root -l -b "${ND_PRODUCTION_OUT_DIR}/${ND_PRODUCTION_IN_FILE}" | tail -1)


# Add information about location of input GHEP file and number of neutrino
# interactions to the macro file.
edepCode="/generator/kinematics/rooTracker/input ${ND_PRODUCTION_OUT_DIR}/${ND_PRODUCTION_IN_FILE}
/edep/runId ${ND_PRODUCTION_RUN_NUMBER}"


# Run edep-sim executable.
edep-sim -C -g "$ND_PRODUCTION_GEOM_EDEP" -o "${ND_PRODUCTION_OUT_DIR}/${ND_PRODUCTION_OUT_FILE}" -e "$nEvents" \
    <(echo "$edepCode") "$ND_PRODUCTION_EDEP_MAC"


echo ""
echo ""
echo ""
echo "ALL DONE!!!"
echo ""
echo ""
