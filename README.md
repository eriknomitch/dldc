# deep-learning-docker

A full Docker Compose setup based on [Deepo](https://github.com/ufoym/deepo) with container services for [Jupyter Lab](https://github.com/jupyterlab/jupyterlab), [Tensorboad](https://github.com/tensorflow/tensorboard), and [nginx-proxy](https://github.com/jwilder/nginx-proxy) to run it all.

## Why?

Deepo is a great start but this goes a step further to add a turnkey development environment on top of the deep learning packages.

## Status

Pre-alpha

## Requirements

`deep-learning-docker` is opinionated.

* An Nvidia GPU for computation is requied
* There are no customization options for Deepo. It is based on the `all-` configuration of Deepo (i.e., `ufoym/deepo:all-py36-jupyter`)
* Python 3 only

## Dependencies

* nvidia-docker
* nvidia-docker-compose
* A working CUDA 9.x installation

## Usage

### Quick Start

```
$ git clone https://github.com/eriknomitch/deep-learning-docker.git

$ cd deep-learning-docker

# Create a secure token for Jupyter lab in .env
$ echo "JUPYTER_TOKEN='<your-token>'" > .env

# This will build the Docker image and start the nvidia-docker-compose services
# fetching any that aren't already fetched.
$ ./deep-learning-docker

```

After launching, the `nvidia-docker-compose` services will be running.

You'll then have the following available:

* **Jupyter Lab** at http://localhost:8888 (use your `JUPYTER_TOKEN` you set in `.env` to log in) with all of the Deepo packages:
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
* **Tensorboard** at http://localhost:6006

### Volumes

Docker volumes will have been created. Here's the list from local directory to the directory on the Docker container(s):
  * `./shared` -> `/shared`
  * `./notebooks` -> `/notebooks` (Jupyter Lab will be configured to use this directory as the default notebook directory.)

### Relaunching

Simply run `./deep-learning-docker` again to start the `nvidia-docker-compose` services. Your volumes will be preserved between launches.
