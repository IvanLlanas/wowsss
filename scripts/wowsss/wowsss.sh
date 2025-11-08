#!/bin/bash
# ------------------------------------------------------------------------------
#     __      __    __      __________________________
#    /  \    /  \__/  \    /  \ _____/  _____/  _____/
#    \   \/\/  /  _ \  \/\/   /____  \_____  \_____  \ 
#     \       (  (_) )       /        \       \       \
#      \__/\  /\____/\__/\  /_______  /_____  /_____  /
#           \/            \/        \/      \/      \/ 1.5
# ------------------------------------------------------------------------------
# World of Warcraft Server Script System
# (C) Copyright by Ivan Llanas, 2023-25
# ------------------------------------------------------------------------------
# This script performs all the functions related to a "World of Warcraft"
# private server installation and maintenance on an Ubuntu or Debian system.
# ------------------------------------------------------------------------------
# WotLK - AzerothCore
#    https://github.com/azerothcore/azerothcore-wotlk
# Cataclysm - TrinityCore
#    https://github.com/The-Cataclysm-Preservation-Project/TrinityCore
# MoP - LegendsOfAzeroth
#    https://github.com/Legends-of-Azeroth/Legends-of-Azeroth-Pandaria-5.4.8
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# function check_settings_file ()
# Checks if file settings.sh is present. If not then copies from *.dist file
# and notifies the user.
# Note that this function is called BEFORE constants creation so message texts
# will be inside this function (by now).
# ------------------------------------------------------------------------------
function check_settings_file ()
{
   local filename=$(realpath -s "$0")
   local     path=$(dirname "$filename")
   filename="$path/settings.sh"

   if [ ! -f "$filename" ]; then
      local _tb="\e[93m"
      local _tn="\e[97m"
      local _bge="\e[41m"
      local _bgi="\e[44m"
      local _0="\e[0m"

      cp "$filename.dist" "$filename"
      echo -e $_tn$_bge"[ File $_tb$filename$_tn was not found. A new one has just been created. ]"$_0
      echo -e $_tn$_bgi"[ Edit file $_tb$filename$_tn to fit your needs. Really. ]"$_0
      echo
      exit
   fi
}

# ------------------------------------------------------------------------------
# function include_modules ()
# Loads all the WoWSSS modules.
# ------------------------------------------------------------------------------
function include_modules ()
{
   local filename=$(realpath -s "$0")
   local     path=$(dirname "$filename")

   source "$path/settings.sh"
   source "$path/src/functions.sh"
   source "$path/src/constants.sh"
   source "$path/src/variables.sh"
   source "$path/src/installation.sh"
   source "$path/src/sources.sh"
   source "$path/src/servers.sh"
   source "$path/src/databases.sh"
   source "$path/src/menus.sh"
   source "$path/src/backup.sh"
}

# ------------------------------------------------------------------------------
#  MAIN FUNCTION ---------------------------------------------------------------
# ------------------------------------------------------------------------------
function main ()
{
   # We want case-insensitive comparisons.
   shopt -s nocasematch

   check_settings_file
   include_modules
   define_constants_1
   define_variables_1

   wowsss_check_update_available

   while : ; do
      detect_or_select_server_mode
      detect_or_select_dbengine

      # if there's no server installed 
      # or
      # let's try to install the current selection:
      if (( $var_available_modes == 0 )) || (( $var_available_modes == 1  &&  $var_force_switch_mode > 0 )); then
         local text=
         # Show details...
         show_wowsss_info
         # ...and ask for confirmation.
         case $var_current_mode in
              $MODE_WOTLK) text=$name_wotlk_full;;
          $MODE_CATACLYSM) text=$name_cataclysm_full;;
                $MODE_MOP) text=$name_mop_full;;
         esac
         text="$cons_install '"$text"'"
         read_confirmation "$text"
         if [ ! $var_confirmed ]; then
            exit
         fi
      fi

      # At this point we already know the desired server mode (var_current_mode)
      # and database engine (var_current_dbengine).
      define_constants_2
      initial_check_required_packages
      initial_check_server_binaries
      initial_check_data_files
      initial_check_sql_files
      initial_check_databases

      # Get som final info
      get_ips # We'll only get the IP's for menu mode and only once. Well, show_wowsss_info may call it too.
      get_sources_hash
      sources_check_update_available
      var_force_switch_mode=0
      play_sound_ready
      wowsss_main_menu

   [[ $var_force_switch_mode -gt 0 ]] || break
   done
}

# ------------------------------------------------------------------------------
# Let's do this!
main
exit
