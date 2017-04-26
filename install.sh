#!/bin/sh
BASEDIR=$(dirname $BASH_SOURCE)

# Get the latest terminus repo clone from GitHub
git clone https://github.com/pantheon-systems/terminus.git $BASEDIR/terminus
cd $BASEDIR/terminus ; composer install
