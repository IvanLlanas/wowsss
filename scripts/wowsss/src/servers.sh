# ------------------------------------------------------------------------------
# function main_menu_servers_start ()
# function main_menu_servers_stop ()
# function main_menu_top ()
# function server_restore_screen_session ()
# function servers_update_server_versions ()
# function server_version_no_date ()
# function servers_setup_default_config_files ()
# function update_pidof_servers ()
# function ensure_no_server_running ()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# function update_pidof_servers ()
# Updates the PID of the MySQL daemon process in "$var_pidof_db".
# ------------------------------------------------------------------------------
function update_pidof_servers ()
{
   var_pidof_dbserver=$(pidof $var_db_process_name)
   var_pidof_authserver=$(pidof $var_as_process_name)
   var_pidof_worldserver=$(pidof $var_ws_process_name)
}

# ------------------------------------------------------------------------------
# function ensure_no_server_running ()
# Checks if there's any of the servers running. If a server is running an error
# message is displayed and returns var_no_server_running set to true, false
# otherwise.
# ------------------------------------------------------------------------------
function ensure_no_server_running ()
{
   update_pidof_servers
   if [ $var_pidof_authserver ] || [ $var_pidof_worldserver ]
      then
      print_error_message "$cons_msg_error_servers_running"
      wait
      var_no_server_running=
   else
      var_no_server_running=1
   fi
}

# ------------------------------------------------------------------------------
# function servers_update_server_versions ()
# Adds a new line into docs/history-xxxx.txt with the new server version and
# updates the docs/version-xxxx.txt with the same text.
# ------------------------------------------------------------------------------
function servers_update_server_versions ()
{
   get_sources_hash # Update the current hash.
   local text="$var_server_name $(date +"%Y/%m/%d %H:%M:%S") ($var_sources_hash) - $var_os_distribution ($var_os_hostname)"
   echo  $text >> $var_dir_docs/history-$var_current_mode_prefix.txt
   echo  $text >  $var_dir_docs/version-$var_current_mode_prefix.txt
}

# ------------------------------------------------------------------------------
# function server_version_no_date ()
# Returns an approximated identifier of the current server mode.
# ------------------------------------------------------------------------------
function server_version_no_date ()
{
   get_sources_hash # Update the current hash.
   local text="$var_server_name ($var_sources_hash) - $var_os_distribution ($var_os_hostname)"
   echo "$text"
}

# ------------------------------------------------------------------------------
# function servers_setup_default_config_files ()
# In case the server config files don't exist, they'll be copied from their 
# .dist versions and updated with the current parameters.
# ------------------------------------------------------------------------------
function servers_setup_default_config_files ()
{
   local filename1=
   local filename2=
   local path=

   # Default *.conf files
   cd $var_dir_config

   # Automatic changes in authserver.conf/bnetserver.conf
   filename1="$var_as_process_name.conf"
   filename2="$filename1.dist"
   if [ ! -f "$filename1" ]; then
      if [ -f "$filename2" ]; then
         print_info_message "$cons_lit_configuring <b>$filename1</b>..."
         cp "$filename2" "$filename1"
         # sed -i "s/^${variable}\=.*/${variable}=\"${content}\"/" "${file}"
         # \s\{0,\} => any space
         path=${var_dir_logs//\//\\/}
         sed -i 's/LogsDir\s\{0,\}=.*/LogsDir = "'$path'"/' $filename1
         path=${var_dir_temp//\//\\/}
         sed -i 's/TempDir\s\{0,\}=.*/TempDir = "'$path'"/' $filename1
         # sed -i 's/MySQLExecutable\s\{0,\}=.*/MySQLExecutable = "\/usr\/bin\/mysql"/' $filename1
         sed -i 's/LoginDatabaseInfo\s\{0,\}=.*/LoginDatabaseInfo = "'$var_db_auth_host';'$var_db_auth_port';'$var_db_servers_user';'$var_db_servers_pass';'$var_db_auth_name'"/' $filename1

         if [ $var_current_mode = $MODE_MOP ]; then
            sed -i 's/Updates.EnableDatabases\s\{0,\}=.*/Updates.EnableDatabases = 0/' $filename1
         fi
         print_warning_message "<b>$var_dir_config/$filename1</b>: $cons_msg_automatic_file_check"
      else
         print_error_message "<b>$filename2</b> $cons_lit_not_found_"
      fi
   fi

   # Automatic changes in worldserver.conf
   filename1="$var_ws_process_name.conf"
   filename2="$filename1.dist"
   if [ ! -f "$filename1" ]; then
      if [ -f "$filename2" ]; then
         print_info_message "$cons_lit_configuring <b>$filename1</b>..."
         cp "$filename2" "$filename1"
         path=${var_dir_logs//\//\\/}
         sed -i 's/LogsDir\s\{0,\}=.*/LogsDir = "'$path'"/' $filename1
         path=${var_dir_data//\//\\/}
         sed -i 's/DataDir\s\{0,\}=.*/DataDir = "'$path'"/' $filename1
         path=${var_dir_temp//\//\\/}
         sed -i 's/TempDir\s\{0,\}=.*/TempDir = "'$path'"/' $filename1
         # sed -i 's/MySQLExecutable\s\{0,\}=.*/MySQLExecutable = "\/usr\/bin\/mysql"/' $filename1
         sed -i 's/LoginDatabaseInfo\s\{0,\}=.*/LoginDatabaseInfo     = "'$var_db_auth_host';'$var_db_auth_port';'$var_db_servers_user';'$var_db_servers_pass';'$var_db_auth_name'"/' $filename1
         sed -i 's/WorldDatabaseInfo\s\{0,\}=.*/WorldDatabaseInfo     = "'$var_db_world_host';'$var_db_world_port';'$var_db_servers_user';'$var_db_servers_pass';'$var_db_world_name'"/' $filename1
         sed -i 's/CharacterDatabaseInfo\s\{0,\}=.*/CharacterDatabaseInfo = "'$var_db_chars_host';'$var_db_chars_port';'$var_db_servers_user';'$var_db_servers_pass';'$var_db_chars_name'"/' $filename1
         if [ $var_current_mode = $MODE_CATACLYSM ]; then
            sed -i 's/HotfixDatabaseInfo\s\{0,\}=.*/HotfixDatabaseInfo    = "'$var_db_hotfixes_host';'$var_db_hotfixes_port';'$var_db_servers_user';'$var_db_servers_pass';'$var_db_hotfixes_name'"/' $filename1
         fi
         if [ $var_current_mode = $MODE_MOP ]; then
            sed -i 's/Updates.EnableDatabases\s\{0,\}=.*/Updates.EnableDatabases = 0/' $filename1
         fi
         print_warning_message "<b>$var_dir_config/$filename1</b>: $cons_msg_automatic_file_check"
      else
         print_error_message "<b>$filename2</b> $cons_lit_not_found_"
      fi
   fi

   if [[ $var_current_mode == $MODE_WOTLK ]]; then
      # No automatic changes in transmog.conf, just copy it.
      filename1="modules/transmog.conf"
      filename2="$filename1.dist"
      if [ ! -f "$filename1" ]; then
         if [ -f "$filename2" ]; then
            print_info_message "$cons_lit_configuring <b>$filename1</b>..."
            cp "$filename2" "$filename1"
            print_warning_message "<b>$var_dir_config/$filename1</b>: $cons_msg_automatic_file_check"
         else
            print_error_message "<b>$filename2</b> $cons_lit_not_found_"
         fi
      fi
   fi
}

# ------------------------------------------------------------------------------
# function main_menu_servers_start ()
# Menu option: Start the servers
# ------------------------------------------------------------------------------
function main_menu_servers_start ()
{
   local auth_just_loaded=
   print_full_width "$cons_option_start_server"

   update_pidof_servers

# Using "screen" to launch and retrieve the servers consoles.
# -A
#    Adapt the sizes of all windows to the size of the current terminal. By
#    default, screen tries to restore its old window sizes when attaching to
#    resizable terminals (those with WS in its description, e.g. suncmd or some
#    xterm).
# -m -d
#    Start screen in detached mode. This creates a new session but doesn't attach
#    to it. This is useful for system startup scripts.
# -S sessionname
#    When creating a new session, this option can be used to specify a meaningful
#    name for the  session. This name identifies the session for screen -list and
#    screen -r actions. It substitutes the default [tty.host] suffix. This name
#    should not be longer then 80 symbols.

   if [ $var_pidof_authserver ]
   then
      print_error_message "$cons_msg_error_authserver_running"
   else
      local server="$var_bin_authserver"
      if test -x "$server"; then
         print_info_message "$cons_msg_starting_authserver"
         # gnome-terminal --tab --title "AuthServer" -- bash -c "$server"
         # nohup "$server" > "$var_dir_logs/authserver.out" &
         # nohup "$server" > /dev/null &
         screen -AmdS  $var_session_auth  "$server"
         auth_just_loaded=1
      else
         print_error_message "$cons_msg_error_authserver_not_found"
      fi
      update_pidof_servers
   fi

   if [ $var_pidof_worldserver ]
   then
      print_error_message "$cons_msg_error_worldserver_running"
   else
      if [ $auth_just_loaded ]
      then
         # Give a couple of seconds to start AuthServer before starting
         # WorldServer.
         sleep 2
      fi
      local server="$var_bin_worldserver"
      if test -x "$server"; then
         print_info_message "$cons_msg_starting_worldserver"
         screen -AmdS  $var_session_world  "$server"
      else
         print_error_message "$cons_msg_error_worldserver_not_found"
      fi
      update_pidof_servers
   fi
}

# ------------------------------------------------------------------------------
# function main_menu_servers_stop ()
# Menu option: Stop the servers
# ------------------------------------------------------------------------------
function main_menu_servers_stop ()
{
   print_full_width "$cons_option_stop_server"
   update_pidof_servers
   if [ $var_pidof_authserver ]
   then
      print_info_message "$cons_msg_stopping_authserver"
      killall -e -w "$var_bin_authserver"
   else
      print_error_message "$cons_msg_error_authserver_not_running"
   fi
   if [ $var_pidof_worldserver ]
   then
      print_info_message "$cons_msg_stopping_worldserver"
      killall -e -w "$var_bin_worldserver"
   else
      print_error_message "$cons_msg_error_worldserver_not_running"
   fi
   update_pidof_servers
}

# ------------------------------------------------------------------------------
# function _screen_restore_session (session)
# Restore screen session given in $1
# ------------------------------------------------------------------------------
function server_restore_screen_session ()
{
   local session=$1
   print_full_width "$cons_msg_restoring_session_1 \"$session\"... $cons_msg_restoring_session_2"
   screen -r "$session"
}

# ------------------------------------------------------------------------------
# function main_menu_top ()
# Menu option: Process monitor
# ------------------------------------------------------------------------------
function main_menu_top ()
{
   update_pidof_servers
   local cmd="top "

   if [ $var_pidof_dbserver ]
      then
      cmd="$cmd -p $var_pidof_dbserver"
   fi
   if [ $var_pidof_authserver ]
      then
      cmd="$cmd -p $var_pidof_authserver"
   fi
   if [ $var_pidof_worldserver ]
      then
      cmd="$cmd -p $var_pidof_worldserver"
   fi

   $cmd
   clear
}
