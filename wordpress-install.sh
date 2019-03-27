#Create a sudo user on server
echo "Before we begin setting up Server and installing Wordpress CMS,"
echo "Do you want to create a new user with few root priviledges [y/n]?"
read -e newUser
if [ $newUser = y ]; then
echo "Please provide your root password"
su
echo "Now that we are logged in as root user, let's create a New User"
echo "Enter new userID"
read -e dummy
adduser $dummy
#usermod -aG sudo $dummy
else
echo "exiting"
exit
fi
