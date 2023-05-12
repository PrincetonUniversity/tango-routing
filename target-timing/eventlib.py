
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


set_next_signature = namedtuple("set_next_signature", "set_next_signature_eth_header_0 set_next_signature_eth_header_1 set_next_signature_eth_header_2 set_next_signature_ip_header_0 set_next_signature_ip_header_1 set_next_signature_ip_header_2 set_next_signature_ip_header_3 set_next_signature_ip_header_4 set_next_signature_ip_header_5 set_next_signature_ip_header_6 set_next_signature_ip_header_7 set_next_signature_udp_header_0 set_next_signature_udp_header_1 set_next_signature_udp_header_2 set_next_signature_udp_header_3 set_next_signature_sig_type set_next_signature_sig_idx set_next_signature_block_idx set_next_signature_next_signature")
set_next_signature.fmt = "!6s6sHIHBB8s8s8s8sHHHHBIBI"
set_next_signature.id  = 3
set_next_signature.name = set_next_signature


set_signature = namedtuple("set_signature", "set_signature_eth_header_0 set_signature_eth_header_1 set_signature_eth_header_2 set_signature_ip_header_0 set_signature_ip_header_1 set_signature_ip_header_2 set_signature_ip_header_3 set_signature_ip_header_4 set_signature_ip_header_5 set_signature_ip_header_6 set_signature_ip_header_7 set_signature_udp_header_0 set_signature_udp_header_1 set_signature_udp_header_2 set_signature_udp_header_3 set_signature_sig_type set_signature_sig_idx set_signature_block_idx set_signature_curr_signature set_signature_next_signature")
set_signature.fmt = "!6s6sHIHBB8s8s8s8sHHHHBIBII"
set_signature.id  = 2
set_signature.name = set_signature


dummy_traffic = namedtuple("dummy_traffic", "dummy_traffic_eth_header_0 dummy_traffic_eth_header_1 dummy_traffic_eth_header_2 dummy_traffic_ip_header_0 dummy_traffic_ip_header_1 dummy_traffic_ip_header_2 dummy_traffic_ip_header_3 dummy_traffic_ip_header_4 dummy_traffic_ip_header_5 dummy_traffic_ip_header_6 dummy_traffic_ip_header_7 dummy_traffic_ip_header_8 dummy_traffic_ip_header_9 dummy_traffic_udp_header_0 dummy_traffic_udp_header_1 dummy_traffic_udp_header_2 dummy_traffic_udp_header_3")
dummy_traffic.fmt = "!6s6sHBBHHHBBHIIHHHH"
dummy_traffic.id  = 1
dummy_traffic.name = dummy_traffic


events = [set_next_signature, set_signature, dummy_traffic]


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