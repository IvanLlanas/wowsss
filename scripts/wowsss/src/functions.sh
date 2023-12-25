# ------------------------------------------------------------------------------
# function get_script_dir ()
# function get_base_dir ()
# function get_ips ()
# function CR ()
# function print_text (text)
# function print_literal_value (value, [literal])
# function print_error_message (message)
# function print_warning_message (message)
# function print_fatal_error (message)
# function print_info_message (message)
# function print_full_width (msg)
# function print_full_width_server_colors (msg)
# function print_warning_centered (message)
# function print_running_state ($pid, $filename)
# function print_menu_title ($title)
# function read_answer (literal)
# function read_confirmation (action)
# function show_wosss_info ()
# function wait (seconds)
# function play_sound ($filename_without_path)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# function wait (seconds)
# Waits for $1 seconds (default "var_wait_seconds").
# ------------------------------------------------------------------------------
function wait ()
{
   local seconds=$1
   if [[ $seconds -gt 0 ]]; then
      :
   else
      seconds=$var_wait_seconds
   fi
   sleep $seconds
}

# ------------------------------------------------------------------------------
# function get_script_dir ()
# Returns the directory of main WoWSSS script.
#  path=$(get_script_dir)
# ------------------------------------------------------------------------------
function get_script_dir ()
{
   local filename=$(realpath -s "$0")
   local path=$(dirname "$filename")
   echo "$path"
}

# ------------------------------------------------------------------------------
# function get_base_dir ()
# Returns the directory of main WoWSSS installation.
#  path=$(get_base_dir)
# ------------------------------------------------------------------------------
function get_base_dir ()
{
   local path=$(get_script_dir)
   # Remove the last 2 subdirs (wowsss and scripts) from the current script's path.
   path=${path%/*/*}
   echo "$path"
}

# ------------------------------------------------------------------------------
# function get_ips ()
# Gets the internal and external ip's and stores them in "$var_internal_ip" and
# "$var_external_ip".
# ------------------------------------------------------------------------------
function get_ips ()
{
   var_internal_ip=$(hostname -I)
   var_external_ip=$(dig +short myip.opendns.com @resolver4.opendns.com)
#  var_external_ip=$(curl -s http://whatismyip.akamai.com/) # This one requires curl package.
   # remove trailing whitespace characters
   var_internal_ip="${var_internal_ip%"${var_internal_ip##*[![:space:]]}"}"   
}

# ------------------------------------------------------------------------------
# function _update_screen_columns ()
# Forces $COLUMNS update. It seems to work but I don't know why.
# ------------------------------------------------------------------------------
function _update_screen_columns ()
{
   local x=$COLUMNS
   sleep 0 # This sleep makes $COLUMNS get its proper value. Why? Dunno.
}

# ------------------------------------------------------------------------------
# function CR ()
# Jumps a line down in the console
# ------------------------------------------------------------------------------
function CR ()
{
   echo ""
}

# ------------------------------------------------------------------------------
# function print_literal_value (value, [literal])
# Prints a value ($1) and an optional literal ($2) on the console.
# ------------------------------------------------------------------------------
function print_literal_value ()
{
   local value="$_bold1$1$_bold0"
   local literal=$2
   local text=""
   if [[ $literal == "" ]]; then  text=$value
   else                           text="$literal: $value"
   fi
   text=${text//$_bold1/$_c_bold1}
   text=${text//$_bold0/$_ansi_off}
   echo -e "$text"
}

# ------------------------------------------------------------------------------
# function print_text (text)
# Prints a raw text ($1) on the console.
# ------------------------------------------------------------------------------
function print_text ()
{
   local text=$1
   text=${text//$_bold1/$_c_bold1}
   text=${text//$_bold0/$_ansi_off}
   echo -e "$text"
}

# ------------------------------------------------------------------------------
# function print_error_message (message)
# Reports an error message ($1) on the console.
# ------------------------------------------------------------------------------
function print_error_message ()
{
   local msg=$1
   msg=${msg//$_bold1/$_ansi_yellow}
   msg=${msg//$_bold0/$_ansi_white}
   echo -e $_ansi_white$_ansi_bg_red"[ ${msg} ]"$_ansi_off
}

# ------------------------------------------------------------------------------
# function print_fatal_error (message)
# Reports an error message ($1) on the console and quits.
# ------------------------------------------------------------------------------
function print_fatal_error ()
{
   local msg=$1
   msg=${msg//$_bold1/$_ansi_yellow}
   msg=${msg//$_bold0/$_ansi_white}
   echo -e $_ansi_white$_ansi_bg_red"[ ${msg} $cons_msg_quitting ]"$_ansi_off
   wait
   exit
}

# ------------------------------------------------------------------------------
# function print_info_message (message)
# Prints an information message ($1) on the console.
# ------------------------------------------------------------------------------
function print_info_message ()
{
   local msg=$1
   msg=${msg//$_bold1/$_ansi_yellow}
   msg=${msg//$_bold0/$_ansi_white}
   echo -e $_ansi_white$_ansi_bg_blue"[ ${msg} ]"$_ansi_off
}

# ------------------------------------------------------------------------------
# function print_warning_message (message)
# Shows a warning message ($1) on the console. Full width.
# ------------------------------------------------------------------------------
function print_warning_message ()
{
   _update_screen_columns
   # Remove _boldx delimiters. No delimiter expected but just in case.
   local msg=$1
   local none=""
   msg=${msg//$_bold1/$none}
   msg=${msg//$_bold0/$none}

   # Calculate the filler size needed to fill the whole terminal width.
   local lmsg=${#msg}
   local count=$(($COLUMNS - $lmsg -2 -2))
   if [ $count -lt 1 ]
      then
      count=0
   fi
   local filler=$(head -c $count < /dev/zero | tr '\0' ' ' )

   msg=$1
   msg=${msg//$_bold1/$_ansi_red}
   msg=${msg//$_bold0/$_ansi_black}
   echo -e $_ansi_black$_ansi_bg_yellow_light"[ ${msg} ${filler}]"$_ansi_off
}

# ------------------------------------------------------------------------------
# function print_full_width (msg)
# Writes an inverted text. Full width.
# ------------------------------------------------------------------------------
function print_full_width ()
{
   _update_screen_columns
   local msg=$1

   # Remove _boldx delimiters. No delimiter expected but just in case.
   local none=""
   msg=${msg//$_bold1/$none}
   msg=${msg//$_bold0/$none}

   # Calculate the filler size needed to fill the whole terminal width.
   local lmsg=${#msg}
   local count=$(($COLUMNS - $lmsg -2))
   if [ $count -lt 1 ]
      then
      count=0
   fi
   local filler=$(head -c $count < /dev/zero | tr '\0' ' ' )

   echo -e $_ansi_black$_ansi_bg_white"  ${msg}${filler}"$_ansi_off
}

# ------------------------------------------------------------------------------
# function print_warning_centered (message)
# ------------------------------------------------------------------------------
function print_warning_centered ()
{
   _update_screen_columns
   local msg=$1

   # Remove _boldx delimiters. No delimiter expected but just in case.
   local none=""
   msg=${msg//$_bold1/$none}
   msg=${msg//$_bold0/$none}

   # Calculate the filler size needed to fill the whole terminal width.
   local lmsg=${#msg}
   local count=$(($COLUMNS - $lmsg))
   if [ $count -lt 1 ]
      then
      count=0
   fi
   local count2=$(($count / 2))
   local filler1=$(head -c $count2 < /dev/zero | tr '\0' ' ' )
   local filler2=
   if [ `expr $count % 2` == 0 ]; then
      filler2=$filler1
   else
      filler2=$filler1" "
   fi
   echo -e $_ansi_black$_ansi_bg_yellow_light"${filler1}${msg}${filler2}"$_ansi_off
}

# ------------------------------------------------------------------------------
# function print_full_width_server_colors (msg)
# Writes a text with current server mode colors. Full width.
# ------------------------------------------------------------------------------
function print_full_width_server_colors ()
{
   _update_screen_columns
   local msg=$1

   # Remove _boldx delimiters. No delimiter expected but just in case.
   local none=""
   msg=${msg//$_bold1/$none}
   msg=${msg//$_bold0/$none}

   # Calculate the filler size needed to fill the whole terminal width.
   local lmsg=${#msg}
   local count=$(($COLUMNS - $lmsg -2))
   if [ $count -lt 1 ]
      then
      count=0
   fi
   local filler=$(head -c $count < /dev/zero | tr '\0' ' ' )
   local bg=
   local fg=
   case $var_current_mode in
        $MODE_WOTLK) bg=$_c_wotlk_bg
                     fg=$_c_wotlk_fg
                     ;;
    $MODE_CATACLYSM) bg=$_c_cataclysm_bg
                     fg=$_c_cataclysm_fg
                     ;;
   esac
   echo -e $fg$bg"  ${msg}${filler}"$_ansi_off
}

# ------------------------------------------------------------------------------
# function read_answer (literal)
# Colored user input showing literal. Puts the user text into variable var_answer.
# ------------------------------------------------------------------------------
function read_answer ()
{
   local text=$1
   text=${text//$_bold1/$_c_bold1}
   text=${text//$_bold0/$_ansi_off}
   echo -en "$text$__input"
   read var_answer
   echo -en $_ansi_off
}

# ------------------------------------------------------------------------------
# function read_confirmation (action)
# Prompt the user to type "ok" in order to confirm the operation especified in
# the first parameter (action). If confirmed (the user typed "ok"), variable
# var_confirmed is true or false otherwise.
# ------------------------------------------------------------------------------
function read_confirmation ()
{
   local msg=$1
   if [[ $msg = "" ]]; then
      msg="proceed"
   fi

   msg="$cons_msg_type_ok_to_"$_bold1"$msg"$_bold0": "
   msg=${msg//$_bold1/$_ansi_yellow}
   msg=${msg//$_bold0/$_ansi_off}
   echo -en "$msg"
   read_answer
   if [[ $var_answer = "$cons_confirmation" ]]
      then
      var_confirmed=1
   else
      print_error_message "$cons_msg_not_confirmed"
      # This counts as "false".
      var_confirmed=
   fi
}

# ------------------------------------------------------------------------------
# function print_running_state ($pid, $filename)
# Writes [Running], [Stopped] or [N/A] depending on a valid pid ($1) and an
# existing or not filename ($2).
# ------------------------------------------------------------------------------
function print_running_state ()
{
   local pid="$1"
   if [ $pid ]; then
      echo -en $_ansi_black$_ansi_bg_green"[ $cons_lit_running ]"$_ansi_off
   else
      local filename="$2"
      if [ -f "$filename" ]; then
         echo -en $_ansi_black$_ansi_bg_red"[ $cons_lit_stopped ]"$_ansi_off
      else
         echo -en $_ansi_gray$_ansi_bg_dark_gray"[ $cons_lit_n_a ]"$_ansi_off
      fi
   fi
}

# ------------------------------------------------------------------------------
# function print_menu_title ($title)
# ------------------------------------------------------------------------------
function print_menu_title ()
{
   local title=$1
   local count=$(expr $COLUMNS - $mn_c1_letter - $mn_c1_letter)
   local x=$mn_c1_letter
   local cbg=
   local cf1=
   local cf2=
   case $var_current_mode in
        $MODE_WOTLK)
            cbg="\e[48;5;18m"
            cf1="\e[38;5;87m"
            cf2=$_ansi_white
            ;;
    $MODE_CATACLYSM)
            cbg="\e[48;5;52m"
            cf1="\e[38;5;202m"
            cf2="\e[38;5;222m"
            ;;
   esac
   print_x $x $cbg$cf1"---"
   count=$(expr $count - 3)
   x=$(expr $x + 3)
   print_x $x "[ "
   count=$(expr $count - 2)
   x=$(expr $x + 2)
   print_x $x $cf2"$title"
   count=$(expr $count - ${#title})
   x=$(expr $x + ${#title})
   print_x $x $cf1" ]"
   count=$(expr $count - 2)
   x=$(expr $x + 2)
 
   local filler=$(head -c $count < /dev/zero | tr '\0' '-' )
 
   print_x $x $filler
   echo -e $_ansi_off
}

# ------------------------------------------------------------------------------
# function show_wosss_info ()
# Shows a lot of server information
# ------------------------------------------------------------------------------
function show_wosss_info ()
{
   local from_menu=$1
   
   if [ $from_menu ]; then
      print_full_width "$cons_lit_server_information"
   fi
   
   # Host OS
   print_literal_value "$var_os_hostname - $var_os_distribution" "$cons_lit_info_host_os"
   print_literal_value "$var_os_username$_ansi_off/$var_os_userid ($HOME)" "$cons_lit_info_user"
   CR
   print_literal_value "$var_internal_ip" "$cons_lit_info_internal_ip"
   print_literal_value "$_c_bold2$var_external_ip" "$cons_lit_info_external_ip"
   CR

   # Server mode
   case $var_current_mode in
        $MODE_WOTLK)
         print_literal_value "$_c_bold2$name_wotlk_full" "$cons_lit_info_mode"
         ;;
    $MODE_CATACLYSM)
         print_literal_value "$_c_bold2$name_cataclysm_full" "$cons_lit_info_mode"
         ;;
    *)
         print_error_message "$cons_error_undefined_mode_q"
         exit
         ;;
   esac
   CR

   # Database engine
   case $var_current_dbengine in
    $DBENGINE_MARIADB)
         print_literal_value "$_c_bold2$name_mariadb_full" "$cons_lit_info_dbengine"
         ;;
    $DBENGINE_MYSQL)
         print_literal_value "$_c_bold2$name_mysql_full" "$cons_lit_info_dbengine"
         ;;
    *)
         print_error_message "$cons_error_undefined_dbengine_q"
         exit
         ;;
   esac
   # Databases
   print_literal_value "$var_db_auth_name $_bold0($var_db_auth_host:$var_db_auth_port)" "$cons_lit_info_db_auth"
   print_literal_value "$var_db_chars_name $_bold0($var_db_chars_host:$var_db_chars_port)" "$cons_lit_info_db_chars"
   print_literal_value "$var_db_world_name $_bold0($var_db_world_host:$var_db_world_port)" "$cons_lit_info_db_world"
   if [ "$var_current_mode" = "$MODE_CATACLYSM" ]; then
      print_literal_value "$var_db_hotfixes_name $_bold0($var_db_hotfixes_host:$var_db_hotfixes_port)" "$cons_lit_info_db_hotfixes"
   fi
   CR

   # Directories
   print_literal_value "$_c_bold2$var_dir_base"    "$cons_lit_info_sources_dir"
   print_literal_value "$var_dir_sources</b> ($_c_bold3$var_sources_hash</b>)" "$cons_lit_info_sources_dir"
   print_literal_value "$var_dir_servers" "$cons_lit_info_servers_dir"
   print_literal_value "$_c_bold3$var_bin_authserver" "$cons_lit_info_authserver"
   print_literal_value "$_c_bold3$var_bin_worldserver" "$cons_lit_info_worldserver"
   print_literal_value "$var_dir_config"  "$cons_lit_info_conf_dir"
   print_literal_value "$var_dir_data</b> ($_c_bold3$var_data_files_count</b>)"    "$cons_lit_info_data_dir"
   print_literal_value "$var_dir_logs"    "$cons_lit_info_logs_dir"
   print_literal_value "$var_dir_scripts" "$cons_lit_info_scripts_dir"
   print_literal_value "$var_dir_docs"    "$cons_lit_info_docs_dir"
   print_literal_value "$var_dir_temp"    "$cons_lit_info_temp_dir"
   print_literal_value "$var_dir_backup_local" "$cons_lit_info_backup_dir"
   if [ $var_do_remote_backups -gt 0 ]; then
      print_literal_value "$_c_bold3$var_dir_backup_remote" "$cons_lit_info_backup_remote_dir"
   else
      print_literal_value "$_ansi_off$cons_lit_disabled_" "$cons_lit_info_backup_remote_dir"
   fi

   # server 1 status !!!
   # server 2 status !!!
   CR
   if [ $from_menu ]; then
      read_answer "$cons_msg_press_enter_to_continue"
   fi
}

# ------------------------------------------------------------------------------
# function play_sound ($filename_without_path)
# ------------------------------------------------------------------------------
function play_sound ()
{
   local filename=$1
   $cons_playsound "$var_dir_sounds/$filename" &> /dev/null
}
