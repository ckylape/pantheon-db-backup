#!/bin/sh

# Get the latest terminus.phar version from GitHub
LATEST="$(curl -s https://api.github.com/repos/pantheon-systems/terminus/releases | grep browser_download_url | head -n 1 | cut -d '"' -f 4).phar"

# Install latest version Terminus with cURL
curl $LATEST -L -o terminus && chmod +x terminus
