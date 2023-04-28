# Stress Test Experiment Overview


### Cabernet801 (DPID 36, Port 12/0), use DPDK to send background IPv6/UDP traffic 
```bash
export RTE_SDK=/u/shared/pktgen-dpdk
export RTE_TARGET=x86_64-native-linuxapp-gcc
cd /u/shared/pktgen-dpdk
sudo -E tools/run.py cabernet

set 1 type ipv4
set 1 count 0
set 1 burst 10000
set 1 rate 1
enable 1 random 
set 1 proto udp
set 1 size 1500 
set 1 src mac 00:00:00:00:00:81
set 1 dst mac 00:00:00:00:00:ff 
start 1
```

### Cabernet804 (DPID 28, Port 13/0), use DPDK to send control packets 
```bash 
export RTE_SDK=/u/shared/pktgen-dpdk-pktgen-19.12.0/
export RTE_TARGET=x86_64-native-linuxapp-gcc
cd /u/shared/pktgen-dpdk-pktgen-19.12.0
tools/run.py tango_pcap

set 1 count 0
set 1 burst 10000
set 1 rate 1
start 1
```

### Cabino2 as Tango switch
```bash
sudo su
cd /data/bf-sde-9.7.1
source set_sde.bash 
cd /u/sy6/tango
$SDE/p4_build.sh v6.p4 P4_VERSION=p4_16 P4_ARCHITECTURE=tna
$SDE/./run_switchd.sh -p v6

# From bfshell> get to bf-sde.pm>, bring up ports for cab801 (12/0) and cab804 13/0), and view sending rates on the ports 
ucli
pm
port-add 12/0 100G NONE
port-add 15/0 100G NONE
an-set 12/0 2
an-set 15/0 2
port-enb 12/0
port-enb 15/0
rate-period 1
rate-show



port-add 12/0 100G NONE
port-add 13/0 100G NONE
port-add 15/0 100G NONE
an-set 12/0 2
an-set 13/0 2
an-set 15/0 2
port-enb 12/0
port-enb 13/0
port-enb 15/0
rate-period 1
rate-show
```

```bash
ucli
pm
port-add 16/0 100G NONE
an-set 16/0 2
port-enb 16/0
rate-period 1
rate-show
```

### Cabernet803 (DPID 12, Port 15/0), dump output packets from background traffic here
```bash
Use interface enp134s0f1np1 to send and receive traffic 
sudo ifconfig enp134s0f1np1 up 
sudo tcpdump -evvvnX -i enp134s0f1np1
 ```
