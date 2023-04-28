
import socket, time, os, struct
from collections import namedtuple

 
lucid_etype = 0x666
EthHdr = namedtuple("EthHdr", "dst_addr src_addr etype")
EthHdr.fmt = "!6s6sH"
WireEvHdr = namedtuple("WireEv", "event_id port_event_id event_bitvec_pad")
WireEvHdr.fmt = "!BB1s"


# static
def parse_header(data, HdrDef):
    # return parsed fields and remaining data.
    if (len(data) < struct.calcsize(HdrDef.fmt)):
        return None, []
    return HdrDef( *struct.unpack(HdrDef.fmt, data[0:struct.calcsize(HdrDef.fmt)])), data[struct.calcsize(HdrDef.fmt):]
def deparse_header(hdr, HdrDef, payload):
  return struct.pack(HdrDef.fmt, *hdr) + payload

# more static code -- parsers and deparsers
def parse_eventpacket(pktbuf):
  eth, payload = parse_header(pktbuf, EthHdr)
  if (eth.etype == lucid_etype):
    wireev, payload = parse_header(payload, WireEvHdr)
    for HdrDef in events:
      if (wireev.event_id == HdrDef.id):
        event, payload = parse_header(payload, HdrDef)
        return event, payload
    # if we got here, its an unknown event type
    return None

def deparse_eventpacket(event, payload):
  # smac and dmac are fixed for now
  smac = b'\x01'*6
  dmac = b'\x02'*6 
  # deparse event header
  for HdrDef in events:
    if (event.id == HdrDef.id):
      # add event header
      pktbuf = deparse_header(event, HdrDef, payload)
      # add event metadata header -- includes the bridged header
      wireev = WireEvHdr(event.id, 0, b'\x00'*(struct.calcsize(WireEvHdr.fmt)-2))
      pktbuf = deparse_header(wireev, WireEvHdr, pktbuf)
      # finally add the lucid ethernet hdr
      lucid_eth = EthHdr(dmac, smac, lucid_etype)
      pktbuf = deparse_header(lucid_eth, EthHdr, pktbuf)
      return pktbuf
  # if we got here, its an unknown event type
  return None


update_route = namedtuple("update_route", "update_route_eth_header_0 update_route_eth_header_1 update_route_eth_header_2 update_route_ip_header_0 update_route_ip_header_1 update_route_ip_header_2 update_route_ip_header_3 update_route_ip_header_4 update_route_ip_header_5 update_route_ip_header_6 update_route_ip_header_7 update_route_tcp_header_0 update_route_tcp_header_1 update_route_tcp_header_2 update_route_tcp_header_3 update_route_tcp_header_4 update_route_tcp_header_5 update_route_tcp_header_6 update_route_tcp_header_7 update_route_tcp_header_8 update_route_update_0 update_route_update_1")
update_route.fmt = "!6s6sHIHBB8s8s8s8sHHIIBBHHHBB"
update_route.id  = 3
update_route.name = update_route


incoming_tango_traffic = namedtuple("incoming_tango_traffic", "incoming_tango_traffic_tango_eth_header_0 incoming_tango_traffic_tango_eth_header_1 incoming_tango_traffic_tango_eth_header_2 incoming_tango_traffic_tango_ip_header_0 incoming_tango_traffic_tango_ip_header_1 incoming_tango_traffic_tango_ip_header_2 incoming_tango_traffic_tango_ip_header_3 incoming_tango_traffic_tango_ip_header_4 incoming_tango_traffic_tango_ip_header_5 incoming_tango_traffic_tango_ip_header_6 incoming_tango_traffic_tango_ip_header_7 incoming_tango_traffic_tango_tcp_header_0 incoming_tango_traffic_tango_tcp_header_1 incoming_tango_traffic_tango_tcp_header_2 incoming_tango_traffic_tango_tcp_header_3 incoming_tango_traffic_tango_tcp_header_4 incoming_tango_traffic_tango_tcp_header_5 incoming_tango_traffic_tango_tcp_header_6 incoming_tango_traffic_tango_tcp_header_7 incoming_tango_traffic_tango_tcp_header_8 incoming_tango_traffic_tango_metrics_header_0 incoming_tango_traffic_tango_metrics_header_1 incoming_tango_traffic_tango_metrics_header_2 incoming_tango_traffic_encaped_ip_header_0 incoming_tango_traffic_encaped_ip_header_1 incoming_tango_traffic_encaped_ip_header_2 incoming_tango_traffic_encaped_ip_header_3 incoming_tango_traffic_encaped_ip_header_4 incoming_tango_traffic_encaped_ip_header_5 incoming_tango_traffic_encaped_ip_header_6 incoming_tango_traffic_encaped_ip_header_7 incoming_tango_traffic_encaped_dup_header_0 incoming_tango_traffic_encaped_dup_header_1 incoming_tango_traffic_encaped_dup_header_2 incoming_tango_traffic_encaped_dup_header_3")
incoming_tango_traffic.fmt = "!6s6sHIHBB8s8s8s8sHHIIBBHHHBHHIHBB8s8s8s8sHHHH"
incoming_tango_traffic.id  = 2
incoming_tango_traffic.name = incoming_tango_traffic


forward_flow = namedtuple("forward_flow", "forward_flow_eth_header_0 forward_flow_eth_header_1 forward_flow_eth_header_2 forward_flow_ip_header_0 forward_flow_ip_header_1 forward_flow_ip_header_2 forward_flow_ip_header_3 forward_flow_ip_header_4 forward_flow_ip_header_5 forward_flow_ip_header_6 forward_flow_ip_header_7 forward_flow_udp_header_0 forward_flow_udp_header_1 forward_flow_udp_header_2 forward_flow_udp_header_3")
forward_flow.fmt = "!6s6sHIHBB8s8s8s8sHHHH"
forward_flow.id  = 1
forward_flow.name = forward_flow


events = [update_route, incoming_tango_traffic, forward_flow]


############ raw socket helpers ############
def open_socket(iface):
  s = socket.socket(socket.PF_PACKET, socket.SOCK_RAW, socket.htons(0x0003))
  s.bind((iface, 0))
  return s

def tx_pkt(s, pkt):
  s.send(pkt)

def rx_pkt(s):
  # get the next incoming packet
  pkt, addr = s.recvfrom(2048)
  (intf, proto, pkttype, hatype, addr) = addr
  while (pkttype == socket.PACKET_OUTGOING):
    pkt, (intf, proto, pkttype, hatype, addr) = s.recvfrom(2048)
  return pkt

def close_socket(s):
  s.close()

############ end raw socket helpers ############


# mapping based on p4tapp assignment
def dpid_to_veth(dpid):
  return ("veth%i"%(dpid * 2 + 1))
