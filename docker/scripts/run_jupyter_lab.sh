#!/usr/bin/env bash

# JupyterLab apparently has issues from being called directly as the main
# Docker command so we need this.
jupyter lab "$@"
