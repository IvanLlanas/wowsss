echo ""
echo -n "You're about to remove+purge all packages used by WoWSSS. Break to cancel..."
read aaa

echo Removing utils...
   sudo apt remove --purge -y p7zip-full unzip gcp screen wget sox

echo Removing compilers...
   sudo apt remove --purge -y cmake make gcc g++ clang

echo Removing libraries...
   sudo apt remove --purge -y libssl-dev libbz2-dev libreadline-dev libncurses-dev libboost-all-dev

echo Removing database engines...
   sudo apt remove --purge -y mariadb-server mariadb-client mysql-server
   sudo apt remove --purge -y libmariadb-dev libmariadb-dev-compat
   sudo apt remove --purge -y default-libmysqlclient-dev
   sudo apt remove --purge -y libmysqlclient-dev
