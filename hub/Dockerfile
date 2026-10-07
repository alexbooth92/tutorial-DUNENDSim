FROM mjkramer/sim2x2:ndlar011

# Jupyter in system python; the container venv python is only used as a kernel.
# nbgitpuller delivers the repository contents at login; jupyterhub provides jupyterhub-singleuser.
RUN pip install --no-cache-dir notebook jupyterlab jupyterlab-rise jupyterhub nbgitpuller && \
    jupyter server extension enable nbgitpuller --sys-prefix

# Register the venv python as a named kernel.
RUN /opt/venv/bin/pip install ipykernel && \
    /opt/venv/bin/python -m ipykernel install --name dunend --display-name "dunend"

# Make the venv python the default kernel.
RUN mkdir -p /etc/jupyter && \
    echo "c.MultiKernelManager.default_kernel_name = 'dunend'" >> /etc/jupyter/jupyter_notebook_config.py

# Non-root user with home directory. Repository files are NOT copied in: the hub mounts
# its own home directory over /home/jovyan, and nbgitpuller clones the repo there.
RUN useradd -m -s /bin/bash -N -u 1000 jovyan

USER jovyan
WORKDIR /home/jovyan
