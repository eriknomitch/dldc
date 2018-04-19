import os

for package in open("/root/config/apt").read().splitlines():
  os.system(f"apt-get install -y ${package}")

