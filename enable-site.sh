#!/bin/bash

set -e

read -rp "Enter the filename (in sites-available) of the site to enable:" filename
sudo ln -s "/etc/nginx/sites-available/${filename}" "/etc/nginx/sites-enabled/${filename}"
sudo nginx -t