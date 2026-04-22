FROM mjkramer/sim2x2:ndlar011

# Install Jupyter
RUN pip install --no-cache-dir notebook jupyterlab

## Create a venv that exists but is not automatically activated and 
## put it outside /home so it persists regardless of user home contents.
#ENV VENV_DIR=/opt/venvs/pythonicana
#
## Create venv + install deps + register as a kernel + install project requirements.
#COPY .binder/requirements.txt /tmp/requirements.txt
#RUN python3 -m venv ${VENV_DIR} \
# && ${VENV_DIR}/bin/pip3 install --no-cache-dir -U pip ipykernel \
# && ${VENV_DIR}/bin/pip3 install --no-cache-dir -r /tmp/requirements.txt \
# && ${VENV_DIR}/bin/python3 -m ipykernel install --prefix=/usr/local \
#      --name pythonicana --display-name "Python (pythonicana)"

# Add non-root user with home directory and default shell, copy repository contents and give right permissions.
RUN useradd -m -s /bin/bash -N jovyan
COPY . /home/jovyan/
RUN chown -R jovyan: /home/jovyan

# Switch to user and workdir.
USER jovyan
WORKDIR /home/jovyan
