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
def install_from_config(config_filename, format_syscall_fn, user=False):
  directory = "packages" if user else "packages-core"

  for line in open(f"/root/.config-image/{directory}/{config_filename}").read().splitlines():
    # Omit empty lines and quoted lines
    if line != "" and not line.startswith("#"):
        os.system(format_syscall_fn(quote(line)))

# ------------------------------------------------
# SUBSYSTEMS -------------------------------------
# ------------------------------------------------
def subsystem_apt(user):
    os.environ['DEBIAN_FRONTEND'] = 'noninteractive'

    install_from_config("apt",
                        lambda name: f"apt-get install -y --no-install-recommends {name}")

def subsystem_lua(user):
    install_from_config("lua",
                        lambda name: f"luarocks install {name}")

def subsystem_jupyter(user):
    install_from_config("jupyter",
                        lambda name: f"jupyter nbextension enable {name}")

def subsystem_jupyterlab(user):
    install_from_config("jupyterlab",
                        lambda name: f"jupyter labextension install {name}")
def subsystem_pip(user):
    install_from_config("pip",
                        lambda name: f"pip --no-cache-dir install --upgrade {name}")

# ================================================
# MAIN ===========================================
# ================================================
def main():
    parser = argparse.ArgumentParser()

    parser.add_argument('-U', '--user')
    parser.add_argument("subsystem")

    args = parser.parse_args()

    subsystems = {
        'apt': subsystem_apt,
        'lua': subsystem_lua,
        'jupyter': subsystem_jupyter,
        'jupyterlab': subsystem_jupyterlab,
        'pip': subsystem_pip
    }

    subsystems[args.subsystem](args.user)

if __name__ == "__main__":
    main()
