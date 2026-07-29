# tutorial-DUNENDSim
The base repository for a DUNE ND Simulation tutorial delivered for the first time as part of the HSF-India Project's Scientific Computing Workshops.

To guide yourself through the exercises once your software environment is set up, use [`hdf5_ana.ipynb`](https://github.com/alexbooth92/tutorial-DUNENDSim/blob/main/hdf5_ana.ipynb) as a place to start.

**If you are a participant in HSF-India**, to run, click on the following: [![Binder](https://mybinder.org/badge_logo.svg)](https://binderhub.ssl-hep.org/v2/gh/alexbooth92/tutorial-DUNENDSim/main?gpuModel=&gpuCount=0&cudaMajor=undefined&cudaMinor=undefined&site=nrp&memory=4.0&cpu=1&qos=Guaranteed)

**If you wish to run on the GPVMs**, follow the steps below to set up you environment to enable you to complete Sections 0 through 4. Section 5, analysis of the NDLAr HDF5 file you produce in Section 4, can be completed wherever you like work with python. For example, using a basic virtual environment that contains `h5py`, `matplotlib`, `math` and `numpy`.

From a completely fresh login on the GPVMs (no need to `setup_dune.sh` etc), launch the containerised environment for the tutorial using apptainer:

```
/cvmfs/oasis.opensciencegrid.org/mis/apptainer/current/bin/apptainer shell --shell=/bin/bash -B ${PWD} /cvmfs/singularity.opensciencegrid.org/dunescience/sim2x2:ndlar011
```

`source` the environment
```
source /opt/environment
```

That's it!
