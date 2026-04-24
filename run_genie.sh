#!/usr/bin/env bash


# Config the output. These two lines must always be uncommented.
export ND_PRODUCTION_LOGDIR_BASE=${PWD}
export ND_PRODUCTION_OUTDIR_BASE=${PWD}


# The following configuration will do vertices inside NDLAr fiducial volume.
export ND_PRODUCTION_OUT_NAME="chosen-out-label.genie.ndlarfid"
export ND_PRODUCTION_CONTAINER="mjkramer/sim2x2:genie_edep.3_04_00.20230912"
export ND_PRODUCTION_DET_LOCATION="DUNEND"
export ND_PRODUCTION_DK2NU_FILE="${PWD}/inputs/g4lbne_v3r5p10_QGSP_BERT_OfficialEngDesignSept2021_OnAxis_neutrino_00000.dk2nu.root"
export ND_PRODUCTION_EXPOSURE="1E15"
export ND_PRODUCTION_GEOM="${PWD}/inputs/nd_hall_with_lar_tms_sand_drift1_v2025.08.11.gdml"
export ND_PRODUCTION_MAX_PATH_FILE="${PWD}/inputs/nd_hall_with_lar_tms_sand_drift1_v2025.08.11.volArgonCubeDetector75.AR23_20i_00_000.maxpath.xml"
export ND_PRODUCTION_RUNTIME="SHIFTER"
export ND_PRODUCTION_TOP_VOLUME="volArgonCubeDetector75"
export ND_PRODUCTION_TUNE="AR23_20i_00_000"
export ND_PRODUCTION_XSEC_FILE="${PWD}/inputs/gxspl-NUsmall.xml"
export ND_PRODUCTION_ZMIN="-3"


## The following configuration will do vertices inside rock and NDLAr antifiducial volume. Rock box definition here
## is a slightly expaded volDetEnclosure.
#export ND_PRODUCTION_OUT_NAME="chosen-out-label.genie.rockantindlarfid"
#export ND_PRODUCTION_CONTAINER="mjkramer/sim2x2:genie_edep.3_04_00.20230912"
#export ND_PRODUCTION_DET_LOCATION="DUNENDROCK"
#export ND_PRODUCTION_DK2NU_DIR="/dvs_ro/cfs/cdirs/dune/users/abooth/fluxfiles/DUNE_PRISM/OnAxis/neutrino/dk2nu"
#export ND_PRODUCTION_EXPOSURE="1E14"
#export ND_PRODUCTION_FID_CUT_STRING="\"rockbox:(-4946.4,-711.472,-80.54)(671.1,1831.527,3004.9),0,500,0.00425,1.05,1\""
#export ND_PRODUCTION_GEOM="geometry/anti_fiducial_nd_hall_with_lar_tms_sand_TDR_Production_geometry_v_1.1.0.gdml"
#export ND_PRODUCTION_MAX_PATH_FILE="maxpath/anti_fiducial_nd_hall_with_lar_tms_sand_TDR_Production_geometry_v_1.1.0.AR23_20i_00_000.maxpath.xml"
#export ND_PRODUCTION_RUN_OFFSET="1000000000"
#export ND_PRODUCTION_RUNTIME="SHIFTER"
#export ND_PRODUCTION_TOP_VOLUME="volWorld"
#export ND_PRODUCTION_TUNE="AR23_20i_00_000"
#export ND_PRODUCTION_XSEC_FILE="/dvs_ro/cfs/cdirs/dune/users/2x2EventGeneration/inputs/NuMI/genie_xsec-3.04.00-noarch-AR2320i00000-k250-e1000/v3_04_00/NULL/AR2320i00000-k250-e1000/data/gxspl-NUsmall.xml"
#export ND_PRODUCTION_ZMIN="-280"


#export ND_PRODUCTION_CONTAINER=${ND_PRODUCTION_CONTAINER:-mjkramer/sim2x2:genie_edep.3_04_00.20230912}
#export ND_PRODUCTION_INDEX=$1
#
#source ../util/reload_in_container.inc.sh
#source ../util/init.inc.sh

dk2nuFile=$ND_PRODUCTION_DK2NU_FILE
echo "dk2nuIdx is $dk2nuIdx"
echo "dk2nuFile is $dk2nuFile"

export GXMLPATH=$PWD/inputs            # contains GNuMIFlux.xml
maxPathFile=$ND_PRODUCTION_MAX_PATH_FILE
USE_MAXPATH=1

genieOutPrefix=$tmpOutDir/$outName

# HACK: gevgen_fnal hardcodes the name of the status file (unlike gevgen, which
# respects -o), so run it in a temporary directory. Need to get absolute paths.

dk2nuFile=$(realpath "$dk2nuFile")
# The geometry file is given relative to the root of 2x2_sim
# ($baseDir is already an absoulte path)
geomFile=$ND_PRODUCTION_GEOM
#ND_PRODUCTION_XSEC_FILE=$(realpath "$ND_PRODUCTION_XSEC_FILE")


runNo=1
seed=1
args_gevgen_fnal=( \
    #-e "$ND_PRODUCTION_EXPOSURE" \
    -n 10 \
    -f "$dk2nuFile,$ND_PRODUCTION_DET_LOCATION" \
    -g "$geomFile" \
    -r "$runNo" \
    -L cm -D g_cm3 \
    --cross-sections "$ND_PRODUCTION_XSEC_FILE" \
    --tune "$ND_PRODUCTION_TUNE" \
    --seed "$seed" \
    -o "${PWD}/my_out_file.root" \
    )

echo $args_gevgen_fnal
#[ "${USE_MAXPATH}" == 1 ] && args_gevgen_fnal+=( -m "$maxPathFile" )
[ -n "${ND_PRODUCTION_TOP_VOLUME}" ] && args_gevgen_fnal+=( -t "$ND_PRODUCTION_TOP_VOLUME" )
[ -n "${ND_PRODUCTION_FID_CUT_STRING}" ] && args_gevgen_fnal+=( -F "$ND_PRODUCTION_FID_CUT_STRING" )
[ -n "${ND_PRODUCTION_ZMIN}" ] && args_gevgen_fnal+=( -z "$ND_PRODUCTION_ZMIN" )
[ -n "${ND_PRODUCTION_EVENT_GEN_LIST}" ] && args_gevgen_fnal+=( --event-generator-list "$ND_PRODUCTION_EVENT_GEN_LIST" )

gevgen_fnal "${args_gevgen_fnal[@]}"

#statDir=$logBase/STATUS/$subDir
#mkdir -p "$statDir"
#mv genie-mcjob-"$runNo".status "$statDir/$outName.status"
#popd
#rmdir "$tmpDir"
#
## use consistent naming convention w/ rest of sim chain
#mv "$genieOutPrefix"."$runNo".ghep.root "$genieOutPrefix".GHEP.root
#
gntpc -i my_out_file.root.1.ghep.root -f rootracker -o ${PWD}/my_out_file.root.1.gtrac.root
#run gntpc -i "$genieOutPrefix".GHEP.root -f rootracker \
#    -o "$genieOutPrefix".GTRAC.root
#
#mkdir -p "$outDir/GHEP/$subDir"  "$outDir/GTRAC/$subDir"
#mv "$genieOutPrefix.GHEP.root" "$outDir/GHEP/$subDir"
#mv "$genieOutPrefix.GTRAC.root" "$outDir/GTRAC/$subDir"
