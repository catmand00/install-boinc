#!/bin/bash

if [ -z "${WGC_ACCOUNT_KEY}" ]; then
    echo "Need to set WGC_ACCOUNT_KEY"
    exit
fi

# Assumes running as root (unsecured BOINC machines!)
apt update
apt install -y boinc-client boinctui

systemctl enable boinc-client
systemctl start boinc-client

chmod g+r /var/lib/boinc/gui_rpc_auth.cfg

boinccmd --project_attach www.worldcommunitygrid.org "${WGC_ACCOUNT_KEY}"
boinccmd --set_run_mode always
boinccmd --set_network_mode always
