# ------------------------------------------------------------------------------
# function get_sources_hash ()
# function servers_sources_download (quit_on_error)
# function servers_sources_update ()
# function servers_sources_compile_and_install ()
# function wowsss_check_update_available ()
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# function get_sources_hash ()
# Stores the current AzerothCore sources Github hash in "$var_sources_hash".
# ------------------------------------------------------------------------------
function get_sources_hash ()
{
   if [ -d "$var_dir_sources" ]; then
      cd $var_dir_sources
      var_sources_hash=$(git log --pretty=format:'%h' -n 1 2>/dev/null);
   fi
   if [[ $var_sources_hash = "" ]]; then
      var_sources_hash="-none-"
   fi
}

# ------------------------------------------------------------------------------
# function sources_update_available ()
# Checks if there is an update for the servers sources. Returns 1 into
# var_sources_update_available if an update is available or 0 otherwise.
# ------------------------------------------------------------------------------
function _do_sources_check_update_available()
{
   # A previous function must have moved to the git directory to check for updates.
   var_sources_update_available=0
   git fetch origin &>/dev/null

   local UPSTREAM=${1:-'@{u}'}
   local LOCAL=$(git rev-parse @)
   local REMOTE=$(git rev-parse "$UPSTREAM")
   local BASE=$(git merge-base @ "$UPSTREAM")

   if [ $LOCAL = $REMOTE ]; then
       # echo "Up-to-date"
       var_sources_update_available=0
   elif [ $LOCAL = $BASE ]; then
       # echo "Need to pull"
       var_sources_update_available=1
   elif [ $REMOTE = $BASE ]; then
       # echo "Need to push"
       var_sources_update_available=0
   else
       # echo "Diverged"
       var_sources_update_available=0
   fi
}

function sources_check_update_available ()
{
   cd "$var_dir_sources"
   _do_sources_check_update_available
   if [[ $var_sources_update_available -le 0 ]]; then
      if [[ $var_current_mode -eq $MODE_WOTLK ]]; then
         cd $var_dir_sources/modules
         _do_sources_check_update_available
      fi
   fi
   # To get the remote hash (I'm not using it by now):
   # git rev-parse `git branch -r --sort=committerdate | tail -1`
   # git rev-parse origin/master
}

# ------------------------------------------------------------------------------
# function servers_sources_download (quit_on_error)
# Deletes the current server sources (if any). Downloads latest server sources
# from Github and creates the make files.
# Returns non-zero on error.
# If $1 is non-zero this function will quit on error.
# ------------------------------------------------------------------------------
function servers_sources_download ()
{
   local quit_on_error=$1
   local result=0

   # Delete old sources if present
   if test -d "$var_dir_sources"; then
      print_warning_message "$cons_msg_deleting_old_sources"
      rm "$var_dir_sources" -rf
   fi

   # Download the main server sources
   mkdir -p "$var_dir_sources"
   cd "$var_dir_sources"
   print_info_message "$cons_msg_cloning_sources"
   case $var_current_mode in
    $MODE_WOTLK)
            git clone "$cons_url_wotlk_sources_github" --branch master --single-branch "$var_dir_sources"
            ;;
    $MODE_CATACLYSM)
            git clone "$cons_url_catacysm_sources_github" "$var_dir_sources"
            ;;
    $MODE_MOP)
            git clone "$cons_url_mop_sources_github" "$var_dir_sources"
            ;;
   esac

   result=$?
   if [ $result -ne 0 ] ; then
      if [ $quit_on_error > 0 ]; then
         play_sound_fatal_error
         print_fatal_error "$cons_msg_error_dwnd_sources"
      else
         print_error_message "$cons_msg_error_dwnd_sources"
         return $result
      fi
   fi

   # Download modules in WotLK
   if [ $var_current_mode = $MODE_WOTLK ]; then
      print_info_message "$cons_msg_cloning_transmog_mod"
      cd $var_dir_sources/modules
      git clone https://github.com/azerothcore/mod-transmog.git
      result=$?
      if [ $result -ne 0 ] ; then
         play_sound_fatal_error
         if [ $quit_on_error -gt 0 ]; then
            print_fatal_error "$cons_msg_error_dwnd_mods"
         else
            print_error_message "$cons_msg_error_dwnd_mods"
            return $result
         fi
      fi
   fi
   servers_update_server_versions

   cd $var_dir_sources
   print_info_message "$cons_msg_creating_make_files"
   mkdir build
   cd build

   case $var_current_mode in
      $MODE_WOTLK)
         cmake ../ -DCMAKE_INSTALL_PREFIX=$var_dir_servers/ -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++ -DWITH_WARNINGS=1 -DTOOLS_BUILD=maps-only -DSCRIPTS=static -DMODULES=static
         ;;
      $MODE_CATACLYSM)
         cmake ../ -DCMAKE_INSTALL_PREFIX=$var_dir_servers/ -DSERVERS=1 -DTOOLS=1 -DWITH_WARNINGS=1
         ;;
      $MODE_MOP)
         cmake ../ -DCMAKE_INSTALL_PREFIX=$var_dir_servers/ -DSERVERS=1 -DTOOLS=1 -DWITH_WARNINGS=1
         ;;
   esac
   result=$?
   if [ $result -ne 0 ] ; then
      play_sound_fatal_error
      if [ $quit_on_error -gt 0 ]; then
         print_fatal_error "$cons_msg_error_creating_make_files"
      else
         print_error_message "$cons_msg_error_creating_make_files"
         return $result
      fi
   fi
   # Ugly calling this from here but...
   initial_check_sql_files
}

# ------------------------------------------------------------------------------
# function servers_sources_compile_and_install ()
# Compiles and installs the servers sources and updates the log files.
# Makes backup of *.conf.dist files to check changes.
# ------------------------------------------------------------------------------
function servers_sources_compile_and_install ()
{
   local msg=$1
   local _start_time=
   local _elapsed=

   if [[ "$msg" != "" ]]; then
      print_full_width "$msg"
   fi

   var_sources_just_compiled=

   local filename=$var_dir_docs/history-$var_current_mode_prefix.txt
   cd $var_dir_sources/build
   cmake ..

   make clean
   # Add starting compiling time to history-xxxx.txt.
   echo "   "--- >> "$filename"
   echo "   "Started at  $(date +"%Y/%m/%d %H:%M:%S") >> "$filename"

   _start_time=$SECONDS
      # Make!
      if [[ $var_compiler_cores -gt 0 ]]; then
         make -j $var_compiler_cores
      else
         make
      fi
      if [ $? -eq 0 ]; then
         var_sources_just_compiled=1
      fi
   _elapsed=$(( SECONDS - start_time ))

   # Add finishing compiling time to history-xxxx.txt.
   echo "   "Finished at $(date +"%Y/%m/%d %H:%M:%S") >> "$filename"

   if [[ $var_sources_just_compiled ]]; then
   # echo Elapsed time: $(date -ud "@$elapsed" +'$((%s/3600/24)) days %H hr %M min %S sec')
      echo "   "--- $(date -ud "@$_elapsed" +'%Hh %Mm %Ss') "($var_compiler_cores $cons_lit_cores)" >> "$filename"
      # ------------------------------------------------------------------------
      # Installs the servers binaries and makes backup of *.conf.dist files to
      # check changes.
      # ------------------------------------------------------------------------
      print_info_message "$cons_msg_backing_up_dist_cfg_files"
      # Backup up previous *.conf.dist files to compare possible changes.
      cd $var_dir_config
      cp "$var_as_process_name.conf.dist" "$var_as_process_name.conf.dist.old"
      cp "$var_ws_process_name.conf.dist" "$var_ws_process_name.conf.dist.old"
      if [ $var_current_mode = $MODE_WOTLK ]; then
         cp modules/transmog.conf.dist modules/transmog.conf.dist.old
      fi
      # Make install
      print_info_message "$cons_msg_make_install"
      cd $var_dir_sources/build
      make install
      play_sound_work_complete
   else
      echo "   "---"(error)" $(date -ud "@$_elapsed" +'%Hh %Mm %Ss') "($var_compiler_cores $cons_lit_cores)" >> "$filename"
      play_sound_error
   fi
   servers_setup_default_config_files

   return $var_sources_just_compiled
}

# ------------------------------------------------------------------------------
# function servers_sources_update ()
# Updates the source code to its last push.
# ------------------------------------------------------------------------------
function servers_sources_update ()
{
   local mode=

   print_info_message "$cons_msg_checking_updates_for_<b>$var_server_name</b>..."
   cd $var_dir_sources
   case $var_current_mode in
    $MODE_WOTLK)
            # For AzerothCore-WotLK:
            git pull origin master
            if [ $? -eq 0 ]; then
               servers_update_server_versions
            fi
            # For Mod-Transmog:
            print_info_message "$cons_msg_checking_updates_for_<b>TransMog</b>..."
            cd $var_dir_sources/modules/mod-transmog/
            git pull origin master
            ;;
    $MODE_CATACLYSM)
            # For AzerothCore-WotLK:
            git pull origin master
            if [ $? -eq 0 ]; then
               servers_update_server_versions
            fi
            ;;
    $MODE_MOP)
            # For AzerothCore-WotLK:
            git pull origin master
            if [ $? -eq 0 ]; then
               servers_update_server_versions
            fi
            ;;
   esac
   sources_check_update_available
}

# ------------------------------------------------------------------------------
# function wowsss_check_update_available ()
# Checks if there is an update for the servers sources. Returns 1 into
# var_sources_update_available if an update is available or 0 otherwise.
# Note: var_sources_update_available is meant for server sources only.
#       Keep its value.
# ------------------------------------------------------------------------------
function wowsss_check_update_available()
{
   print_info_message "$cons_msg_wowsss_checking_updates"
   cd "$var_dir_base"
   _do_sources_check_update_available
   # Let's reset var_sources_update_available to use it for the real server
   # sources.
   var_wowsss_update_available=$var_sources_update_available
   var_sources_update_available=0
   #var_wowsss_update_available=1 #debug

   if [[ $var_wowsss_update_available -gt 0 ]]; then
      print_warning_message "$cons_msg_wowsss_new_version_available"
      read_answer "$cons_qst_install_update"
      if [ "$var_answer" = "" ] || [ "$var_answer" = "Y" ] || [ "$var_answer" = "y" ]
         then
         print_info_message "$cons_msg_updating"
         git pull
         if [ $? -eq 0 ]; then
            print_error_message "$cons_error_wowsss_updating"
         else
            print_warning_message "$cons_msg_wowsss_updated"
            print_info_message "$cons_msg_restarting"
            local filename=$(realpath -s "$0")
            $filename
         fi
         exit
      else
         print_info_message "$cons_msg_skipping"
      fi
   fi
}
