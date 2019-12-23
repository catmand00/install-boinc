#!/bin/bash

if [ -z "${WGC_ACCOUNT_KEY}" ]; then
    echo "Need to set WGC_ACCOUNT_KEY"
    exit
fi

# Assumes running as root (unsecured BOINC machines!)
apt update
apt install -y boinc-client boinctui

# Set autologin
echo -e "[Service]\nExecStart=\nExecStart=-/sbin/agetty --autologin root --noclear %I 38400 linux" >/etc/systemd/system/getty@tty1.service.d/override.conf

# Set laptop lid to do nothing
echo -e "HandleLidSwitch=ignore\nHandleLidSwitchExternalPower=ignore\nHandleLidSwitchDocked=ignore\n" >>/etc/systemd/logind.conf

systemctl enable boinc-client
systemctl start boinc-client

chmod g+r /var/lib/boinc/gui_rpc_auth.cfg

echo "Waiting for BOINC client..."
sleep 5

echo "Now attaching project"
boinccmd --project_attach www.worldcommunitygrid.org "${WGC_ACCOUNT_KEY}"
boinccmd --set_run_mode always
boinccmd --set_network_mode always
