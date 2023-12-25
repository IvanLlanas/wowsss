# Installing a TrinityCore/Cataclysm server
_World of Warcraft Server Script System_ documentation
Almost uncommmented quick guide to manually install a WoW-Cataclym server with TrinityCore on an Ubuntu 23.10 system:
[The Cataclysm Preservation Project](https://github.com/The-Cataclysm-Preservation-Project/TrinityCore)
For much more detailed information, visit [The Cataclysm Preservation Project](https://github.com/The-Cataclysm-Preservation-Project).

## Installing the pre-requisites
```
sudo apt update
sudo apt remove -y unattended-upgrades
sudo apt install -y git clang cmake make gcc g++ libssl-dev libbz2-dev libreadline-dev libncurses-dev libboost-all-dev p7zip -y
```

Decide if you'll use __MariaDB__:
```
sudo apt install -y mariadb-server libmariadb-dev libmariadb-dev-compat
```
or __MySQL__:
```
sudo apt install -y mysql-server libmysqlclient-dev
```
```
sudo update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100
sudo update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang 100
```

## Making the servers

### Preparing the destination directories
```
mkdir ~/cataclysm
mkdir ~/cataclysm/data
mkdir ~/cataclysm/logs
mkdir ~/cataclysm/temp
```

### Downloading the sources from github.com
```
cd ~/cataclysm
git clone https://github.com/The-Cataclysm-Preservation-Project/TrinityCore.git trinitycore
```

### Creating the makefiles
```
cd ~/cataclysm/trinitycore
mkdir build
cd ~/cataclysm/trinitycore/build
cmake ../ -DCMAKE_INSTALL_PREFIX=$HOME/cataclysm/server/ -DSERVERS=1 -DTOOLS=1 -DWITH_WARNINGS=1
```

### Building the servers and utilities
```
cd ~/cataclysm/trinitycore/build
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
#### MariaDB
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
GRANT ALL PRIVILEGES ON `cataclysm_auth`.*       TO 'wows'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON `cataclysm_characters`.* TO 'wows'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON `cataclysm_world`.*      TO 'wows'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON `cataclysm_hotfixes`.*   TO 'wows'@'localhost' WITH GRANT OPTION;
EXIT
```

### Donwloading required sql scripts
They will be required on starting `worldserver` for the first time.
```
cd ~/cataclysm/server/bin
wget https://github.com/The-Cataclysm-Preservation-Project/TrinityCore/releases/download/TDB434.22011/TDB_full_434.22011_2022_01_09.7z
7z x TDB_full_434.22011_2022_01_09.7z
rm TDB_full_434.22011_2022_01_09.7z
```

## Configuring the servers

### bnetserver
Create and edit the `bnetserver` configuration file:
```
cd ~/cataclysm/server/etc
cp bnetserver.conf.dist bnetserver.conf
nano bnetserver.conf
```
Make sure the next variables have the right values:
* __`LogsDir`__: directory where the log files will be written.
    *   `LogsDir="/home/wow/cataclysm/logs"`
* __`MySQLExecutable`__: client used to make bluk operation with the databases. Should be ok leaving it blank.
    *   `MySQLExecutable="/usr/bin/mysql"`
* __`LoginDatabaseInfo`__: authentication database name, host, port, user, password.
    *   `LoginDatabaseInfo = "127.0.0.1;3306;wows;1234;cataclysm_auth"`

### worldserver
Create and edit the `worldserver` configuration file:
```
cd ~/cataclysm/server/etc
cp worldserver.conf.dist worldserver.conf
nano worldserver.conf
```
Make sure the next variables have the right values:
* __`DataDir`__: directory where the log files will be written.
    *   `DataDir="/home/wow/cataclysm/data"`
* __`LogsDir`__: directory where the log files will be written.
    *   `LogsDir="/home/wow/cataclysm/logs"`
* __`MySQLExecutable`__: client used to make bulk operation with the databases. Should be ok leaving it blank.
    *   `MySQLExecutable="/usr/bin/mysql"`
* __`LoginDatabaseInfo`__: authentication database name, host, port, user, password.
    *   `LoginDatabaseInfo = "127.0.0.1;3306;wows;1234;cataclysm_auth"`
* __`WorldDatabaseInfo`__: authentication database name, host, port, user, password.
    *   `WorldDatabaseInfo = "127.0.0.1;3306;wows;1234;cataclysm_world"`
* __`CharacterDatabaseInfo`__: authentication database name, host, port, user, password.
    *   `CharacterDatabaseInfo = "127.0.0.1;3306;wows;1234;cataclysm_characters"`
* __`HotfixDatabaseInfo`__: authentication database name, host, port, user, password.
    *   `HotfixDatabaseInfo = "127.0.0.1;3306;wows;1234;cataclysm_hotfixes"`

Obviously there are many more variables to consider but these are the only ones necessary.

## Downloading the server data files

```
cd ~/cataclysm/data
wget https://github.com/IvanLlanas/The-Cataclysm-Preservation-Project-data-files/releases/download/v2312/data.7z
7z x data.7z
rm data.7z
```

## Creating and populating the databases
Launch the `worldserver` in order to create the missing databases:
```
cd ~/cataclysm/server/bin
./worldserver
```
Answer `yes` to create each of the four databases (`cataclysm_auth`, `cataclysm_characters`, `cataclysm_world` and `cataclysm_hotfixes`) when prompted.
Then the TDB_full* scripts and a lot of small scripts will be applies. Be patient.
When a __`TC>`__ prompt appears, the databases have been created. Type the next command at that prompt to shutdown the server:
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
use cataclysm_auth;
select * from realmlist;
```
We should see something like:
```
+----+---------+-----------+--------------+-----------------+------+------+------+----------+----------------------+------------+-----------+--------+-------------+
| id | name    | address   | localAddress | localSubnetMask | port | icon | flag | timezone | allowedSecurityLevel | population | gamebuild | Region | Battlegroup |
+----+---------+-----------+--------------+-----------------+------+------+------+----------+----------------------+------------+-----------+--------+-------------+
|  1 | Trinity | 127.0.0.1 | 127.0.0.1    | 255.255.255.0   | 8085 |    0 |    2 |        1 |                    0 |          0 |     15595 |      2 |           1 |
+----+---------+-----------+--------------+-----------------+------+------+------+----------+----------------------+------------+-----------+--------+-------------+
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
Launch the `bnetserver` in a terminal:
```
cd ~/cataclysm/server/bin
./bnetserver
```
Leave it there alone. And launch the `worldserver` in another terminal, both servers must be running simultaneously:
```
cd ~/cataclysm/server/bin
./worldserver
```
Wait for `worldserver` to load all the needed data from the databases.

### Creating an _administrator_ (gm) user
Now we have both servers running but no user can login yet. Let's create a gm user. The usernames are expected to be email addresses so an _at_ symbol (@) must be part of the username:
```
bnetaccount create admin@ adminpassword
```
This will return the account id (1#1, returned from the last command) we'll use in the next command to set de gm level to this account:
```
account set gmlevel 1#1 3 -1
```

### Creating a _player_ user
And to create a normal user to play:
```
bnetaccount create player@ playerpassword
```

## Updating the server sources and rebuilding them
Of course, the servers __must__ be stopped to do it.
```
cd ~/cataclysm/trinitycore
git pull origin master
cd ~/cataclysm/trinitycore/build
cmake ..
make clean
make
make install
```

## Ports to open for external connections
You have to have the ports __3724__ (3.3.5a / 4.3.4 authserver) and __8085__ (3.3.5a, 4.3.4 worldserver) and 1119, 8081, 8085, 8086 (master only) forwarded or open from your router / firewall, if you plan to have diferent version servers you will need to use a diferent worldserver ports for the other versions.
