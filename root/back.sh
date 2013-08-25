#!/bin/bash

# simple Backup Script for configurations

tar zcvf /root/Backup.tar.gz \
	/etc/ntp.conf \
	/etc/hostapd \
	/etc/dnsmasq.conf \
	/etc/tor \
	/etc/iptables/iptables.rules \
	/root/genIptables.sh \
	/root/back.sh \
	/etc/netctl/wifi-bridge \
	/etc/netctl/dhcp
