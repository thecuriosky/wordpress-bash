#!/bin/bash
#Check if PHP, Mysql & Nginx are installed. If not present, install the missing packages

for i in nginx mysql php
do
dpkg --get-selections | grep $i
if [ `echo $?` -eq 0 ]
then
echo "+----------------------------------------+"
echo -e "$i is already installed on server"
echo "+----------------------------------------+"
else
echo "+------------------------------------+"
echo -e "$i is not installed on server"
echo "           Installing $i            " 
echo "+------------------------------------+"
sudo apt-get -y update
sudo apt-get install -y $i
fi
done

#Adding domain to hosts

#read ip from ipconfig and storing in variable ip -- ip=$(command to fetch the ip from ifconfig)
ip=$(ifconfig ens33|awk '/inet / {print $2}')
echo "Please enter your desired domain name:\n"
read domain
sudo -- sh -c -e "echo '$ip $domain.com $domain' >> /etc/hosts";
echo "+------------------------------------+"
echo "$ip  $domain.com $domain"
echo "entry created in /etc/hosts"
echo "+------------------------------------+"

#configuring nginx config file

#downloading and ensuring if curl is installed

#checking and installing PHP extensions for use with WordPress
for php in php-fpm php-mysql php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip
do
dpkg --get-selections | grep $php
if [ `echo $?` -eq 1 ]
then
echo "+------------------------------------+"
echo "Installing $php"
echo "+------------------------------------+"
sudo apt-get install -y $php
sudo systemctl restart php7.2-fpm
else
echo "+-----------------------------------------------------------+"
echo "Great! $php was already installed, you're heck of a techie"
echo "+-----------------------------------------------------------+"
fi
done
#restart the PHP-FPM process so that the running PHP processor can leverage the newly installed features
sudo systemctl restart php7.2-fpm



#editing nginx config file for wordpress
sudo nano /etc/nginx/sites-available/akashmhaske.com


dpkg --get-selections | grep curl
if [ `echo $?` -eq 1 ]
then
echo "+----------------------------------------+"
echo -e "instaling curl before downloading wordpress"
echo "+----------------------------------------+"
sudo apt install -y curl
else
curl -O https://wordpress.org/latest.tar.gz
fi
done
