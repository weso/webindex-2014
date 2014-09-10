import sys

# Activate webindex virualenv
activate_this = '/usr/local/virtualenvs/webindex/bin/activate_this.py'
execfile(activate_this, dict(__file__=activate_this))
# Import data-access-api application
sys.path.insert(0, '/usr/local/src/webindex')
from application.wixapi.api.api import app as application
