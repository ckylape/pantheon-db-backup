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
  $CMD auth:login --machine-token $AUTH > /dev/null 2>&1

  # Terminus : Create New DB Backup
  $CMD backup:create --element=db --keep-for=3 $SITE.$ENV

  # Remove file if it already exists
  if [ "$OVERWRITE" = true ]; then
    if [ -f $FILE ]; then
        rm $FILE
    fi
  fi

  # Terminus : Get AWS S3 URL of last DB Dump
  $CMD backup:get --element=db --to=$FILE $SITE.$ENV

  # Optionally Send Slack Webhook
  if [ ! -z "$WEBHOOK" ]; then
    JSON='{
      "attachments": [{
        "fallback": "Pantheon DB Backup - Terminus Dump",
        "color": "#36a64f",
        "pretext": "Pantheon DB Backup",
        "text": "Backup succesfully created for database: '$SITE.$ENV'"
      }]
    }'
    curl -X POST -H 'Content-type: application/json' --data "$JSON" $WEBHOOK
  fi

fi
