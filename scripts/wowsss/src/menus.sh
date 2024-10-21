# ------------------------------------------------------------------------------
# function wowsss_main_menu ()
# function main_menu_restore_databases ()
# function main_menu_backup_databases_critical ()
# function main_menu_backup_databases_other ()
# function main_menu_backup_all ()
# function main_menu_sources_download ()
# function main_menu_sources_update ()
# function main_menu_sources_compile ()
# function main_menu_configure_realms_ips ()
# ------------------------------------------------------------------------------
function print_x ()
{
   local x=$1
   local msg=$2

   #echo -en "\e[500D\e["$1"C"
   echo -en "\r\e["$1"C"
   echo -en "$msg"
}

# ------------------------------------------------------------------------------
# function wowsss_main_menu ()
# Enters the menu mode of the script.
# ------------------------------------------------------------------------------
function wowsss_main_menu ()
{
   local i="   "
   local x=$_ansi_off
   local d=$_c_menu_letter
   local c1=$mn_c1_letter
   local c2=$mn_c1_text
   local c3=$mn_c2_letter
   local c4=$mn_c2_text

   database_get_realm_info
   while [ true ]
   do
      _update_menu_colors
      _print_main_menu_header
      print_menu_title "$cons_title_main_menu"
      CR
      print_x $c1 $d"1$x)"
      print_x $c2 $start_enabled"$cons_option_start_server"$x
      print_x $c3 $d"0$x)"
      print_x $c4 $_c_menu_text"$cons_option_server_information"$x
      CR
      print_x $c1 $d"2$x)"
      print_x $c2 $stop_enabled"$cons_option_stop_server"$x
      print_x $c3 $d"V$x)"
      print_x $c4 $stop_enabled"$cons_option_restore_as_console"$x
      CR
      print_x $c1 $d"3$x)"
      print_x $c2 $stop_enabled"$cons_option_process_monitor"$x
      print_x $c3 $d"W$x)"
      print_x $c4 $stop_enabled"$cons_option_restore_ws_console"$x
      CR
      CR
      print_x $c1 $d"S$x)"
      print_x $c2 $make_enabled"$cons_option_sources_menu"$x
      print_x $c3 $d"D$x)"
      print_x $c4 $backup_enabled"$cons_option_databases_menu"$x
      CR
      print_x $c1 $d"B$x)"
      print_x $c2 $backup_enabled"$cons_option_backups_menu"$x
      print_x $c3 $d"Z$x)"
      print_x $c4 $make_enabled"$cons_option_switch_server_mode"$x
      CR
      CR
      print_x $c1 $d"Q$x)"
      print_x $c2 $_c_menu_text"$cons_option_quit"$x
      print_x $c3 $d"X$x)"
      print_x $c4 $make_enabled"$cons_option_shutdown_host"$x
      CR
      CR
      read_answer "$cons_msg_choose_an_option"
      case $var_answer in
       "0")    show_wowsss_info 1;;
       "1")    main_menu_servers_start;;
       "2")    main_menu_servers_stop;;
       "3")    main_menu_top;;
       "V")    server_restore_screen_session "$var_session_auth";;
       "W")    server_restore_screen_session "$var_session_world";;
       "S")    sources_menu;;
       "D")    databases_menu;;
       "B")    backups_menu;;
       "Z")    ensure_no_server_running
               if [ $var_no_server_running ]; then
                  #read_confirmation "$cons_option_switch_server_mode"
                  #if [ $var_confirmed ]; then
                     var_force_switch_mode=1
                     return
                  #fi
               fi
               ;;
       "Q")    print_info_message "$cons_msg_good_bye";
               return
               ;;
       "X")    ensure_no_server_running
               if [ $var_no_server_running ]; then
                  print_info_message "$cons_msg_good_bye";
                  print_warning_message "Shutting down...";
                  if [[ $SSH_CLIENT == "" ]]; then
                     poweroff
                  else
                     sudo poweroff
                  fi
                  exit
               fi
               ;;
         *)    print_error_message "$cons_msg_error_invalid_option_\"<b>$var_answer</b>\".";;
      esac
   done
}

# ------------------------------------------------------------------------------
function sources_menu ()
{
   local x=$_ansi_off
   local d=$_c_menu_letter
   local c1=$mn_c1_letter
   local c2=$mn_c1_text
   local c3=$mn_c2_letter
   local c4=$mn_c2_text

   while [ true ]
   do
      _update_menu_colors
      _print_main_menu_header
      print_menu_title "$cons_title_sources_menu"
      CR
      print_x $c1 $d"V$x)"
      print_x $c2 $_c_menu_text"$cons_option_visit_site"$x
      CR
      print_x $c1 $d"D$x)"
      print_x $c2 $source_enabled_download"$cons_option_sources_download"$x
      CR
      print_x $c1 $d"U$x)"
      print_x $c2 $source_enabled_update"$cons_option_sources_update"$x
      CR
      print_x $c1 $d"C$x)"
      print_x $c2 $make_enabled"$cons_option_sources_compile"$x
      CR
      CR
      print_x $c1 $d"ENTER$x) $_c_menu_text$cons_option_back"$x
      CR
      CR
      read_answer "$cons_msg_choose_an_option"
      case $var_answer in
         "V")  local url=
               case $var_current_mode in
                    $MODE_WOTLK) url=$cons_url_wotlk_sources_project;;
                $MODE_CATACLYSM) url=$cons_url_catacysm_sources_project;;
               esac
               xdg-open "$url" &
               ;;
         "D")  main_menu_sources_download;;
         "U")  main_menu_sources_update;;
         "C")  main_menu_sources_compile;;
           *)  return;;
      esac
   done
}

# ------------------------------------------------------------------------------
function databases_menu ()
{
   local x=$_ansi_off
   local d=$_c_menu_letter
   local c1=$mn_c1_letter
   local c2=$mn_c1_text
   local c3=$mn_c2_letter
   local c4=$mn_c2_text

   while [ true ]
   do
      _update_menu_colors
      _print_main_menu_header
      print_menu_title "$cons_title_databases_menu"
      CR
      print_x $c1 $d"I$x)"
      print_x $c2 $start_enabled"$cons_option_configure_realm_ips"$x
      CR
      print_x $c1 $d"R$x)"
      print_x $c2 $make_enabled"$cons_option_restore_databases"$x
      CR
      CR
      print_x $c1 $d"ENTER$x) $_c_menu_text$cons_option_back"$x
      CR
      CR
      read_answer "$cons_msg_choose_an_option"
      case $var_answer in
         "I")  main_menu_configure_realms_ips;;
         "R")  main_menu_restore_databases;;
           *)  return;;
      esac
   done
}

# ------------------------------------------------------------------------------
function backups_menu ()
{
   local x=$_ansi_off
   local d=$_c_menu_letter
   local c1=$mn_c1_letter
   local c2=$mn_c1_text
   local c3=$mn_c2_letter
   local c4=$mn_c2_text

   while [ true ]
   do
      _update_menu_colors
      _print_main_menu_header
      print_menu_title "$cons_title_backups_menu"
      CR
      print_x $c1 $d"1$x)"
      print_x $c2 $backup_enabled"$cons_option_backup_databases_critical"$x
      CR
      print_x $c1 $d"2$x)"
      print_x $c2 $backup_enabled"$cons_option_backup_databases_other"$x
      CR
      print_x $c1 $d"3$x)"
      print_x $c2 $backup_enabled"$cons_option_backup_servers"$x
      CR
      print_x $c1 $d"4$x)"
      print_x $c2 $backup_enabled"$cons_option_backup_sources"$x
      CR
      print_x $c1 $d"5$x)"
      print_x $c2 $backup_enabled"$cons_option_backup_all"$x
      CR
      print_x $c1 $d"6$x)"
      print_x $c2 $backup_enabled"$cons_option_backup_data"$x
      CR
      CR
      print_x $c1 $d"ENTER$x) $_c_menu_text$cons_option_back"$x
      CR
      CR
      read_answer "$cons_msg_choose_an_option"
      case $var_answer in
         "1")  main_menu_backup_databases_critical;;
         "2")  main_menu_backup_databases_other;;
         "3")  main_menu_backup_servers;;
         "4")  main_menu_backup_sources;;
         "5")  main_menu_backup_all;;
         "6")  main_menu_backup_data;;
           *)  return;;
      esac
   done
}

# ------------------------------------------------------------------------------
# function _update_menu_colors ()
# Updates start_enabled, stop_enabled, backup_enabled, make_enabled and
# source_enabled_* colours for menu/command line help. It also fixes the prefixes
# for the compile/update/download options.
# ------------------------------------------------------------------------------
function _update_menu_colors ()
{
   # Check servers PID's
   update_pidof_servers

   if [ $var_pidof_authserver ] && [ $var_pidof_worldserver ]
      then
      start_enabled=$_c_disabled
   else
      start_enabled=$_c_menu_text
   fi

   if [ $var_pidof_authserver ] || [ $var_pidof_worldserver ]
      then
      # Colors
      stop_enabled=$_c_menu_text
      backup_enabled=$_c_disabled
      make_enabled=$_c_disabled
      install_enabled=$_c_disabled
      source_enabled_download=$_c_disabled
      source_enabled_update=$_c_disabled
   else
      # Colors
      stop_enabled=$_c_disabled
      backup_enabled=$_ansi_lime
      make_enabled=$_ansi_red
      install_enabled=$_ansi_red
      source_enabled_download=$_ansi_yellow
      source_enabled_update=$_ansi_yellow
   fi
}

# ------------------------------------------------------------------------------
# function main_menu_backup_databases_critical ()
# Makes a backup of the critical databases (auth and charactes).
# ------------------------------------------------------------------------------
function main_menu_backup_databases_critical ()
{
   print_full_width "$cons_option_backup_databases_critical"
   case $var_current_mode in
    $MODE_WOTLK)
            databases_backup "$var_current_mode_prefix-databases-auth-chars" "$cons_wotlk_db_auth_name $cons_wotlk_db_characters_name"
            ;;
    $MODE_CATACLYSM)
            databases_backup "$var_current_mode_prefix-databases-auth-chars" "$cons_cataclysm_db_auth_name $cons_cataclysm_db_characters_name"
            ;;
    $MODE_MOP)
            databases_backup "$var_current_mode_prefix-databases-auth-chars" "$cons_mop_db_auth_name $cons_mop_db_characters_name"
            ;;
   esac
   print_info_message "$cons_msg_done"
}

# ------------------------------------------------------------------------------
# function main_menu_backup_databases_other ()
# Makes a backup of the not so critical databases (world and hotfixes).
# ------------------------------------------------------------------------------
function main_menu_backup_databases_other ()
{
   print_full_width "$cons_option_backup_databases_other"
   case $var_current_mode in
    $MODE_WOTLK)
            databases_backup "$var_current_mode_prefix-databases-world" "$cons_wotlk_db_world_name"
            ;;
    $MODE_CATACLYSM)
            databases_backup "$var_current_mode_prefix-databases-world-hotfixes" "$cons_cataclysm_db_world_name $cons_cataclysm_db_hotfixes_name"
            ;;
    $MODE_MOP)
            databases_backup "$var_current_mode_prefix-databases-world" "$cons_mop_db_world_name"
            ;;
   esac
}

# ------------------------------------------------------------------------------
# function main_menu_restore_databases ()
# Tries to import all databases from scripts located in "var_dir_scripts/sql".
# ------------------------------------------------------------------------------
function main_menu_restore_databases ()
{
   ensure_no_server_running
   if [ $var_no_server_running ]; then
      print_warning_message ""
      print_warning_message "$cons_msg_restore_db_1"
      print_warning_message "$cons_msg_restore_db_2"
      print_warning_message "$cons_msg_restore_db_3"
      print_warning_message "$cons_msg_restore_db_4"
      print_warning_message "$cons_msg_restore_db_5"
      print_warning_message "$cons_msg_restore_db_6"
      if [ "$var_current_mode" = "$MODE_CATACLYSM" ]; then
      print_warning_message "$cons_msg_restore_db_7_c"
      fi
      print_warning_message ""
      print_warning_message "$cons_msg_restore_db_8"
      print_warning_message "$cons_msg_restore_db_9"
      print_warning_message ""
      read_confirmation "$cons_option_restore_databases"
      if [ $var_confirmed ]; then
         print_full_width "$cons_option_restore_databases"
         cd "$var_dir_sql"
         CR
         database_import_from_script "$var_db_auth_name" "$var_dir_sql/$var_db_auth_name.sql"
         database_import_from_script "$var_db_chars_name" "$var_dir_sql/$var_db_chars_name.sql"
         database_import_from_script "$var_db_world_name" "$var_dir_sql/$var_db_world_name.sql"
         if [ "$var_current_mode" = "$MODE_CATACLYSM" ]; then
            database_import_from_script "$var_db_hotfixes_name" "$sql_dir/$var_db_hotfixes_name.sql"
         fi
      fi
   fi
}

# ------------------------------------------------------------------------------
# function main_menu_backup_all ()
# Menu option: Save all (data directory and world database excluded)
# ------------------------------------------------------------------------------
function main_menu_backup_all ()
{
   print_full_width "$cons_option_backup_all"
   main_menu_backup_databases_critical
   # main_menu_backup_databases_other
   main_menu_backup_servers
   main_menu_backup_sources
   # main_menu_backup_data
}

# ------------------------------------------------------------------------------
# function main_menu_sources_download ()
# Menu option: Remove current sources and download them from github
#              The source is prepared for compilation process creating the
#              make files (cmake).
# ------------------------------------------------------------------------------
function main_menu_sources_download ()
{
   read_confirmation "$cons_option_sources_download"
   if [ $var_confirmed ]; then
      print_full_width "$cons_option_sources_download"
      servers_sources_download
   fi
}

# ------------------------------------------------------------------------------
# function main_menu_sources_update ()
# Menu option: Update current sources from github
# ------------------------------------------------------------------------------
function main_menu_sources_update ()
{
   read_confirmation "$cons_option_sources_update"
   if [ $var_confirmed ]; then
      print_full_width "$cons_option_sources_update"
      servers_sources_update
   fi
}

# ------------------------------------------------------------------------------
# function main_menu_sources_compile ()
# Menu option: Compile servers and tools
# ------------------------------------------------------------------------------
function main_menu_sources_compile ()
{
   ensure_no_server_running
   if [ $var_no_server_running ]; then
      read_confirmation "$cons_option_sources_compile"
      if [ $var_confirmed ]
         then
         print_full_width "$cons_option_sources_compile"
         servers_sources_compile_and_install
      fi
   fi
}

# ------------------------------------------------------------------------------
# function main_menu_configure_realms_ips ()
# Menu option: Compile servers and tools
# ------------------------------------------------------------------------------
function main_menu_configure_realms_ips ()
{
   ensure_no_server_running
   if [ $var_no_server_running ]; then
      local i="   "
      print_full_width "$cons_option_configure_realm_ips"
      CR
      database_get_realm_info
      local x=$_ansi_off
      case $var_realm_count in
         0) print_error_message "$cons_error_no_realm_found";;
         1) local count=0
            local ip127=127.0.0.1
            local ext_ip=
            local int_ip=
            local c1=4
            local c2=33
            print_x $c1 "$cons_lit_host: $_c_bold3$var_os_hostname$x"
            print_x $c2 "$cons_lit_realm_name: $_c_bold3$var_realm_name$x"
            CR
            print_x $c1 "$cons_lit_external_ip: $_c_bold2$var_external_ip$x"
            print_x $c2 "$cons_lit_external_ip: $_c_bold2$var_realm_external_ip$x"
            CR
            print_x $c1 "$cons_lit_internal_ip: $_c_bold1$var_internal_ip$x"
            print_x $c2 "$cons_lit_internal_ip: $_c_bold1$var_realm_internal_ip$x"
            CR
            CR
            print_text "${i}$cons_lit_server_connection_mode:"
            print_text "${i}${i} <b>1</b>) $_ansi_lime""$cons_lit_private_server$x $cons_lit_private_server_remark"
            print_text "${i}${i} ${i}[ address: $_c_bold2$var_internal_ip$x / localAddress: $_c_bold1$ip127$x ]"
            print_text "${i}${i} <b>2</b>) $_ansi_red""$cons_lit_public_server$x $cons_lit_public_server_remark"
            print_text "${i}${i} ${i}[ address: $_c_bold2$var_external_ip$x / localAddress: $_c_bold1$var_internal_ip$x]"
            print_text "${i}<b>ENTER</b>) Cancel."
            CR
            read_answer "${i}$cons_msg_select_ip_mode_for_$_c_bold2$var_realm_name$x (<b>$var_server_name</b>) ($_ansi_red"1"$x/$_ansi_lime"2"$x/<b>ENTER</b>): "
            case $var_answer in
             "1") ext_ip=$var_internal_ip
                  int_ip=$ip127
                  ;;
             "2") ext_ip=$var_external_ip
                  int_ip=$var_internal_ip
                  ;;
               *) print_error_message "$cons_lit_cancelled"
                  wait
                  return;
            esac
            CR
            read_confirmation "$x$cons_lit_apply address=$_c_bold2$ext_ip$x / localAddress=$_c_bold1$int_ip$x"
            if [ $var_confirmed ]; then
               database_setup_realm "$ext_ip" "$int_ip"
               local result=$?
               if [ $result -ne 0 ]; then
                  print_error_message "$cons_error_applying_changes"
               else
                  print_info_message "$cons_msg_done"
                  database_get_realm_info
               fi
            fi
            return
            ;;
         *) print_error_message "$cons_error_multiple_realm_found";;
      esac
   fi
}


# ------------------------------------------------------------------------------
# function _print_main_menu_header ()
# ------------------------------------------------------------------------------
function _print_main_menu_header ()
{
   local text=
   local c1=
   local c2=
   local c3=
   local filename="$var_dir_docs/version-$var_current_mode_prefix.txt"

   if [ ! -f "$filename" ]; then
      text=$(server_version_no_date)
   else
      text=$(head --lines=1 "$filename")
   fi
   print_full_width_server_colors "$text"
   if [[ $var_wowsss_update_available -gt 0 ]]; then
      print_warning_centered "$cons_msg_wowsss_update_available"
   fi
   if [[ $var_sources_update_available -gt 0 ]]; then
      print_warning_centered "$cons_msg_sources_update_available"
   fi
   CR
   c1=4
   c2=33
   c3=66
   print_x $c2 "$cons_lit_host: $_c_bold3$var_os_hostname$x"
   print_x $c3 "$cons_lit_realm_name: $_c_bold3$var_realm_name$x"
   CR
   print_x $c1 " AuthServer: "
      print_running_state "$var_pidof_authserver" "$var_bin_authserver" ""
      print_x $c2 "$cons_lit_external_ip: $_c_bold2$var_external_ip$x"
      print_x $c3 "$cons_lit_external_ip: $_c_bold2$var_realm_external_ip$x"
   CR
   print_x $c1 "WorldServer: "
      print_running_state "$var_pidof_worldserver" "$var_bin_worldserver" ""
      print_x $c2 "$cons_lit_internal_ip: $_c_bold1$var_internal_ip$x"
      print_x $c3 "$cons_lit_internal_ip: $_c_bold1$var_realm_internal_ip$x"
   CR
   CR
}
