# install lxd with 'sudo apt-get install lxd'
# alias vm-ssh='lxc exec development -- /bin/bash'
# alias vm-mysql='mysql --host=10.22.84.174 --port=3306 --user=root --password=secret --protocol=TCP' 
#

sudo apt install lxd
lxc remote add images images.linuxcontainers.org

lxc launch ubuntu:16.04 development
lxc start development

lxc file push provision.sh development/
lxc file push serve development/usr/bin/

lxc exec development -- chmod +x /provision.sh
lxc exec development -- chmod +x /usr/bin/serve

lxc config device add development webroot disk path=/projects source=`echo ~/projects`

echo "Wait for IPv4...."
sleep 10
lxc exec development -- /bin/bash /provision.sh