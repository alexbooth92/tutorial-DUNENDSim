#!/usr/bin/env bash


# Config the output. These two lines must always be uncommented.
export ND_PRODUCTION_LOGDIR_BASE="/pscratch/sd/a/abooth/chosen-out-label/logs"
export ND_PRODUCTION_OUTDIR_BASE="/pscratch/sd/a/abooth/chosen-out-label/output"


# Regardless of the geometry that we generate in (GENIE) we want to edepsim
# in the nominal (not antifiducial) geometry. The following configuration should be
# used for GENIE output for NDLAr fiducial volume.
export ND_PRODUCTION_OUT_NAME="my_out_file.edep.root"
export ND_PRODUCTION_EDEP_MAC="${PWD}/inputs/dune-nd.mac"
export ND_PRODUCTION_GENIE_NAME="my_out_file.root.1.gtrac.root"
export ND_PRODUCTION_GEOM_EDEP="${PWD}/inputs/nd_hall_with_lar_tms_sand_drift1_v2025.08.11.gdml"
export ND_PRODUCTION_RUNTIME="SHIFTER"


## The following configuration should be used for the rock and NDLAr antifiducial volume (the only thing
## actually different to the one above is the run offset).
#export ND_PRODUCTION_OUT_NAME="chosen-out-label.edep.rockantindlarfid"
#export ND_PRODUCTION_CONTAINER="mjkramer/sim2x2:ndlar011"
#export ND_PRODUCTION_EDEP_MAC="macros/dune-nd.mac"
#export ND_PRODUCTION_GENIE_NAME="chosen-out-label.genie.rockantindlarfid"
#export ND_PRODUCTION_GEOM_EDEP="geometry/nd_hall_with_lar_tms_sand_TDR_Production_geometry_v_1.1.0.gdml"
#export ND_PRODUCTION_RUN_OFFSET="1000000000"
#export ND_PRODUCTION_RUNTIME="SHIFTER"


export ND_PRODUCTION_CONTAINER=${ND_PRODUCTION_CONTAINER:-mjkramer/sim2x2:ndlar011}
export ND_PRODUCTION_INDEX=$1


runNo=1
inputFile=${ND_PRODUCTION_GENIE_NAME}
rootCode='
auto t = (TTree*) _file0->Get("gRooTracker");
std::cout << t->GetEntries() << std::endl;'
nEvents=$(echo "$rootCode" | root -l -b "$inputFile" | tail -1)


edepCode="/generator/kinematics/rooTracker/input $inputFile
/edep/runId $runNo"

# The geometry file is given relative to the root of 2x2_sim

edep-sim -C -g "$ND_PRODUCTION_GEOM_EDEP" -o "$ND_PRODUCTION_OUT_NAME" -e "$nEvents" \
    <(echo "$edepCode") "$ND_PRODUCTION_EDEP_MAC"

#mkdir -p "$outDir/EDEPSIM/$subDir"
#mv "$edepRootFile" "$outDir/EDEPSIM/$subDir"
