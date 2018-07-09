#!/usr/bin/env bash

# JupyterLab apparently has issues from being called directly as the main
# Docker command so we need this.
export NODE_OPTIONS=--max-old-space-size=4096

jupyter lab "$@"
