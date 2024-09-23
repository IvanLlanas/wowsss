# ------------------------------------------------------------------------------
# World of Warcraft Server Script System environment setup
# (C) Copyright by Ivan Llanas, 2023
# ------------------------------------------------------------------------------

# ANSI colors
_0="\e[0m"
_r="\e[31m"
_b="\e[34m"
_l="\e[92m"
_y="\e[93m"
_c="\e[96m"
_w="\e[97m"

confirmed=

# Internal themes
THEME_IVAN=1
THEME_INAS=2
THEME_VANILLA=3
THEME_WOTLK=4
THEME_CATACLYSM=5
theme=

# Terminal profiles ID.
profile_ivan=b1dcc9dd-5262-4d8d-a863-c897e6d979b9
profile_inas=b1dcc9dd-5262-4d8d-a863-c897e6d979b9
profile_vanilla=9956a6c5-0a18-47f7-8777-ff097f8254c3
profile_wotlk=c88a9988-91de-4767-b381-89adef5b6180
profile_cataclysm=7bb44f24-9657-4f0a-8f68-06995133b4eb

#
path_media="../../media"
path_icons="$path_media/icons"
path_wallpapers="$path_media/wallpapers"
path_grub="$path_media/grub/"

# ------------------------------------------------------------------------------
function choose_theme ()
{
   cr
   echo "Available themes:"
   cr
   echo -e "   $_w$THEME_IVAN - $_b""Ivan"$_0
   echo -e "   $_w$THEME_INAS - $_l""INAS"$_0
   echo -e "   $_w$THEME_VANILLA - $_y""Vanilla"$_0
   echo -e "   $_w$THEME_WOTLK - $_c""Wrath of the Lich King"$_0
   echo -e "   $_w$THEME_CATACLYSM - $_r""Cataclysm"$_0
   cr
   echo -n "Select theme: "
   read theme
   case $theme in
          $THEME_IVAN) echo -e $_b"Ivan$_w theme selected."$_0;;
          $THEME_INAS) echo -e $_l"INAS$_w theme selected."$_0;;
       $THEME_VANILLA) echo -e $_y"Vanilla$_w theme selected."$_0;;
         $THEME_WOTLK) echo -e $_c"WotLK$_w theme selected."$_0;;
     $THEME_CATACLYSM) echo -e $_r"Cataclysm$_w theme selected."$_0;;
                    *) echo -e $_r"Invalid!"
                       exit
                       ;;
   esac
}

# ------------------------------------------------------------------------------
function cr ()
{
   echo ""
}

# ------------------------------------------------------------------------------
function log ()
{
   echo -e "$1"
}

# ------------------------------------------------------------------------------
function announce ()
{
   cr
   echo -e $_w$1$_0
}

# ------------------------------------------------------------------------------
function not_found ()
{
   local filename=$1
   echo -e "\"$_y$filename$_0\" $_r""not found!"$_0
}

# ------------------------------------------------------------------------------
function confirm ()
{
   local msg="$1"
   local msg2="$2"
   local answer=

   msg="Do you want to \"$_w$msg$_0\" [$_l""YES$_0/no]? "
   cr
   echo -en "$msg"
   read answer
   if [[ $answer = "no" ]] || [[ $answer = "n" ]]; then
      echo -e $_r" No $_0 -> Skipping."
      confirmed=
   else
      echo -en $_l" Yes $_0 -> $_w$msg2$_0"
      confirmed=1
   fi
   cr
}

# ------------------------------------------------------------------------------
function backup_file ()
{
   local filename="$1"
   if [ ! -f "$filename".old ]; then
      sudo cp "$filename" "$filename".old
   fi
}
# ------------------------------------------------------------------------------
function keyboard_set_option ()
{
   confirm "set up keyboard options" "Setting up keyboard options..."
   if [ $confirmed ]; then
      sudo sed -i 's/\(^XKBOPTIONS=\).*/\1\"numpad:microsoft\"/' /etc/default/keyboard
   fi
}

# ------------------------------------------------------------------------------
function terminal_startup_configuration_files ()
{
   confirm "restore startup configuration files" "Copying startup configuration files..."
   if [ $confirmed ]; then
      cp data/bashrc ~/.bashrc
      cp data/bash_aliases ~/.bash_aliases
      cp data/nanorc ~/.nanorc
   fi
}

# ------------------------------------------------------------------------------
function terminal_import_profiles ()
{
   confirm "import terminal profiles" "Importing terminal profiles..."
   if [ $confirmed ]; then
      local filename="data/gnome-terminal-profiles.dconf"
      local profile=
      case $theme in
             $THEME_IVAN) profile=$profile_ivan;;
             $THEME_INAS) profile=$profile_inas;;
          $THEME_VANILLA) profile=$profile_vanilla;;
            $THEME_WOTLK) profile=$profile_wotlk;;
        $THEME_CATACLYSM) profile=$profile_cataclysm;;
      esac
      sed -i 's/default\s\{0,\}=.*/default='\'$profile\'/ $filename
      dconf load /org/gnome/terminal/legacy/profiles:/ < $filename
      # dconf dump /org/gnome/terminal/legacy/profiles:/ > gnome-terminal-profiles.dconf
   fi
}

# ------------------------------------------------------------------------------
function _gui_set_themes ()
{
   local gtk=$1
   local icon=$2
   gsettings set org.gnome.shell.ubuntu            color-scheme 'prefer-dark'
   gsettings set org.gnome.desktop.interface       color-scheme 'prefer-dark'
   gsettings set org.gnome.desktop.interface       gtk-theme    $1
   gsettings set org.gnome.desktop.interface       icon-theme   $2
   gsettings set org.gnome.desktop.interface       cursor-theme 'Adwaita'
   gsettings set org.gnome.desktop.wm.preferences  theme        'Adwaita'
}
      # ------------------------------------------------------------------------------
      function _gui_get_themes ()
      {
      #  prefer-dark
      #  prefer-dark
      #  Yaru-dark       Yaru-blue-dark      Yaru-red-dark
      #  Yaru            Yaru-blue           Yaru-red
      #  Adwaita
      #  Adwaita
         gsettings get org.gnome.shell.ubuntu            color-scheme
         gsettings get org.gnome.desktop.interface       color-scheme
         gsettings get org.gnome.desktop.interface       gtk-theme
         gsettings get org.gnome.desktop.interface       icon-theme
         gsettings get org.gnome.desktop.interface       cursor-theme
         gsettings get org.gnome.desktop.wm.preferences  theme
      }

# ------------------------------------------------------------------------------
function gui_mode_set_dark ()
{
   announce "Setting up dark mode..."
   case $theme in
          $THEME_IVAN) _gui_set_themes "Yaru-blue-dark" "Yaru-blue";;
          $THEME_INAS) _gui_set_themes "Yaru-blue-dark" "Yaru-blue";;
       $THEME_VANILLA) _gui_set_themes "Yaru-dark"      "Yaru";;
         $THEME_WOTLK) _gui_set_themes "Yaru-blue-dark" "Yaru-blue";;
     $THEME_CATACLYSM) _gui_set_themes "Yaru-red-dark"  "Yaru-red";;
   esac
}

# ------------------------------------------------------------------------------
function gui_mouse_set_pointer_size ()
{
   announce "Setting mouse pointer size..."
   gsettings set org.gnome.desktop.interface cursor-size 48
}

# ------------------------------------------------------------------------------
function gui_user_set_icon ()
{
   confirm "setup user icon" "Setting up user icon..."
   if [ $confirmed ]; then
      local filename=
      case $theme in
             $THEME_IVAN) filename=$(realpath ivan/avatars/avatar-ivan-1.png);;
             $THEME_INAS) filename=$(realpath ivan/avatars/avatar-ivan-1.png);;
          $THEME_VANILLA) filename=$(realpath $path_icons/vanilla-icon-1.png);;
            $THEME_WOTLK) filename=$(realpath $path_icons/wotlk-icon-1.png);;
        $THEME_CATACLYSM) filename=$(realpath $path_icons/cataclysm-icon-1.png);;
      esac
      if [ -f "$filename" ]; then
         busctl call org.freedesktop.Accounts /org/freedesktop/Accounts/User$UID org.freedesktop.Accounts.User SetIconFile s "$filename"
      else
         not_found "$filename"
      fi
   fi
}

# ------------------------------------------------------------------------------
function gui_desktop_wallpaper_setup ()
{
   confirm "setup desktop wallpaper" "Setting up desktop wallpaper..."
   if [ $confirmed ]; then
      local filename=
      case $theme in
             $THEME_IVAN) filename=$(realpath ivan/wallpapers/city-17-2.jpg);;
             $THEME_INAS) filename=$(realpath ivan/wallpapers/traffic-7.jpg);;
          $THEME_VANILLA) filename=$(realpath $path_wallpapers/vanilla-1-b.jpg);;
            $THEME_WOTLK) filename=$(realpath $path_wallpapers/wotlk-2-b.jpg);;
        $THEME_CATACLYSM) filename=$(realpath $path_wallpapers/cataclysm-2-b.jpg);;
      esac
      if [ -f "$filename" ]; then
         gsettings set org.gnome.desktop.background picture-uri-dark "file:///$filename"
      else
         not_found "$filename"
      fi
   fi
}

# ------------------------------------------------------------------------------
function gui_desktop_hide_home ()
{
   announce "Hiding personal folder icon..."
   gsettings set org.gnome.shell.extensions.ding show-home false
}

# ------------------------------------------------------------------------------
function gui_dock_setup ()
{
   announce "Setting up dock..."
   gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed true
   gsettings set org.gnome.shell.extensions.dash-to-dock dock-position LEFT
   gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false
   gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 48
   # gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode FIXED
   # gsettings set org.gnome.shell.extensions.dash-to-dock background-opacity 0.0
   # gsettings set org.gnome.shell.extensions.dash-to-dock unity-backlit-items true
}

# ------------------------------------------------------------------------------
function gui_dock_hide_trash ()
{
   announce "Hiding trash icon..."
   gsettings set org.gnome.shell.extensions.dash-to-dock show-trash false
}

# ------------------------------------------------------------------------------
function gui_dock_copy_desktop_icons ()
{
   confirm "setup and copy dock icons definitions" "Setting up and copying dock icons definitions..."
   if [ $confirmed ]; then
      # The *.desktop files should be copied to /usr/share/applications in order to add icons to the Applications
      # menu and the Dock.
      local name=
      local comment=
      local icon=

      case $theme in
          $THEME_VANILLA) name="WoW Server"
                          comment="WoW Server Management"
                          icon=$(realpath $path_icons/vanilla-icon-1.png)
                          ;;
            $THEME_WOTLK) name="WotLK Server"
                          comment="WotLK Server Management"
                          icon=$(realpath $path_icons/wotlk-icon-1.png)
                          ;;
        $THEME_CATACLYSM) name="Cataclysm Server"
                          comment="Cataclysm Server Management"
                          icon=$(realpath $path_icons/cataclysm-icon-1.png)
                          ;;
      esac
      if [ ! "$name" == "" ]; then
         local filename="data/wowsss.desktop"
         local script=$(realpath ../wowsss/wowsss.sh)
         # Replace / with \/
         name=${name//\//\\\/}
         comment=${comment//\//\\\/}
         icon=${icon//\//\\\/}
         script=${script//\//\\\/}

         sed -i 's/Exec\s\{0,\}=.*/Exec=\/usr\/bin\/bash '"$script"/ $filename
         sed -i 's/Name\s\{0,\}=.*/Name='"$name"/ $filename
         sed -i 's/Comment\s\{0,\}=.*/Comment='"$comment"/ $filename
         sed -i 's/Icon\s\{0,\}=.*/Icon='"$icon"/ $filename

         sudo cp data/*.desktop /usr/share/applications
      fi
   fi
}

# ------------------------------------------------------------------------------
function grub_setup_menu ()
{
   confirm "setup GRUB 2 menu" "Setting up GRUB 2 menu..."
   if [ $confirmed ]; then
      local filename=/etc/default/grub
      local wp=
      local distrib=
      case $theme in
             $THEME_IVAN) wp=$(realpath ivan/grub/city-17-2-grub.png)
                          distrib=
                          ;;
             $THEME_INAS) wp=$(realpath ivan/grub/inas-grub.png)
                          distrib=
                          ;;
          $THEME_VANILLA) wp=$(realpath $path_grub/vanilla-1.png)
                          distrib="World of Warcraft Server"
                          ;;
            $THEME_WOTLK) wp=$(realpath $path_grub/wotlk-2.png)
                          distrib="WoW - Wrath of the Lich King Server"
                          ;;
        $THEME_CATACLYSM) wp=$(realpath $path_grub/cataclysm-2.png)
                          distrib="WoW - Cataclysm Server"
                          ;;
      esac
      backup_file "/etc/default/grub"

# GRUB_DEFAULT=0
# GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
# GRUB_CMDLINE_LINUX=""
# GRUB_BACKGROUND="wp"
# GRUB_DISTRIBUTOR="WoW – WotLK"
# GRUB_TIMEOUT_STYLE=menu
# GRUB_TIMEOUT=5
# GRUB_GFXMODE=640x480
#          sed -i 's/XXXX\s\{0,\}=.*/XXXX='"$variable"/ $filename

      local buffer=$(grep GRUB_BACKGROUND < $filename)
      backup_file "$filename"

      # if no entry for GRUB_BACKGROUND is found let's add a new one.
      if [ "$buffer" == "" ]; then
         sudo bash -c 'echo GRUB_BACKGROUND="'$wp'" >> '$filename
      fi

      # Replace / with \/
      wp=${wp//\//\\\/}
      distrib=${distrib//\//\\\/}
      sudo sed -i 's/#GRUB_BACKGROUND\s\{0,\}=.*/GRUB_BACKGROUND=\"'"$wp"'\"/' $filename
      sudo sed -i 's/GRUB_BACKGROUND\s\{0,\}=.*/GRUB_BACKGROUND=\"'"$wp"'\"/' $filename

      if [ ! "$distrib" == "" ]; then
         sudo sed -i 's/GRUB_DISTRIBUTOR\s\{0,\}=.*/GRUB_DISTRIBUTOR=\"'"$distrib"'\"/' $filename
      fi

      sudo sed -i 's/GRUB_TIMEOUT_STYLE\s\{0,\}=.*/GRUB_TIMEOUT_STYLE=menu/' $filename
      sudo sed -i 's/GRUB_TIMEOUT\s\{0,\}=.*/GRUB_TIMEOUT=5/' $filename

      sudo sed -i 's/#GRUB_GFXMODE\s\{0,\}=.*/GRUB_GFXMODE=640x480/' $filename
      sudo sed -i 's/GRUB_GFXMODE\s\{0,\}=.*/GRUB_GFXMODE=640x480/' $filename

# Colors: red, green, blue, cyan, magenta, brown, light-gray, black
# Foreground has additional colors available:
#         light-red, light-green, light-blue
#         light-cyan, light-magenta, yellow, white, dark-gray

      # sudo nano /etc/grub.d/05_debian_theme
      # ... WotLK
      # if [ -z "${2}" ] && [ -z "${3}" ]; then
      #  #echo "  true"
      #  echo "  set color_highlight=black/light-cyan"
      #  echo "  set color_normal=white/black"
      # fi
      # ...
      # ... Ivan
      # if [ -z "${2}" ] && [ -z "${3}" ]; then
      #  #echo "  true"
      #  echo "  set color_highlight=black/cyan"
      #  echo "  set color_normal=white/black"
      # fi
      # ...

      sudo update-grub
   fi
}


# ------------------------------------------------------------------------------
function login_screen_wallpaper ()
{
   confirm "setup login screen wallpaper" "Setting up login screen wallpaper..."
   if [ $confirmed ]; then
      local filename=
      case $theme in
             $THEME_IVAN) filename=ivan/wallpapers/city-17-2.jpg
                          ;;
             $THEME_INAS) filename=ivan/wallpapers/data-city.jpg
                          ;;
          $THEME_VANILLA) filename=$path_media/boot-ui/wallpapers/vanilla-map.jpg
                          ;;
            $THEME_WOTLK) filename=$path_media/boot-ui/wallpapers/wotlk-map.jpg
                          ;;
        $THEME_CATACLYSM) filename=$path_media/boot-ui/wallpapers/cataclysm-map.jpg
                          ;;
      esac
      local script=ubuntu-gdm-set-background/src/post-23.sh
      sudo $script --image "$filename"
   fi
}

# ------------------------------------------------------------------------------
function boot_setup_logos ()
{
# ------------------------------------------------------------------------------
# I updated my probook 450 g3 to kubuntu 20.04 but didnt get the oem logo.
# Had to manually enable. In terminal:
# $ sudo apt install plymouth-theme-spinner (This is the OEM Boot logo theme)
# $ sudo update-alternatives --config default.plymouth (Let´s you pick a default theme if more than one is installed)
# Select the "bgrt" theme.
# $ sudo update-initramfs -u
# Then reboot.
# ------------------------------------------------------------------------------   confirm "setup system boot logos" "Setting up system boot logos..."
   confirm "setup boot logos" "Setting up boot logos..."
   if [ $confirmed ]; then
      local prefix=
      local path=
      case $theme in
             $THEME_IVAN) prefix=ivan
                          path=ivan
                          ;;
             $THEME_INAS) prefix=inas
                          path=ivan
                          ;;
          $THEME_VANILLA) prefix=vanilla
                          path=$path_media
                          ;;
            $THEME_WOTLK) prefix=wotlk
                          path=$path_media
                          ;;
        $THEME_CATACLYSM) prefix=cataclysm
                          path=$path_media
                          ;;
      esac
      backup_file "/usr/share/plymouth/themes/spinner/bgrt-fallback.png"
      backup_file "/usr/share/plymouth/themes/spinner/watermark.png"
      backup_file "/usr/share/plymouth/ubuntu-logo.png"
      sudo cp $path/boot-ui/192/$prefix-bgrt-fallback.png     /usr/share/plymouth/themes/spinner/bgrt-fallback.png
      sudo cp $path/boot-ui/$prefix-watermark.png             /usr/share/plymouth/themes/spinner/watermark.png
      sudo cp $path/boot-ui/$prefix-ubuntu-logo.png           /usr/share/plymouth/ubuntu-logo.png
      # sudo nano /usr/share/plymouth/themes/bgrt/bgrt.plymouth
      # set value of ‘UseFirmwareBackground’ to false under [boot-up], [reboot], and [shutdown] sections.
      local filename=/usr/share/plymouth/themes/bgrt/bgrt.plymouth
      backup_file "$filename"
      sudo sed -i 's/UseFirmwareBackground\s\{0,\}=.*/UseFirmwareBackground=true/' "$filename"
   fi
}

# ------------------------------------------------------------------------------
function main ()
{
   # We want case-insensitive comparisons.
   shopt -s nocasematch

   cr
   log "---------------------[ WoWSSS environment ]-----------------------"
   log " This script configures some of $_r""my$_0 preferences and configurations"
   log " for an Ubuntu system with a $_y""GNOME 46+$_0 desktop."
   log " Do not run this unless you are me or you are sure you want these changes."
   log "------------------------------------------------------------------"
   echo -en "Press $_w""ENTER$_0 to continue or $_r""break$_0 to cancel..."
   read

   choose_theme

   grub_setup_menu
   boot_setup_logos
   login_screen_wallpaper

   keyboard_set_option
   terminal_startup_configuration_files
   terminal_import_profiles

   gui_mode_set_dark
   gui_mouse_set_pointer_size
   gui_desktop_wallpaper_setup
   gui_desktop_hide_home
   gui_user_set_icon
   gui_dock_setup
   gui_dock_hide_trash
   gui_dock_copy_desktop_icons

   cr
   log $_l"Done."$_0
}

main
