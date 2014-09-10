#!/usr/bin/env bash

# --- Change this  default values ---: #
mysql_root_pass=root
app_pass=root
wordpress_db=wordpress
wordpress_user=wpuser
wordpress_user_pass=root
mongodb_user=wix_admin
mongodb_pass=root
# ------------------------------------ #

# Install required packages:
sudo apt-get -y update && sudo apt-get -y upgrade
sudo apt-get install -y php5-gd php5 libapache2-mod-php5 php5-cli php5-mysql php5-curl python-dev python-pip python-virtualenv git-core apache2 libapache2-mod-wsgi curl php-apc

# Install Virtualenv Wrapper
sudo pip install virtualenvwrapper

# Configure src and virtualenv paths in .bashrc
# http://virtualenvwrapper.readthedocs.org/en/latest/install.html

# Install MongoDB
# Import the public key used by the package management system
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10

# Create a list file for MongoDB
echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list

# Reload local package database.
sudo apt-get update

# Install the MongoDB packages
sudo apt-get install -y mongodb-org

# Start MongoDB
sudo service mongod start

# Create Mongo admin user
echo "db.createUser({user: \"$mongodb_user\", pwd: \"$mongodb_pass\", roles: [{ role: \"userAdminAnyDatabase\", db: \"admin\"}]})" > admin_user.js
mongo localhost:27017/admin admin_user.js
rm -rf admin_user.js

# Enable Mongo Client Access Control
sudo sed -ri 's|bind_ip = 127.0.0.1|#bind_ip = 127.0.0.1|g' /etc/mongod.conf
sudo service mongod restart

# Install MySQL
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password '$mysql_root_pass''
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password '$mysql_root_pass''
sudo apt-get install -y mysql-server mysql-client libmysqlclient-dev

# Install phpMyAdmin
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/dbconfig-install boolean true'
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/app-password-confirm password '$app_pass''
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/admin-pass password '$mysql_root_pass''
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/app-pass password '$mysql_root_pass''
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2'
sudo apt-get install -y phpmyadmin

# Create the Apache Config File
sudo rm /etc/apache2/sites-available/000-default.conf
sudo cp /vagrant/scripts/vhost /etc/apache2/sites-available/000-default.conf

# Reload apache
sudo service apache2 reload