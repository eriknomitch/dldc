#!/bin/bash
# ================================================
# ZSH->NCV->APP ==================================
# ================================================
source .env

if [ -z $EXTERNAL_HOST ] ; then
  echo "fatal: EXTERNAL_HOST is not set."
  exit 1
fi

echo "Using host: $EXTERNAL_HOST"

# ------------------------------------------------
# ------------------------------------------------
# ------------------------------------------------

# Default to up, allow "" for up, handle "down", handle 
# additional arguments to docker-compose <command> ...
_command="up"

case $1 in
  "")
    ;;
  up)
    shift
    ;;
  *)
    _command="$1"
    shift
    ;;
esac

if [[ $_command == "up" ]] ; then

  # Make sure we're down
  echo "Ensuring services are down..."
  #nvidia-docker-compose down --remove-orphans > /dev/null 2>&1
  nvidia-docker-compose down --remove-orphans

  echo "Ensuring external volumes..."
  docker volume create --name=shared
fi

nvidia-docker-compose $_command $*
