#!/bin/bash

sudo apt update
sudo apt install apache2

# Uncomment below 2 lines if you are running script for first time
sudo -- sh -c -e "echo 10.0.2.15 omega.com >> /etc/hosts"
sudo -- sh -c -e "echo 10.0.2.15 www.omega.com >> /etc/hosts"
sudo a2enmod proxy
sudo a2enmod proxy_http
sudo a2enmod proxy_balancer
sudo a2enmod lbmethod_byrequests
sudo service apache2 restart

sudo cp scripts/omega.com.conf /etc/apache2/sites-available/omega.com.conf
sudo a2ensite omega.com.conf
sudo service apache2 restart

