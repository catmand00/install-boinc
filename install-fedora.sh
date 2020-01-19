#!/bin/bash

if [ -z "${WCG_ACCOUNT_KEY}" ]; then
    echo "Need to set WCG_ACCOUNT_KEY"
    exit
fi

# Assumes running as root (unsecured BOINC machines!)
yum update
yum install boinc-client boinc-manager

# Set autologin
echo -e "[Service]\nExecStart=\nExecStart=-/sbin/agetty --autologin root --noclear %I 38400 linux" >/etc/systemd/system/getty@tty1.service.d/override.conf

# Set laptop lid to do nothing
echo -e "\nHandleLidSwitch=ignore\nHandleLidSwitchExternalPower=ignore\nHandleLidSwitchDocked=ignore\n" >>/etc/systemd/logind.conf

systemctl enable boinc-client
systemctl start boinc-client

chmod g+r /var/lib/boinc/gui_rpc_auth.cfg

echo "Waiting for BOINC client..."
sleep 5

echo "Now attaching project"
boinccmd --project_attach www.worldcommunitygrid.org "${WCG_ACCOUNT_KEY}"
boinccmd --set_run_mode always
boinccmd --set_network_mode always
