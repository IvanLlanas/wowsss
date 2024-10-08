# ##############################################################################
# These values should be checked and updated by the user BEFORE running WoWSSS.
# While they should work for a fresh system installation, you'll may need to
# adjust some of them for already working systems.
# ##############################################################################

# Common settings --------------------------------------------------------------
# ------------------------------------------------------------------------------

# Allow WoWSSS play some sounds on errors and "works completed".
PLAY_SOUNDS=1

# Database server user and password to be used by WoWSSS for the database
# management. It can be root.
DB_SCRIPT_USER=root
DB_SCRIPT_USER_PASSWORD=1234

# Database server user and password to be used by the WoW servers. Used to
# update the new configuration files. It shouldn't be root.
DB_SERVERS_USER=wows
DB_SERVERS_USER_PASSWORD=1234

# Database names and hosts.
DB_SERVER_IP="127.0.0.1"
DB_SERVER_PORT="3306"

# WotLK databases
WOTLK_DB_AUTH_NAME=wotlk_auth
WOTLK_DB_WORLD_NAME=wotlk_world
WOTLK_DB_CHARACTERS_NAME=wotlk_characters
WOTLK_DB_AUTH_HOST=$DB_SERVER_IP
WOTLK_DB_WORLD_HOST=$DB_SERVER_IP
WOTLK_DB_CHARACTERS_HOST=$DB_SERVER_IP
WOTLK_DB_AUTH_PORT=$DB_SERVER_PORT
WOTLK_DB_WORLD_PORT=$DB_SERVER_PORT
WOTLK_DB_CHARACTERS_PORT=$DB_SERVER_PORT

# Cataclysm databases
CATACLYSM_DB_AUTH_NAME=cataclysm_auth
CATACLYSM_DB_WORLD_NAME=cataclysm_world
CATACLYSM_DB_CHARACTERS_NAME=cataclysm_characters
CATACLYSM_DB_HOTFIXES_NAME=cataclysm_hotfixes
CATACLYSM_DB_AUTH_HOST=$DB_SERVER_IP
CATACLYSM_DB_WORLD_HOST=$DB_SERVER_IP
CATACLYSM_DB_CHARACTERS_HOST=$DB_SERVER_IP
CATACLYSM_DB_HOTFIXES_HOST=$DB_SERVER_IP
CATACLYSM_DB_AUTH_PORT=$DB_SERVER_PORT
CATACLYSM_DB_WORLD_PORT=$DB_SERVER_PORT
CATACLYSM_DB_CHARACTERS_PORT=$DB_SERVER_PORT
CATACLYSM_DB_HOTFIXES_PORT=$DB_SERVER_PORT

# MoP databases
MOP_DB_AUTH_NAME=mop_auth
MOP_DB_WORLD_NAME=mop_world
MOP_DB_CHARACTERS_NAME=mop_characters
MOP_DB_AUTH_HOST=$DB_SERVER_IP
MOP_DB_WORLD_HOST=$DB_SERVER_IP
MOP_DB_CHARACTERS_HOST=$DB_SERVER_IP
MOP_DB_AUTH_PORT=$DB_SERVER_PORT
MOP_DB_WORLD_PORT=$DB_SERVER_PORT
MOP_DB_CHARACTERS_PORT=$DB_SERVER_PORT

# Advanced settings ------------------------------------------------------------
# ------------------------------------------------------------------------------

# Number of CPU cores to use on sources compilation.
# Let's use all the cores... NO! Don't do this!
# CPU_CORES=$(nproc --all)
# Let's use half the cores... We could user some more...
# CPU_CORES=$(expr $(nproc) / 2)
# Let's not strangle the system, leave a couple of cores for it...
CPU_CORES=$(expr $(nproc) - 2)

# Should backup files be copied elsewhere? After making a backup, which will be 
# placed in "backup" directory, if REMOTE_BACKUPS is non-zero the backup will be
# copied to REMOTE_BACKUPS_DIR.
REMOTE_BACKUPS=1
# Set this to your remote backups directory.
REMOTE_BACKUPS_DIR=$HOME/remote
