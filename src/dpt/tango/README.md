# Dynamic Routing Experiment Overview

## Mini Test for Dynamic Routing with Local eBPF Node in Jen's Testbed

### Cabernet802 (DPID 4, Port 16/0) for sending traffic

Send traffic on interface enp134s0f0 with this command (remove -V for non IPv6 traffic, also remember to adjust destination addresses as needed):

```bash
iperf -t 50000000 -i 1 -V -M 100 -u -length .1k -c 2604:4540:80::1 -b .1M

```

### Cabino1 as Tango switch

### Cabernet804 (DPID 12, Port XX/0) as eBPF Tango node

```plaintext
Use interface enp134s0f0 to send and receive traffic 
```

## Full Test for Dynamic Routing with external Vultr eBPF Node

### Cab-fruity-03 (DPID X, Port XX/0) for sending traffic

```plaintext
Steps to get access to cab-fruity-03
------------------------------------

Install Tango P4 program on the P4 switch.
In the P4 switch, For the IPv4 and the IPv6 traffic to/from cab-fruity-03, just 
make it pass through. This will allow cab-fruity-03 to get an IPv4 address from 
the subnet "outside the CS firewall", which will allow you to SSH into it. 
AND cab-fruity-03 will get an IPv6 address too, which can be used to SSH into 
or reach the Internet via IPv6.
```

```plaintext
Additional Notes (from Joon)
----------------------------

cab-fruity-03 is unreachable with regular ssh access because it lost its old 
IPv4 connection because CS staff moved the subnet to "outside of the CS 
firewall". CS staff does not want to make a "bridge" between the inside and 
outside of the CS firewall, so other devices inside the CS firewall (such as 
cab-spicy-02) should not be used to connect to the IPv6 network. The only way 
for cab-fruity-03 to gain access to the IPv4 and IPv6 address is via the P4 
switch or its LOM connection, which is accessible via a web browser if you make 
an SSH tunnel to it.

Note that CS LDAP does not work on this anymore. So we have to create local 
accounts on this machine. I recommend to create a username that is different 
from your CS account name, so that it is easy to move this machine back in to 
the CS firewall when the time comes.

I can create accounts for folks. Let me know your preferred username and SSH 
pub key.
```

### Cabino4 as Tango switch

### External Vultr eBPF Tango node
