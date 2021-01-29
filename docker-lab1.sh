#!/bin/bash
# Version 1.0	- 26/Jan/2021
# This script to install Docker, Docker-compose and
# Script will exit if the OS version is not Ubuntu
# testing hello-world container and download Jenkin image to create Jenkin server

OS=$(lsb_release -id | grep Distributor | cut -d":" -f2 | sed -e 's/[ \t]*//')

echo
echo "--------------------------------------------------------------------------------------------"
echo "Installed $OS version"
echo
if [ $OS = "Ubuntu" ]
then

echo
echo "-------------------------------------- 1. SET UP THE REPOSITORY"
sudo apt-get update

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common -y

echo
echo "-------------------------------------- UNINSTALL OLD VERSION Docker Packages"
sudo apt-get remove docker-ce docker-ce-cli containerd.io docker.io -y
#sudo mv /var/lib/docker /var/lib/docker-`date +%-F`
#sudo rm -rf /var/lib/docker

echo

echo "-------------------------------------------2. Add Docker’s official GPG key "
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
echo

echo "-------------------------------------------3. set up the stable repository. test repository"
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"


# INSTALL DOCKER ENGINE
echo "-------------------------------------------4. INSTALL DOCKER ENGINE"
echo
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sleep 5

echo
echo "-------------------------------------------5. INSTALLING Docker-compose"
# https://docs.docker.com/compose/install/
#sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.28.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
sleep 5

echo
echo "---------------------------------------------------------------------------------------------"
echo
echo "Verify that Docker Engine is installed correctly - Download Hello World Image...."
sudo docker run hello-world
sleep 5

echo
echo "--------------------------------------- SETTING UP LOCAL USER TO ACCESS Docker DAEMON"
# Docker group check

        GI2=$(cat /etc/group | grep docker | cut -d":" -f1)
        ID=$(whoami)
        if [ "$GI2" = "docker"  ]
        then
          echo "Group $GI2 exists"
          sudo usermod -aG docker $ID
        else
          sudo groupadd docker
          sudo usermod -aG docker $ID
        fi

sleep 3
sudo chmod 666 /var/run/docker.sock

echo
echo "------------------------------------------------------------- RESTARTING DOCKER SERVICES......."
sudo systemctl enable docker
echo
echo "-----------------------------------------------------------------------------------------------"
sudo systemctl restart docker
echo
echo "-----------------------------------------------------------------------------------------------"
echo "Download image and create Jenkins container"
##sudo docker pull jenkins/jenkins

echo
echo "-----------------------------------------------------------------------------------------------"
sleep 3
echo "Installed : $(docker -v)"
echo "Installed : $(docker-compose -v)"

echo
echo "------------------------------------------------------"
echo "Logout and Relogin to docker works proper in sudo user"
echo "------------------------------------------------------"

else
echo
echo "************************** This is not Ubuntu OS. Aborting.... ********************************"
exit
fi

