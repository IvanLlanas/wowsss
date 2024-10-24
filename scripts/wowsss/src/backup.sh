# ------------------------------------------------------------------------------
# function main_menu_backup_data ()
# function main_menu_backup_sources ()
# function main_menu_backup_servers ()
# function databases_backup (sufix, databases_list)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# function _compress (filename, files_to_compress, [option=delete])
# Compresses
#    $1: archive filename
#    $2: files to compress
#    $3: Options (If options="delete" source files are deleted after
#        compression)
# ------------------------------------------------------------------------------
function _compress ()
{
   local fullfilename=$1
   local files=$2
   local options=$3

   if [[ $options = "delete" ]]; then options="-sdel"
   fi
   print_info_message "$cons_msg_compressing"
   7z a $fullfilename -t7z -mx=9 $options $files
}

# ------------------------------------------------------------------------------
# function _copy_to_remote_backup (fullfilename)
# Copies the file specified in the first parameter ($1) to the remote backup
# directory ($var_dir_backup_remote) if $var_user_backup_remote is true.
# ------------------------------------------------------------------------------
function _copy_to_remote_backup ()
{
   if [ $var_do_remote_backups -gt 0 ]
      then
      local fullfilename="$1"
      local filename=$(basename -- "$fullfilename")
      #extension="${filename##*.}"
      #filename="${filename%.*}"
      print_info_message "$cons_msg_copying_to_remote_: <b>$filename</b>..."
      rsync --progress "$fullfilename" "$var_dir_backup_remote"
   fi
}

# ------------------------------------------------------------------------------
# function databases_backup (sufix, databases_list)
# ------------------------------------------------------------------------------
function databases_backup ()
{
   local sufix="$1"
   local databases="$2"
   local databases_array=($databases)
   local uparams="--defaults-extra-file=$var_db_client_file"
   local files=""

   cd "$var_dir_temp"
   for database in "${databases_array[@]}"
   do
      local script=$database.sql
      files=$files" $script"
      print_info_message "$cons_lit_extracting <b>$database</b>..."
      mysqldump $uparams $database > $script
      # We'll additionally split data and structure for the characters database.
      if [ $database = $cons_wotlk_db_characters_name ] || [ $database = $cons_cataclysm_db_characters_name ] || [ $database = $cons_mop_db_characters_name ]
      then
         script=$database-structure.sql
         files=$files" $script"
         mysqldump $uparams $database > $script --no-data
         script=$database-data.sql
         files=$files" $script"
         mysqldump $uparams $database > $script --no-create-info
      fi
   done
   filename=$(date +"%Y-%m-%d_%H-%M-%S")_$sufix.7z
   fullfilename=$var_dir_backup_local/$filename
   _compress "$fullfilename" "$files" "delete"
   _copy_to_remote_backup "$fullfilename"
   print_info_message "$cons_msg_done"
}

# ------------------------------------------------------------------------------
# function main_menu_backup_servers ()
# Menu option: Save servers files (binaries, data directory and sources excluded)
# ------------------------------------------------------------------------------
function main_menu_backup_servers ()
{
   print_full_width "$cons_option_backup_servers"
   local n=${#var_dir_base}
   n=$(( n + 1 ))
   local backup=${var_dir_backup_local:$n}/.gitignore
   local data=data/.gitignore
   local docs=${var_dir_docs:$n}/
   local logs=${var_dir_logs:$n}/.gitignore
   local media=${var_dir_media:$n}/
   local scripts=${var_dir_scripts:$n}/
   local servers=servers/.gitignore
   local sources=sources/.gitignore
   local temp=${var_dir_temp:$n}/.gitignore
   local cfg=""

   local filename=$(date +"%Y-%m-%d_%H-%M-%S")_$var_current_mode_prefix"_servers.7z"
   local fullfilename=$var_dir_backup_local/$filename

   if [ -d $var_dir_config_wotlk ]; then
      cfg=$cfg" "${var_dir_config_wotlk:$n}/
   fi
   if [ -d $var_dir_config_cataclysm ]; then
      cfg=$cfg" "${var_dir_config_cataclysm:$n}/
   fi
   if [ -d $var_dir_config_mop ]; then
      cfg=$cfg" "${var_dir_config_mop:$n}/
   fi
   
   if [ -d $var_dir_base/_base ]; then # Developer's
      cfg=$cfg" _base/"
   fi

   cd $var_dir_base
   _compress "$fullfilename" "$backup $data $docs $logs $media $scripts $servers $sources $temp $cfg"
   _copy_to_remote_backup "$fullfilename"
   print_info_message "$cons_msg_done"
}

# ------------------------------------------------------------------------------
# function main_menu_backup_sources ()
# Menu option: Save current servers sources.
# ------------------------------------------------------------------------------
function main_menu_backup_sources ()
{
   print_full_width "$cons_option_backup_sources"

   print_info_message "$cons_msg_cleaning"
   cd $var_dir_sources/build
   make clean

   cd $var_dir_sources
   local filename=$(date +"%Y-%m-%d_%H-%M-%S")_$var_current_mode_prefix"_sources-($var_sources_hash).7z"
   local fullfilename=$var_dir_backup_local/$filename
   _compress "$fullfilename" "./"
   _copy_to_remote_backup "$fullfilename"
   print_info_message "$cons_msg_done"
}

# ------------------------------------------------------------------------------
# function main_menu_backup_data ()
# Menu option: Save data directory
# ------------------------------------------------------------------------------
function main_menu_backup_data ()
{
   print_full_width "$cons_option_backup_data"

   cd $var_dir_data
   local filename=$(date +"%Y-%m-%d_%H-%M-%S")_$var_current_mode_prefix"_data.7z"
   local fullfilename=$var_dir_backup_local/$filename
   _compress "$fullfilename" "./"
   _copy_to_remote_backup "$fullfilename"
   print_info_message "$cons_msg_done"
}
