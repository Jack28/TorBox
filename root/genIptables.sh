#!/bin/sh

# based on
#   https://trac.torproject.org/projects/tor/wiki/doc/TransparentProxy#LocalRedirectionandAnonymizingMiddlebox

# setup correct Nameserver (foebud)
#echo "nameserver 85.214.20.141" > /etc/resolv.conf

# destinations you don't want routed through Tor
NON_TOR="192.168.42.0/24"

# the UID Tor runs as
TOR_UID="43"

# Tor's TransPort
TRANS_PORT="9040"

# your internal interface
INT_IF="br0"

iptables -F
iptables -t nat -F

# allow NTP for host for server [0-2].pool.ntp.org
iptables -A OUTPUT -d 193.170.62.252 -p udp -j ACCEPT
iptables -A OUTPUT -d 198.60.22.240 -p udp -j ACCEPT
iptables -A OUTPUT -d 69.164.217.193 -p udp -j ACCEPT
iptables -A OUTPUT -d 91.236.251.5 -p udp -j ACCEPT

iptables -A OUTPUT -d 193.1.31.66 -p udp -j ACCEPT
iptables -A OUTPUT -d 193.40.133.142 -p udp -j ACCEPT
iptables -A OUTPUT -d 66.175.216.101 -p udp -j ACCEPT
iptables -A OUTPUT -d 66.220.6.244 -p udp -j ACCEPT

iptables -A OUTPUT -d 46.4.37.135 -p udp -j ACCEPT
iptables -A OUTPUT -d 80.153.14.198 -p udp -j ACCEPT
iptables -A OUTPUT -d 89.238.66.126 -p udp -j ACCEPT
iptables -A OUTPUT -d 217.145.98.135 -p udp -j ACCEPT


# allow DNS for host
#iptables -A OUTPUT -d 85.214.20.141 -p udp -j ACCEPT


iptables -t nat -A OUTPUT -o lo -j RETURN
iptables -t nat -A OUTPUT -m owner --uid-owner $TOR_UID -j RETURN
iptables -t nat -A OUTPUT -p udp --dport 53 -j REDIRECT --to-ports 9053
for NET in $NON_TOR; do
 iptables -t nat -A OUTPUT -d $NET -j RETURN
 iptables -t nat -A PREROUTING -i $INT_IF -d $NET -j RETURN
done

iptables -t nat -A OUTPUT -p tcp --syn -j REDIRECT --to-ports $TRANS_PORT

iptables -t nat -A PREROUTING -i $INT_IF -p udp --dport 53 -j REDIRECT --to-ports 9053
#iptables -t nat -A PREROUTING -i $INT_IF -p udp --dport 53 -j DNAT --to 192.168.42.1:9053
iptables -t nat -A PREROUTING -i $INT_IF -p tcp --syn -j REDIRECT --to-ports $TRANS_PORT
#iptables -t nat -A PREROUTING -i $INT_IF -p tcp -j REDIRECT --to-ports $TRANS_PORT

iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
for NET in $NON_TOR 127.0.0.0/8; do
 iptables -A OUTPUT -d $NET -j ACCEPT
done
# allow ntp
#iptables -A OUTPUT -p udp --dport 123 -j ACCEPT
#iptables -A INPUT -p udp --sport 123 -j ACCEPT
# allow tor
iptables -A OUTPUT -m owner --uid-owner $TOR_UID -j ACCEPT
# log reject,drop the rest
iptables -A OUTPUT -j LOG
iptables -A OUTPUT -j REJECT
iptables -A OUTPUT -j DROP
