apt update --fix-missing

echo "############# install nginx ################"
apt -y install nginx

echo "############# reload nginx ################"
systemctl reload nginx

echo "############# install mysql ################"
echo "mysql-server mysql-server/root_password password secret" | sudo debconf-set-selections
echo "mysql-server mysql-server/root_password_again password secret" | sudo debconf-set-selections
apt -y install mysql-server mysql-client
echo "[client]" > /root/.my.cnf
echo 'password="secret"' >> /root/.my.cnf
echo "user=root" >> /root/.my.cnf
sed -i 's/127\.0\.0\.1/0\.0\.0\.0/g' /etc/mysql/mysql.conf.d/mysqld.cnf
mysql -uroot -e 'USE mysql; UPDATE `user` SET `Host`="%" WHERE `User`="root" AND `Host`="localhost"; DELETE FROM `user` WHERE `Host` != "%" AND `User`="root"; FLUSH PRIVILEGES;'

service mysql restart

echo "############# install php ################"
apt -y install php-fpm php-mysql
apt -y install php7.0-mbstring
apt -y install php7.0-bcmath
apt -y install curl php7.0-curl
apt -y install php7.0-mcrypt

echo "############# change php settings ################"
sed -i 's/^;cgi.fix_pathinfo/cgi.fix_pathinfo/g' /etc/php/7.0/fpm/php.ini

echo "############# restart php service ################"
systemctl restart php7.0-fpm

echo "############# install nano ################"
apt -y install nano

echo "############# install composer ################"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/bin/composer

echo
echo "###########  Server IPs ############"
ip addr show eth0 | grep inet | awk '{ print $2; }' | sed 's/\/.*$//'
echo "###########  Server IPs ############"
echo