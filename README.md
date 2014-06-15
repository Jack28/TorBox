TorBox
======

Some config files to setup an unencrypted, free to use WIFI hotspot without
getting into trouble. The wireless network routes everything through the TOR
Network.

Uses
Archlinux ARM
hostapd
dnsmasq
iptables
tor

- bring config files in place
- enable systemctl hostapd, dnsmask, iptabes, tor
- enable netctl wifi-bridge, dhcp
- disable systemctl dhcp@eth0
- DO NOT configure IP-Forward. All Routing is done by the tor socks proxy and iptables
- reboot and hope best
