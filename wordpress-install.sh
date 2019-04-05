#!/bin/bash
#use alt shift 3 to view line number in nano editor
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
#1. creating a nginx file in /etc/nginx/sites-available/

#2. replacing example.com with $domain.com #sudo -s cat <<EOT >> "/etc/nginx/sites-available/$domain.com"
sudo -s touch /etc/nginx/sites-available/$domain.com
sudo sh -c "cat >> /etc/nginx/sites-available/$domain.com <<'EOT'
server {
        listen 80;
        root /var/www/html;
        index index.php index.html index.htm index.nginx-debian.html;
        server_name example.com;

        location / {
                try_files $uri $uri/ =404;
        }

        location ~ \.php$ {
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
        }

        location ~ /\.ht {
                deny all;
        }
}
EOT" | sudo sed -i "s/server_name example.com;/server_name $domain.com;/g" "/etc/nginx/sites-available/$domain.com"
#-------------------------------------------------------------------------------------------------
#Enable your new server block by creating a symbolic link from your new server block configuration file
sudo ln -s /etc/nginx/sites-available/$domain.com /etc/nginx/sites-enabled/
sudo unlink /etc/nginx/sites-enabled/default
#Note: If you ever need to restore the default configuration, you can do so by recreating the symbolic link, like this:
#sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/
#Test your new configuration file for syntax errors:
sudo nginx -t
#reload nginx
sudo systemctl reload nginx

#configuring php
#sudo -s touch /var/www/html/info.php
#sudo sh -c "cat >> /var/www/html/info.php <<'EOT'
#<?php
#phpinfo();
#EOT"

#creating mysql database
sudo mysql
echo "enter root password when prompted"
echo ""
mysql -u root -p

-----------------
dpkg --get-selections | grep curl
if [ `echo $?` -eq 1 ]
then
echo "+----------------------------------------+"
echo -e "instaling curl before downloading wordpress"
echo "+----------------------------------------+"
sudo apt install -y curl
else
echo "Downloading wordpress"
curl -O https://wordpress.org/latest.tar.gz
fi
done

