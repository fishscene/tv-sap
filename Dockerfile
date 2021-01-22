FROM ubuntu:20.04
STOPSIGNAL SIGINT
run apt-get update
run apt-get install minisapserver -y
run apt-get upgrade -y
run apt-get autoremove -y
run apt-get autoclean -y
run mkdir /config
run mkdir /configsap
ADD tv-sap_Exec.sh /configsap
run chmod +x /configsap/tv-sap_Exec.sh
ENTRYPOINT ["/configsap/tv-sap_Exec.sh"]
