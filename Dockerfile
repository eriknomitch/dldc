# ================================================
# DOCKERFILE =====================================
# ================================================
FROM ufoym/deepo:all-py36-jupyter

# ------------------------------------------------
# ADD->SCRIPTS -----------------------------------
# ------------------------------------------------

# Copy init scripts
# ------------------------------------------------
ADD ./docker/scripts/ /root/.scripts

# ------------------------------------------------
# APT --------------------------------------------
# ------------------------------------------------
RUN apt-get update

RUN APT_INSTALL="apt-get install -y --no-install-recommends" && \
      $APT_INSTALL curl

# ------------------------------------------------
# NODE -------------------------------------------
# ------------------------------------------------
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y --no-install-recommends nodejs

# ------------------------------------------------
# PIP --------------------------------------------
# ------------------------------------------------
RUN pip install --upgrade pip

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

# ------------------------------------------------
# INSTALL-FROM-CONFIG ----------------------------
# ------------------------------------------------
ADD ./config/ /root/config

RUN python /root/.scripts/install_from_config.py

