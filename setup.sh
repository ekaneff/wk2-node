#!/bin/sh

DIRECTORY="/var/www/html/node"

if [ ! -d "$DIRECTORY" ]; then
	cd /var/www/html
	mkdir node
	cd /
fi