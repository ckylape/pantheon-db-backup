#!/bin/sh

# Script Directory
BASEDIR=$(dirname $BASH_SOURCE)

# Create Filename
FILE="$1/pantheon-$(date +"%H%M").sql.gz"

# Check if terminus executable exists
if [ ! -f $BASEDIR/terminus/bin/terminus ]; then
   $BASEDIR/install.sh
fi

# Read environment variables from file
export $(cat $BASEDIR/.env | xargs)

if [ $# -lt 1 ]; then
  echo "Usage: $BASH_SOURCE <directory>"
  echo "Example: $BASH_SOURCE /Users/admin/Desktop"
else

  # Create the Directory
  mkdir -p $1

  # Terminus Command
  if [ $BASEDIR = "." ]; then
    CMD='./terminus/bin/terminus'
  else
    CMD="$BASEDIR/terminus/bin/terminus"
  fi

  # Terminus : Login
  $CMD auth login --machine-token=$AUTH > /dev/null 2>&1

  # Terminus : Create New DB Backup
  $CMD site backups create --element=db --site=$SITE --env=$ENV --keep-for=3

  # Remove file if it already exists
  if [ "$OVERWRITE" = true ]; then
    if [ -f $FILE ]; then
        rm $FILE
    fi
  fi

  # Terminus : Get AWS S3 URL of last DB Dump
  $CMD site backups get --element=db --site=$SITE --env=$ENV --latest --to=$FILE

fi
