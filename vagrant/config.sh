#!/usr/bin/env bash


echo "Creating Convenience Links From Home Directory ..."
# ---------------------------
cd /home/vagrant
rm -rf html log conf
mkdir -p conf log
ln -fs /var/www/html    html
ln -fs /var/log/apache2 log/apache
ln -fs /var/log/mysql   log/mysql
ln -fs /etc/apache2     conf/apache
ln -fs /etc/mysql       conf/mysql
ln -fs /var/lib/mysql   conf/mysql-lib
ln -fs /etc/php/7.0     conf/php7
sudo ln -fs /usr/lib/php/20151012    /etc/php/7.0/extension
chown -R vagrant:vagrant .

# cd /var/www
# chown -R vagrant:vagrant .


echo  "Creating Custom PHP ini for overrides ..."
# ---------------------------
touch /etc/php/7.0/php-custom.ini
ln -fs /etc/php/7.0/php-custom.ini /etc/php/7.0/cli/conf.d/01-php-custom.ini
ln -fs /etc/php/7.0/php-custom.ini /etc/php/7.0/apache2/conf.d/01-php-custom.ini

echo  "Configuring xDebug ..."
# ---------------------------
# cp /home/vagrant/xdebug.ini /etc/php/7.0/mods-available/xdebug.ini
# rm /home/vagrant/xdebug.ini


echo "Changing Apache to run as vagrant user ..."
# ---------------------------
# Replace www-data user with vagrant in /etc/apache2/envvars
sed -i "s/export APACHE_RUN_USER=www-data/export APACHE_RUN_USER=vagrant/g" /etc/apache2/envvars
sed -i "s/export APACHE_RUN_GROUP=www-data/export APACHE_RUN_GROUP=vagrant/g" /etc/apache2/envvars


echo "Setting Up Apache virtual hosts ..."
# ---------------------------
VHOST=$(cat <<EOF
Listen 8080
<VirtualHost *:80>
  DocumentRoot "/var/www/html"
  ServerName localhost
  <Directory "/var/www/html">
    AllowOverride All
  </Directory>
</VirtualHost>
<VirtualHost *:8080>
  DocumentRoot "/var/www/html"
  ServerName localhost
  <Directory "/var/www/html">
    AllowOverride All
  </Directory>
</VirtualHost>
<VirtualHost *:80>
  DocumentRoot "/home/vagrant/mage"
  ServerName mage2.local
  <Directory "/home/vagrant/mage">
    AllowOverride All
  </Directory>
</VirtualHost>
<VirtualHost *:443>
  DocumentRoot "/home/vagrant/mage"
  ServerName mage2.local
  <Directory "/home/vagrant/mage">
    AllowOverride All
  </Directory>
</VirtualHost>

<Directory "/home/vagrant">
    Options Indexes FollowSymLinks
    AllowOverride All
    Require all granted
</Directory>
EOF
)

echo "$VHOST" > /etc/apache2/sites-enabled/000-default.conf

a2enmod rewrite

# Remove default Apache file from web root
rm -f /var/www/html/index.html

service apache2 restart


echo "Replacing MySQL config file (mysqld.cnf) ..."
# ---------------------------
[ ! -f /etc/mysql/original-my.cnf ] && mv /etc/mysql/mysql.conf.d/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld-original.cnf
mv /home/vagrant/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf

# Remove ib_logfiles since size has changed
rm -f /var/lib/mysql/ib_logfile0 /var/lib/mysql/ib_logfile1

service mysql restart



