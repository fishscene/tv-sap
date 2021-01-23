FROM ubuntu:20.04
STOPSIGNAL SIGINT
run apt-get update && apt-get install minisapserver -y && apt-get upgrade -y && apt-get autoremove -y && apt-get autoclean -y
run mkdir /config && mkdir /configsap
ADD tv-sap_Exec.sh /configsap
run chmod +x /configsap/tv-sap_Exec.sh
ENTRYPOINT ["/configsap/tv-sap_Exec.sh"]
