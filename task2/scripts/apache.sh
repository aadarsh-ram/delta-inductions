#!/bin/bash

sudo apt update
sudo apt install apache2

# Uncomment if you are running script for first time
# Change <ip_address> to your system IP address

# sudo -- sh -c -e "echo <ip_address> omega.com >> /etc/hosts"
# sudo -- sh -c -e "echo <ip_address> www.omega.com >> /etc/hosts"

sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod proxy_balancer
sudo a2enmod lbmethod_byrequests
sudo service apache2 restart

sudo cp scripts/omega.com.conf /etc/apache2/sites-available/omega.com.conf
sudo a2ensite omega.com.conf
sudo service apache2 restart