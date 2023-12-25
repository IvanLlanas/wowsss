     __      __    __      __________________________
    /  \    /  \__/  \    /  \ _____/  _____/  _____/
    \   \/\/  /  _ \  \/\/   /____  \_____  \_____  \ 
     \       (  (_) )       /        \       \       \
      \__/\  /\____/\__/\  /_______  /_____  /_____  /
           \/            \/        \/      \/      \/ 1.0

# World of Warcraft Server Script System
[Github repository](https://github.com/IvanLlanas/wowsss)

## Description
WoWSSS is a script system designed to install and manage a World of Warcraft private server from scratch.
It uses [AzerothCore](https://github.com/azerothcore/azerothcore-wotlk) for a "Wrath of the Lich King" server 
and [TrinityCore](https://github.com/azerothcore/azerothcore-wotlk) for a "Cataclysm" server.

## Installation
Just clone WoWSSS from [github](https://www.github.com/IvanLlanas/wowsss) anywhere in your (sudoer) user directory and launch the `wowsss.sh` script to start the installation and compilation process.
Once WoWSSS founds any server installation it will show the maintenance menu from where the servers can be started/stopped, backed up and updated.

Launch the servers. Wait for worldserver to populate the databases (w - to change to world server). Answer yes whenever it asks about populating an empty database.
>shutdown server 1
^A^D to get back to the menu.
I) -> IPs


---------------------------------------

Once WOWSSS has installed all software packages, compiled and linked the server sources, downloaded the data files, setup the databases and database server, you will be able to start the servers.
The first you will need to do is to create a WoW account in the `worldserver` console:
AC> account create admin admin admin
AC> Account created: admin
AC> account set gmlevel admin 3 -1
AC> You change security level of account ADMIN to 3.

You'll be stuck trying to enter the AzerothCore realm. No luck since it is defined in 127.0.0.1.
You'll have to change the realm definition in the realmlist table in the acore_auth database:
STOP the servers.
realmlist.sh

## Procedure
Every time acscs.sh is run it will check all AzerothCore's requierements and it will try to install or configure any of them missing.

## Hints
Add the next alias to your user's `.bash_aliases`:
```
alias wow="/home/your-user/wotlk/scripts/acscs/acscs.sh"
```
so you can call the script by simply typing `wow` in the shell.
