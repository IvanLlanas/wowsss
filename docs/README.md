            __      __    __      __________________________
           /  \    /  \__/  \    /  \ _____/  _____/  _____/
           \   \/\/  /  _ \  \/\/   /____  \_____  \_____  \
            \       (  (_) )       /        \       \       \
             \__/\  /\____/\__/\  /_______  /_____  /_____  /
                  \/            \/        \/      \/      \/ 1.4

# _World of Warcraft_ Server Script System
[Github repository](https://github.com/IvanLlanas/wowsss)

## Description
WoWSSS is a script system designed to install and manage a _World of Warcraft_ private server from scratch.
It uses [AzerothCore](https://github.com/azerothcore/azerothcore-wotlk) for a "_Wrath of the Lich King_" server,
 [TrinityCore](https://github.com/The-Cataclysm-Preservation-Project/TrinityCore) for a "_Cataclysm_" server
and [Legends-of-Azeroth](https://github.com/Legends-of-Azeroth/Legends-of-Azeroth-Pandaria-5.4.8) for a "_Mists of Pandaria_" server.

## Installation
Supported (and tested) distributions: Ubuntu 24, Ubuntu 22(1), Linuxmint 22, Kubuntu 24, Lubuntu 24, Debian 12(1).
Just clone WoWSSS from [github](https://www.github.com/IvanLlanas/wowsss) anywhere in your (sudoer) user directory.
Copy file `settings.sh.dist` to `settings.sh`. Edit file `settings.sh` to setup your preferences.
Launch the `start.sh` or `wowsss.sh` scripts to start the installation and compilation process.
From now on, every time WoWSSS finds any server installation it will show the maintenance menu, where you'll be able to start/stop the servers, update and compile the sources and make backups.

### First start
Assuming you've configured or let WoWSSS configure the database servers, you have to start the game servers and let them do the databases job.
Wait for `worldserver` to populate the databases (`w` - to change to `worldserver` and watch the progress). Answer "_yes_" whenever it asks about populating an empty database.
Once you get the `worldserver` user prompt (`AC>` or `TC>`) you must create an account (an admin account would be wise):

(You can press `^A^D` to get back to the WoWSSS main menu at any time.)

| AzerothCore/WotLK                         | TrinitiyCore/Cataclysm                  | Legends-of-Azeroth/MoP |
| ------------------------------------------|-----------------------------------------| ------------------------|
| _Create and admin user_                   | _Create and admin user_                 | _Create and admin user_ |
| `AC> account create admin admin`          | `TC> bnetaccount create admin@ admin`   | `SF> account create admin admin` |
|                       | TC>Battle.net account created: admin@ with game account 1#1 |                         |
| `AC> account set gmlevel admin 3 -1`      | `TC> account set gmlevel 1#1 3 -1`      | `SF> account set gmlevel admin 3 -1` |
| _Create a player user_                    | _Create a player user_                  |  _Create a player user_ |
| `AC> account create player player`        | `TC> bnetaccount create player@ player` | `SF> account create player player` |
| _Shutdown the server_                     | _Shutdown the server_                   |  _Shutdown the server_  |
| `AC> shutdown server 1`                   | `TC> shutdown server 1`                 | `SF> shutdown server 1` |

Stop the servers.

Last step: configure the server IPs:

__`D`__) __Databases__ -> __`I`__) __Configure realm IPs__ -> __`1`__) __Private server__

Restart the servers. Configure your _Windows_ client and start playing.

(1) Issues with MySQL installation/configuration may happen.
