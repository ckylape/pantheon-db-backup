Pantheon Database Backups
=========================

This script creates and retrieves database backups from the Pantheon platform. These backups are created by `mysqldump` or Pantheons `terminus` command. 

Installation
------------

**Requirements:**
- PHP version 5.5.9 or later
- [PHP-CLI](http://www.php-cli.com/)
- [PHP-CURL](http://php.net/manual/en/curl.setup.php)

**Options:**

The scripts look for a `.env` file with the following options (see example.env):

- AUTH
  - The machine token generated from [Pantheon.io](https://dashboard.pantheon.io/machine-token/create).
- SITE
  - The site's short name (not the Site's UUID).
- ENV
  - The environment you wish to backup. This will most likely be set to `dev`, `test`, or `live`, but the script will work with multi-dev environments as well.


