# Dynamic Routing Experiment Overview

## Mini Test for Dynamic Routing with Local eBPF Node in Jen's Testbed

### Cabernet802 (DPID 4, Port 16/0) for sending traffic

Configure routing for interface enp134s0f0 and send traffic with iperf:

```bash
# Set up local IP and MAC 
sudo ifconfig enp134s0f0 <ip6 address> 
sudo ifconfig enp134s0f0 hw ether <mac address> 
# Create route to switch "gateway" with assigned ipv6 address and mac, through the interface
sudo ip -6 neigh add fc::3 lladdr 00:00:00:00:00:01 dev enp134s0f0
# Specify interface to get to the switch gateway 
sudo ip -6 route add fc::2/128 via fc::3 dev enp134s0f0
# Iperf command to send packets (remove -V for non IPv6 traffic, also remember to adjust destination addresses as needed)
iperf -t 50000000 -i 1 -V -M 100 -u -c fc::2 -b 100k

```

### Cabino1 as Tango switch
```bash
sudo su
cd /data/bf-sde-9.7.1
source set_sde.bash 
cd /u/sy6/tango
$SDE/p4_build.sh v4.p4 P4_VERSION=p4_16 P4_ARCHITECTURE=tna
$SDE/./run_switchd.sh -p v4

# From bfshell> get to bf-sde.pm>, bring up ports for cab802 (16/0) and cab803(15/0), and view sending rates on the ports 
ucli
pm
port-add 16/0 100G NONE
port-add 15/0 100G NONE
an-set 16/0 2
an-set 15/0 2
port-enb 16/0
port-enb 15/0
rate-period 1
rate-show
```

### Cabernet803 (DPID 12, Port 15/0) as eBPF Tango node

```bash
Use interface enp134s0f0np0 to send and receive traffic 

sudo ifconfig enp134s0f0np0 up 
 sudo tcpdump -evvvnX -i enp134s0f0np0
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
Run it as sudo.
The SDE is located in /root/software. 

### External Vultr eBPF Tango node
