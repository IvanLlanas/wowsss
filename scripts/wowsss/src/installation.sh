# ------------------------------------------------------------------------------
# function is_package_installed (package_name)
# function select_server_mode (n)
# function detect_or_select_server_mode ()
# function select_dbengine ()
# function detect_or_select_dbengine ()
#
# function initial_check_data_files ()
# function initial_check_sql_files ()
# function initial_check_required_packages ()
# function initial_check_server_binaries ()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# function select_server_mode (n)
# Asks the user which server mode is to be started.
# n specifies the status of the installation:
#   0 - Some installations were detected, disable all detected installations.
#   1 - No installation was detected, show all of them enabled.
# ------------------------------------------------------------------------------
function select_server_mode ()
{
   local c=""
   local n=$1

   print_text "$cons_mode_selection_1"
   CR

      if [ $var_wotlk_present -eq "$n" ]; then
         c=$_c_disabled
      else
         c=""
      fi
   print_text "$c$cons_option_mode_wotlk$_ansi_off"

      if [ $var_cataclysm_present -eq "$n" ]; then
         c=$_c_disabled
      else
         c=""
      fi
   print_text "$c$cons_option_mode_cataclysm$_ansi_off"

      if [ $var_mop_present -eq "$n" ]; then
         c=$_c_disabled
      else
         c=""
      fi
   print_text "$c$cons_option_mode_mop$_ansi_off"

   CR
   read_answer "$cons_mode_selection_2"
   case $var_answer in
    "1") var_current_mode=$MODE_WOTLK;;
    "2") var_current_mode=$MODE_CATACLYSM;;
    "3") var_current_mode=$MODE_MOP;;
   esac
}

# ------------------------------------------------------------------------------
# function detect_or_select_server_mode ()
# Tries do detect any previous server installation and lets the user select if
# more than one available.
# If no server installation is detected then asks the user which is the one
# desired.
# ------------------------------------------------------------------------------
function detect_or_select_server_mode ()
{
   local mode=$MODE_NONE
   var_wotlk_present=0
   var_cataclysm_present=0

   # We'll only consider a server installation when both server binaries are present.

   if [[ -f $var_dir_bin_wotlk/authserver && -f $var_dir_bin_wotlk/worldserver ]]; then
      var_wotlk_present=1
      mode=$MODE_WOTLK
   fi

   if [[ -f $var_dir_bin_cataclysm/bnetserver && -f $var_dir_bin_cataclysm/worldserver ]]; then
      var_cataclysm_present=1
      mode=$MODE_CATACLYSM
   fi

   if [[ -f $var_dir_bin_mop/authserver && -f $var_dir_bin_mop/worldserver ]]; then
      var_mop_present=1
      mode=$MODE_MOP
   fi

   if [[ $var_force_switch_mode -gt 0 ]]; then # Force asking the user for a (new) mode?
      var_current_mode=$MODE_NONE
      select_server_mode 1
      var_force_switch_mode=0
   else
      # Calculate total installations
      var_available_modes=$(($var_wotlk_present + $var_cataclysm_present + $var_mop_present))
      case $var_available_modes in
       0) CR
          print_warning_message "No server installation found. You have to decide which server to install."
          CR
          select_server_mode 1
          ;;
       1) var_current_mode=$mode;;
       *) CR
          select_server_mode 0;;
      esac
   fi

   # At this point we already know the MODE we want to use:
   case $var_current_mode in
    $MODE_WOTLK)
            print_info_message "$cons_lit_initializing_<b>$cons_lit_woltk_server_name</b>..."
            var_current_mode_prefix="$cons_wotlk_prefix"
            var_server_name="$cons_lit_woltk_server_name"
            var_dir_sources=$var_dir_sources_wotlk
            var_dir_servers=$var_dir_servers_wotlk
            var_dir_bin=$var_dir_bin_wotlk
            var_dir_data=$var_dir_data_wotlk
            var_dir_config=$var_dir_config_wotlk
            var_as_process_name="authserver"
            var_ws_process_name="worldserver"
            var_bin_authserver="$var_dir_bin_wotlk/$var_as_process_name"
            var_bin_worldserver="$var_dir_bin_wotlk/$var_ws_process_name"

            var_db_auth_name=$cons_wotlk_db_auth_name
            var_db_world_name=$cons_wotlk_db_world_name
            var_db_chars_name=$cons_wotlk_db_characters_name
            var_db_auth_host=$cons_wotlk_db_auth_host
            var_db_world_host=$cons_wotlk_db_world_host
            var_db_chars_host=$cons_wotlk_db_characters_host
            var_db_auth_port=$cons_wotlk_db_auth_port
            var_db_world_port=$cons_wotlk_db_world_port
            var_db_chars_port=$cons_wotlk_db_characters_port
            var_db_hotfixes_name=
            var_db_hotfixes_host=
            var_db_hotfixes_port=
            ;;
    $MODE_CATACLYSM)
            print_info_message "$cons_lit_initializing_<b>$cons_lit_cataclysm_server_name</b>..."
            var_current_mode_prefix="$cons_cataclysm_prefix"
            var_server_name="$cons_lit_cataclysm_server_name"
            var_dir_sources=$var_dir_sources_cataclysm
            var_dir_servers=$var_dir_servers_cataclysm
            var_dir_bin=$var_dir_bin_cataclysm
            var_dir_data=$var_dir_data_cataclysm
            var_dir_config=$var_dir_config_cataclysm
            var_as_process_name="bnetserver"
            var_ws_process_name="worldserver"
            var_bin_authserver="$var_dir_bin_cataclysm/$var_as_process_name"
            var_bin_worldserver="$var_dir_bin_cataclysm/$var_ws_process_name"

            var_db_auth_name=$cons_cataclysm_db_auth_name
            var_db_world_name=$cons_cataclysm_db_world_name
            var_db_chars_name=$cons_cataclysm_db_characters_name
            var_db_auth_host=$cons_cataclysm_db_auth_host
            var_db_world_host=$cons_cataclysm_db_world_host
            var_db_chars_host=$cons_cataclysm_db_characters_host
            var_db_auth_port=$cons_cataclysm_db_auth_port
            var_db_world_port=$cons_cataclysm_db_world_port
            var_db_chars_port=$cons_cataclysm_db_characters_port
            var_db_hotfixes_name=$cons_cataclysm_db_hotfixes_name
            var_db_hotfixes_host=$cons_cataclysm_db_hotfixes_host
            var_db_hotfixes_port=$cons_cataclysm_db_hotfixes_port
            ;;
    $MODE_MOP)
            print_info_message "$cons_lit_initializing_<b>$cons_lit_mop_server_name</b>..."
            var_current_mode_prefix="$cons_mop_prefix"
            var_server_name="$cons_lit_mop_server_name"
            var_dir_sources=$var_dir_sources_mop
            var_dir_servers=$var_dir_servers_mop
            var_dir_bin=$var_dir_bin_mop
            var_dir_data=$var_dir_data_mop
            var_dir_config=$var_dir_config_mop
            var_as_process_name="authserver"
            var_ws_process_name="worldserver"
            var_bin_authserver="$var_dir_bin_mop/$var_as_process_name"
            var_bin_worldserver="$var_dir_bin_mop/$var_ws_process_name"

            var_db_auth_name=$cons_mop_db_auth_name
            var_db_world_name=$cons_mop_db_world_name
            var_db_chars_name=$cons_mop_db_characters_name
            var_db_auth_host=$cons_mop_db_auth_host
            var_db_world_host=$cons_mop_db_world_host
            var_db_chars_host=$cons_mop_db_characters_host
            var_db_auth_port=$cons_mop_db_auth_port
            var_db_world_port=$cons_mop_db_world_port
            var_db_chars_port=$cons_mop_db_characters_port
            var_db_hotfixes_name=
            var_db_hotfixes_host=
            var_db_hotfixes_port=
            ;;
    *)
            print_error_message "$cons_error_undefined_mode_q"
            exit
            ;;
   esac
}

# ------------------------------------------------------------------------------
# function is_package_installed (package_name)
# Returns 1 if package_name is installed, 0 otherwise.
# ------------------------------------------------------------------------------
function is_package_installed ()
{
   local package=$1
   local installed=$(dpkg-query -W --showformat='${Status}\n' $package 2>/dev/null |grep "install ok installed")

   if [ "$installed" != "" ]; then
      # installed
      echo 1
   else
      # not installed
      echo 0
   fi
}

# ------------------------------------------------------------------------------
# function detect_or_select_dbengine ()
# Tries do detect the installed database engine. If no databse engine is
# detected then asks the user which is the one to install/use.
# ------------------------------------------------------------------------------
function detect_or_select_dbengine ()
{
   var_current_dbengine=$DBENGINE_MYSQL
   print_info_message "$cons_lit_initializing_<b>$name_mysql_full</b>..."
   var_db_process_name="mysql"
}

# ------------------------------------------------------------------------------
# Checks if all packages in $1 are installed. If any package is missing it
# will be installed.
# $2 is the heading message.
# Quits on error.
# ------------------------------------------------------------------------------
function _check_packages ()
{
   local packages="$1"
   local msg="$2"
   local installed=

   print_full_width "$msg"

   # https://byby.dev/bash-split-string
   # Accept current IFS and use array assignment.
   local packages_array=($packages)
   for package in "${packages_array[@]}"
   do
      echo -ne "  [ ] $_c_bold2$package$_ansi_off"
      installed=$(is_package_installed "$package")
      if [ $installed = 0 ]; then
         echo ""
         sudo apt-get --yes install $package | sed 's/^/      /'
         # if [[ $? > 0 ]]
         if [[ ${PIPESTATUS[0]} -gt 0 ]]; then
            show_fatal_error "$cons_msg_installation_failed"
         else
            ((var_installed_packages=var_installed_packages+1))
         fi
      else
         echo -e "\r  [x] $package"
      fi
   done
   print_info_message "$cons_msg_done"
}

# ------------------------------------------------------------------------------
# Checks ACSCS and AzerothCore required packages are installed.
# If any package is missing it will be installed. Quits on error.
# ------------------------------------------------------------------------------
function initial_check_required_packages ()
{
   _check_packages "$cons_packages_wowsss" "$cons_msg_checking_wowsss_req_packages"

   if [ -n "$var_os_is_debian" ]; then
      # Debian (12) does not include mysql-server in its repositories and it must be installed
      # manually.
      local installed=$(is_package_installed "mysql-server")
      if [ $installed = 0 ]; then
         print_warning_message ""
         print_warning_message "<b>mysql-server</b> is not installed in this system. You must install it manually before continuing."
         print_warning_message "Manual procedure documented in: <b>https://docs.vultr.com/how-to-install-mysql-on-debian-12</b>"
         print_warning_message ""
         print_warning_message "1. Download the latest MySQL repository information package."
         print_warning_message "   $ <b>wget https://dev.mysql.com/get/mysql-apt-config_0.8.30-1_all.deb</b>"
         print_warning_message ""
         print_warning_message "2. Install the MySQL repository information using the file."
         print_warning_message "   $ <b>sudo dpkg -i mysql-apt-config_0.8.30-1_all.deb</b>"
         print_warning_message "   Select <b>\"Server & cluster\"</b> and save settings."
         print_warning_message ""
         print_warning_message "3. Update the packages index and install the server:"
         print_warning_message "   $ <b>sudo apt update</b>"
         print_warning_message "   $ <b>sudo apt install mysql-server</b>"
         print_warning_message "   Enter a password for root when prompted. Tadaaah!"
         print_warning_message ""
         print_fatal_error "Install <b>mysql-server</b> and come back. Sorry."
      fi
   fi

   case $var_current_mode in
    $MODE_WOTLK)
            _check_packages "$cons_packages_wotlk" "$cons_msg_checking_server_req_packages"
            case $var_current_dbengine in
              $DBENGINE_MYSQL) _check_packages "$cons_packages_wotlk_mysql" "$cons_msg_checking_database_req_packages";;
            esac
            ;;
    $MODE_CATACLYSM)
            _check_packages "$cons_packages_cataclysm" "$cons_msg_checking_server_req_packages"
            case $var_current_dbengine in
               $DBENGINE_MYSQL) _check_packages "$cons_packages_cataclysm_mysql" "$cons_msg_checking_database_req_packages";;
            esac
            ;;
    $MODE_MOP)
            _check_packages "$cons_packages_mop" "$cons_msg_checking_server_req_packages"
            case $var_current_dbengine in
               $DBENGINE_MYSQL) _check_packages "$cons_packages_mop_mysql" "$cons_msg_checking_database_req_packages";;
            esac
            ;;
   esac

   if [[ $var_installed_packages -gt 0 ]]; then
      print_warning_message "$cons_lit_installed_packages: $var_installed_packages"
   fi
}

# ------------------------------------------------------------------------------
# function initial_check_server_binaries ()
# Checks if the server binaries are missing. In such case it downloads them.
# Quits on error.
# ------------------------------------------------------------------------------
function initial_check_server_binaries ()
{
   print_full_width "$cons_msg_checking_server_sources"

   if [[ -f $var_dir_bin/$var_as_process_name && -f $var_dir_bin/$var_ws_process_name ]]; then
      print_info_message "$cons_msg_binaries_found"
      servers_setup_default_config_files
   else
      # If makefile exists then the sources "should" be correct.
      if test -f $var_dir_sources/build/Makefile; then
         get_sources_hash
         print_info_message "$cons_lit_sources_version_found: <b>$var_sources_hash</b>"
      else
         # Discard possible sources and get last version.
         servers_sources_download 1 # Quit on error
         # If we get here then the sources were succesfully downloaded.
      fi
      servers_sources_compile_and_install
   fi
   print_info_message "$cons_msg_done"
}

# ------------------------------------------------------------------------------
# function initial_check_data_files ()
# Checks whether the contents of the data directory are likely to be the
# necessary data files. If not it will try to dowload and uncompress them into
# the data directory.
# ------------------------------------------------------------------------------
function initial_check_data_files ()
{
   print_full_width "$cons_msg_checking_data"

   if test -d "$var_dir_data/maps"; then
      if test -d "$var_dir_data/mmaps"; then
         if test -d "$var_dir_data/vmaps"; then
            var_data_files_count=$(find $var_dir_data -type f | wc -l)
            local n=
            case $var_current_mode in
                 $MODE_WOTLK) n=20000;;
             $MODE_CATACLYSM) n=40000;;
                   $MODE_MOP) n=47000;;
            esac
            if [ $var_data_files_count -gt $n ]; then
               print_literal_value "$var_data_files_count" "$cons_lit_files"
               print_info_message "$cons_msg_done"
               return
            fi
         fi
      fi
   fi

   local filename=$var_dir_temp/data.7z
   local url=
   case $var_current_mode in
        $MODE_WOTLK) url="$cons_url_wotlk_data";;
    $MODE_CATACLYSM) url="$cons_url_cataclysm_data";;
          $MODE_MOP) url="$cons_url_mop_data";;
   esac

   # 900 seconds timeout is crazy.
   wget --output-document="$filename" --timeout=30 "$url"
   result=$?
   if [ $result -ne 0 ]; then
      print_fatal_error "$cons_msg_error_download_data"
   fi
   7z x "$filename" -o"$var_dir_data"
   result=$?
   rm "$filename"
   if [ $result -ne 0 ]; then
      print_fatal_error "$cons_msg_error_extracting_data"
   fi
}

# ------------------------------------------------------------------------------
# function initial_check_sql_files ()
# Checks whether the required sql files by worldserver are in place.
# ------------------------------------------------------------------------------
function initial_check_sql_files ()
{
   # Cataclysm world sql files.
   if [ $var_current_mode == $MODE_CATACLYSM ]; then
      print_full_width "$cons_msg_checking_sql"
      cd $var_dir_sources
      if [ ! -f TDB_full_hotfixes_434.22011_2022_01_09.sql ] || [ ! -f TDB_full_world_434.22011_2022_01_09.sql ]; then
         local filename=$var_dir_temp/sql.7z

         # 900 seconds timeout is crazy.
         wget --output-document="$filename" --timeout=30 "$cons_url_cataclysm_sql"
         result=$?
         if [ $result -ne 0 ]; then
            print_fatal_error "$cons_msg_error_download_sql"
         fi
         7z x "$filename" -o"$var_dir_sources"
         result=$?
         rm "$filename"
         if [ $result -ne 0 ]; then
            print_fatal_error "$cons_msg_error_extracting_sql"
         fi
      fi
      print_info_message "$cons_msg_done"
   fi
   if [ $var_current_mode == $MODE_MOP ]; then
      print_full_width "$cons_msg_checking_sql"
      cd $var_dir_sources
      if [ ! -f world_548_20231230.sql ]; then
         local filename=$var_dir_temp/sql.7z

         # 900 seconds timeout is crazy.
         wget --output-document="$filename" --timeout=30 "$cons_url_mop_sql"
         result=$?
         if [ $result -ne 0 ]; then
            print_fatal_error "$cons_msg_error_download_sql"
         fi
         7z x "$filename" -o"$var_dir_sources"
         result=$?
         rm "$filename"
         if [ $result -ne 0 ]; then
            print_fatal_error "$cons_msg_error_extracting_sql"
         fi
      fi
      print_info_message "$cons_msg_done"
   fi
}
