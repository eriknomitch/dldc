# deep-learning-docker

A full Docker Compose setup based on [Deepo](https://github.com/ufoym/deepo) with container services for [Jupyter Lab](https://github.com/jupyterlab/jupyterlab), [Tensorboad](https://github.com/tensorflow/tensorboard), and [nginx-proxy](https://github.com/jwilder/nginx-proxy) to run it all.

## Why?

Deepo is a great start but this goes a step further to add a turnkey development environment on top of the deep learning packages.

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

```
$ git clone https://github.com/eriknomitch/deep-learning-docker.git

$ cd deep-learning-docker

# Create a secure token for Jupyter lab in .env
$ echo "JUPYTER_TOKEN='<your-token>'" > .env

# This will build the Docker image and start the nvidia-docker-compose services
# fetching any that aren't already fetched.
$ ./app

```
