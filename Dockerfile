FROM ufoym/deepo:all-py36-jupyter

# ------------------------------------------------
# JUPYTER-LAB ------------------------------------
# ------------------------------------------------
RUN APT_INSTALL="apt-get install -y --no-install-recommends" && \
    PIP_INSTALL="pip --no-cache-dir install --upgrade" && \
    GIT_CLONE="git clone --depth 10" && \
    $PIP_INSTALL \
        jupyterlab \
        && \
        jupyter serverextension enable --py jupyterlab && \
        mkdir -p /opt/app/data

# Copy config and run script
# ------------------------------------------------
COPY ./docker/jupyter_notebook_config.py /root/.jupyter/
COPY ./docker/run_jupyter.sh /root/

