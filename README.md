# DLDC (Deep Learning Docker Compose)

A full [Docker Compose](https://github.com/docker/compose) setup for deep learning based on [Deepo](https://github.com/ufoym/deepo) with separate container services for [JupyterLab](https://github.com/jupyterlab/jupyterlab), [Tensorboad](https://github.com/tensorflow/tensorboard), and [nginx-proxy](https://github.com/jwilder/nginx-proxy) and persistent volumes.

## Why?

Deepo is great but it's only one Docker image. This goes a step further to add a turnkey development environment using Docker Compose to create a full system.

![DLDC Diagram](https://i.imgur.com/IdclXPt.png "DLDC Diagram")


## Requirements

DLDC is semi-opinionated.

* An Nvidia GPU is required (i.e., a CPU version isn't offered)
* There are no customization options for Deepo. The DLDC Docker image is based on the `all-` configuration of Deepo (i.e., `ufoym/deepo:all-py36-jupyter`) so it includes everything.
* Python 3 only
* JupyterLab is used but classic Jupyter notebooks can be run easily from JupyterLab

## Dependencies

* [nvidia-docker](https://github.com/NVIDIA/nvidia-docker)
* [nvidia-docker-compose](https://github.com/eywalker/nvidia-docker-compose)
* [Nvidia Drivers](http://www.nvidia.com/Download/index.aspx)
* [CUDA](https://developer.nvidia.com/cuda-downloads) (>= 9.1)

## Usage

### Quick Start

```Shell

# Clone the repository
#
$ git clone https://github.com/eriknomitch/dldc.git

$ cd dldc

# Create a secure token for Jupyter lab in .env
# 
$ echo "JUPYTER_TOKEN='<your-token>'" > .env

# Create an external host for nginx-proxy
#
# This is the base host you'll use so you can use subdomains for each service (i.e., http://jupyter.<external-host>, http://tensorboard.<external-host>)
# If you only plan to run this on localhost just use "localhost"
#
$ echo "EXTERNAL_HOST='<external-host>'" > .env

# Start dldc
#
# This will build the Docker image and start the nvidia-docker-compose services
# fetching any that aren't already fetched.
#
$ ./dldc

```

After launching, the `nvidia-docker-compose` services will be running.

* **JupyterLab** at http://localhost:8888 or http://jupyter.<hostname>. Use your `JUPYTER_TOKEN` you set in `.env` to log in. All of the Deepo packages will be available plus whatever you add in `packages/`.
  * Tensorflow
  * Pytorch
  * Keras
  * Theano
  * Sonnet
  * Lasagne
  * MXNet
  * CNTK
  * Chainer
  * Caffe
  * Caffe2
  * Torch
* **Tensorboard** at http://tensorboard.<hostname> or http://localhost:6006


## Commands

### Build and start the DLDC Docker services

```Shell
$ ./dldc
```

If the `dldc` image is already built and up-to-date (i.e., nothing has changed in your personal configuration) the build will use the cache version.

### Open an shell to the running DLDC `jupyter` service

```Shell
$ ./dldc shell
```

### Volumes

The local `./shared` directory will have been created and mounted on the containers at `/shared`.

The Jupyter notebooks root path is `./shared` locally and `/shared` on the container.

### Relaunching

Simply run `./dldc` again to start the `nvidia-docker-compose` services.

All data in `./shared` will have been preserved between instances.

