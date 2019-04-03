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

#read ip from ipconfig and storing in variable 'ip' -- ip=$(command to fetch the ip from ifconfig)
ip=$(ifconfig)
echo "please enter your desired domain name"
read domain

ip=$(ifconfig)
#d=$(which nginx)
#read domain
#echo "$domain.com $domain installation directory $d"


#remove .com from example.com
sed -i "$ip  $domain.com venus" /etc/hosts


#downloading wordpress and ensuring if curl is installed

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
