import os

# ------------------------------------------------
# MAIN-CONFIG ------------------------------------
# ------------------------------------------------
c.NotebookApp.allow_origin = '*'
c.NotebookApp.allow_root = True
c.NotebookApp.ip = '*'
c.NotebookApp.notebook_dir = '/shared'
c.NotebookApp.open_browser = False
c.NotebookApp.port = 8888
c.NotebookApp.trust_xheaders = True

# ------------------------------------------------
# JUPYTER-TOKEN-ENV ------------------------------
# ------------------------------------------------
if "JUPYTER_TOKEN" in os.environ:
  c.NotebookApp.token = os.environ['JUPYTER_TOKEN']
