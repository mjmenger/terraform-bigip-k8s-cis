eval "$(jq -r '@sh "KEYPATH=\(.sshkeypath) BIGIPUSER=\(.bigip_user) BIGIPADDRESS=\(.bigip_address) TUNNELNAME=\(.tunnel_name)"')"

MACADDR=`ssh -i $KEYPATH $BIGIPUSER@$BIGIPADDRESS -oStrictHostKeyChecking=no 'tmsh show net tunnels tunnel $TUNNELNAME all-properties | grep MAC' | awk '{print $3}' | head -1`

jq -n --arg tunnelname "$TUNNELNAME" --arg macaddress "$MACADDR" '{"mac":$macaddress, "tunnelname": $tunnelname}'