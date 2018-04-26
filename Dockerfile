# ================================================
# DOCKERFILE =====================================
# ================================================
FROM ufoym/deepo:all-py36-jupyter

# ------------------------------------------------
# ENV --------------------------------------------
# ------------------------------------------------

# Reset this at bottom of file.
# https://github.com/phusion/baseimage-docker/issues/319#issuecomment-272568689
ENV DEBIAN_FRONTEND noninteractive

# ------------------------------------------------
# COPY->SCRIPTS ----------------------------------
# ------------------------------------------------
COPY ./docker/scripts/ /root/.scripts

# ------------------------------------------------
# APT --------------------------------------------
# ------------------------------------------------
RUN apt-get update && \
      apt-get install -y --no-install-recommends \
        curl

# ------------------------------------------------
# NODE -------------------------------------------
# ------------------------------------------------
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
      apt-get install -y --no-install-recommends \
        nodejs

# ------------------------------------------------
# PIP --------------------------------------------
# ------------------------------------------------

# Upgrade
# ------------------------------------------------
# FIX: Should we stick to a specific version instead of upgrading blindly?
RUN pip --no-cache-dir install --upgrade pip

# Install packages
# ------------------------------------------------
RUN PIP_INSTALL="pip --no-cache-dir install --upgrade" && \
    $PIP_INSTALL \
        jupyterlab \
        mxnet-cu90 # This needs to be upgraded for graphviz

# ------------------------------------------------
# JUPYTER-LAB ------------------------------------
# ------------------------------------------------
RUN jupyter serverextension enable --py jupyterlab

# ------------------------------------------------
# CONFIG->IMAGE ----------------------------------
# ------------------------------------------------

# Copy Jupyter/JupyterLab settings
COPY ./docker/jupyter /root/.jupyter/

# ------------------------------------------------
# CONFIG->INSTALLS -------------------------------
# ------------------------------------------------
COPY ./config-packages/ /root/.config-packages

# Run individually to preserve cache for each
RUN python /root/.scripts/install_from_config.py apt
RUN python /root/.scripts/install_from_config.py jupyter
RUN python /root/.scripts/install_from_config.py jupyterlab
RUN python /root/.scripts/install_from_config.py lua
RUN python /root/.scripts/install_from_config.py pip

# ------------------------------------------------
# CUDA -------------------------------------------
# ------------------------------------------------
RUN pip install --upgrade tensorflow-gpu

# Downgrade cudnn
# ------------------------------------------------
# FIX: This is a hack for current issue with tensorflow-gpu
RUN apt-get purge -y libcudnn7 libcudnn7-dev

RUN curl "http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64/libcudnn7_7.0.5.15-1+cuda9.1_amd64.deb" > /tmp/libcudnn7_7.0.5.15-1+cuda9.1_amd64.deb && \
      dpkg -i /tmp/libcudnn7_7.0.5.15-1+cuda9.1_amd64.deb

# ------------------------------------------------
# ENV->RESET -------------------------------------
# ------------------------------------------------
ENV DEBIAN_FRONTEND teletype

# ------------------------------------------------
# WORKDIR ----------------------------------------
# ------------------------------------------------
WORKDIR /root
