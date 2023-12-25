echo ""
echo -n "You're about to change realms names and IPs. Break to cancel..."
read aaa

ip=$(hostname -I | xargs)
user=root
pass=1234

db=wotlk_auth
realm_name="Azeroth"
mysql -u $user -p$pass -e "use $db; UPDATE realmlist SET address='$ip', name='$realm_name' WHERE id=1;"

db=cataclysm_auth
realm_name="Burnt Azeroth"
mysql -u $user -p$pass -e "use $db; UPDATE realmlist SET address='$ip', name='$realm_name' WHERE id=1;"

