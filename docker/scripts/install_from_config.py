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

# ------------------------------------------------
# UTILITY ----------------------------------------
# ------------------------------------------------
def install_from_config(config_filename, format_syscall_fn):
  for name in open(f"/root/config/{config_filename}").read().splitlines():
    if name != "":
        os.system(format_syscall_fn(name))

# ================================================
# MAIN ===========================================
# ================================================
def main():

    os.environ['DEBIAN_FRONTEND'] = 'noninteractive'

    install_from_config("apt",
                        lambda name: f"apt-get install -y --no-install-recommends {name}")
    install_from_config("pip",
                        lambda name: f"pip --no-cache-dir install --upgrade {name}")
    install_from_config("jupyter",
                        lambda name: f"jupyter nbextension enable {name}")
    install_from_config("jupyterlab",
                        lambda name: f"jupyter labextension install {name}")

if __name__ == "__main__":
    main()
