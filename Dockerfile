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

# Update
# ------------------------------------------------
RUN apt-get update

# Install
# ------------------------------------------------
RUN export APT_INSTALL="apt-get install -y --no-install-recommends" && \
      $APT_INSTALL \
        curl \
        zsh

# ------------------------------------------------
# NODE -------------------------------------------
# ------------------------------------------------
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y --no-install-recommends nodejs

# ------------------------------------------------
# PIP --------------------------------------------
# ------------------------------------------------

# Upgrade
# ------------------------------------------------
# FIX: Should we stick to a specific version instead of upgrading blindly?
RUN pip --no-cache-dir install --upgrade pip

# Install packages
# ------------------------------------------------
RUN export PIP_INSTALL="pip --no-cache-dir install --upgrade" && \
    $PIP_INSTALL \
        jupyterlab

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

RUN python /root/.scripts/install_from_config.py

# ------------------------------------------------
# ENV->RESET -------------------------------------
# ------------------------------------------------
ENV DEBIAN_FRONTEND teletype


