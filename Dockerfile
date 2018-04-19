# ================================================
# DOCKERFILE =====================================
# ================================================
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

# Copy Jupyter config
# ------------------------------------------------
COPY ./docker/jupyter_notebook_config.py /root/.jupyter/

# Copy run script
# ------------------------------------------------
COPY ./docker/run_jupyter.sh /root/

# ------------------------------------------------
# INSTALL-FROM-CONFIG ----------------------------
# ------------------------------------------------
COPY ./docker/install_from_config.py /root/

ADD ./config/ /root/config

RUN apt-get update

RUN python /root/install_from_config.py

