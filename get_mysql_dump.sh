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

  # Terminus : Get Site ID
  ID="$($CMD site:info --field=id $SITE )"

  # MySQL Host
  HOST="$ENV.$ID@dbserver.$ENV.$ID.drush.in"

  # Terminus : Get MySQL Port
  PORT="$($CMD connection:info --field=mysql_port $SITE.$ENV)"

  # Terminus : Get MySQL Password
  PASS="$($CMD connection:info --field=mysql_password $SITE.$ENV)"

  # SSH Tunnel to MySQL Server
  ssh -M -S my-ctrl-socket -f -N -L $PORT:localhost:$PORT -p 2222 $HOST

  # Dump MySQL Database
  /Applications/MySQLWorkbench.app/Contents/MacOS/mysqldump pantheon -u pantheon -h 127.0.0.1 -P $PORT -p$PASS --single-transaction --quick | gzip > $FILE

  # Close the SSH Tunnel
  ssh -S my-ctrl-socket -O exit $HOST

fi
