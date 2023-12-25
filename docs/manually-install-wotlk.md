# Installing a AzerothCore/WotLK server
_World of Warcraft Server Script System_ documentation
Almost uncommmented quick guide to manually install a WoW-WotLK server with AzerothCore on an Ubuntu 23.10 system:
[AzerothCore-WotLK](https://github.com/azerothcore/azerothcore-wotlk)
For much more detailed information, visit [AzerothCore](https://www.azerothcore.org/).

## Installing the pre-requisites
```
sudo apt update
sudo apt remove -y unattended-upgrades
sudo apt install -y git clang cmake make gcc g++ libssl-dev libbz2-dev libreadline-dev libncurses-dev libboost-all-dev p7zip -y
```

Decide if you'll use __MariaDB__:
```
sudo apt install -y mariadb-server mariadb-client libmariadb-dev libmariadb-dev-compat
```
or __MySQL__:
```
sudo apt install -y mysql-server libmysqlclient-dev
```

## Making the servers

### Preparing the destination directories
```
mkdir ~/wotlk
mkdir ~/wotlk/data
mkdir ~/wotlk/logs
mkdir ~/wotlk/temp
```

### Downloading the sources from github.com
```
cd ~/wotlk
git clone https://github.com/azerothcore/azerothcore-wotlk.git --branch master --single-branch azerothcore
```

### Creating the makefiles
```
cd ~/wotlk/azerothcore
mkdir build
cd ~/wotlk/azerothcore/build
cmake ../ -DCMAKE_INSTALL_PREFIX=/home/wow/wotlk/server/ -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++ -DWITH_WARNINGS=1 -DTOOLS_BUILD=maps-only -DSCRIPTS=static -DMODULES=static
```

### Building the servers and utilities
```
cd ~/wotlk/azerothcore/build
make
make install
```

## Configuring the database server

### Initial configuration
Only for new installations:
```
sudo mysql_secure_installation
```
`root` password wil not be working yet.
### Configuring `root` password
For __MariaDB__:
```
sudo mysqladmin -u root password 1234
sudo mysqladmin -u root -h localhost password 1234
```
Now `root` password should be working.

#### MySQL
Since root password has not been initialized and the user can use sudo
```
sudo mysql
```
```
USE mysql;
SELECT user,authentication_string,plugin,host FROM mysql.user;
ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY '1234';
FLUSH PRIVILEGES;
EXIT;
```
Now `root` password should be working.

### Creating a new database user
```
mysql -u root -p1234
```
```
DROP USER IF EXISTS 'wows'@'localhost';
CREATE USER 'wows'@'localhost' IDENTIFIED BY '1234' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0;
GRANT ALL PRIVILEGES ON `wotlk_auth`.*       TO 'wows'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON `wotlk_characters`.* TO 'wows'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON `wotlk_world`.*      TO 'wows'@'localhost' WITH GRANT OPTION;
EXIT
```

## Configuring the servers

### authserver
Create and edit the `authserver` configuration file:
```
cd ~/wotlk/server/etc
cp authserver.conf.dist authserver.conf
nano authserver.conf
```
Make sure the next variables have the right values:
* __`LogsDir`__: directory where the log files will be written.
    *   `LogsDir="/home/wow/wotlk/logs"`
* __`MySQLExecutable`__: client used to make bulk operation with the databases. Should be ok leaving it blank.
    *   `MySQLExecutable="/usr/bin/mysql"`
* __`LoginDatabaseInfo`__: authentication database name, host, port, user, password.
    *   `LoginDatabaseInfo = "127.0.0.1;3306;wows;1234;wotlk_auth"`

### worldserver
Create and edit the `worldserver` configuration file:
```
cd ~/wotlk/server/etc
cp worldserver.conf.dist worldserver.conf
nano worldserver.conf
```
Make sure the next variables have the right values:
* __`DataDir`__: directory where the log files will be written.
    *   `DataDir="/home/wow/wotlk/data"`
* __`LogsDir`__: directory where the log files will be written.
    *   `LogsDir="/home/wow/wotlk/logs"`
* __`TempDir`__: directory where the log files will be written.
    *   `TempDir="/home/wow/wotlk/temp"`
* __`MySQLExecutable`__: client used to make bluk operation with the databases. Should be ok leaving it blank.
    *   `MySQLExecutable="/usr/bin/mysql"`
* __`LoginDatabaseInfo`__: authentication database name, host, port, user, password.
    *   `LoginDatabaseInfo = "127.0.0.1;3306;wows;1234;wotlk_auth"`
* __`WorldDatabaseInfo`__: authentication database name, host, port, user, password.
    *   `WorldDatabaseInfo = "127.0.0.1;3306;wows;1234;wotlk_world"`
* __`CharacterrsDatabaseInfo`__: authentication database name, host, port, user, password.
    *   `CharacterDatabaseInfo = "127.0.0.1;3306;wows;1234;wotlk_characters"`
* __`HotfixDatabaseInfo`__: authentication database name, host, port, user, password.
    *   `HotfixDatabaseInfo = "127.0.0.1;3306;wows;1234;wotlk_hotfixes"`

Obviously there are many more variables to consider but these are the only ones necessary.

## Downloading the server data files

```
cd ~/wotlk/data
wget https://github.com/wowgaming/client-data/releases/download/v16/data.zip
unzip data.zip
rm data.zip
```

## Creating and populating the databases
Launch the `worldserver` in order to create the missing databases:
```
cd ~/wotlk/server/bin
./worldserver
```
Answer `yes` to create each of the three databases (`wotlk_auth`, `wotlk_characters` and `wotlk_world`) when prompted.
When a __`AC>`__ prompt appears, the databases have been created. Type the next command at that prompt to shutdown the server:
```
server shutdown 1
```

## Updating the realm IP addresses
To get your server __internal__ IP address:
```
hostname -I
```
To get your server __external__ IP address:
```
dig +short myip.opendns.com @resolver4.opendns.com
```
or (this one requires curl package installed)
```
curl -s http://whatismyip.akamai.com/
```

Once we have both IP's
```
mysql -u root -p1234
```
```
use wotlk_auth;
select * from realmlist;
```
We should see something like:
```
+----+-------------+-----------+--------------+-----------------+------+------+------+----------+----------------------+------------+-----------+
| id | name        | address   | localAddress | localSubnetMask | port | icon | flag | timezone | allowedSecurityLevel | population | gamebuild |
+----+-------------+-----------+--------------+-----------------+------+------+------+----------+----------------------+------------+-----------+
|  1 | AzerothCore | 127.0.0.1 | 127.0.0.1    | 255.255.255.0   | 8085 |    0 |    0 |        1 |                    0 |          0 |     12340 |
+----+-------------+-----------+--------------+-----------------+------+------+------+----------+----------------------+------------+-----------+
```
To accept connections from another computers we'll have to change the __`address`__ field. To accept connection from computers __inside__ your private network you'll have to use your internal IP address. To accept connection from computers __outside__ your private network, through the router, you'll have to use your external IP address:
```
UPDATE realmlist SET address="192.168.1.100";
```
assuming 192.168.1.100 is your server IP address.
And for changing your realm name:
```
UPDATE realmlist SET name="For the Horde";
```

## Starting the servers
Launch the `authserver` in a terminal:
```
cd ~/wotlk/server/bin
./authserver
```
Leave it there alone. And launch the `worldserver` in another terminal, both servers must be running simultaneously:
```
cd ~/wotlk/server/bin
./worldserver
```
Wait for `worldserver` to load all the needed data from the databases.

### Creating an _administrator_ (gm) user
Now we have both servers running but no user can login yet. Let's create a gm user. The usernames are expected to be email addresses so an _at_ symbol (@) must be part of the username:
```
account create admin adminpassword
account set gmlevel admin 3 -1
```

### Creating a _player_ user
And to create a normal user to play:
```
account create player playerpassword
```

## Updating the server sources and rebuilding them
Of course, the servers __must__ be stopped to do it.
```
cd ~/wotlk/azerothcore
git pull origin master
cd ~/wotlk/azerothcore/build
cmake ..
make clean
make
make install
```

## Ports to open for external connections
You have to have the ports __3724__ (3.3.5a / 4.3.4 authserver) and __8085__ (3.3.5a, 4.3.4 worldserver) and 1119, 8081, 8085, 8086 (master only) forwarded or open from your router / firewall, if you plan to have diferent version servers you will need to use a diferent worldserver ports for the other versions.
