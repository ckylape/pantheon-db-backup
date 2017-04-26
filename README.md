Pantheon Database Backups
=========================

This script creates and retrieves database backups from the Pantheon platform. These backups are created by `mysqldump` or Pantheons `terminus` command.

Installation
------------

**Requirements:**
- PHP version 5.5.9 or later
- [PHP-CLI](http://www.php-cli.com/)
- [PHP-CURL](http://php.net/manual/en/curl.setup.php)
- [Composer](https://getcomposer.org/)

**Options:**
The scripts look for a `.env` file with the following options (see example.env):

- AUTH
  - The machine token generated from [Pantheon.io](https://dashboard.pantheon.io/machine-token/create).
- SITE
  - The site's short name (not the Site's UUID).
- ENV
  - The environment you wish to backup. This will most likely be set to `dev`, `test`, or `live`, but the script will work with multi-dev environments as well.
- OVERWRITE
    - This will remove the file if it already exists before downloading. Terminus, by default, just throws an error if the file already exists. This only applys to the `get_terminus_dump.sh` script. The `get_mysql_dump.sh` will always overwrite the file if it exists.


Updating Terminus
-----------------

The Terminus project can be updated via the Git update method from [Pantheon's doc](https://github.com/pantheon-systems/terminus).

```bash
cd terminus ; git pull
composer update
```


get_mysql_dump.sh
-----------------

This script requires `mysqldump` to be installed and executable from the PATH. This script takes longer to run than `get_terminus_dump.sh` because of the remote connection to the database over an SSH tunnel. A 500MB database with 1200+ tables takes roughly ~7 minutes to complete.  

**Usage:**
```bash
./get_mysql_dump.sh ~/Desktop
```


get_terminus_dump.sh
-----------------

This script utilizes Pantheon's preferred way of extracting off-site database backups. This script runs faster than `get_mysql_dump.sh` because it's running on the server cluster instead of over an SSH tunnel. The database are then retrieved from an Amazon S3 private bucket via `wget`. A 500MB database with 1200+ tables takes roughly ~1 minute to complete.

**Usage:**
```bash
./get_terminus_dump.sh ~/Desktop
```
