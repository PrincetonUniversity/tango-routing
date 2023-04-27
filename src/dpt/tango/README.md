# Stress Test Experiment Overview

### Cabernet804 (DPID 28, Port XX/0), use DPDK to send control packets 
```bash 
export RTE_SDK=/u/shared/pktgen-dpdk-pktgen-19.12.0/
export RTE_TARGET=x86_64-native-linuxapp-gcc
cd /u/shared/pktgen-dpdk-pktgen-19.12.0
tools/run.py cabernet
```

### Cabernet801 (DPID 36, Port XX/0), use DPDK to send background IPv6/UDP traffic 
```bash
export RTE_SDK=/u/shared/pktgen-dpdk
export RTE_TARGET=x86_64-native-linuxapp-gcc
tools/run.py cabernet
```

```

### Cabino2 as Tango switch
```bash
sudo su
cd /data/bf-sde-9.7.1
source set_sde.bash 
cd /u/sy6/tango
$SDE/p4_build.sh v6.p4 P4_VERSION=p4_16 P4_ARCHITECTURE=tna
$SDE/./run_switchd.sh -p v6

# From bfshell> get to bf-sde.pm>, bring up ports for cab804 (XX/0) and cab801 XX/0), and view sending rates on the ports 
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

