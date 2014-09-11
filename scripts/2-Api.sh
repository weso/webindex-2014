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

api_home_file=~/webindex-2014/scripts/api.wsgi
api_vagrant_file=/vagrant/scripts/api.wsgi

if [ -f "$api_home_file" ]
then
    sudo cp $api_home_file /var/www/webindex

elif [ -f "$api_vagrant_file" ]
then
    sudo cp $api_vagrant_file /var/www/webindex

fi

# Add Apache user permissions
sudo chown -R www-data:www-data /var/www/webindex
sudo chown -R www-data:www-data /usr/local/src/webindex/
sudo service apache2 reload

# Feed API initial data
cd /usr/local/src/webindex/application/wixapi/initial_data
. import.sh
