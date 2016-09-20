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

# Terminus : Get Site ID
ID="$(./terminus site info --site=$SITE --field=id)"

# MySQL Host
HOST="$ENV.$ID@dbserver.$ENV.$ID.drush.in"

# Terminus : Get MySQL Port
PORT="$(./terminus site connection-info --site=$SITE --env=$ENV --field=mysql_port)"

# Terminus : Get MySQL Password
PASS="$(./terminus site connection-info --site=$SITE --env=$ENV --field=mysql_password)"

# SSH Tunnel to MySQL Server
ssh -M -S my-ctrl-socket -f -N -L $PORT:localhost:$PORT -p 2222 $HOST

# Dump MySQL Database
mysqldump pantheon -u pantheon -h 127.0.0.1 -P $PORT -p$PASS --single-transaction --quick | gzip > $FILE

# Close the SSH Tunnel
ssh -S my-ctrl-socket -O exit $HOST
