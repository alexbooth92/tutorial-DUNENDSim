# tutorial-DUNENDSim
The base repository for a DUNE ND Simulation tutorial delivered for the first time as part of the HSF-India Project's Scientific Computing Workshops.


To guide yourself through the exercises once your software environment is set up, use [`hdf5_ana.ipynb`](https://github.com/alexbooth92/tutorial-DUNENDSim/blob/dune-tech-rice/hdf5_ana.ipynb) as a place to start.


## If you are using the DUNE Tech JupyterHub
Log in with GitHub at [![DUNE Tech JupyterHub](https://img.shields.io/badge/Log%20in-DUNE%20Tech%20JupyterHub-F37626?logo=jupyter&logoColor=white)](https://dune-tech.rice.edu/jupyterhub/), then click the following to clone this repository into your session:

[![Clone the tutorial](https://img.shields.io/badge/Clone-tutorial--DUNENDSim-2EA44F?logo=git&logoColor=white)](https://dune-tech.rice.edu/jupyterhub/hub/user-redirect/git-pull?repo=https%3A%2F%2Fgithub.com%2Falexbooth92%2Ftutorial-DUNENDSim&branch=dune-tech-rice&urlpath=lab%2Ftree%2Ftutorial-DUNENDSim%2F)

Then open a terminal (File → New → Terminal) and launch the containerised environment from inside the cloned repository. This also links the large input files from the shared directory into `inputs/`:

```
cd ~/tutorial-DUNENDSim
apptainer exec \
    -B /data/home/tutorial-DUNENDSim:/data/home/tutorial-DUNENDSim \
    --env LC_ALL=C.UTF-8 \
    --pwd /opt/generators/root \
    /opt/images/tutorial-dunendsim_v1-kernel.sif \
    bash -c "cd '$PWD'
unset BASH_ENV
export PYTHONPATH=/opt/ipykernel:\$PYTHONPATH
bash '$HOME/tutorial-DUNENDSim/hub/link_inputs.sh'
exec bash"
```

The image for this environment is built from [`hub/Dockerfile`](hub/Dockerfile).


## If you wish to run on the DUNE GPVMs
Checkout the `main` branch of this repository and follow the instructions there.
