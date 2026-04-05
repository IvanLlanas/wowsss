#!/bin/bash
# ------------------------------------------------------------------------------
#     __      __    __      __________________________
#    /  \    /  \__/  \    /  \ _____/  _____/  _____/
#    \   \/\/  /  _ \  \/\/   /____  \_____  \_____  \
#     \       (  (_) )       /        \       \       \
#      \__/\  /\____/\__/\  /_______  /_____  /_____  /
#           \/            \/        \/      \/      \/ 1.6
# ------------------------------------------------------------------------------
# World of Warcraft Server Script System
# (C) Copyright by Ivan Llanas, 2023-26
# ----------------------------------------------------------------------
# This script performs a first time setting-up to configure an unatended
# installation of WoWSSS and launches WoWSSS.
# ----------------------------------------------------------------------

# Constants ------------------------------------------------------------

flag_file="/root/installed"

_ansi_off="\e[0m"
_ansi_black="\e[30m"
_ansi_white="\e[97m"
_ansi_bg_yellow_light="\e[103m"
_ansi_bg_blue="\e[44m"

# Functions ------------------------------------------------------------

function _update_screen_columns ()
{
   local x=$COLUMNS
   sleep 0 # This sleep makes $COLUMNS get its proper value. Why? Dunno.
}

function print_title ()
{
   local msg="$1"

   _update_screen_columns

   # Calculate the filler size needed to fill the whole terminal width.
   local lmsg=${#msg}
   local count=$(($COLUMNS - $lmsg))
   local lbar=$COLUMNS
   if [ $count -lt 1 ]
      then
      count=0
   fi
   local count2=$(($count / 2))
   local bar=$(head -c $lbar < /dev/zero | tr '\0' '-' )
   local filler1=$(head -c $count2 < /dev/zero | tr '\0' ' ' )
   local filler2=
   if [ `expr $count % 2` == 0 ]; then
      filler2=$filler1
   else
      filler2=$filler1" "
   fi
   echo -e $_ansi_black$_ansi_bg_yellow_light$bar
   echo -e "${filler1}${msg}${filler2}"
   echo -e $bar$_ansi_off
}

function print_information ()
{
   local msg="$1"
   echo -e $_ansi_white$_ansi_bg_blue"[ ${msg} ]"$_ansi_off
}

function first_time_setting_up ()
{
   if [ ! -f "$flag_file" ]; then

      # ---------------------------------------
      print_title "WoWSSS environment first time setup"

      print_information "Updating system..."
      apt update
      apt upgrade -y

      print_information "Installing tools..."
      apt install -y git nano

      print_information "Getting WoWSSS..."
      git clone https://github.com/IvanLlanas/wowsss.git /root/wowsss

      # ---------------------------------------
      print_title "WoWSSS Docker configuring..."

      mkdir /root/remote

      # Copy default settings. For clean dockers it's ok.
      print_information "Replicating settings.sh..."
      cp /root/wowsss/scripts/wowsss/settings.sh.dist /root/wowsss/scripts/wowsss/settings.sh

      # Add "is_docker" variable to settings.sh
      print_information "Adding variable to settings.sh..."
      echo "WOWSSS_CONTAINED=1" >> /root/wowsss/scripts/wowsss/settings.sh

      # Done!
      print_information "Closing first time setup..."
      touch "$flag_file"
   fi
}

function start_wowsss ()
{
   if [ ! -f "$flag_file" ]; then # Let's only spam once.
      print_title "Starting WoWSSS..."
   fi
   cd /root/wowsss
   ./start.sh
}

function start_shell ()
{
   print_information "WoWSSS finished. Starting shell. \"exit\" to close container."
   $SHELL
}

function main ()
{
   first_time_setting_up
   start_wowsss
   # Should be commented on final release.
   # start_shell
}

main
