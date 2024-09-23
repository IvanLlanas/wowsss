# ------------------------------------------------------------------------------
# function define_constants_1 ()
# function define_constants_2 ()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# function define_constants_1 ()
# ------------------------------------------------------------------------------
function define_constants_1 ()
{
   cons_lit_product_name_short="WoWSSS"
   cons_lit_product_name_long="World of Warcraft Server Script System"
   cons_lit_product_version="1.2"
   cons_lit_product_date="2024-09-25"

   # ANSI codes - Uncomment those being used.
   # ----------
   # https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797
   _ansi_off="\e[0m"
   _ansi_black="\e[30m"
   _ansi_red="\e[31m"
#  _ansi_green="\e[32m"
#  _ansi_yellow="\e[33m"
  _ansi_blue="\e[34m"
#  _ansi_magenta="\e[35m"
#  _ansi_teal="\e[36m"
#  _ansi_gray="\e[37m"
   _ansi_dark_gray="\e[90m"
   _ansi_lime="\e[92m"
   _ansi_yellow="\e[93m"
   _ansi_cyan="\e[96m"
   _ansi_white="\e[97m"
#  _ansi_magenta="\e[95m"
# Background Black: [40m
   _ansi_bg_red="\e[41m"
   _ansi_bg_green="\e[42m"
   _ansi_bg_yellow="\e[43m"
   _ansi_bg_blue="\e[44m"
#  _ansi_bg_magenta="\e[45m"
#  _ansi_bg_cyan="\e[46m"
   _ansi_bg_white="\e[47m"
#  _ansi_blue2="\e[1;94m"
   _ansi_bg_dark_gray="\e[100m"
   _ansi_bg_yellow_light="\e[103m"
#  _ansi_bg_white_light="\e[107m"
#  _ansi_bg_cyan_light="\e[106m"

   _c_bold1=$_ansi_white
   _c_bold2=$_ansi_yellow
   _c_bold3=$_ansi_cyan

   _c_input=$_ansi_lime
   _c_disabled=$_ansi_dark_gray

   _c_menu_title=$_ansi_white
   _c_menu_text=$_ansi_cyan
   _c_menu_letter=$_ansi_white

   _c_wotlk_bg="\e[48;5;87m"
   _c_wotlk_fg="\e[38;5;18m"
   _c_cataclysm_bg="\e[48;5;88m"
   _c_cataclysm_fg="\e[38;5;214m"
   _c_mop_bg="\e[48;5;28m"
   _c_mop_fg="\e[38;5;230m"

   # Messages
   _bold1='<b>'    # Bold text delimiter 1 - do not use spaces!
   _bold0='</b>'   # Bold text delimiter 2 - do not use spaces!

   # Session modes
   MODE_NONE=0
   MODE_WOTLK=1
   MODE_CATACLYSM=2
   MODE_MOP=3

   # Database engines
   DBENGINE_NONE=0
   DBENGINE_MYSQL=1

   cons_wotlk_db_auth_name=$WOTLK_DB_AUTH_NAME
   cons_wotlk_db_world_name=$WOTLK_DB_WORLD_NAME
   cons_wotlk_db_characters_name=$WOTLK_DB_CHARACTERS_NAME
   cons_cataclysm_db_auth_name=$CATACLYSM_DB_AUTH_NAME
   cons_cataclysm_db_world_name=$CATACLYSM_DB_WORLD_NAME
   cons_cataclysm_db_characters_name=$CATACLYSM_DB_CHARACTERS_NAME
   cons_cataclysm_db_hotfixes_name=$CATACLYSM_DB_HOTFIXES_NAME
   cons_mop_db_auth_name=$MOP_DB_AUTH_NAME
   cons_mop_db_world_name=$MOP_DB_WORLD_NAME
   cons_mop_db_characters_name=$MOP_DB_CHARACTERS_NAME
   cons_wotlk_db_auth_host=$WOTLK_DB_AUTH_HOST
   cons_wotlk_db_world_host=$WOTLK_DB_WORLD_HOST
   cons_wotlk_db_characters_host=$WOTLK_DB_CHARACTERS_HOST
   cons_cataclysm_db_auth_host=$CATACLYSM_DB_AUTH_HOST
   cons_cataclysm_db_world_host=$CATACLYSM_DB_WORLD_HOST
   cons_cataclysm_db_characters_host=$CATACLYSM_DB_CHARACTERS_HOST
   cons_cataclysm_db_hotfixes_host=$CATACLYSM_DB_HOTFIXES_HOST
   cons_mop_db_auth_host=$MOP_DB_AUTH_HOST
   cons_mop_db_world_host=$MOP_DB_WORLD_HOST
   cons_mop_db_characters_host=$MOP_DB_CHARACTERS_HOST
   cons_wotlk_db_auth_port=$WOTLK_DB_AUTH_PORT
   cons_wotlk_db_world_port=$WOTLK_DB_WORLD_PORT
   cons_wotlk_db_characters_port=$WOTLK_DB_CHARACTERS_PORT
   cons_cataclysm_db_auth_port=$CATACLYSM_DB_AUTH_PORT
   cons_cataclysm_db_world_port=$CATACLYSM_DB_WORLD_PORT
   cons_cataclysm_db_characters_port=$CATACLYSM_DB_CHARACTERS_PORT
   cons_cataclysm_db_hotfixes_port=$CATACLYSM_DB_HOTFIXES_PORT
   cons_wotlk_db_auth_port=$MOP_DB_AUTH_PORT
   cons_wotlk_db_world_port=$MOP_DB_WORLD_PORT
   cons_wotlk_db_characters_port=$MOP_DB_CHARACTERS_PORT

   # Update REMOTE_BACKUPS_DIR using functions.
   if [ ! $REMOTE_BACKUPS_DIR ]; then
      REMOTE_BACKUPS_DIR=$(get_base_dir)/backup/remote
   fi

   # Texts and messages
   indent_op="     "    # Menu option indentation
   indent_sh="  "       # Short indentation

   cons_lit_starting="Starting"
   cons_lit_initializing_="Initializing "

   name_mysql_full="MySQL"
   name_wotlk_full="Wrath of the Lich King (AzerothCore)"
   name_cataclysm_full="Cataclysm (TrinityCore)"
   name_mop_full="Mists of Pandaria (Legends-of-Azeroth)"
   cons_lit_woltk_server_name="AzerothCore-WotLK"
   cons_lit_cataclysm_server_name="TrinityCore-Cataclysm"
   cons_lit_mop_server_name="LegendsOfAzeroth-MoP"
   cons_wotlk_prefix="wotlk"
   cons_cataclysm_prefix="cataclysm"
   cons_mop_prefix="mop"

   cons_confirmation="ok"
   cons_msg_not_confirmed="Not confirmed."
   cons_msg_type_ok_to_=" Type '<b>$cons_confirmation</b>' to "
   cons_msg_press_enter_to_continue="Press ENTER to continue..."

   cons_lit_disabled_="(disabled)"
   cons_install="install"
   cons_lit_host_os="Host OS"
   cons_lit_user="User"
   cons_lit_installed_packages="Installed packages"
   cons_lit_not_found_="not found!"
   cons_lit_files="Files"
   cons_msg_cannot_continue="Cannot continue."
   cons_msg_quitting="Quitting."
   cons_msg_done="Done."
   cons_msg_unknown_linux_version="Unknown Linux version."
   cons_lit_running="Running"
   cons_lit_stopped="Stopped"
   cons_lit_n_a="  N/A  "
   cons_lit_host="       Host"
   cons_lit_realm_name=" Realm name"
   cons_lit_internal_ip="Internal IP"
   cons_lit_external_ip="External IP"
   cons_lit_cores="cores"
   cons_lit_none_="[none]"
   cons_lit_multiple_="[multiple]"

   cons_mode_selection_1="${indent_sh}Select the server mode you desire:"
   cons_option_mode_wotlk="${indent_op}1 - $name_wotlk_full"
   cons_option_mode_cataclysm="${indent_op}2 - $name_cataclysm_full"
   cons_option_mode_mop="${indent_op}3 - $name_mop_full"
   cons_mode_selection_2="${indent_sh}Select option (1-3): "

   cons_lit_info_host_os="                 Host OS"
   cons_lit_info_user="                    User"
   cons_lit_info_internal_ip="             Internal IP"
   cons_lit_info_external_ip="             External IP"
   cons_lit_info_dbengine="         Database engine"
   cons_lit_info_mode="     Current server mode"
   cons_lit_info_sources_dir="       Sources directory"
   cons_lit_info_servers_dir="        Server directory"
   cons_lit_info_authserver="   Authentication server"
   cons_lit_info_worldserver="            World server"
   cons_lit_info_data_dir="          Data directory"
   cons_lit_info_conf_dir="Configurations directory"
   cons_lit_info_scripts_dir="       Scripts directory"
   cons_lit_info_logs_dir="          Logs directory"
   cons_lit_info_docs_dir="     Documents directory"
   cons_lit_info_temp_dir="      Temporal directory"
   cons_lit_info_backup_dir="        Backup directory"
   cons_lit_info_backup_remote_dir=" Remote backup directory"
   cons_lit_info_db_auth="  Authorization database"
   cons_lit_info_db_chars="     Characters database"
   cons_lit_info_db_world="          World database"
   cons_lit_info_db_hotfixes="       Hotfixes database"

   cons_error_undefined_mode_q="Undefined server mode. Quitting..."
   cons_error_undefined_dbengine_q="Undefined database engine. Quitting..."

   cons_msg_checking_server_sources="Checking <b>server sources</b>:"
   cons_msg_binaries_found="Server binaries found. Bypassing sources checking."
   cons_msg_deleting_old_sources="Deleting old sources..."
   cons_msg_cloning_sources="Downloading <b>server sources</b> from <b>github.com</b>..."
   cons_msg_error_dwnd_sources="Error downloading <b>server sources</b>."
   cons_msg_error_dwnd_mods="Error downloading <b>modules sources</b>."
   cons_msg_cloning_transmog_mod="Downloading <b>TransMog</b> module..."
   cons_msg_creating_make_files="Creating <b>make</b> files..."
   cons_msg_error_creating_make_files="Error creating <b>make</b> files."
   cons_lit_sources_version_found="Sources version found"
   cons_lit_configuring="Configuring"
   cons_msg_sources_update_available="An update for this server sources is available."

   cons_msg_checking_wowsss_req_packages="Checking <b>WoWSSS</b> required packages:"
   cons_msg_checking_server_req_packages="Checking <b>server</b> required packages:"
   cons_msg_checking_database_req_packages="Checking <b>database server</b> required packages:"
   cons_msg_backing_up_dist_cfg_files="Backing up old <b>distribution config files</b>..."
   cons_msg_make_install="Make <b>install</b>..."
   cons_msg_automatic_file_check="This file has been automatically generated. You should check it out."

   cons_msg_checking_data="Checking <b>data</b> directory:"
   cons_msg_error_download_data="Could not download data files archive."
   cons_msg_error_extracting_data="Error extracting data files from archive."
   cons_msg_checking_sql="Checking <b>sql</b> files:"
   cons_msg_error_download_sql="Could not download sql files archive."
   cons_msg_error_extracting_sql="Error extracting sql files from archive."

   cons_msg_checking_databases="Checking <b>databases</b>:"
   cons_msg_db_access_granted="Access granted to database server."
   cons_lit_checking_database="Checking database"
   cons_lit_creating_database="Creating database"
   cons_lit_cannot_create_db="Cannot create database"
   cons_lit_cannot_populate_db="Cannot populate database"
   cons_lit_database_populated="Database populated"
   cons_lit_database_populating="Populating database"

   cons_msg_restoring_session_1="Restoring session"
   cons_msg_restoring_session_2="Press <b>Ctrl+A</b> + <b>Ctrl+D</b> to return."
   cons_msg_error_authserver_running="<b>Authentication server</b> already running."
   cons_msg_starting_authserver="Starting <b>Authentication server</b>..."
   cons_msg_error_authserver_not_found="<b>Authentication server</b> binary not found."
   cons_msg_error_worldserver_running="<b>World server</b> already running."
   cons_msg_starting_worldserver="Starting <b>World server</b>..."
   cons_msg_error_worldserver_not_found="<b>World server</b> binary not found."
   cons_msg_stopping_authserver="Shutting down <b>Authentication server</b>..."
   cons_msg_stopping_worldserver="Shutting down <b>World server</b>..."
   cons_msg_error_authserver_not_running="<b>Authentication server</b> is not running."
   cons_msg_error_worldserver_not_running="<b>World server</b> is not running."
   cons_msg_error_servers_running="Servers are running. Shut them down first before continuing."

   cons_msg_good_bye="Good bye!"
   cons_msg_error_invalid_option_="Invalid option "
   cons_msg_choose_an_option=" Please, choose an option: "
   cons_option_server_information="Show servers information"
   cons_lit_server_information="Servers information"
   cons_option_configure_realm_ips="Configure realm IPs"
   cons_option_back="Back"
   cons_option_start_server="Start the servers"
   cons_option_stop_server="Stop the servers"
   cons_option_process_monitor="Server processes monitor"
   cons_option_sources_menu="Sources"
   cons_option_databases_menu="Databases"
   cons_option_backups_menu="Backups"
   cons_option_backup_databases_critical="Save critical databases (auth and characters)"
   cons_option_backup_databases_other="Save other databases (world and hotfixes)"
   cons_option_backup_servers="Save servers files (binaries, sources and data directory excluded)"
   cons_option_backup_sources="Save current servers sources"
   cons_option_backup_data="Save data directory"
   cons_option_backup_all="Save all (data directory excluded)"
   cons_option_visit_site="Visit github.com site."
   cons_option_sources_download="Remove current sources and download them from github"
   cons_option_sources_update="Update current sources from github"
   cons_option_sources_compile="Compile and install servers and tools"
   cons_option_restore_databases="Restore databases"
   cons_option_switch_server_mode="Switch to another server mode"
   cons_option_quit="Quit"
   cons_title_main_menu="Main menu"
   cons_title_sources_menu="Sources menu"
   cons_title_databases_menu="Databases menu"
   cons_title_backups_menu="Backups menu"

   cons_msg_copying_to_remote_="Copying to remote backup folder"
   cons_lit_extracting="Extracting"
   cons_msg_compressing="Compressing..."
   cons_msg_cleaning="Cleaning..."

   cons_msg_checking_updates_for_="Checking updates for "

   cons_lit_apply="apply"
   cons_lit_cancelled="Cancelled"
   cons_lit_server_connection_mode="Server connection mode"
   cons_lit_public_server="Public server"
   cons_lit_public_server_remark="(Accept connections from the Internet)"
   cons_lit_private_server="Private server"
   cons_lit_private_server_remark="(Accept only connections from the local network)"
   cons_msg_select_ip_mode_for_="Select IP mode for "
   cons_error_applying_changes="Error applying changes."

   # URL's
   # cons_wotlk_data_url="https://github.com/wowgaming/client-data/releases/download/v16/data.zip"
   cons_url_wotlk_sources_github="https://github.com/azerothcore/azerothcore-wotlk.git"
   cons_url_wotlk_sources_project="https://github.com/azerothcore/azerothcore-wotlk"
   cons_url_catacysm_sources_github="https://github.com/The-Cataclysm-Preservation-Project/TrinityCore.git"
   cons_url_catacysm_sources_project="https://github.com/The-Cataclysm-Preservation-Project/TrinityCore"
   cons_url_mop_sources_github="https://github.com/Legends-of-Azeroth/Legends-of-Azeroth-Pandaria-5.4.8.git"
   cons_url_mop_sources_project="https://github.com/Legends-of-Azeroth/Legends-of-Azeroth-Pandaria-5.4.8"

   cons_url_wotlk_data="https://github.com/IvanLlanas/wotlk-server-data-files/releases/download/v16/data.7z"
   cons_url_cataclysm_data="https://github.com/IvanLlanas/cataclysm-server-data-files/releases/download/v2312/data.7z"
   # cons_url_cataclysm_sql="https://github.com/IvanLlanas/cataclysm-server-sql-files/releases/download/v2201/sql-files.7z"
   cons_url_cataclysm_sql="https://github.com/The-Cataclysm-Preservation-Project/TrinityCore/releases/download/TDB434.22011/TDB_full_434.22011_2022_01_09.7z"
   cons_url_mop_data="https://github.com/IvanLlanas/mop-server-data-files/releases/download/v2401/data.7z"
   cons_url_mop_sql="https://github.com/Legends-of-Azeroth/Legends-of-Azeroth-Pandaria-5.4.8/releases/download/WDB20231230/world_548_20231230.7z"

   # Linux packages
   cons_packages_wowsss="git p7zip-full unzip gcp screen wget sox"

   cons_packages_ubuntu_wotlk="cmake make gcc g++ clang libssl-dev libbz2-dev libreadline-dev libncurses-dev libboost-all-dev"
   cons_packages_ubuntu_wotlk_mysql="mysql-server libmysqlclient-dev"

   cons_packages_ubuntu_cataclysm="cmake make gcc g++ clang libssl-dev libbz2-dev libreadline-dev libncurses-dev libboost-all-dev"
   cons_packages_ubuntu_cataclysm_mysql=$cons_packages_ubuntu_wotlk_mysql

   cons_packages_ubuntu_mop="cmake make gcc g++ clang libssl-dev libbz2-dev libreadline-dev libncurses-dev libboost-all-dev libace-dev"
   cons_packages_ubuntu_mop_mysql=$cons_packages_ubuntu_wotlk_mysql

   # Application to play a sound file (ogg) and its command line parameters.
   cons_playsound="play -q"

   # Sound files
   cons_snd_error1="are-you-challenging-me.ogg"
   cons_snd_error2="thats-not-funny.ogg"
   cons_snd_error3="you-dispute-my-honor.ogg"
   cons_snd_done1="work-complete.ogg"
   cons_snd_ready1="lok-tar.ogg"

   # Menu columns coordinates
   mn_c1_letter=3
   mn_c1_text=6
   mn_c2_letter=50
   mn_c2_text=53
}

# ------------------------------------------------------------------------------
# function define_constants_2 ()
# ------------------------------------------------------------------------------
function define_constants_2 ()
{
   cons_option_restore_as_console="Restore $var_as_process_name console (^A^D)"
   cons_option_restore_ws_console="Restore $var_ws_process_name console (^A^D)"

   cons_msg_error_db_cannot_access_server="Cannot access the database server. You should check the <b>DB_SCRIPT_USER</b> and <b>DB_SCRIPT_USER_PASSWORD</b> variables in your <b>$var_dir_wowsss_script/settings.sh</b> file or manually configure your database server."

   cons_msg_db_setup_0_message="In case this is a fresh installation or your database server is not configured yet I can do this for you (not recommended) or you can do it by yourself (recommended)."
   cons_msg_tips_setup_db_server_0="To configure your server with the values in your <b>$var_dir_wowsss_script/settings.sh</b> file you can do:"
   cons_msg_tips_setup_db_server_0_mysql_1="${indent_op}$ sudo mysql_secure_installation"
   cons_msg_tips_setup_db_server_0_mysql_2="${indent_op}$ sudo mysql"
   cons_msg_tips_setup_db_server_0_mysql_3="${indent_op}mysql> ALTER USER '$var_db_user'@'localhost' IDENTIFIED WITH caching_sha2_password BY '$var_db_pass'; FLUSH PRIVILEGES;"

   cons_msg_db_setup_0_option_question="$cons_msg_db_setup_0_option_question"
   cons_msg_db_setup_0_option_1="${indent_op}1 - Yes, please, make these changes for me and put my database server at risk."
   cons_msg_db_setup_0_option_2="${indent_op}2 - Naah, thanks, I don't trust you, I'll do this myself."
   cons_msg_db_setup_enter_option="${indent_sh}Enter option (1-2): "
   cons_msg_db_setup_0_confirmation="automatically setup the databases and the server"
   cons_msg_come_back_db_configured="Come back once you've configured the database server and checked the <b>$var_dir_wowsss_script/settings.sh</b> file."

   cons_msg_mysqladmin_user_password="Using <b>mysqladmin</b> to set user password: <b>$var_db_user</b> + <b>$var_db_user</b>@localhost"
   cons_msg_creating_server_user="Creating users <b>$var_db_servers_user</b> + <b>$var_db_servers_user</b>@localhost..."
   cons_msg_error_cannot_create_db_user="Cannot create database server user <b>$var_db_servers_user</b>."
   cons_msg_db_access_granted_1="Access granted to user <b>$var_db_user</b> to database server."
   cons_msg_db_access_granted_2="Access granted to user <b>$var_db_servers_user</b> to database server."

   cons_msg_restore_db_1="<b>WARNING</b>"
   cons_msg_restore_db_2="   This process will try to restore all databases from their sql scripts."
   cons_msg_restore_db_3="   These scripts must be placed in directory <b>sql_dir</b>."
   cons_msg_restore_db_4="   Database <b>$var_db_auth_name</b> will be restored from script <b>$var_db_auth_name.sql</b>."
   cons_msg_restore_db_5="   Database <b>$var_db_chars_name</b> will be restored from script <b>$var_db_chars_name.sql</b>."
   cons_msg_restore_db_6="   Database <b>$var_db_world_name</b> will be restored from script <b>$var_db_world_name.sql</b>."
   cons_msg_restore_db_7_c="   Database <b>$var_db_hotfixes_name</b> will be restored from script <b>$var_db_hotfixes_name.sql</b>."
   cons_msg_restore_db_8="   <b>Current database contents will be OVERRIDEN</b>.</b>"

   cons_error_no_realm_found="No realm found in table <b>$var_db_auth_name.realmlist</b>."
   cons_error_multiple_realm_found="Multiple realms found in table <b>$var_db_auth_name.realmlist</b>. This needs a manual configuration, and you know it."
}
