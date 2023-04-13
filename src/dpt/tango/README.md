# Stress Test Experiment Overview


### Cabernet802 (DPID 4, Port 16/0) for sending traffic

Configure routing for interface enp134s0f1 (Notice the interface is different than the one used for the dyn-routing experiment!) and send traffic with iperf:

```bash
# Set up local IP and MAC 
sudo ifconfig enp134s0f0 <ip6 address> 
sudo ifconfig enp134s0f0 hw ether <mac address> 
# Create route to switch "gateway" with an ipv6 address and the destination MAC of the eBPF server
sudo ip -6 neigh add fc::3 lladdr 50:6b:4b:c4:01:80 dev enp134s0f0
# Add route to destination IPv6 address through switch gateway interface 
sudo ip -6 route add fc::2/128 via fc::3 dev enp134s0f0
# Iperf command to send packets (remove -V for non IPv6 traffic, also remember to adjust destination addresses as needed)
iperf -t 50000000 -i 1 -V -u -c 2604:4540:80::1 -l1000 -b 100k

```

### Cabino1 as Tango switch
```bash
sudo su
cd /data/bf-sde-9.7.1
source set_sde.bash 
cd /u/sy6/tango
$SDE/p4_build.sh v6.p4 P4_VERSION=p4_16 P4_ARCHITECTURE=tna
$SDE/./run_switchd.sh -p v6

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

