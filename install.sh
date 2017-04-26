#!/bin/sh

# Get the latest terminus repo clone from GitHub
git clone https://github.com/pantheon-systems/terminus.git terminus
cd terminus ; composer install

# Install latest version Terminus with cURL
#curl $LATEST -L -o $BASEDIR/terminus && chmod +x $BASEDIR/terminus
