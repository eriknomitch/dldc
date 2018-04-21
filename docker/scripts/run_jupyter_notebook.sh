#!/usr/bin/env bash

# Jupyter apparently has issues from being called directly as the main
# Docker command so we need this.
jupyter notebook "$@"
