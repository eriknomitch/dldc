import os

# ------------------------------------------------
# MAIN-CONFIG ------------------------------------
# ------------------------------------------------
c.NotebookApp.allow_origin = '*'
c.NotebookApp.allow_root = True
c.NotebookApp.allow_remote_access = True
c.NotebookApp.ip = '*'
c.NotebookApp.notebook_dir = '/shared'
c.NotebookApp.open_browser = False
c.NotebookApp.port = 8888
c.NotebookApp.trust_xheaders = True
c.NotebookApp.iopub_data_rate_limit = 1.0e10

# ------------------------------------------------
# AUTHENTICATION  --------------------------------
# ------------------------------------------------
if "JUPYTER_TOKEN" in os.environ:
  c.NotebookApp.token = os.environ['JUPYTER_TOKEN']

if "JUPYTER_PASSWORD_HASH" in os.environ:
    c = get_config()
    c.NotebookApp.password = os.environ['JUPYTER_PASSWORD_HASH']
