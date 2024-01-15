# ------------------------------------------------------------------------------
# function define_variables_1 ()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# function define_variables_1 ()
# ------------------------------------------------------------------------------
function define_variables_1 ()
{
   print_full_width "$cons_lit_starting <b>$cons_lit_product_name_long $cons_lit_product_version</b> ($cons_lit_product_date)..."

   # OS name and version -------------------------------------------------------
   var_os_hostname=$HOSTNAME
   if type lsb_release >/dev/null 2>&1; then
      # Get OS info from lsb_release
      var_os_name=$(lsb_release -si)
      var_os_version=$(lsb_release -sr)
      var_os_codename=$(lsb_release -sc)
      var_os_distribution="$var_os_name $var_os_version ($var_os_codename)"
      case $var_os_name in
        *"Ubuntu"*) var_os_is_ubuntu=1;;
        *"Debian"*) var_os_is_debian=1;;
        *) show_fatal_error "$cons_msg_unknown_linux_version";;
      esac
   else
      print_fatal_error "$cons_msg_unknown_linux_version"
   fi
   print_literal_value "$var_os_hostname - $var_os_distribution" "$cons_lit_host_os"

   # Current user name and current user home directory -------------------------
   var_os_username=$USER
   var_os_userid=$UID
   print_literal_value "$var_os_username$_ansi_off/$var_os_userid ($HOME)" "$cons_lit_user"

   # WoWSSS directories --------------------------------------------------------
   var_dir_wowsss_script=$(get_script_dir) # WoWSSS script directory
   # WoWSSS main directory
   var_dir_base=${var_dir_wowsss_script%/*/*} # Remove the last 2 subdirs (wowsss and scripts) from the current script's path.
   # Scripts directory
   var_dir_scripts="$var_dir_base/scripts"
   # Logs directory
   var_dir_logs="$var_dir_base/logs"
   # Docs directory
   var_dir_docs="$var_dir_base/docs"
   # Temp directory
   var_dir_temp="$var_dir_base/temp"
   # Backup directories
   var_dir_backup_local="$var_dir_base/backup"
   var_do_remote_backups=$REMOTE_BACKUPS
   var_dir_backup_remote="$REMOTE_BACKUPS_DIR"

   var_dir_media="$var_dir_base/media"
   # Sounds directory
   var_dir_sounds="$var_dir_media/sounds"
   # Sources directory
   var_dir_sources=
   var_dir_sources_wotlk="$var_dir_base/sources/wotlk"
   var_dir_sources_cataclysm="$var_dir_base/sources/cataclysm"
   var_dir_sources_mop="$var_dir_base/sources/mop"
   # Data directory
   var_dir_data=
   var_dir_data_wotlk="$var_dir_base/data/wotlk"
   var_dir_data_cataclysm="$var_dir_base/data/cataclysm"
   var_dir_data_mop="$var_dir_base/data/mop"
   # Servers directory
   var_dir_servers=
   var_dir_servers_wotlk="$var_dir_base/servers/wotlk"
   var_dir_servers_cataclysm="$var_dir_base/servers/cataclysm"
   var_dir_servers_mop="$var_dir_base/servers/mop"
   # Servers binaries
   var_dir_bin=
   var_dir_bin_wotlk="$var_dir_servers_wotlk/bin"
   var_dir_bin_cataclysm="$var_dir_servers_cataclysm/bin"
   var_dir_bin_mop="$var_dir_servers_mop/bin"
   # Servers directory
   var_dir_config=
   var_dir_config_wotlk="$var_dir_servers_wotlk/etc"
   var_dir_config_cataclysm="$var_dir_servers_cataclysm/etc"
   var_dir_config_mop="$var_dir_servers_mop/etc"

   # Server binaries (full path)
   var_bin_authserver=
   var_bin_worldserver=
   # Processes names
   var_db_process_name=
   var_as_process_name=
   var_ws_process_name=
   # and PIDs (-> top)
   var_pidof_dbserver=
   var_pidof_authserver=
   var_pidof_worldserver=
   # Session names for "screen". These could be constants, but I'll keep them here.
   var_session_auth="scr_auth"
   var_session_world="scr_world"
   # Return value of ensure_no_server_running
   var_no_server_running=

   # Availables installations
   var_wotlk_present=0
   var_cataclysm_present=0
   var_mop_present=0
   # Database engine being used during this session.
   var_current_dbengine=
   # Installation mode being used during this session.
   var_current_mode=$MODE_NONE
   var_current_mode_prefix=
   # Current descriptive server name
   var_server_name=
   # Used in function main to force a server mode switch.
   var_force_switch_mode=0
   # Amount of already installed modes.
   var_available_modes=0

   # Get the sources hash, if any.
   var_sources_hash=
   # Is there any servers sources update?
   var_sources_update_available=

   # MariaDB/MySQL user and password for script management.
   var_db_user=$DB_SCRIPT_USER
   var_db_pass=$DB_SCRIPT_USER_PASSWORD
   # MariaDB/MySQL user and password for AC/TC servers access.
   var_db_servers_user=$DB_SERVERS_USER
   var_db_servers_pass=$DB_SERVERS_USER_PASSWORD

   # Databases
   var_db_auth_name=
   var_db_auth_host=
   var_db_auth_port=
   var_db_world_name=
   var_db_world_host=
   var_db_world_port=
   var_db_chars_name=
   var_db_chars_host=
   var_db_chars_port=
   var_db_hotfixes_name=
   var_db_hotfixes_host=
   var_db_hotfixes_port=

   # Default wait seconds
   var_wait_seconds=2

   # Input
   var_answer=                # Used by read_answer as result.
   var_confirmed=             # Used by read_confirmation as result.

   # Amount of installed packages in installation phase.
   var_installed_packages=0

   # Amount of files in the data directory.
   var_data_files_count=0

   # Number of cores used to compile the sources. Use all =)
   var_compiler_cores=$CPU_CORES

   # System IP's
   var_internal_ip=
   var_external_ip=
   # get_ips # No, not yet. We'll get them just before showing the menu.
   
   # Realm info
   var_realm_name=
   var_realm_internal_ip=
   var_realm_external_ip=
}
