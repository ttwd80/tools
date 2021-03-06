#!/bin/bash

# Ensure user is root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root. Use 'sudo ./<script>'." 1>&2
   exit 1
fi

# Install nginx with hhvm
apt-get install -y software-properties-common
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449
add-apt-repository -y 'deb http://dl.hhvm.com/ubuntu trusty main'
apt-get update
apt-get install -y nginx
apt-get install -y hhvm
/usr/share/hhvm/install_fastcgi.sh
/etc/init.d/hhvm restart
sed -i s/index.html/index.php/g /etc/nginx/sites-enabled/default
mkdir /var/lib/php5
chown -R www-data:www-data /var/lib/php5
echo '<?php phpinfo(); ?>' > /usr/share/nginx/html/phpinfo.php
/etc/init.d/nginx restart
update-rc.d hhvm defaults

# Install MySQL server
debconf-set-selections <<< 'mysql-server mysql-server/root_password password Passw0rd'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password Passw0rd'
apt-get -y install mysql-server
update-rc.d mysql defaults

echo "Installation is complete."
