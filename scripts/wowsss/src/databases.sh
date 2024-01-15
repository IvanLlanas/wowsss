# ------------------------------------------------------------------------------
# function database_check_enable_admin_access ()
# function database_check_create_servers_access ()
# function database_import_from_script (database_name, sql_script)
# function databases_check_create()
# function initial_check_databases ()
# function database_get_realm_info ()
# function database_setup_realm ()
# function _database_check_table_exists (db, tablename)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# Tries to configure the initial database access.
# https://gist.github.com/alexwebgr/e438dcbb1eba91af8131736cfbfe9b80
# ------------------------------------------------------------------------------
function _mysql_secure_installation ()
{
   print_warning_message "$cons_msg_mysqladmin_user_password"

   case $var_current_dbengine in
    $DBENGINE_MARIADB)
         print_info_message "$cons_lit_configuring <b>$name_mariadb_full</b>..."
         sudo mysqladmin -u $var_db_user password "$var_db_pass"
         result=$?
         if [ $result -ne 0 ]; then
            print_fatal_error "Error @ mysqladmin 1"
         fi
         sudo mysqladmin -u $var_db_user -h localhost password "$var_db_pass"
         result=$?
         if [ $result -ne 0 ]; then
            print_fatal_error "Error @ mysqladmin 2"
         fi
         print_warning_message "ALTER USER (<b>$var_db_user</b>@localhost)..."
         mysql -u $var_db_user -p$var_db_pass -e "ALTER USER '$var_db_user'@'localhost' IDENTIFIED BY '$var_db_pass'; FLUSH PRIVILEGES"
         result=$?
         if [ $result -ne 0 ]; then
            print_fatal_error "Error @ ALTER-USER"
         fi
         ;;
    $DBENGINE_MYSQL)
         print_info_message "$cons_lit_configuring <b>$name_mysql_full</b>..."
         print_warning_message "ALTER USER (<b>$var_db_user</b>@localhost)..."
         sudo mysql -e "ALTER USER '$var_db_user'@'localhost' IDENTIFIED WITH caching_sha2_password BY '$var_db_pass'; FLUSH PRIVILEGES;"
         result=$?
         if [ $result -ne 0 ]; then
            print_fatal_error "Error @ ALTER-USER"
         fi
         ;;
    *)
         print_error_message "$cons_error_undefined_dbengine_q"
         exit
         ;;
   esac

   # These commands are also performed by mysql_secure_installation but they're
   # not required for WoWSSS to work so, let the user take care of it.
   # Kill off the demo database
   # sudo mysql -e "DROP DATABASE IF EXISTS test"
   # Kill the anonymous users
   # sudo mysql -e "DROP USER ''@'localhost'"
   # Because our hostname varies we'll use some Bash magic here. Nope.
   # sudo mysql -e "DROP USER ''@'$(hostname)'"
}

# ------------------------------------------------------------------------------
# function _database_check_create ()
# Check if database ($1) exists. If it does not exists it will try to create it.
# Quits on error.
# ------------------------------------------------------------------------------
function _database_check_create ()
{
   local db=$1
   local uparams="--user=$var_db_user --password=$var_db_pass"
   local query="USE $db"

   print_info_message "$cons_lit_checking_database <b>$db</b>..."

   mysql $uparams -e "$query" &> /dev/null
   result=$?
   if [ $result -ne 0 ]; then
      print_warning_message "$cons_lit_creating_database <b>$db</b>..."
      query="CREATE DATABASE \`$db\` DEFAULT CHARACTER SET UTF8MB4 COLLATE utf8mb4_general_ci"
      mysql $uparams -e "$query" &> /dev/null
      result=$?
      if [ $result -ne 0 ]; then
         print_fatal_error "$cons_lit_cannot_create_db <b>$db</b>."
      fi

      local host="localhost"
      local query="GRANT ALL PRIVILEGES ON \`$db\`.* TO '$var_db_servers_user'@'$host' WITH GRANT OPTION;"
      mysql $uparams -e "$query" &> /dev/null

      print_info_message "$cons_msg_done"
   fi
}

# ------------------------------------------------------------------------------
# Checks if the databases game required databases exist and creates them if not.
# ------------------------------------------------------------------------------
function databases_check_create ()
{
   _database_check_create "$var_db_auth_name"
   _database_check_create "$var_db_world_name"
   _database_check_create "$var_db_chars_name"

   if [[ $var_current_mode = $MODE_CATACLYSM ]]; then
      _database_check_create "$var_db_hotfixes_name"
   fi

   if [[ $var_current_mode = $MODE_MOP ]]; then
      # At this point we surely have the required SQL scripts.
      _database_check_table_exists "$var_db_auth_name" "realmlist" "$var_dir_sources/sql/base/auth.sql"
      _database_check_table_exists "$var_db_chars_name" "characters" "$var_dir_sources/sql/base/characters.sql"
      _database_check_table_exists "$var_db_world_name" "item_template" "$var_dir_sources/world_548_20231230.sql"
   fi
}

# ------------------------------------------------------------------------------
# Checks if we can access the database server with $var_db_user (root)
# and $var_db_pass. Quits on error.
# ------------------------------------------------------------------------------
function database_check_enable_admin_access ()
{
   # Can we login with var_db_user/var_db_pass?
   mysql -e "SHOW DATABASES" --user=$var_db_user --password=$var_db_pass &> /dev/null
   result=$?
   if [ $result -ne 0 ]
   then
      # Cannot access. Cannot continue until the server is properly configured.
      print_error_message "$cons_msg_error_db_cannot_access_server"
      print_warning_message "$cons_msg_db_setup_0_message"

      case $var_current_dbengine in
       $DBENGINE_MARIADB)
         print_text "$cons_msg_tips_setup_db_server_0"
         print_text "$cons_msg_tips_setup_db_server_0_mariadb_1"
         print_text "$cons_msg_tips_setup_db_server_0_mariadb_2"
         print_text "$cons_msg_tips_setup_db_server_0_mariadb_3"
         ;;
       $DBENGINE_MYSQL)
         print_text "MYSQL SPECIFIC INSTRUCTIONS!"
         print_text "$cons_msg_tips_setup_db_server_0"
         print_text "$cons_msg_tips_setup_db_server_0_mysql_1"
         print_text "$cons_msg_tips_setup_db_server_0_mysql_2"
         print_text "$cons_msg_tips_setup_db_server_0_mysql_3"
         ;;
      esac
      CR
      print_text "$cons_msg_db_setup_0_option_question"
      print_text "$cons_msg_db_setup_0_option_1"
      print_text "$cons_msg_db_setup_0_option_2"
      read_answer "$cons_msg_db_setup_enter_option"
      case $var_answer in
       "1")   read_confirmation "$cons_msg_db_setup_0_confirmation"
              if [ $var_confirmed ]; then
                 _mysql_secure_installation
                 # Let's try again after _mysql_secure_installation. Recursive!!! So, don't do it forever.
                 database_check_enable_admin_access
              else
                 print_fatal_error "$cons_msg_cannot_continue"
              fi
              ;;
         *)   print_info_message "$cons_msg_come_back_db_configured"
              exit
              ;;
      esac
   else
      print_info_message "$cons_msg_db_access_granted_1"
   fi
}

# ------------------------------------------------------------------------------
# function database_check_create_servers_access ()
# Checks if we can access the database server with $var_db_servers_user (wows)
# and $var_db_servers_pass and/or creates and sets up the database user.
# ------------------------------------------------------------------------------
function database_check_create_servers_access ()
{
   local user_just_created=
   # Can we login with var_db_servers_user/var_db_servers_pass?
   mysql -e "SHOW DATABASES" --user=$var_db_servers_user --password=$var_db_servers_pass &> /dev/null
   result=$?
   if [ $result -ne 0 ]
   then
      # User does not exists or invalid values. Let's create it!
      print_warning_message "$cons_msg_creating_server_user"
      local host="localhost"
      local queries="DROP USER IF EXISTS '$var_db_servers_user'@'$host';\
                      CREATE USER '$var_db_servers_user'@'$host' IDENTIFIED BY '$var_db_servers_pass' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0;\
                      GRANT ALL PRIVILEGES ON \`$var_db_world_name\`.* TO '$var_db_servers_user'@'$host' WITH GRANT OPTION;\
                      GRANT ALL PRIVILEGES ON \`$var_db_chars_name\`.* TO '$var_db_servers_user'@'$host' WITH GRANT OPTION;\
                      GRANT ALL PRIVILEGES ON \`$var_db_auth_name\`.*  TO '$var_db_servers_user'@'$host' WITH GRANT OPTION;"
      mysql -e "$queries" --user=$var_db_user --password=$var_db_pass
      result=$?
      if [ $result -ne 0 ]
      then
         print_fatal_error "$cons_msg_error_cannot_create_db_user"
      else
         print_info_message "$cons_msg_db_access_granted_2"
      fi
      user_just_created=1
   else
      print_info_message "$cons_msg_db_access_granted_2"
   fi
}

# ------------------------------------------------------------------------------
# function initial_check_databases ()
# Checks/creates the two accesses to the database manager and checks/creates
# the game databases.
# ------------------------------------------------------------------------------
function initial_check_databases ()
{
   print_full_width "$cons_msg_checking_databases"
   database_check_enable_admin_access
   database_check_create_servers_access
   databases_check_create
}

# ------------------------------------------------------------------------------
# function database_import_from_script (database_name, sql_script)
# Imports the given script ($2) into database ($1)
# ------------------------------------------------------------------------------
function database_import_from_script ()
{
   local db=$1
   local script=$2
   print_info_message "Importing \"<b>$db</b>\" database:"
   if test -f "$script"; then
      mysql -u $var_db_user -p $db < "$script"
   else
      print_error_message "File <b>$script</b> not found. Database <b>$db</b> bypassed."
   fi
}

# ------------------------------------------------------------------------------
# function database_get_realm_info ()
# ------------------------------------------------------------------------------
function database_get_realm_info ()
{
   var_realm_count=$(_get_realm_count)
   case $var_realm_count in
      1) var_realm_name=$(_get_realm_name)
         var_realm_external_ip=$(_get_realm_ip1)
         var_realm_internal_ip=$(_get_realm_ip2)
         ;;
      0) var_realm_name=$cons_lit_none_
         var_realm_external_ip=$cons_lit_none_
         var_realm_internal_ip=$cons_lit_none_
         ;;
      *) var_realm_name=$cons_lit_multiple_
         var_realm_external_ip=$cons_lit_multiple_
         var_realm_internal_ip=$cons_lit_multiple_
         ;;
   esac
}

# ------------------------------------------------------------------------------
# function database_setup_realm ()
# Changes de IPs of the realm in the current database.
# ------------------------------------------------------------------------------
function database_setup_realm ()
{
   local ext_ip=$1
   local int_ip=$2

   mysql -u $var_db_user -p$var_db_pass -e \
   "USE $var_db_auth_name; UPDATE realmlist SET address='$ext_ip', localAddress='$int_ip'"
}

# ------------------------------------------------------------------------------
# Returns the number of realms in the current database.
# ------------------------------------------------------------------------------
function _get_realm_count ()
{
   local result=`mysql -u $var_db_user -p$var_db_pass -e "USE $var_db_auth_name; SELECT COUNT(*) FROM realmlist;" | grep -v "COUNT"`
   local result2=$?
   if [ $result2 -ne 0 ]; then
      echo 0
   else
      echo $result
   fi
}

# ------------------------------------------------------------------------------
# Returns the the name of the realm in the current database.
# ------------------------------------------------------------------------------
function _get_realm_name ()
{
   local result=`mysql -u $var_db_user -p$var_db_pass -N -s -e "USE $var_db_auth_name; SELECT name FROM realmlist;"`
   local result2=$?
   if [ $result2 -ne 0 ]; then
      echo "[ERROR]"
   else
      echo $result
   fi
}

# ------------------------------------------------------------------------------
# function database_get_realm_ip1 ()
# Returns the the "address" of the realm in the current database.
# ------------------------------------------------------------------------------
function _get_realm_ip1 ()
{
   local result=`mysql -u $var_db_user -p$var_db_pass -N -s -e "USE $var_db_auth_name; SELECT address FROM realmlist;"`
   local result2=$?
   if [ $result2 -ne 0 ]; then
      echo "[ERROR]"
   else
      echo $result
   fi
}

# ------------------------------------------------------------------------------
# function database_get_realm_ip2 ()
# Returns the the "localAddress" of the realm in the current database.
# ------------------------------------------------------------------------------
function _get_realm_ip2 ()
{
   local result=`mysql -u $var_db_user -p$var_db_pass -N -s -e "USE $var_db_auth_name; SELECT localAddress FROM realmlist;"`
   local result2=$?
   if [ $result2 -ne 0 ]; then
      echo "[ERROR]"
   else
      echo $result
   fi
}

# ------------------------------------------------------------------------------
# function _database_check_table_exists (db, tablename)
# Returns the the "localAddress" of the realm in the current database.
# ------------------------------------------------------------------------------
function _database_check_table_exists ()
{
   local db=$1
   local table=$2
   local script=$3
   local SQL_EXISTS='USE '$db'; SHOW TABLES LIKE "'$table'"'

   local result=$(mysql -u $var_db_user -p$var_db_pass -e "$SQL_EXISTS" $DATABASE)
   local result2=$?

   if [ $result2 -ne 0 ]; then
      print_fatal_error "error_executing_dbclient"
   fi
   if [[ $result ]]; then
      return
#     # Table exists
#     local SQL_IS_EMPTY='USE '$db'; SELECT 1 FROM '$table' LIMIT 1'
#     # Check if table has records
#     if [[ $(mysql -u $var_db_user -p$var_db_pass -e "$SQL_IS_EMPTY" $DATABASE) ]]
#     then
#        # Table has records
#     else
#        # Table is empty
#     fi
   else
      # Table does not exists
      print_info_message "$cons_lit_database_populating <b>$db</b>."
      mysql -u $var_db_user -p$var_db_pass $db < $script
      result2=$?
      if [ $result2 -ne 0 ]; then
         print_fatal_error "$cons_lit_cannot_populate_db <b>$db</b>."
      fi
      print_warning_message "$cons_lit_database_populated <b>$db</b>."
   fi
}
