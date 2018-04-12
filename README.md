# deep-learning-docker

A full Docker Compose setup based on [Deepo](https://github.com/ufoym/deepo) with container services for [Jupyter Lab](https://github.com/jupyterlab/jupyterlab), [Tensorboad](https://github.com/tensorflow/tensorboard), and [nginx-proxy](https://github.com/jwilder/nginx-proxy) to run it all.

## Why?

Deepo is a great start but this goes a step further to add a turnkey development environment on top of the deep learning packages.

## Requirements

`deep-learning-docker` is opinionated.

* An Nvidia GPU for computation is requied
* There are no customization options for Deepo. It is based on the `all-` configuration of Deepo (i.e., `ufoym/deepo:all-py36-jupyter`)
* Python 3 only

## Usage


