# NUT
Repository contains the NUT configuration and tells how to install Docker, Docker Compose and run the Home Assistant as a Docker container. Additionally I present how to turn off the Mikrotik router from the Raspberry Pi if the battery level state is low. 

I decided to "promote" this video that is just an excellent example that explains step by step how to install and configure NUT on a Raspberry Pi. https://youtu.be/vyBP7wpN72c 

First run the lsusb command

It will allow you to find out what device is connected through the USB port.

Then perform the below command to update repositories:

sudo apt update

Then we are going to install the NUT, NUT client and NUT server

sudo apt install nut nut-client nut-server

Next you can use a utility called a nut scanner to actually proble the UPS device and get some information from it so you can configure it a little bit easier.

sudo nut-scanner -U

You can see the result, so you can just copy and paste it into the notepad or make a note of it and you can use some of these values in your configuration. 

The configuration is stored in /etc/nut/ups.conf

So let's edit this file

You can make a backup of this file or modify it. 

I had to test some of these settings and read a NUT documentation that you can find it here: https://networkupstools.org/docs/man/ 

I had to change the driver to nutdrv_qx and modify a little bit the ups.conf to be able to work with the mentioned UPS. 

Then you have to edit the /etc/nut/upsmon.conf

add a line to monitor a UPS

Edit

/etc/nut/upsd.conf

and modify it to listen on all IP addresses if you want to be able to connect to it from other devices / containers / virtual machines

Edit

/etc/nut/nut.conf

And change the mode to netserver

Edit

/etc/nut/upsd.users

Add users

[upsmon]
        password  = secret
        upsmon master


If a help is needed with any part, do not hesitate to ask.

I had to set up Home Assistant as the docker container on a raspberry Pi and add my Green Cell UPS there.
I had to do that because I am using AdGuard Home on a Raspberry Pi and I was not able to run it together.

First I had to create a yaml file
vim home-assistant.yml

version: '3'
services:
  homeassistant:
    container_name: homeassistant
    image: "ghcr.io/home-assistant/home-assistant:stable"
    volumes:
      - /home/adrian/home-assistant/config
      - /etc/localtime:/etc/localtime:ro
    restart: unless-stopped
    privileged: true
    network_mode: host

Then run the below commands

The first one installs the docker
sudo curl -sSL https://get.docker.com | sh


This one creates the user
sudo usermod -aG docker ${USER}

The next one installs the docker-compose
sudo pip3 install docker-compose

This one enables the docker to start during the boot process
sudo systemctl enable docker

And start and check the status
sudo systemctl start docker
sudo systemctl status docker

Create a docker containter with Home Assistant that runs locally

sudo docker-compose -f home-assistant.yml up -d --remove-orphans

Check is the containter running
sudo docker ps

List all containters
sudo docker container ls -a

To kill a container, use the below command:
sudo docker kill a1c19f3ec04e

To restart the container:
sudo docker container restart homeassistant


Start the container during the boot process
sudo docker update --restart unless-stopped $(docker ps -q)

The Home Assistant is working locally so, I had to create a ssh tunnel to be able to access it from my laptop.

Actually Home Assistant detected UPS automatically. 
I see the basic information like load, power etc.  


Now it is time to write a bash script that will log into Mikrotik router and perform the shutdown command before the raspberry will shut down. I will use a bash script that I tested on my Mikrotik hap ac2.


Of course sshpass has to be installed with the below command

sudo apt install sshpass

-p 2244 is a nonstandard ssh port
