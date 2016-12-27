#!/usr/bin/env bash


echo "Adding PHP  Repo ..."
# --------------------
add-apt-repository -y ppa:ondrej/php
apt-get -y update


echo "Installing some basic tools ..."
# --------------------
apt-get install -y nfs-common libcurl3 vim git sendmail


echo "Installing Apache ..."
# --------------------
apt-get install -y apache2


echo "Installing PHP 7.0 and modules ..."
# --------------------
apt-get install -y  php7.0         php7.0-cli   php7.0-common            libapache2-mod-php7.0
apt-get install -y  php7.0-bcmath  php7.0-curl  php7.0-gd   php7.0-intl  php7.0-mbstring  php7.0-mcrypt  
apt-get install -y  php7.0-mysql   php7.0-soap  php7.0-xml  php7.0-xsl   php7.0-zip       php7.0-iconv
apt-get install -y  php-imagick php-xdebug



echo "Installing MySQL 5.7 ..."
# --------------------

# Prep root password for noninteractive install
export DEBIAN_FRONTEND=noninteractive
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password mysql"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password mysql"

# Install MySQL Server
apt-get install -y -q mysql-server mysql-client











