dir="$1"
if [[ $dir == "" ]]; then
   echo Sets 755 to directories and 644 to files recursively in the given directory.
   echo chmodall.sh directory
else
   find $1 -type d -exec chmod 755 {} \;
   find $1 -type f -exec chmod 644 {} \;
fi
