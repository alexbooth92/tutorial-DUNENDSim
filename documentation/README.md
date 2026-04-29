Taken from [here](https://github.com/DUNE/2x2_sim/wiki/File-data-definitions).

## MC Truth

The MC truth is organized as two datasets: one for event summary information (the `mc_hdr`) and one for the particle stack (the `mc_stack`). This is a short explanation of the variables in each and their units (if applicable). The MC truth datasets are introduced in this form starting with the HDF5 converted edep-sim files and are the same for `larndsim` and `ndflow` output (although might have a different top-level name). Currently the MC simulation only uses GENIE as the event generator.

### Event summary info (`mc_hdr`)

There is one entry per GENIE interaction in the array.

+ `event_id`: unique ID for an interesting window of time; for beam events this corresponds to a spill
+ `vertex_id`: the vertex ID number, corresponds to an individual generator interaction
+ `vertex`: the position of the interaction vertex (x,y,z,t) in [cm]
+ `target`: the Z value of the struck nucleus
+ `reaction`: an integer enumeration for the different GENIE reactions. Positive int for neutrino, negative int for anti-neutrino events. Some numbers reserved for future use.
```    
QES       : 1
1Kaon     : 2
DIS       : 3
RES       : 4
COH       : 5
DFR       : 6
NuEEL     : 7
IMD       : 8
AMNuGamma : 9
MEC       : 10
CEvNS     : 11
IBD       : 12
GLR       : 13
IMDAnh    : 14
PhotonCOH : 15
PhotonRES : 16
1Pion     : 17
DMEL      : 101
DMDIS     : 102
DME       : 103
```
+ `isCC`: True if charged-current event, False if neutral-current event
+ `isXYZ`: boolean flags for identifying interaction types, which come from the GENIE reaction string, and are mutually exclusive; currently supported types:
    * `isQES`: quasi-elastic
    * `isMEC`: meson-exchange current (also known as multi-nucleon)
    * `isRES`: resonant pion production
    * `isDIS`: deep inelastic scattering
    * `isCOH`: coherent scattering
+ `Enu`: incident neutrino energy in [MeV]
+ `nu_4mom`: incident neutrino 4-momentum vector (px, py, pz, E) in [MeV]
+ `nu_pdg`: incident neutrino PDG code
+ `Elep`: outgoing lepton energy in [MeV]
+ `lep_mom`: outgoing lepton momentum in [MeV]
+ `lep_ang`: angle between the outgoing lepton and the neutrino beam direction in [degrees]
+ `lep_pdg`: outgoing lepton PDG code
+ `q0`: energy transfer in [MeV]
+ `q3`: magnitude of the momentum transfer in [MeV]
+ `Q2`: 4-momentum transfer squared in [MeV^2]
+ `x`: bjorken x, defined as Q^2 / (2 * nucleon_mass * q0) where the nucleon mass is simply the proton mass
+ `y`: inelasticity y, defined as 1 - (Elep / Enu)

### Particle stack (`mc_stack`)

There is one entry per particle in the array. Match `event_id` to find all the particles for a given interaction across different array entries. Currently only contains the initial and final state particles for the interaction.

+ `event_id`: unique ID for an interesting window of time; for beam events this corresponds to a spill
+ `vertex_id`: the vertex ID number, corresponds to an individual generator interaction
+ `traj_id`: the edep-sim trajectory ID that corresponds to this MC particle; otherwise -999 if no matching trajectory
+ `part_4mom`: the particle 4-momentum vector (px, py, pz, E) in [MeV]
+ `part_pdg`: the particle PDG code
+ `part_status`: 0 if initial state particle, 1 if final state particle (as defined by GENIE)

### Vertex/event ID cheatsheet

For a MiniRun (i.e. beam) file, in the truth datasets, the `event_id` is the true beam spill ID, defined as

```
1e3*file_number + (0, 1, 2...)
```

The vertex_id is more complicated, and is defined roughly as:

```
1e15*(1 if from_rock_generator else 0) + 1e7*file_number + (0, 1, 2...)
```

More precisely it's

```
1e15*(1 if from_rock_generator else 0) + 1e6*genie_file_number + (0, 1, 2...)
```

For file number 123, the GENIE file numbers are 1230, 1231, ..., 1239, since we merge 20 GENIE/Geant files (10 rock + 10 "fiducial") into each downstream file.


## edep-sim Truth

The edep-sim truth information is organized as two datasets: one for the true particle trajectories and one for the true energy deposits/segments. These datasets are introduced in this form starting with the HDF5 converted edep-sim files and have the same structure for `larndsim` and `ndflow` output (although might have a different top-level name). Both datasets are a near one-to-one translation from the edep-sim ROOT data structures.

### `trajectories`

These are the true particle trajectories (or paths) through the detector for all particles, both neutral and charged, excluding the incident neutrino. Each true particle may have multiple trajectories if the trajectory was split/broken by edep-sim with each having their own unique track ID.

+ `event_id`: unique ID for an interesting window of time; for beam events this corresponds to a spill
+ `vertex_id`: the vertex ID number, corresponds to an individual generator interaction
+ `traj_id`: the original edep-sim trajectory (track) ID, not unique within a file, guaranteed to be unique for each vertex
+ `file_traj_id`: the trajectory id that is unique within a file
+ `parent_id`: the trajectory (track) ID of the parent trajectory, if the trajectory is a primary particle the ID is -1
+ `E_start`: the total energy in [MeV] at the start of the trajectory
+ `pxyz_start`: the momentum 3-vector (px, py, pz) in [MeV] at the start of the trajectory
+ `xyz_start`: the start position 3-vector (x, y, z) in [cm] of the trajectory (specifically the position of the first trajectory point)
+ `t_start`: the start time of the trajectory in [us]
+ `E_end`: the total energy in [MeV] at the end of the trajectory
+ `pxyz_end`: the momentum 3-vector (px, py, pz) in [MeV] at the end of the trajectory
+ `xyz_end`: the end position 3-vector (x, y, z) in [cm] of the trajectory (specifically the position of the last trajectory point)
+ `t_end`: the end time of the trajectory in [us]
+ `pdg_id`: the PDG code of the particle
+ `start_process`: physics process for the start of the trajectory as defined by GEANT4
+ `start_subprocess`: physics subprocess for the start of the trajectory as defined by GEANT4
+ `end_process`: physics process for the end of the trajectory as defined by GEANT4
+ `end_subprocess`: physics subprocess for the end of the trajectory as defined by GEANT4

See the enums in the edep-sim [TG4Trajectory.h](https://github.com/ClarkMcGrew/edep-sim/blob/master/io/TG4Trajectory.h) (or GEANT4 docs) for process and subprocess codes.

### `segments` (previously `tracks`)

These are the true energy deposits (or energy segments) for active parts of the detector from edep-sim. Each segment corresponds to some amount of energy deposited over some distance. Some variables are filled during the `larndsim` stage of processing.

+ `event_id`: unique ID for an interesting window of time; for beam events this corresponds to a spill
+ `vertex_id`: the vertex ID number, corresponds to an individual generator interaction
+ `segment_id`: the segment ID number
+ `traj_id`: the original edep-sim trajectory (track) ID of the trajectory that created this energy deposit, not unique within a file, guaranteed to be unique for each vertex
+ `x_start`: the x start position [cm]
+ `y_start`: the y start position [cm]
+ `z_start`: the z start position [cm]
+ `t0_start`: the start time [us]
+ `x_end`: the x end position [cm]
+ `y_end`: the y end position [cm]
+ `z_end`: the z end position [cm]
+ `t0_end`: the end time [us]
+ `x`: the x mid-point of the segment [cm] -> (x_start + x_end) / 2
+ `y`: the y mid-point of the segment [cm] -> (y_start + y_end) / 2
+ `z`: the z mid-point of the segment [cm] -> (z_start + z_end) / 2
+ `t0`: the time mid-point [us] -> (t0_start + t0_end) / 2
+ `pdg_id`: PDG code of the particle that created this energy deposit
+ `dE`: the energy deposited in this segment [MeV]
+ `dx`: the length of this segment [cm]
+ `dEdx`: the calculated energy per length [MeV/cm]
+ `tran_diff`: (ADD INFO)
+ `long_diff`: (ADD INFO)
+ `n_electrons`: (ADD INFO)
+ `n_photons`: (ADD INFO)
+ `pixel_plane`: (ADD INFO)
+ `t`/`t_start`/`t_end`: arrival time regarding to t0 -- event start time (including the beam width or cosmic time offset etc), filled in larnd-sim. Note t_start/t_end is the early/late end of the segment, which doesn't necessarily correspond to the t0/x/y/z_start and t0/x/y/z_end.
