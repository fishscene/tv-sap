#!/usr/bin/env bash
#set -x
version=2021.01.20
pid=0


#### https://stackoverflow.com/questions/41451159/how-to-execute-a-script-when-i-terminate-a-docker-container
#### https://www.linuxjournal.com/content/bash-trap-command
#Define cleanup procedure
function cleanup()
{
	printf "\n#####################################################################\n#####################################################################\n"
	printf "Container stopped, performing cleanup...\n"
	rm -rf /config/sap/master.cfg
	
  if [ $pid -ne 0 ]; then
    kill -SIGTERM "$pid"
    wait "$pid"
	printf "\n\n minisapserver stopped successfully.\n"
  fi
}

trap 'cleanup' EXIT
#trap 'cleanup' SIGHUP
#trap 'cleanup' SIGQUIT
#trap 'cleanup' SIGABRT
#trap 'cleanup' SIGKILL
#trap 'cleanup' SIGTERM
#trap 'cleanup' SIGUSR1
#trap 'cleanup' SIGUSR2
trap 'cleanup' SIGINT


#### Create SAP config file.
printf "\n#####################################################################\n#####################################################################\n"
printf "\nCurrent Task: Remove, then create /config/sap/master.cfg\n"

until [ "$(ls -A /config/sap)" ]; do
  >&2 printf "Scanning is not complete or stream containers have not yet started - sleeping\n"
  sleep 5
done
printf "Scanning is complete or containers have started. Moving on.\n"

rm -rf /config/sap/master.cfg
for FILE in /config/sap/*.cfg; do
  printf "Filename: $FILE\n"
  cat $FILE >> /config/sap/master.cfg
done
if [ ! -f /config/sap/master.cfg ]; then
  printf "/config/sap/master.cfg not found. Nothing to do. Exiting\n"
  exit
fi
#### Run sapserver
printf "\n#####################################################################\n#####################################################################\n"
printf "\nCurrent Task: Run sapserver\n"
sapserver -c /config/sap/master.cfg &
pid="$!"
printf "sapserver PID:$pid\n"
wait "$pid"
