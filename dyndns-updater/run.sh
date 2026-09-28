#!/usr/bin/env bash

# echo $(ls -al)

USERNAME=$(jq -r '.username' /data/options.json) 
PASSWORD=$(jq -r '.password' /data/options.json) 
HOSTNAME=$(jq -r '.hostname' /data/options.json) 
BASE_URL=$(jq -r '.base_url' /data/options.json) 
UPDATE_INTERVAL=$(jq -r '.update_interval' /data/options.json)



while true; do
  IP=$(curl -s ifconfig.me)

  echo "Updating DynDNS for $HOSTNAME with IP: $IP"

  curl -u "${USERNAME}:${PASSWORD}" \
    "${BASE_URL}hostname=${HOSTNAME}&myip=${IP}"

  echo "$IP" > /share/dyndns_ip.txt

  echo "Done."
  echo "Sleeping for ${UPDATE_INTERVAL} seconds:"
  echo -n "["
  STEPS=10
  REMAINDER=$((UPDATE_INTERVAL % STEPS))
  INTERVAL=$((UPDATE_INTERVAL / STEPS))

  for ((i=1; i<=STEPS; i++)); do
    sleep "$INTERVAL"
    echo -n "-"
  done

  # Sleep any remaining seconds
  if [ "$REMAINDER" -gt 0 ]; then
    sleep "$REMAINDER"
  fi

  echo "]"
done

