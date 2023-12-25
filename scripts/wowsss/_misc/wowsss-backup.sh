# ------------------------------------------------------------------------------
function get_script_dir ()
{
   local filename=$(realpath -s "$0")
   local path=$(dirname "$filename")
   echo "$path"
}

# ------------------------------------------------------------------------------
function _compress ()
{
   local fullfilename=$1
   local files=$2
   local options=$3

   if [[ $options = "delete" ]]; then options="-sdel"
   fi
   7z a $fullfilename -t7z -mx=9 $options $files
}

# ------------------------------------------------------------------------------
function _copy_to_remote_backup ()
{
   local file="$1"
   rsync --progress "$file" "$var_dir_backup_remote"
}

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------

var_dir_wowsss_script=$(get_script_dir) # WoWSSS script directory
var_dir_base=${var_dir_wowsss_script%/*} # Remove the last subdir (scripts) from the current script's path.
var_dir_scripts="$var_dir_base/scripts"
var_dir_logs="$var_dir_base/logs"
var_dir_docs="$var_dir_base/docs"
var_dir_backup_local="$var_dir_base/backup"
var_dir_backup_remote="$HOME/remote"
var_dir_cfg1="$var_dir_base/server/wotlk/etc"
var_dir_cfg2="$var_dir_base/server/cataclysm/etc"

filename=$(date +"%Y-%m-%d_%H-%M-%S")_wowsss.7z
fullfilename=$var_dir_backup_local/$filename
cd $var_dir_base

dirs="_base/ backup/.0 data/.0 docs/ logs/.0 media/ scripts/ servers/.0 sources/.0 temp/.0"

if test -d "$var_dir_cfg1"; then
   dirs=$dirs" server/wotlk/etc/"
fi

if test -d "$var_dir_cfg2"; then
   dirs=$dirs" server/cataclysm/etc/"
fi

echo "Compressing $dirs..."
_compress "$fullfilename" "$dirs"
_copy_to_remote_backup "$fullfilename"
