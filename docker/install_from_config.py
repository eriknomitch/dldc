from os import system

#  -----------------------------------------------
#  UTILITY->INSTALL ------------------------------
#  -----------------------------------------------
def install_from_config(config_filename, format_syscall_fn):
  for name in open(f"/root/config/{config_filename}").read().splitlines():
    system(format_syscall_fn(name))

#  ===============================================
#  MAIN ==========================================
#  ===============================================
install_from_config("apt",
                    lambda name: f"apt-get install -y {name}")
install_from_config("pip",
                    lambda name: f"pip install {name}")
install_from_config("jupyter",
                    lambda name: f"jupyter nbextension enable {name}")
install_from_config("jupyterlab",
                    lambda name: f"jupyter labextension install {name}")
