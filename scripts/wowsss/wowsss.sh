# ------------------------------------------------------------------------------
#     __      __    __      __________________________
#    /  \    /  \__/  \    /  \ _____/  _____/  _____/
#    \   \/\/  /  _ \  \/\/   /____  \_____  \_____  \ 
#     \       (  (_) )       /        \       \       \
#      \__/\  /\____/\__/\  /_______  /_____  /_____  /
#           \/            \/        \/      \/      \/ 1.1
# ------------------------------------------------------------------------------
# World of Warcraft Server Script System
# (C) Copyright by Ivan Llanas, 2023-24
# ------------------------------------------------------------------------------
# This script performs all the functions related to a "World of Warcraft"
# private server installation and maintenance on a Ubuntu or Debian system.
# ------------------------------------------------------------------------------
# WotLK - AzerothCore
#    https://github.com/azerothcore/azerothcore-wotlk
# Cataclysm - TrinityCore
#    https://github.com/The-Cataclysm-Preservation-Project/TrinityCore
# MoP - LegendsOfAzeroth
#    https://github.com/Legends-of-Azeroth/Legends-of-Azeroth-Pandaria-5.4.8
# ------------------------------------------------------------------------------

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

   include_modules
   define_constants_1
   define_variables_1

   while : ; do
      detect_or_select_server_mode
      detect_or_select_dbengine

      # if there's no server installed 
      # or
      # let's try to install the current selection:
      if (( $var_available_modes == 0 )) || (( $var_available_modes == 1  &&  $var_force_switch_mode > 0 )); then
         local text=
         # Show details...
         show_wosss_info
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
      get_ips # We'll only get the IP's for menu mode and only once.
      get_sources_hash
      sources_check_update_available

      var_force_switch_mode=0
      wowsss_main_menu

   [[ $var_force_switch_mode -gt 0 ]] || break
   done
}

# ------------------------------------------------------------------------------
# Let's do this!
main
exit
