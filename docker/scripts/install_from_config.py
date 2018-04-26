# ================================================
# PYTHON->INSTALL-FROM-CONFIG ====================
# ================================================

# This file is copied to the Docker image during build and run on it to install
# packages into the image.
#
# This allows the user to quickly add in packages they need to configure their own
# dldc image (which builds on ./dldc).

# ------------------------------------------------
# IMPORT -----------------------------------------
# ------------------------------------------------
import os
from shlex import quote
import argparse

# ------------------------------------------------
# UTILITY ----------------------------------------
# ------------------------------------------------
def install_from_config(config_filename, format_syscall_fn):
  for name in open(f"/root/.config-packages/{config_filename}").read().splitlines():
    if name != "":
        os.system(format_syscall_fn(quote(name)))

# ------------------------------------------------
# SUBSYSTEMS -------------------------------------
# ------------------------------------------------
def subsystem_apt():
    os.environ['DEBIAN_FRONTEND'] = 'noninteractive'

    install_from_config("apt",
                        lambda name: f"apt-get install -y --no-install-recommends {name}")

def subsystem_lua():
    install_from_config("lua",
                        lambda name: f"luarocks install {name}")

def subsystem_jupyter():
    install_from_config("jupyter",
                        lambda name: f"jupyter nbextension enable {name}")

def subsystem_jupyterlab():
    install_from_config("jupyterlab",
                        lambda name: f"jupyter labextension install {name}")
def subsystem_pip():
    install_from_config("pip",
                        lambda name: f"pip --no-cache-dir install --upgrade {name}")

# ================================================
# MAIN ===========================================
# ================================================
def main():
    parser = argparse.ArgumentParser()

    parser.add_argument("subsystem")

    args = parser.parse_args()

    subsystems = {
        'apt': subsystem_apt,
        'lua': subsystem_lua,
        'jupyter': subsystem_jupyter,
        'jupyterlab': subsystem_jupyterlab,
        'pip': subsystem_pip
    }

    subsystems[args.subsystem]()

if __name__ == "__main__":
    main()
