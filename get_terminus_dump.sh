#!/bin/sh

# check if terminus executable exists
if [ ! -f ./terminus ]; then
   ./install.sh
fi

# read environment variables from file
export $(cat .env | xargs)

# exit on any errors:
set -e

if [ $# -lt 1 ]
then
  echo "Usage: $0 <directory>"
  echo "Example: $0 /Users/admin/Desktop"
  exit 1
fi

# Create the Directory
mkdir -p $1

# Create Filename
FILE="$1/pantheon-$(date +"%Y%m%d-%H%M").sql.gz"

# Terminus : Login
./terminus auth login --machine-token=$AUTH > /dev/null 2>&1

# Terminus : Create New DB Backup
./terminus site backups create --element=db --site=$SITE --env=$ENV --keep-for=3

# Terminus : Get AWS S3 URL of last DB Dump
./terminus site backups get --element=db --site=$SITE --env=$ENV --latest --to=$FILE
