FROM mjkramer/sim2x2:ndlar011

# Install Jupyter using system python. BH launches Jupyter itself, container venv python
# only needed as a kernel.
RUN pip install --no-cache-dir notebook jupyterlab

# Register the venv python as a named kernel.
RUN /opt/venv/bin/pip install ipykernel && \
    /opt/venv/bin/python -m ipykernel install --name dunend --display-name "dunend"

# Make the venv python the default kernel.
RUN mkdir -p /etc/jupyter && \
    echo "c.MultiKernelManager.default_kernel_name = 'dunend'" >> /etc/jupyter/jupyter_notebook_config.py

# Add non-root user with home directory and default shell, copy repository contents and give right permissions.
RUN useradd -m -s /bin/bash -N jovyan
COPY . /home/jovyan/
RUN chown -R jovyan: /home/jovyan

# Switch to user and workdir.
USER jovyan
WORKDIR /home/jovyan
