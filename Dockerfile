# ================================================
# DOCKERFILE =====================================
# ================================================
FROM nvidia/cuda:10.0-devel-ubuntu18.04

# ------------------------------------------------
# ENV --------------------------------------------
# ------------------------------------------------

# See http://bugs.python.org/issue19846
ENV LANG C.UTF-8

# Reset this at bottom of file.
# https://github.com/phusion/baseimage-docker/issues/319#issuecomment-272568689
ENV DEBIAN_FRONTEND noninteractive

# ------------------------------------------------
# ------------------------------------------------
# ------------------------------------------------
LABEL com.nvidia.volumes.needed="nvidia_driver"

ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64
ENV PATH=$PATH:/usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV CUDA_PATH=/usr/local/cuda
ENV PYTHON_VERSION=3.6

RUN echo "deb http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list

# NOTE: cuda-nvcc-<version>
RUN apt-get update && apt-get install -y --no-install-recommends \
         build-essential \
         cmake \
         git \
         curl \
         vim \
         ca-certificates \
         python-qt4 \
         libjpeg-dev \
         zip \
         unzip \
         libpng-dev &&\
     rm -rf /var/lib/apt/lists/*

RUN curl -o ~/miniconda.sh -O  https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh  && \
     chmod +x ~/miniconda.sh && \
     ~/miniconda.sh -b -p /opt/conda && \
     rm ~/miniconda.sh && \
    /opt/conda/bin/conda install conda-build

ENV PATH=$PATH:/opt/conda/bin/
ENV USER dldc

# Create Environment
COPY environment.yaml /environment.yaml
RUN conda env create -f environment.yaml

WORKDIR /notebooks

# Activate Source
CMD source activate dldc
CMD source ~/.bashrc

RUN chmod -R a+w /notebooks
WORKDIR /notebooks

COPY config.yml /root/.dldc/config.yml

# ------------------------------------------------
# COPY->SCRIPTS ----------------------------------
# ------------------------------------------------
COPY ./docker/scripts/ /root/.scripts

# ------------------------------------------------
# CONFIG->INSTALLS -------------------------------
# ------------------------------------------------
COPY ./config/ /root/.config-image/

# Core (in dldc repo)
# ------------------------------------------------

# Run individually to preserve cache for each
CMD python /root/.scripts/install_from_config.py core apt
CMD python /root/.scripts/install_from_config.py core jupyter
CMD python /root/.scripts/install_from_config.py core jupyterlab
CMD python /root/.scripts/install_from_config.py core lua
CMD python /root/.scripts/install_from_config.py core pip

# User (Ignored in dldc repo - user configured)
# ------------------------------------------------
# NOTE: Except pip. That will be last for caching purposes. JupyterLab extensions are slow.

# Run individually to preserve cache for each
CMD python /root/.scripts/install_from_config.py user apt
CMD python /root/.scripts/install_from_config.py user jupyter
CMD python /root/.scripts/install_from_config.py user jupyterlab
CMD python /root/.scripts/install_from_config.py user lua

# User -> pip
# ------------------------------------------------
CMD python /root/.scripts/install_from_config.py user pip

# ------------------------------------------------
# CONFIG->IMAGE ----------------------------------
# ------------------------------------------------

# Copy Jupyter/JupyterLab settings
COPY ./docker/jupyter /root/.jupyter/

# ------------------------------------------------
# ENV->RESET -------------------------------------
# ------------------------------------------------
ENV DEBIAN_FRONTEND teletype

