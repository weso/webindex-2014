#!/usr/bin/env bash

cd /usr/local/src/

# Clone webindex domain
sudo git clone https://github.com/weso/wixDom.git webindex
cd webindex/application/

# Clone Data Access Api
sudo git clone https://github.com/weso/wixAPI.git wixapi
cd ..

# Create WebIndex Python virtual environment
sudo virtualenv /usr/local/virtualenvs/webindex

# Access to virtualenv paths
sudo chmod -R 777 /usr/local/virtualenvs/

#Activate the virtualenv
. /usr/local/virtualenvs/webindex/bin/activate

#Install Domain requirements
pip install -r /usr/local/src/webindex/wixdom_requirements.txt

#Install API requirements
pip install -r /usr/local/src/webindex/application/wixapi/wixapi_requirements.txt

#Reload the virtualenv
deactivate
. /usr/local/virtualenvs/webindex/bin/activate

# Copy api wsgi file
sudo mkdir /var/www/webindex
sudo cp /vagrant/scripts/api.wsgi /var/www/webindex

# Add Apache user permissions
sudo chown -R www-data:www-data /var/www/webindex
sudo chown -R www-data:www-data /usr/local/src/webindex/
sudo service apache2 reload

# Feed API initial data
cd /usr/local/src/webindex/application/wixapi/initial_data
. import.sh
