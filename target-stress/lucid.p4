//Global declarations
//(includes, headers, structs, constants, register arrays)
#include <core.p4>
#include <tna.p4>
header lucid_eth_t {
  bit<48> dst_addr;
  bit<48> src_addr;
  bit<16> etype;
}
header wire_ev_t {
  bit<8> event_id;
}
header bridge_ev_t {
  bit<8> port_event_id;
  bit<5> flag_pad_5746;
  bit<1> forward_flow;
  bit<1> attach_signatures;
  bit<1> incoming_tango_traffic;
}
header forward_flow_t {
  bit<48> forward_flow_eth_header_0;
  bit<48> forward_flow_eth_header_1;
  bit<16> forward_flow_eth_header_2;
  bit<8> forward_flow_ip_header_0;
  bit<8> forward_flow_ip_header_1;
  bit<16> forward_flow_ip_header_2;
  bit<16> forward_flow_ip_header_3;
  bit<16> forward_flow_ip_header_4;
  bit<8> forward_flow_ip_header_5;
  bit<8> forward_flow_ip_header_6;
  bit<16> forward_flow_ip_header_7;
  bit<32> forward_flow_ip_header_8;
  bit<32> forward_flow_ip_header_9;
  bit<16> forward_flow_udp_header_0;
  bit<16> forward_flow_udp_header_1;
  bit<16> forward_flow_udp_header_2;
  bit<16> forward_flow_udp_header_3;
}
header attach_signatures_t {
  bit<48> attach_signatures_tango_eth_header_0;
  bit<48> attach_signatures_tango_eth_header_1;
  bit<16> attach_signatures_tango_eth_header_2;
  bit<32> attach_signatures_tango_ip_header_0;
  bit<16> attach_signatures_tango_ip_header_1;
  bit<8> attach_signatures_tango_ip_header_2;
  bit<8> attach_signatures_tango_ip_header_3;
  bit<64> attach_signatures_tango_ip_header_4;
  bit<64> attach_signatures_tango_ip_header_5;
  bit<64> attach_signatures_tango_ip_header_6;
  bit<64> attach_signatures_tango_ip_header_7;
  bit<16> attach_signatures_tango_udp_header_0;
  bit<16> attach_signatures_tango_udp_header_1;
  bit<16> attach_signatures_tango_udp_header_2;
  bit<16> attach_signatures_tango_udp_header_3;
  bit<16> attach_signatures_seq_number;
  bit<8> attach_signatures_traffic_class;
  bit<16> attach_signatures_timestamp;
  bit<8> attach_signatures_encaped_ip_header_0;
  bit<8> attach_signatures_encaped_ip_header_1;
  bit<16> attach_signatures_encaped_ip_header_2;
  bit<16> attach_signatures_encaped_ip_header_3;
  bit<16> attach_signatures_encaped_ip_header_4;
  bit<8> attach_signatures_encaped_ip_header_5;
  bit<8> attach_signatures_encaped_ip_header_6;
  bit<16> attach_signatures_encaped_ip_header_7;
  bit<32> attach_signatures_encaped_ip_header_8;
  bit<32> attach_signatures_encaped_ip_header_9;
  bit<16> attach_signatures_encaped_udp_header_0;
  bit<16> attach_signatures_encaped_udp_header_1;
  bit<16> attach_signatures_encaped_udp_header_2;
  bit<16> attach_signatures_encaped_udp_header_3;
}
header incoming_tango_traffic_t {
  bit<48> incoming_tango_traffic_tango_eth_header_0;
  bit<48> incoming_tango_traffic_tango_eth_header_1;
  bit<16> incoming_tango_traffic_tango_eth_header_2;
  bit<32> incoming_tango_traffic_tango_ip_header_0;
  bit<16> incoming_tango_traffic_tango_ip_header_1;
  bit<8> incoming_tango_traffic_tango_ip_header_2;
  bit<8> incoming_tango_traffic_tango_ip_header_3;
  bit<64> incoming_tango_traffic_tango_ip_header_4;
  bit<64> incoming_tango_traffic_tango_ip_header_5;
  bit<64> incoming_tango_traffic_tango_ip_header_6;
  bit<64> incoming_tango_traffic_tango_ip_header_7;
  bit<16> incoming_tango_traffic_tango_udp_header_0;
  bit<16> incoming_tango_traffic_tango_udp_header_1;
  bit<16> incoming_tango_traffic_tango_udp_header_2;
  bit<16> incoming_tango_traffic_tango_udp_header_3;
  bit<8> incoming_tango_traffic_tango_metrics_header_0;
  bit<16> incoming_tango_traffic_tango_metrics_header_1;
  bit<32> incoming_tango_traffic_tango_metrics_header_2;
  bit<16> incoming_tango_traffic_tango_metrics_header_3;
  bit<8> incoming_tango_traffic_tango_metrics_header_4;
  bit<8> incoming_tango_traffic_encaped_ip_header_0;
  bit<8> incoming_tango_traffic_encaped_ip_header_1;
  bit<16> incoming_tango_traffic_encaped_ip_header_2;
  bit<16> incoming_tango_traffic_encaped_ip_header_3;
  bit<16> incoming_tango_traffic_encaped_ip_header_4;
  bit<8> incoming_tango_traffic_encaped_ip_header_5;
  bit<8> incoming_tango_traffic_encaped_ip_header_6;
  bit<16> incoming_tango_traffic_encaped_ip_header_7;
  bit<32> incoming_tango_traffic_encaped_ip_header_8;
  bit<32> incoming_tango_traffic_encaped_ip_header_9;
  bit<16> incoming_tango_traffic_encaped_udp_header_0;
  bit<16> incoming_tango_traffic_encaped_udp_header_1;
  bit<16> incoming_tango_traffic_encaped_udp_header_2;
  bit<16> incoming_tango_traffic_encaped_udp_header_3;
}
struct hdr_t {
  lucid_eth_t lucid_eth;
  wire_ev_t wire_ev;
  bridge_ev_t bridge_ev;
  forward_flow_t forward_flow;
  attach_signatures_t attach_signatures;
  incoming_tango_traffic_t incoming_tango_traffic;
}
struct meta_t {
  bit<8> egress_event_id;
}
Register<bit<16>,_>(32w8) sequence_counters_0;
Register<bit<32>,_>(32w32)
outgoing_metric_signature_manager_7;
Register<bit<32>,_>(32w32)
outgoing_metric_signature_manager_6;
Register<bit<32>,_>(32w32)
outgoing_metric_signature_manager_5;
Register<bit<32>,_>(32w32)
outgoing_metric_signature_manager_4;
Register<bit<32>,_>(32w32)
outgoing_metric_signature_manager_3;
Register<bit<32>,_>(32w32)
outgoing_metric_signature_manager_2;
Register<bit<32>,_>(32w32)
outgoing_metric_signature_manager_1;
Register<bit<32>,_>(32w32)
outgoing_metric_signature_manager_0;
Register<bit<1>,_>(32w65536)
outgoing_book_signature_manager_7;
Register<bit<1>,_>(32w65536)
outgoing_book_signature_manager_6;
Register<bit<1>,_>(32w65536)
outgoing_book_signature_manager_5;
Register<bit<1>,_>(32w65536)
outgoing_book_signature_manager_4;
Register<bit<1>,_>(32w65536)
outgoing_book_signature_manager_3;
Register<bit<1>,_>(32w65536)
outgoing_book_signature_manager_2;
Register<bit<1>,_>(32w65536)
outgoing_book_signature_manager_1;
Register<bit<1>,_>(32w65536) outgoing_book_signature_manager_0;
//Main program components (ingress/egress parser, control, deparser)
parser IngressParser(packet_in pkt,
    out hdr_t hdr,
    out meta_t meta,
    out ingress_intrinsic_metadata_t ig_intr_md){
  state start {
    pkt.extract(ig_intr_md);
    pkt.advance(64);
    transition select(ig_intr_md.ingress_port){
      (196) : parse_eth;
      (_) : default_setup;
    }
  }
  state default_setup {
    hdr.lucid_eth.setValid();
    hdr.lucid_eth.dst_addr=0;
    hdr.lucid_eth.src_addr=0;
    hdr.lucid_eth.etype=1638;
    hdr.wire_ev.setValid();
    hdr.wire_ev.event_id=3;
    hdr.bridge_ev.setValid();
    hdr.bridge_ev.port_event_id=0;
    hdr.bridge_ev.forward_flow=0;
    hdr.bridge_ev.attach_signatures=0;
    hdr.bridge_ev.incoming_tango_traffic=0;
    transition parse_forward_flow;
  }
  state parse_eth {
    pkt.extract(hdr.lucid_eth);
    transition select(hdr.lucid_eth.etype){
      (1638) : parse_wire_ev;
    }
  }
  state parse_wire_ev {
    pkt.extract(hdr.wire_ev);
    pkt.extract(hdr.bridge_ev);
    transition select(hdr.wire_ev.event_id){
      (255) : parse_all_events;
      (3) : parse_forward_flow;
      (2) : parse_attach_signatures;
      (1) : parse_incoming_tango_traffic;
    }
  }
  state parse_forward_flow {
    pkt.extract(hdr.forward_flow);
    transition accept;
  }
  state parse_attach_signatures {
    pkt.extract(hdr.attach_signatures);
    transition accept;
  }
  state parse_incoming_tango_traffic {
    pkt.extract(hdr.incoming_tango_traffic);
    transition accept;
  }
  state parse_all_events {
    pkt.extract(hdr.forward_flow);
    pkt.extract(hdr.attach_signatures);
    pkt.extract(hdr.incoming_tango_traffic);
    transition accept;
  }
}
control IngressControl(inout hdr_t hdr,
    inout meta_t meta,
    in ingress_intrinsic_metadata_t ig_intr_md,
    in ingress_intrinsic_metadata_from_parser_t ig_prsr_md,
    inout ingress_intrinsic_metadata_for_deparser_t ig_dprsr_md,
    inout ingress_intrinsic_metadata_for_tm_t ig_tm_md){
  bit<64> map_path_to_tunnel_header_ret_7;
  action labeledstmt_28(){
    map_path_to_tunnel_header_ret_7=64w32;
  }
  bit<64> map_path_to_tunnel_header_ret_6;
  action labeledstmt_27(){
    map_path_to_tunnel_header_ret_6=64w32;
  }
  bit<64> map_path_to_tunnel_header_ret_5;
  action labeledstmt_26(){
    map_path_to_tunnel_header_ret_5=64w32;
  }
  bit<64> map_path_to_tunnel_header_ret_4;
  action labeledstmt_25(){
    map_path_to_tunnel_header_ret_4=64w32;
  }
  bit<8> map_path_to_tunnel_header_ret_3;
  action labeledstmt_24(){
    map_path_to_tunnel_header_ret_3=8w32;
  }
  bit<8> map_path_to_tunnel_header_ret_2;
  action labeledstmt_23(){
    map_path_to_tunnel_header_ret_2=8w32;
  }
  bit<16> map_path_to_tunnel_header_ret_1;
  action labeledstmt_22(){
    map_path_to_tunnel_header_ret_1=16w32;
  }
  bit<32> map_path_to_tunnel_header_ret_0;
  action labeledstmt_21(){
    map_path_to_tunnel_header_ret_0=32w32;
  }
  bit<8> map_flow_to_traffic_class_ret;
  action labeledstmt_20(){
    map_flow_to_traffic_class_ret=8w32;
  }
  action labeledstmt_1(){
    labeledstmt_20();
    labeledstmt_21();
    labeledstmt_22();
    labeledstmt_23();
    labeledstmt_24();
    labeledstmt_25();
    labeledstmt_26();
    labeledstmt_27();
    labeledstmt_28();
  }
  action labeledstmt_29(){
    hdr.incoming_tango_traffic.setInvalid();
  }
  action labeledstmt_2(){
    labeledstmt_29();
  }
  action labeledstmt_3(){
    //NOOP
  }
  action labeledstmt_30(){
    map_flow_to_traffic_class_ret=8w15;
  }
  action labeledstmt_4(){
    labeledstmt_30();
  }
  action labeledstmt_5(){
    //NOOP
  }
  bit<8> traffic_class;
  action labeledstmt_31(){
    traffic_class=map_flow_to_traffic_class_ret;
  }
  action labeledstmt_6(){
    labeledstmt_31();
  }
  action labeledstmt_7(){
    //NOOP
  }
  bit<8> path_id;
  action labeledstmt_32(){
    path_id=((bit<8>)traffic_class);
  }
  action labeledstmt_8(){
    labeledstmt_32();
  }
  action labeledstmt_9(){
    //NOOP
  }
  action labeledstmt_44(){
    map_path_to_tunnel_header_ret_0=32w0;
  }
  action labeledstmt_43(){
    map_path_to_tunnel_header_ret_1=16w0;
  }
  action labeledstmt_42(){
    map_path_to_tunnel_header_ret_2=8w0;
  }
  action labeledstmt_41(){
    map_path_to_tunnel_header_ret_3=8w0;
  }
  action labeledstmt_40(){
    map_path_to_tunnel_header_ret_4=64w0;
  }
  action labeledstmt_39(){
    map_path_to_tunnel_header_ret_5=64w0;
  }
  action labeledstmt_38(){
    map_path_to_tunnel_header_ret_6=64w0;
  }
  action labeledstmt_37(){
    map_path_to_tunnel_header_ret_7=64w0;
  }
  bit<8> path_id4778;
  action labeledstmt_36(){
    path_id4778=((bit<8>)traffic_class);
  }
  bit<16> SequenceNumberManager_increment_ret;
  action labeledstmt_35(){
    SequenceNumberManager_increment_ret=16w32;
  }
  bit<32> time_now;
  action labeledstmt_34(){
    time_now=(ig_intr_md.ingress_mac_tstamp[47:16]);
  }
  bit<16> precompute;
  action labeledstmt_33(){
    precompute=(hdr.forward_flow.forward_flow_ip_header_2+16w88);
  }
  action labeledstmt_10(){
    labeledstmt_33();
    labeledstmt_34();
    labeledstmt_35();
    labeledstmt_36();
    labeledstmt_37();
    labeledstmt_38();
    labeledstmt_39();
    labeledstmt_40();
    labeledstmt_41();
    labeledstmt_42();
    labeledstmt_43();
    labeledstmt_44();
  }
  action labeledstmt_11(){
    //NOOP
  }
  bit<32> tango_tunnel_hdr_0;
  action labeledstmt_54(){
    tango_tunnel_hdr_0=map_path_to_tunnel_header_ret_0;
  }
  bit<16> tango_tunnel_hdr_1;
  action labeledstmt_53(){
    tango_tunnel_hdr_1=map_path_to_tunnel_header_ret_1;
  }
  bit<8> tango_tunnel_hdr_2;
  action labeledstmt_52(){
    tango_tunnel_hdr_2=map_path_to_tunnel_header_ret_2;
  }
  bit<8> tango_tunnel_hdr_3;
  action labeledstmt_51(){
    tango_tunnel_hdr_3=map_path_to_tunnel_header_ret_3;
  }
  bit<64> tango_tunnel_hdr_4;
  action labeledstmt_50(){
    tango_tunnel_hdr_4=map_path_to_tunnel_header_ret_4;
  }
  bit<64> tango_tunnel_hdr_5;
  action labeledstmt_49(){
    tango_tunnel_hdr_5=map_path_to_tunnel_header_ret_5;
  }
  bit<64> tango_tunnel_hdr_6;
  action labeledstmt_48(){
    tango_tunnel_hdr_6=map_path_to_tunnel_header_ret_6;
  }
  bit<64> tango_tunnel_hdr_7;
  action labeledstmt_47(){
    tango_tunnel_hdr_7=map_path_to_tunnel_header_ret_7;
  }
  RegisterAction<bit<16>,bit<8>,bit<16>>(sequence_counters_0)
  sequence_counters_0_regaction_5699 = {
    void apply(inout bit<16> cell1_remote,
        out bit<16> ret_remote){
      bit<16> cell1_local=cell1_remote;
      bit<16> cell2_local=0;
      if(true){
        cell1_remote=(cell1_local+16w1);
      }
      if(true){
        cell2_local=cell1_local;
      }
      if(true){
        ret_remote=cell2_local;
      }
    }
  };
  action labeledstmt_46(){
   
SequenceNumberManager_increment_ret=sequence_counters_0_regaction_5699.execute(path_id4778);
  }
  bit<12> timestamp;
  action labeledstmt_45(){
    timestamp=(time_now[31:20]);
  }
  action labeledstmt_12(){
    labeledstmt_45();
    labeledstmt_46();
    labeledstmt_47();
    labeledstmt_48();
    labeledstmt_49();
    labeledstmt_50();
    labeledstmt_51();
    labeledstmt_52();
    labeledstmt_53();
    labeledstmt_54();
  }
  action labeledstmt_13(){
    //NOOP
  }
  bit<16> seq_number;
  action labeledstmt_55(){
    seq_number=SequenceNumberManager_increment_ret;
  }
  action labeledstmt_14(){
    labeledstmt_55();
  }
  action labeledstmt_15(){
    //NOOP
  }
  action labeledstmt_16(){
    hdr.bridge_ev.attach_signatures=1;
    hdr.attach_signatures.setValid();
   
hdr.attach_signatures.attach_signatures_tango_eth_header_0=hdr.forward_flow.forward_flow_eth_header_0;
   
hdr.attach_signatures.attach_signatures_tango_eth_header_1=hdr.forward_flow.forward_flow_eth_header_1;
   
hdr.attach_signatures.attach_signatures_tango_eth_header_2=hdr.forward_flow.forward_flow_eth_header_2;
   
hdr.attach_signatures.attach_signatures_tango_ip_header_0=tango_tunnel_hdr_0;
    hdr.attach_signatures.attach_signatures_tango_ip_header_1=precompute;
   
hdr.attach_signatures.attach_signatures_tango_ip_header_2=tango_tunnel_hdr_2;
   
hdr.attach_signatures.attach_signatures_tango_ip_header_3=tango_tunnel_hdr_3;
   
hdr.attach_signatures.attach_signatures_tango_ip_header_4=tango_tunnel_hdr_4;
   
hdr.attach_signatures.attach_signatures_tango_ip_header_5=tango_tunnel_hdr_5;
   
hdr.attach_signatures.attach_signatures_tango_ip_header_6=tango_tunnel_hdr_6;
   
hdr.attach_signatures.attach_signatures_tango_ip_header_7=tango_tunnel_hdr_7;
    hdr.attach_signatures.attach_signatures_tango_udp_header_0=16w8080;
    hdr.attach_signatures.attach_signatures_tango_udp_header_1=16w8080;
    hdr.attach_signatures.attach_signatures_tango_udp_header_2=16w0;
    hdr.attach_signatures.attach_signatures_tango_udp_header_3=16w0;
    hdr.attach_signatures.attach_signatures_seq_number=seq_number;
    hdr.attach_signatures.attach_signatures_traffic_class=traffic_class;
    hdr.attach_signatures.attach_signatures_timestamp=((bit<16>)timestamp);
   
hdr.attach_signatures.attach_signatures_encaped_ip_header_0=hdr.forward_flow.forward_flow_ip_header_0;
   
hdr.attach_signatures.attach_signatures_encaped_ip_header_1=hdr.forward_flow.forward_flow_ip_header_1;
   
hdr.attach_signatures.attach_signatures_encaped_ip_header_2=hdr.forward_flow.forward_flow_ip_header_2;
   
hdr.attach_signatures.attach_signatures_encaped_ip_header_3=hdr.forward_flow.forward_flow_ip_header_3;
   
hdr.attach_signatures.attach_signatures_encaped_ip_header_4=hdr.forward_flow.forward_flow_ip_header_4;
   
hdr.attach_signatures.attach_signatures_encaped_ip_header_5=hdr.forward_flow.forward_flow_ip_header_5;
   
hdr.attach_signatures.attach_signatures_encaped_ip_header_6=hdr.forward_flow.forward_flow_ip_header_6;
   
hdr.attach_signatures.attach_signatures_encaped_ip_header_7=hdr.forward_flow.forward_flow_ip_header_7;
   
hdr.attach_signatures.attach_signatures_encaped_ip_header_8=hdr.forward_flow.forward_flow_ip_header_8;
   
hdr.attach_signatures.attach_signatures_encaped_ip_header_9=hdr.forward_flow.forward_flow_ip_header_9;
   
hdr.attach_signatures.attach_signatures_encaped_udp_header_0=hdr.forward_flow.forward_flow_udp_header_0;
   
hdr.attach_signatures.attach_signatures_encaped_udp_header_1=hdr.forward_flow.forward_flow_udp_header_1;
   
hdr.attach_signatures.attach_signatures_encaped_udp_header_2=hdr.forward_flow.forward_flow_udp_header_2;
   
hdr.attach_signatures.attach_signatures_encaped_udp_header_3=hdr.forward_flow.forward_flow_udp_header_3;
    hdr.bridge_ev.port_event_id=2;
    ig_tm_md.ucast_egress_port=ig_intr_md.ingress_port;
  }
  action labeledstmt_17(){
    //NOOP
  }
  action labeledstmt_56(){
    hdr.forward_flow.setInvalid();
  }
  action labeledstmt_18(){
    labeledstmt_56();
  }
  action labeledstmt_19(){
    //NOOP
  }
  table table_5708 {
    key = {
      hdr.wire_ev.event_id : ternary;
      hdr.forward_flow.forward_flow_ip_header_6 : ternary;
      hdr.forward_flow.forward_flow_udp_header_1 : ternary;
      hdr.forward_flow.forward_flow_ip_header_9 : ternary;
      hdr.forward_flow.forward_flow_udp_header_0 : ternary;
      hdr.forward_flow.forward_flow_ip_header_8 : ternary;
    }
    actions = {
      labeledstmt_1;
      labeledstmt_2;
      labeledstmt_3;
    }
    const entries = {
      (3,_,_,_,_,_) : labeledstmt_1();
      (1,_,_,_,_,_) : labeledstmt_2();
      (_,_,_,_,_,_) : labeledstmt_3();
    } 
  } 
  table table_5707 {
    key = {
      hdr.forward_flow.forward_flow_ip_header_6 : ternary;
      hdr.forward_flow.forward_flow_udp_header_1 : ternary;
      hdr.forward_flow.forward_flow_ip_header_9 : ternary;
      hdr.forward_flow.forward_flow_udp_header_0 : ternary;
      hdr.forward_flow.forward_flow_ip_header_8 : ternary;
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_4;
      labeledstmt_5;
    }
    const entries = {
      (_,_,_,_,_,3) : labeledstmt_4();
      (_,_,_,_,_,_) : labeledstmt_5();
    } 
  } 
  table table_5706 {
    key = {
      hdr.forward_flow.forward_flow_ip_header_6 : ternary;
      hdr.forward_flow.forward_flow_udp_header_1 : ternary;
      hdr.forward_flow.forward_flow_ip_header_9 : ternary;
      hdr.forward_flow.forward_flow_udp_header_0 : ternary;
      hdr.forward_flow.forward_flow_ip_header_8 : ternary;
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_6;
      labeledstmt_7;
    }
    const entries = {
      (_,_,_,_,_,3) : labeledstmt_6();
      (_,_,_,_,_,_) : labeledstmt_7();
    } 
  } 
  table table_5705 {
    key = {
      hdr.forward_flow.forward_flow_ip_header_6 : ternary;
      hdr.forward_flow.forward_flow_udp_header_1 : ternary;
      hdr.forward_flow.forward_flow_ip_header_9 : ternary;
      hdr.forward_flow.forward_flow_udp_header_0 : ternary;
      hdr.forward_flow.forward_flow_ip_header_8 : ternary;
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_8;
      labeledstmt_9;
    }
    const entries = {
      (_,_,_,_,_,3) : labeledstmt_8();
      (_,_,_,_,_,_) : labeledstmt_9();
    } 
  } 
  table table_5704 {
    key = {
      path_id : ternary;
      hdr.forward_flow.forward_flow_ip_header_6 : ternary;
      hdr.forward_flow.forward_flow_udp_header_1 : ternary;
      hdr.forward_flow.forward_flow_ip_header_9 : ternary;
      hdr.forward_flow.forward_flow_udp_header_0 : ternary;
      hdr.forward_flow.forward_flow_ip_header_8 : ternary;
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_10;
      labeledstmt_11;
    }
    const entries = {
      (_,_,_,_,_,_,3) : labeledstmt_10();
      (_,_,_,_,_,_,_) : labeledstmt_11();
    } 
  } 
  table table_5703 {
    key = {
      path_id : ternary;
      hdr.forward_flow.forward_flow_ip_header_6 : ternary;
      hdr.forward_flow.forward_flow_udp_header_1 : ternary;
      hdr.forward_flow.forward_flow_ip_header_9 : ternary;
      hdr.forward_flow.forward_flow_udp_header_0 : ternary;
      hdr.forward_flow.forward_flow_ip_header_8 : ternary;
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_12;
      labeledstmt_13;
    }
    const entries = {
      (_,_,_,_,_,_,3) : labeledstmt_12();
      (_,_,_,_,_,_,_) : labeledstmt_13();
    } 
  } 
  table table_5702 {
    key = {
      path_id : ternary;
      hdr.forward_flow.forward_flow_ip_header_6 : ternary;
      hdr.forward_flow.forward_flow_udp_header_1 : ternary;
      hdr.forward_flow.forward_flow_ip_header_9 : ternary;
      hdr.forward_flow.forward_flow_udp_header_0 : ternary;
      hdr.forward_flow.forward_flow_ip_header_8 : ternary;
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_14;
      labeledstmt_15;
    }
    const entries = {
      (_,_,_,_,_,_,3) : labeledstmt_14();
      (_,_,_,_,_,_,_) : labeledstmt_15();
    } 
  } 
  table table_5701 {
    key = {
      path_id : ternary;
      hdr.forward_flow.forward_flow_ip_header_6 : ternary;
      hdr.forward_flow.forward_flow_udp_header_1 : ternary;
      hdr.forward_flow.forward_flow_ip_header_9 : ternary;
      hdr.forward_flow.forward_flow_udp_header_0 : ternary;
      hdr.forward_flow.forward_flow_ip_header_8 : ternary;
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_16;
      labeledstmt_17;
    }
    const entries = {
      (_,_,_,_,_,_,3) : labeledstmt_16();
      (_,_,_,_,_,_,_) : labeledstmt_17();
    } 
  } 
  table table_5700 {
    key = {
      path_id : ternary;
      hdr.forward_flow.forward_flow_ip_header_6 : ternary;
      hdr.forward_flow.forward_flow_udp_header_1 : ternary;
      hdr.forward_flow.forward_flow_ip_header_9 : ternary;
      hdr.forward_flow.forward_flow_udp_header_0 : ternary;
      hdr.forward_flow.forward_flow_ip_header_8 : ternary;
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_18;
      labeledstmt_19;
    }
    const entries = {
      (_,_,_,_,_,_,3) : labeledstmt_18();
      (_,_,_,_,_,_,_) : labeledstmt_19();
    } 
  } 
  apply {
    table_5708.apply();
    table_5707.apply();
    table_5706.apply();
    table_5705.apply();
    table_5704.apply();
    table_5703.apply();
    table_5702.apply();
    table_5701.apply();
    table_5700.apply();
  }
} 
control IngressDeparser(packet_out pkt,
    inout hdr_t hdr,
    in meta_t meta,
    in ingress_intrinsic_metadata_for_deparser_t ig_dprsr_md){

  apply {
    pkt.emit(hdr);
  }
} 
parser EgressParser(packet_in pkt,
    out hdr_t hdr,
    out meta_t meta,
    out egress_intrinsic_metadata_t eg_intr_md){
  state start {
    pkt.extract(eg_intr_md);
    pkt.extract(hdr.lucid_eth);
    pkt.extract(hdr.wire_ev);
    pkt.extract(hdr.bridge_ev);
    meta.egress_event_id=0;
    transition select(hdr.bridge_ev.forward_flow,
hdr.bridge_ev.attach_signatures, hdr.bridge_ev.incoming_tango_traffic){
      (0, 1, 0) : parse_eventset_0;
    }
  }
  state parse_eventset_0 {
    pkt.extract(hdr.attach_signatures);
    transition accept;
  }
}
control EgressControl(inout hdr_t hdr,
    inout meta_t meta,
    in egress_intrinsic_metadata_t eg_intr_md,
    in egress_intrinsic_metadata_from_parser_t eg_prsr_md,
    inout egress_intrinsic_metadata_for_deparser_t eg_dprsr_md,
    inout egress_intrinsic_metadata_for_output_port_t eg_oport_md){
  @pa_no_overlay("egress","hdr.forward_flow.forward_flow_eth_header_0")
  @pa_no_overlay("egress","hdr.forward_flow.forward_flow_eth_header_1")
  @pa_no_overlay("egress","hdr.forward_flow.forward_flow_eth_header_2")
  @pa_no_overlay("egress","hdr.forward_flow.forward_flow_ip_header_0")
  @pa_no_overlay("egress","hdr.forward_flow.forward_flow_ip_header_1")
  @pa_no_overlay("egress","hdr.forward_flow.forward_flow_ip_header_2")
  @pa_no_overlay("egress","hdr.forward_flow.forward_flow_ip_header_3")
  @pa_no_overlay("egress","hdr.forward_flow.forward_flow_ip_header_4")
  @pa_no_overlay("egress","hdr.forward_flow.forward_flow_ip_header_5")
  @pa_no_overlay("egress","hdr.forward_flow.forward_flow_ip_header_6")
  @pa_no_overlay("egress","hdr.forward_flow.forward_flow_ip_header_7")
  @pa_no_overlay("egress","hdr.forward_flow.forward_flow_ip_header_8")
  @pa_no_overlay("egress","hdr.forward_flow.forward_flow_ip_header_9")
  @pa_no_overlay("egress","hdr.forward_flow.forward_flow_udp_header_0")
  @pa_no_overlay("egress","hdr.forward_flow.forward_flow_udp_header_1")
  @pa_no_overlay("egress","hdr.forward_flow.forward_flow_udp_header_2")
  @pa_no_overlay("egress","hdr.forward_flow.forward_flow_udp_header_3")
 
@pa_no_overlay("egress","hdr.attach_signatures.attach_signatures_tango_eth_header_0")
 
@pa_no_overlay("egress","hdr.attach_signatures.attach_signatures_tango_eth_header_1")
 
@pa_no_overlay("egress","hdr.attach_signatures.attach_signatures_tango_eth_header_2")
 
@pa_no_overlay("egress","hdr.attach_signatures.attach_signatures_tango_ip_header_0")
 
@pa_no_overlay("egress","hdr.attach_signatures.attach_signatures_tango_ip_header_1")
 
@pa_no_overlay("egress","hdr.attach_signatures.attach_signatures_tango_ip_header_2")
 
@pa_no_overlay("egress","hdr.attach_signatures.attach_signatures_tango_ip_header_3")
 
@pa_no_overlay("egress","hdr.attach_signatures.attach_signatures_tango_ip_header_4")
 
@pa_no_overlay("egress","hdr.attach_signatures.attach_signatures_tango_ip_header_5")
 
@pa_no_overlay("egress","hdr.attach_signatures.attach_signatures_tango_ip_header_6")
 
@pa_no_overlay("egress","hdr.attach_signatures.attach_signatures_tango_ip_header_7")
 
@pa_no_overlay("egress","hdr.attach_signatures.attach_signatures_tango_udp_header_0")
 
@pa_no_overlay("egress","hdr.attach_signatures.attach_signatures_tango_udp_header_1")
 
@pa_no_overlay("egress","hdr.attach_signatures.attach_signatures_tango_udp_header_2")
 
@pa_no_overlay("egress","hdr.attach_signatures.attach_signatures_tango_udp_header_3")
 
@pa_no_overlay("egress","hdr.attach_signatures.attach_signatures_seq_number")
 
@pa_no_overlay("egress","hdr.attach_signatures.attach_signatures_traffic_class")
 
@pa_no_overlay("egress","hdr.attach_signatures.attach_signatures_timestamp")
 
@pa_no_overlay("egress","hdr.attach_signatures.attach_signatures_encaped_ip_header_0")
 
@pa_no_overlay("egress","hdr.attach_signatures.attach_signatures_encaped_ip_header_1")
 
@pa_no_overlay("egress","hdr.attach_signatures.attach_signatures_encaped_ip_header_2")
 
@pa_no_overlay("egress","hdr.attach_signatures.attach_signatures_encaped_ip_header_3")
 
@pa_no_overlay("egress","hdr.attach_signatures.attach_signatures_encaped_ip_header_4")
 
@pa_no_overlay("egress","hdr.attach_signatures.attach_signatures_encaped_ip_header_5")
 
@pa_no_overlay("egress","hdr.attach_signatures.attach_signatures_encaped_ip_header_6")
 
@pa_no_overlay("egress","hdr.attach_signatures.attach_signatures_encaped_ip_header_7")
 
@pa_no_overlay("egress","hdr.attach_signatures.attach_signatures_encaped_ip_header_8")
 
@pa_no_overlay("egress","hdr.attach_signatures.attach_signatures_encaped_ip_header_9")
 
@pa_no_overlay("egress","hdr.attach_signatures.attach_signatures_encaped_udp_header_0")
 
@pa_no_overlay("egress","hdr.attach_signatures.attach_signatures_encaped_udp_header_1")
 
@pa_no_overlay("egress","hdr.attach_signatures.attach_signatures_encaped_udp_header_2")
 
@pa_no_overlay("egress","hdr.attach_signatures.attach_signatures_encaped_udp_header_3")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_tango_eth_header_0")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_tango_eth_header_1")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_tango_eth_header_2")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_0")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_1")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_2")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_3")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_4")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_5")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_6")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_7")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_tango_udp_header_0")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_tango_udp_header_1")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_tango_udp_header_2")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_tango_udp_header_3")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_tango_metrics_header_0")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_tango_metrics_header_1")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_tango_metrics_header_2")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_tango_metrics_header_3")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_tango_metrics_header_4")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_0")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_1")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_2")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_3")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_4")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_5")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_6")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_7")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_8")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_9")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_udp_header_0")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_udp_header_1")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_udp_header_2")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_udp_header_3")
  action egr_noop(){
    //NOOP
  }
  action forward_flow_recirc(){
    hdr.attach_signatures.setInvalid();
    hdr.incoming_tango_traffic.setInvalid();
    hdr.wire_ev.event_id=3;
    meta.egress_event_id=3;
    hdr.bridge_ev.port_event_id=0;
    hdr.bridge_ev.forward_flow=0;
    hdr.bridge_ev.attach_signatures=0;
    hdr.bridge_ev.incoming_tango_traffic=0;
  }
  action attach_signatures_recirc(){
    hdr.forward_flow.setInvalid();
    hdr.incoming_tango_traffic.setInvalid();
    hdr.wire_ev.event_id=2;
    meta.egress_event_id=2;
    hdr.bridge_ev.port_event_id=0;
    hdr.bridge_ev.forward_flow=0;
    hdr.bridge_ev.attach_signatures=0;
    hdr.bridge_ev.incoming_tango_traffic=0;
  }
  action incoming_tango_traffic_recirc(){
    hdr.forward_flow.setInvalid();
    hdr.attach_signatures.setInvalid();
    hdr.wire_ev.event_id=1;
    meta.egress_event_id=1;
    hdr.bridge_ev.port_event_id=0;
    hdr.bridge_ev.forward_flow=0;
    hdr.bridge_ev.attach_signatures=0;
    hdr.bridge_ev.incoming_tango_traffic=0;
  }
  action forward_flow_to_external(){
    meta.egress_event_id=3;
    hdr.lucid_eth.setInvalid();
    hdr.wire_ev.setInvalid();
    hdr.bridge_ev.setInvalid();
    hdr.attach_signatures.setInvalid();
    hdr.incoming_tango_traffic.setInvalid();
  }
  action attach_signatures_to_external(){
    meta.egress_event_id=2;
    hdr.lucid_eth.setInvalid();
    hdr.wire_ev.setInvalid();
    hdr.bridge_ev.setInvalid();
    hdr.forward_flow.setInvalid();
    hdr.incoming_tango_traffic.setInvalid();
  }
  action incoming_tango_traffic_to_external(){
    meta.egress_event_id=1;
    hdr.lucid_eth.setInvalid();
    hdr.wire_ev.setInvalid();
    hdr.bridge_ev.setInvalid();
    hdr.forward_flow.setInvalid();
    hdr.attach_signatures.setInvalid();
  }
  action forward_flow_to_internal(){
    meta.egress_event_id=3;
    hdr.wire_ev.event_id=3;
    hdr.bridge_ev.port_event_id=0;
    hdr.bridge_ev.forward_flow=0;
    hdr.bridge_ev.attach_signatures=0;
    hdr.bridge_ev.incoming_tango_traffic=0;
    hdr.attach_signatures.setInvalid();
    hdr.incoming_tango_traffic.setInvalid();
  }
  action attach_signatures_to_internal(){
    meta.egress_event_id=2;
    hdr.wire_ev.event_id=2;
    hdr.bridge_ev.port_event_id=0;
    hdr.bridge_ev.forward_flow=0;
    hdr.bridge_ev.attach_signatures=0;
    hdr.bridge_ev.incoming_tango_traffic=0;
    hdr.forward_flow.setInvalid();
    hdr.incoming_tango_traffic.setInvalid();
  }
  action incoming_tango_traffic_to_internal(){
    meta.egress_event_id=1;
    hdr.wire_ev.event_id=1;
    hdr.bridge_ev.port_event_id=0;
    hdr.bridge_ev.forward_flow=0;
    hdr.bridge_ev.attach_signatures=0;
    hdr.bridge_ev.incoming_tango_traffic=0;
    hdr.forward_flow.setInvalid();
    hdr.attach_signatures.setInvalid();
  }
  table t_extract_recirc_event {
    key = {
      eg_intr_md.egress_rid : ternary;
      hdr.bridge_ev.port_event_id : ternary;
      hdr.bridge_ev.forward_flow : ternary;
      hdr.bridge_ev.attach_signatures : ternary;
      hdr.bridge_ev.incoming_tango_traffic : ternary;
    }
    actions = {
      egr_noop;
      forward_flow_recirc;
      attach_signatures_recirc;
      incoming_tango_traffic_recirc;
    }
    const entries = {
      (1,0,0,1,0) : attach_signatures_recirc();
      (_,_,_,_,_) : egr_noop();
    } 
  } 
  table t_extract_port_event {
    key = {
      hdr.bridge_ev.port_event_id : ternary;
      eg_intr_md.egress_port : ternary;
    }
    actions = {
      forward_flow_to_external;
      forward_flow_to_internal;
      attach_signatures_to_external;
      attach_signatures_to_internal;
      incoming_tango_traffic_to_external;
      incoming_tango_traffic_to_internal;
    }
    const entries = {
      (3,196) : forward_flow_to_internal();
      (3,_) : forward_flow_to_external();
      (2,196) : attach_signatures_to_internal();
      (2,_) : attach_signatures_to_external();
      (1,196) : incoming_tango_traffic_to_internal();
      (1,_) : incoming_tango_traffic_to_external();
    } 
  } 
  bit<16> tango_metrics_hdr_3;
  action labeledstmt_109(){
    tango_metrics_hdr_3=hdr.attach_signatures.attach_signatures_seq_number;
  }
  bit<16> tango_metrics_hdr_1;
  action labeledstmt_108(){
    tango_metrics_hdr_1=hdr.attach_signatures.attach_signatures_timestamp;
  }
  bit<8> tango_metrics_hdr_0;
  action labeledstmt_107(){
   
tango_metrics_hdr_0=((bit<8>)hdr.attach_signatures.attach_signatures_traffic_class);
  }
  bit<32> MetricSignatureManager_sign_ret;
  action labeledstmt_106(){
    MetricSignatureManager_sign_ret=32w32;
  }
  bit<3> path_id4819;
  action labeledstmt_105(){
   
path_id4819=((bit<3>)hdr.attach_signatures.attach_signatures_traffic_class);
  }
  bit<12> timestamp4818;
  action labeledstmt_104(){
   
timestamp4818=((bit<12>)hdr.attach_signatures.attach_signatures_timestamp);
  }
  bit<1> BookSignatureManager_sign_ret;
  action labeledstmt_103(){
    BookSignatureManager_sign_ret=1w0;
  }
  bit<3> path_id4815;
  action labeledstmt_102(){
   
path_id4815=((bit<3>)hdr.attach_signatures.attach_signatures_traffic_class);
  }
  action labeledstmt_101(){
    eg_dprsr_md.drop_ctl=3w1;
  }
  action labeledstmt_57(){
    labeledstmt_101();
    labeledstmt_102();
    labeledstmt_103();
    labeledstmt_104();
    labeledstmt_105();
    labeledstmt_106();
    labeledstmt_107();
    labeledstmt_108();
    labeledstmt_109();
  }
  action labeledstmt_58(){
    //NOOP
  }
  action labeledstmt_59(){
    //NOOP
  }
  RegisterAction<bit<1>,bit<16>,bit<1>>(outgoing_book_signature_manager_7)
  outgoing_book_signature_manager_7_regaction_5709 = {
    void apply(inout bit<1> cell1_remote,
        out bit<1> ret_remote){
      bit<1> cell1_local=cell1_remote;
      bit<1> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_110(){
   
BookSignatureManager_sign_ret=outgoing_book_signature_manager_7_regaction_5709.execute(hdr.attach_signatures.attach_signatures_seq_number);
  }
  action labeledstmt_60(){
    labeledstmt_110();
  }
  action labeledstmt_61(){
    //NOOP
  }
  RegisterAction<bit<1>,bit<16>,bit<1>>(outgoing_book_signature_manager_6)
  outgoing_book_signature_manager_6_regaction_5710 = {
    void apply(inout bit<1> cell1_remote,
        out bit<1> ret_remote){
      bit<1> cell1_local=cell1_remote;
      bit<1> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_111(){
   
BookSignatureManager_sign_ret=outgoing_book_signature_manager_6_regaction_5710.execute(hdr.attach_signatures.attach_signatures_seq_number);
  }
  action labeledstmt_62(){
    labeledstmt_111();
  }
  action labeledstmt_63(){
    //NOOP
  }
  RegisterAction<bit<1>,bit<16>,bit<1>>(outgoing_book_signature_manager_5)
  outgoing_book_signature_manager_5_regaction_5711 = {
    void apply(inout bit<1> cell1_remote,
        out bit<1> ret_remote){
      bit<1> cell1_local=cell1_remote;
      bit<1> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_112(){
   
BookSignatureManager_sign_ret=outgoing_book_signature_manager_5_regaction_5711.execute(hdr.attach_signatures.attach_signatures_seq_number);
  }
  action labeledstmt_64(){
    labeledstmt_112();
  }
  action labeledstmt_65(){
    //NOOP
  }
  RegisterAction<bit<1>,bit<16>,bit<1>>(outgoing_book_signature_manager_4)
  outgoing_book_signature_manager_4_regaction_5712 = {
    void apply(inout bit<1> cell1_remote,
        out bit<1> ret_remote){
      bit<1> cell1_local=cell1_remote;
      bit<1> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_113(){
   
BookSignatureManager_sign_ret=outgoing_book_signature_manager_4_regaction_5712.execute(hdr.attach_signatures.attach_signatures_seq_number);
  }
  action labeledstmt_66(){
    labeledstmt_113();
  }
  action labeledstmt_67(){
    //NOOP
  }
  RegisterAction<bit<1>,bit<16>,bit<1>>(outgoing_book_signature_manager_3)
  outgoing_book_signature_manager_3_regaction_5713 = {
    void apply(inout bit<1> cell1_remote,
        out bit<1> ret_remote){
      bit<1> cell1_local=cell1_remote;
      bit<1> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_114(){
   
BookSignatureManager_sign_ret=outgoing_book_signature_manager_3_regaction_5713.execute(hdr.attach_signatures.attach_signatures_seq_number);
  }
  action labeledstmt_68(){
    labeledstmt_114();
  }
  action labeledstmt_69(){
    //NOOP
  }
  RegisterAction<bit<1>,bit<16>,bit<1>>(outgoing_book_signature_manager_2)
  outgoing_book_signature_manager_2_regaction_5714 = {
    void apply(inout bit<1> cell1_remote,
        out bit<1> ret_remote){
      bit<1> cell1_local=cell1_remote;
      bit<1> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_115(){
   
BookSignatureManager_sign_ret=outgoing_book_signature_manager_2_regaction_5714.execute(hdr.attach_signatures.attach_signatures_seq_number);
  }
  action labeledstmt_70(){
    labeledstmt_115();
  }
  action labeledstmt_71(){
    //NOOP
  }
  RegisterAction<bit<1>,bit<16>,bit<1>>(outgoing_book_signature_manager_1)
  outgoing_book_signature_manager_1_regaction_5715 = {
    void apply(inout bit<1> cell1_remote,
        out bit<1> ret_remote){
      bit<1> cell1_local=cell1_remote;
      bit<1> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_116(){
   
BookSignatureManager_sign_ret=outgoing_book_signature_manager_1_regaction_5715.execute(hdr.attach_signatures.attach_signatures_seq_number);
  }
  action labeledstmt_72(){
    labeledstmt_116();
  }
  RegisterAction<bit<1>,bit<16>,bit<1>>(outgoing_book_signature_manager_0)
  outgoing_book_signature_manager_0_regaction_5716 = {
    void apply(inout bit<1> cell1_remote,
        out bit<1> ret_remote){
      bit<1> cell1_local=cell1_remote;
      bit<1> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_117(){
   
BookSignatureManager_sign_ret=outgoing_book_signature_manager_0_regaction_5716.execute(hdr.attach_signatures.attach_signatures_seq_number);
  }
  action labeledstmt_73(){
    labeledstmt_117();
  }
  action labeledstmt_74(){
    //NOOP
  }
  bit<1> book_signature;
  action labeledstmt_118(){
    book_signature=BookSignatureManager_sign_ret;
  }
  action labeledstmt_75(){
    labeledstmt_118();
  }
  RegisterAction<bit<32>,bit<5>,bit<32>>(outgoing_metric_signature_manager_7)
  outgoing_metric_signature_manager_7_regaction_5717 = {
    void apply(inout bit<32> cell1_remote,
        out bit<32> ret_remote){
      bit<32> cell1_local=cell1_remote;
      bit<32> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_119(){
   
MetricSignatureManager_sign_ret=outgoing_metric_signature_manager_7_regaction_5717.execute((timestamp4818[4:0]));
  }
  action labeledstmt_76(){
    labeledstmt_119();
    labeledstmt_118();
  }
  action labeledstmt_77(){
    //NOOP
  }
  action labeledstmt_78(){
    //NOOP
  }
  RegisterAction<bit<32>,bit<5>,bit<32>>(outgoing_metric_signature_manager_6)
  outgoing_metric_signature_manager_6_regaction_5718 = {
    void apply(inout bit<32> cell1_remote,
        out bit<32> ret_remote){
      bit<32> cell1_local=cell1_remote;
      bit<32> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_120(){
   
MetricSignatureManager_sign_ret=outgoing_metric_signature_manager_6_regaction_5718.execute((timestamp4818[4:0]));
  }
  action labeledstmt_79(){
    labeledstmt_120();
  }
  action labeledstmt_80(){
    //NOOP
  }
  RegisterAction<bit<32>,bit<5>,bit<32>>(outgoing_metric_signature_manager_5)
  outgoing_metric_signature_manager_5_regaction_5719 = {
    void apply(inout bit<32> cell1_remote,
        out bit<32> ret_remote){
      bit<32> cell1_local=cell1_remote;
      bit<32> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_121(){
   
MetricSignatureManager_sign_ret=outgoing_metric_signature_manager_5_regaction_5719.execute((timestamp4818[4:0]));
  }
  action labeledstmt_81(){
    labeledstmt_121();
  }
  action labeledstmt_82(){
    //NOOP
  }
  RegisterAction<bit<32>,bit<5>,bit<32>>(outgoing_metric_signature_manager_4)
  outgoing_metric_signature_manager_4_regaction_5720 = {
    void apply(inout bit<32> cell1_remote,
        out bit<32> ret_remote){
      bit<32> cell1_local=cell1_remote;
      bit<32> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_122(){
   
MetricSignatureManager_sign_ret=outgoing_metric_signature_manager_4_regaction_5720.execute((timestamp4818[4:0]));
  }
  action labeledstmt_83(){
    labeledstmt_122();
  }
  bit<8> tango_metrics_hdr_4;
  action labeledstmt_123(){
    tango_metrics_hdr_4=((bit<8>)book_signature);
  }
  action labeledstmt_84(){
    labeledstmt_123();
  }
  RegisterAction<bit<32>,bit<5>,bit<32>>(outgoing_metric_signature_manager_3)
  outgoing_metric_signature_manager_3_regaction_5721 = {
    void apply(inout bit<32> cell1_remote,
        out bit<32> ret_remote){
      bit<32> cell1_local=cell1_remote;
      bit<32> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_124(){
   
MetricSignatureManager_sign_ret=outgoing_metric_signature_manager_3_regaction_5721.execute((timestamp4818[4:0]));
  }
  action labeledstmt_85(){
    labeledstmt_124();
    labeledstmt_123();
  }
  action labeledstmt_86(){
    //NOOP
  }
  action labeledstmt_87(){
    //NOOP
  }
  RegisterAction<bit<32>,bit<5>,bit<32>>(outgoing_metric_signature_manager_2)
  outgoing_metric_signature_manager_2_regaction_5722 = {
    void apply(inout bit<32> cell1_remote,
        out bit<32> ret_remote){
      bit<32> cell1_local=cell1_remote;
      bit<32> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_125(){
   
MetricSignatureManager_sign_ret=outgoing_metric_signature_manager_2_regaction_5722.execute((timestamp4818[4:0]));
  }
  action labeledstmt_88(){
    labeledstmt_125();
  }
  action labeledstmt_89(){
    //NOOP
  }
  RegisterAction<bit<32>,bit<5>,bit<32>>(outgoing_metric_signature_manager_1)
  outgoing_metric_signature_manager_1_regaction_5723 = {
    void apply(inout bit<32> cell1_remote,
        out bit<32> ret_remote){
      bit<32> cell1_local=cell1_remote;
      bit<32> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_126(){
   
MetricSignatureManager_sign_ret=outgoing_metric_signature_manager_1_regaction_5723.execute((timestamp4818[4:0]));
  }
  action labeledstmt_90(){
    labeledstmt_126();
  }
  RegisterAction<bit<32>,bit<5>,bit<32>>(outgoing_metric_signature_manager_0)
  outgoing_metric_signature_manager_0_regaction_5724 = {
    void apply(inout bit<32> cell1_remote,
        out bit<32> ret_remote){
      bit<32> cell1_local=cell1_remote;
      bit<32> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_127(){
   
MetricSignatureManager_sign_ret=outgoing_metric_signature_manager_0_regaction_5724.execute((timestamp4818[4:0]));
  }
  action labeledstmt_91(){
    labeledstmt_127();
  }
  action labeledstmt_92(){
    //NOOP
  }
  bit<32> ts_signature;
  action labeledstmt_128(){
    ts_signature=MetricSignatureManager_sign_ret;
  }
  action labeledstmt_93(){
    labeledstmt_128();
  }
  action labeledstmt_94(){
    //NOOP
  }
  bit<32> tango_metrics_hdr_2;
  action labeledstmt_129(){
    tango_metrics_hdr_2=ts_signature;
  }
  action labeledstmt_95(){
    labeledstmt_129();
  }
  action labeledstmt_96(){
    //NOOP
  }
  action labeledstmt_97(){
    eg_dprsr_md.drop_ctl=0;
    hdr.incoming_tango_traffic.setValid();
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_eth_header_0=hdr.attach_signatures.attach_signatures_tango_eth_header_0;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_eth_header_1=hdr.attach_signatures.attach_signatures_tango_eth_header_1;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_eth_header_2=hdr.attach_signatures.attach_signatures_tango_eth_header_2;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_0=hdr.attach_signatures.attach_signatures_tango_ip_header_0;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_1=hdr.attach_signatures.attach_signatures_tango_ip_header_1;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_2=hdr.attach_signatures.attach_signatures_tango_ip_header_2;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_3=hdr.attach_signatures.attach_signatures_tango_ip_header_3;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_4=hdr.attach_signatures.attach_signatures_tango_ip_header_4;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_5=hdr.attach_signatures.attach_signatures_tango_ip_header_5;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_6=hdr.attach_signatures.attach_signatures_tango_ip_header_6;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_7=hdr.attach_signatures.attach_signatures_tango_ip_header_7;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_udp_header_0=hdr.attach_signatures.attach_signatures_tango_udp_header_0;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_udp_header_1=hdr.attach_signatures.attach_signatures_tango_udp_header_1;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_udp_header_2=hdr.attach_signatures.attach_signatures_tango_udp_header_2;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_udp_header_3=hdr.attach_signatures.attach_signatures_tango_udp_header_3;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_metrics_header_0=tango_metrics_hdr_0;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_metrics_header_1=tango_metrics_hdr_1;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_metrics_header_2=tango_metrics_hdr_2;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_metrics_header_3=tango_metrics_hdr_3;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_metrics_header_4=tango_metrics_hdr_4;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_0=hdr.attach_signatures.attach_signatures_encaped_ip_header_0;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_1=hdr.attach_signatures.attach_signatures_encaped_ip_header_1;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_2=hdr.attach_signatures.attach_signatures_encaped_ip_header_2;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_3=hdr.attach_signatures.attach_signatures_encaped_ip_header_3;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_4=hdr.attach_signatures.attach_signatures_encaped_ip_header_4;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_5=hdr.attach_signatures.attach_signatures_encaped_ip_header_5;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_6=hdr.attach_signatures.attach_signatures_encaped_ip_header_6;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_7=hdr.attach_signatures.attach_signatures_encaped_ip_header_7;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_8=hdr.attach_signatures.attach_signatures_encaped_ip_header_8;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_9=hdr.attach_signatures.attach_signatures_encaped_ip_header_9;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_udp_header_0=hdr.attach_signatures.attach_signatures_encaped_udp_header_0;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_udp_header_1=hdr.attach_signatures.attach_signatures_encaped_udp_header_1;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_udp_header_2=hdr.attach_signatures.attach_signatures_encaped_udp_header_2;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_udp_header_3=hdr.attach_signatures.attach_signatures_encaped_udp_header_3;
  }
  action labeledstmt_98(){
    //NOOP
  }
  action labeledstmt_130(){
    hdr.attach_signatures.setInvalid();
  }
  action labeledstmt_99(){
    labeledstmt_130();
  }
  action labeledstmt_100(){
    //NOOP
  }
  table table_5745 {
    key = {
      meta.egress_event_id : ternary;
    }
    actions = {
      labeledstmt_57;
      labeledstmt_58;
    }
    const entries = {
      (2) : labeledstmt_57();
      (_) : labeledstmt_58();
    } 
  } 
  @ignore_table_dependency("EgressControl.table_5742")
  @ignore_table_dependency("EgressControl.table_5743")
  @ignore_table_dependency("EgressControl.table_5744")table table_5741 {
    key = {
      path_id4815 : ternary;
      meta.egress_event_id : ternary;
      path_id4819 : ternary;
    }
    actions = {
      labeledstmt_59;
      labeledstmt_60;
    }
    const entries = {
      (0,2,0) : labeledstmt_59();
      (1,2,0) : labeledstmt_59();
      (2,2,0) : labeledstmt_59();
      (3,2,0) : labeledstmt_59();
      (4,2,0) : labeledstmt_59();
      (5,2,0) : labeledstmt_59();
      (6,2,0) : labeledstmt_59();
      (7,2,0) : labeledstmt_60();
      (_,2,0) : labeledstmt_59();
      (0,2,1) : labeledstmt_59();
      (1,2,1) : labeledstmt_59();
      (2,2,1) : labeledstmt_59();
      (3,2,1) : labeledstmt_59();
      (4,2,1) : labeledstmt_59();
      (5,2,1) : labeledstmt_59();
      (6,2,1) : labeledstmt_59();
      (7,2,1) : labeledstmt_60();
      (_,2,1) : labeledstmt_59();
      (0,2,2) : labeledstmt_59();
      (1,2,2) : labeledstmt_59();
      (2,2,2) : labeledstmt_59();
      (3,2,2) : labeledstmt_59();
      (4,2,2) : labeledstmt_59();
      (5,2,2) : labeledstmt_59();
      (6,2,2) : labeledstmt_59();
      (7,2,2) : labeledstmt_60();
      (_,2,2) : labeledstmt_59();
      (0,2,3) : labeledstmt_59();
      (1,2,3) : labeledstmt_59();
      (2,2,3) : labeledstmt_59();
      (3,2,3) : labeledstmt_59();
      (4,2,3) : labeledstmt_59();
      (5,2,3) : labeledstmt_59();
      (6,2,3) : labeledstmt_59();
      (7,2,3) : labeledstmt_60();
      (_,2,3) : labeledstmt_59();
      (0,2,4) : labeledstmt_59();
      (1,2,4) : labeledstmt_59();
      (2,2,4) : labeledstmt_59();
      (3,2,4) : labeledstmt_59();
      (4,2,4) : labeledstmt_59();
      (5,2,4) : labeledstmt_59();
      (6,2,4) : labeledstmt_59();
      (7,2,4) : labeledstmt_60();
      (_,2,4) : labeledstmt_59();
      (0,2,5) : labeledstmt_59();
      (1,2,5) : labeledstmt_59();
      (2,2,5) : labeledstmt_59();
      (3,2,5) : labeledstmt_59();
      (4,2,5) : labeledstmt_59();
      (5,2,5) : labeledstmt_59();
      (6,2,5) : labeledstmt_59();
      (7,2,5) : labeledstmt_60();
      (_,2,5) : labeledstmt_59();
      (0,2,6) : labeledstmt_59();
      (1,2,6) : labeledstmt_59();
      (2,2,6) : labeledstmt_59();
      (3,2,6) : labeledstmt_59();
      (4,2,6) : labeledstmt_59();
      (5,2,6) : labeledstmt_59();
      (6,2,6) : labeledstmt_59();
      (7,2,6) : labeledstmt_60();
      (_,2,6) : labeledstmt_59();
      (0,2,7) : labeledstmt_59();
      (1,2,7) : labeledstmt_59();
      (2,2,7) : labeledstmt_59();
      (3,2,7) : labeledstmt_59();
      (4,2,7) : labeledstmt_59();
      (5,2,7) : labeledstmt_59();
      (6,2,7) : labeledstmt_59();
      (7,2,7) : labeledstmt_60();
      (_,2,7) : labeledstmt_59();
      (0,2,_) : labeledstmt_59();
      (1,2,_) : labeledstmt_59();
      (2,2,_) : labeledstmt_59();
      (3,2,_) : labeledstmt_59();
      (4,2,_) : labeledstmt_59();
      (5,2,_) : labeledstmt_59();
      (6,2,_) : labeledstmt_59();
      (7,2,_) : labeledstmt_60();
      (_,2,_) : labeledstmt_59();
      (_,_,_) : labeledstmt_59();
    } 
  } 
  @ignore_table_dependency("EgressControl.table_5741")
  @ignore_table_dependency("EgressControl.table_5743")
  @ignore_table_dependency("EgressControl.table_5744")table table_5742 {
    key = {
      path_id4815 : ternary;
      meta.egress_event_id : ternary;
    }
    actions = {
      labeledstmt_61;
      labeledstmt_62;
    }
    const entries = {
      (0,2) : labeledstmt_61();
      (1,2) : labeledstmt_61();
      (2,2) : labeledstmt_61();
      (3,2) : labeledstmt_61();
      (4,2) : labeledstmt_61();
      (5,2) : labeledstmt_61();
      (6,2) : labeledstmt_62();
      (_,_) : labeledstmt_61();
    } 
  } 
  @ignore_table_dependency("EgressControl.table_5741")
  @ignore_table_dependency("EgressControl.table_5742")
  @ignore_table_dependency("EgressControl.table_5744")table table_5743 {
    key = {
      path_id4815 : ternary;
      meta.egress_event_id : ternary;
    }
    actions = {
      labeledstmt_63;
      labeledstmt_64;
    }
    const entries = {
      (0,2) : labeledstmt_63();
      (1,2) : labeledstmt_63();
      (2,2) : labeledstmt_63();
      (3,2) : labeledstmt_63();
      (4,2) : labeledstmt_63();
      (5,2) : labeledstmt_64();
      (_,_) : labeledstmt_63();
    } 
  } 
  @ignore_table_dependency("EgressControl.table_5741")
  @ignore_table_dependency("EgressControl.table_5742")
  @ignore_table_dependency("EgressControl.table_5743")table table_5744 {
    key = {
      path_id4815 : ternary;
      meta.egress_event_id : ternary;
    }
    actions = {
      labeledstmt_65;
      labeledstmt_66;
    }
    const entries = {
      (0,2) : labeledstmt_65();
      (1,2) : labeledstmt_65();
      (2,2) : labeledstmt_65();
      (3,2) : labeledstmt_65();
      (4,2) : labeledstmt_66();
      (_,_) : labeledstmt_65();
    } 
  } 
  @ignore_table_dependency("EgressControl.table_5738")
  @ignore_table_dependency("EgressControl.table_5739")
  @ignore_table_dependency("EgressControl.table_5740")table table_5737 {
    key = {
      path_id4815 : ternary;
      meta.egress_event_id : ternary;
    }
    actions = {
      labeledstmt_67;
      labeledstmt_68;
    }
    const entries = {
      (0,2) : labeledstmt_67();
      (1,2) : labeledstmt_67();
      (2,2) : labeledstmt_67();
      (3,2) : labeledstmt_68();
      (_,_) : labeledstmt_67();
    } 
  } 
  @ignore_table_dependency("EgressControl.table_5737")
  @ignore_table_dependency("EgressControl.table_5739")
  @ignore_table_dependency("EgressControl.table_5740")table table_5738 {
    key = {
      path_id4815 : ternary;
      meta.egress_event_id : ternary;
    }
    actions = {
      labeledstmt_69;
      labeledstmt_70;
    }
    const entries = {
      (0,2) : labeledstmt_69();
      (1,2) : labeledstmt_69();
      (2,2) : labeledstmt_70();
      (_,_) : labeledstmt_69();
    } 
  } 
  @ignore_table_dependency("EgressControl.table_5737")
  @ignore_table_dependency("EgressControl.table_5738")
  @ignore_table_dependency("EgressControl.table_5740")table table_5739 {
    key = {
      path_id4815 : ternary;
      meta.egress_event_id : ternary;
    }
    actions = {
      labeledstmt_71;
      labeledstmt_72;
    }
    const entries = {
      (0,2) : labeledstmt_71();
      (1,2) : labeledstmt_72();
      (_,_) : labeledstmt_71();
    } 
  } 
  @ignore_table_dependency("EgressControl.table_5737")
  @ignore_table_dependency("EgressControl.table_5738")
  @ignore_table_dependency("EgressControl.table_5739")table table_5740 {
    key = {
      path_id4815 : ternary;
      meta.egress_event_id : ternary;
    }
    actions = {
      labeledstmt_73;
      labeledstmt_74;
    }
    const entries = {
      (0,2) : labeledstmt_73();
      (_,_) : labeledstmt_74();
    } 
  } 
  @ignore_table_dependency("EgressControl.table_5734")
  @ignore_table_dependency("EgressControl.table_5735")
  @ignore_table_dependency("EgressControl.table_5736")table table_5733 {
    key = {
      path_id4819 : ternary;
      meta.egress_event_id : ternary;
    }
    actions = {
      labeledstmt_75;
      labeledstmt_76;
      labeledstmt_77;
    }
    const entries = {
      (0,2) : labeledstmt_75();
      (1,2) : labeledstmt_75();
      (2,2) : labeledstmt_75();
      (3,2) : labeledstmt_75();
      (4,2) : labeledstmt_75();
      (5,2) : labeledstmt_75();
      (6,2) : labeledstmt_75();
      (7,2) : labeledstmt_76();
      (_,2) : labeledstmt_75();
      (_,_) : labeledstmt_77();
    } 
  } 
  @ignore_table_dependency("EgressControl.table_5733")
  @ignore_table_dependency("EgressControl.table_5735")
  @ignore_table_dependency("EgressControl.table_5736")table table_5734 {
    key = {
      path_id4819 : ternary;
      meta.egress_event_id : ternary;
    }
    actions = {
      labeledstmt_78;
      labeledstmt_79;
    }
    const entries = {
      (0,2) : labeledstmt_78();
      (1,2) : labeledstmt_78();
      (2,2) : labeledstmt_78();
      (3,2) : labeledstmt_78();
      (4,2) : labeledstmt_78();
      (5,2) : labeledstmt_78();
      (6,2) : labeledstmt_79();
      (_,_) : labeledstmt_78();
    } 
  } 
  @ignore_table_dependency("EgressControl.table_5733")
  @ignore_table_dependency("EgressControl.table_5734")
  @ignore_table_dependency("EgressControl.table_5736")table table_5735 {
    key = {
      path_id4819 : ternary;
      meta.egress_event_id : ternary;
    }
    actions = {
      labeledstmt_80;
      labeledstmt_81;
    }
    const entries = {
      (0,2) : labeledstmt_80();
      (1,2) : labeledstmt_80();
      (2,2) : labeledstmt_80();
      (3,2) : labeledstmt_80();
      (4,2) : labeledstmt_80();
      (5,2) : labeledstmt_81();
      (_,_) : labeledstmt_80();
    } 
  } 
  @ignore_table_dependency("EgressControl.table_5733")
  @ignore_table_dependency("EgressControl.table_5734")
  @ignore_table_dependency("EgressControl.table_5735")table table_5736 {
    key = {
      path_id4819 : ternary;
      meta.egress_event_id : ternary;
    }
    actions = {
      labeledstmt_82;
      labeledstmt_83;
    }
    const entries = {
      (0,2) : labeledstmt_82();
      (1,2) : labeledstmt_82();
      (2,2) : labeledstmt_82();
      (3,2) : labeledstmt_82();
      (4,2) : labeledstmt_83();
      (_,_) : labeledstmt_82();
    } 
  } 
  @ignore_table_dependency("EgressControl.table_5730")
  @ignore_table_dependency("EgressControl.table_5731")
  @ignore_table_dependency("EgressControl.table_5732")table table_5729 {
    key = {
      path_id4819 : ternary;
      meta.egress_event_id : ternary;
    }
    actions = {
      labeledstmt_84;
      labeledstmt_85;
      labeledstmt_86;
    }
    const entries = {
      (0,2) : labeledstmt_84();
      (1,2) : labeledstmt_84();
      (2,2) : labeledstmt_84();
      (3,2) : labeledstmt_85();
      (_,2) : labeledstmt_84();
      (_,_) : labeledstmt_86();
    } 
  } 
  @ignore_table_dependency("EgressControl.table_5729")
  @ignore_table_dependency("EgressControl.table_5731")
  @ignore_table_dependency("EgressControl.table_5732")table table_5730 {
    key = {
      path_id4819 : ternary;
      meta.egress_event_id : ternary;
    }
    actions = {
      labeledstmt_87;
      labeledstmt_88;
    }
    const entries = {
      (0,2) : labeledstmt_87();
      (1,2) : labeledstmt_87();
      (2,2) : labeledstmt_88();
      (_,_) : labeledstmt_87();
    } 
  } 
  @ignore_table_dependency("EgressControl.table_5729")
  @ignore_table_dependency("EgressControl.table_5730")
  @ignore_table_dependency("EgressControl.table_5732")table table_5731 {
    key = {
      path_id4819 : ternary;
      meta.egress_event_id : ternary;
    }
    actions = {
      labeledstmt_89;
      labeledstmt_90;
    }
    const entries = {
      (0,2) : labeledstmt_89();
      (1,2) : labeledstmt_90();
      (_,_) : labeledstmt_89();
    } 
  } 
  @ignore_table_dependency("EgressControl.table_5729")
  @ignore_table_dependency("EgressControl.table_5730")
  @ignore_table_dependency("EgressControl.table_5731")table table_5732 {
    key = {
      path_id4819 : ternary;
      meta.egress_event_id : ternary;
    }
    actions = {
      labeledstmt_91;
      labeledstmt_92;
    }
    const entries = {
      (0,2) : labeledstmt_91();
      (_,_) : labeledstmt_92();
    } 
  } 
  table table_5728 {
    key = {
      meta.egress_event_id : ternary;
    }
    actions = {
      labeledstmt_93;
      labeledstmt_94;
    }
    const entries = {
      (2) : labeledstmt_93();
      (_) : labeledstmt_94();
    } 
  } 
  table table_5727 {
    key = {
      meta.egress_event_id : ternary;
    }
    actions = {
      labeledstmt_95;
      labeledstmt_96;
    }
    const entries = {
      (2) : labeledstmt_95();
      (_) : labeledstmt_96();
    } 
  } 
  table table_5726 {
    key = {
      meta.egress_event_id : ternary;
    }
    actions = {
      labeledstmt_97;
      labeledstmt_98;
    }
    const entries = {
      (2) : labeledstmt_97();
      (_) : labeledstmt_98();
    } 
  } 
  table table_5725 {
    key = {
      meta.egress_event_id : ternary;
    }
    actions = {
      labeledstmt_99;
      labeledstmt_100;
    }
    const entries = {
      (2) : labeledstmt_99();
      (_) : labeledstmt_100();
    } 
  } 
  apply {
    eg_dprsr_md.drop_ctl=0;
    if ((eg_intr_md.egress_rid==0)){
      t_extract_port_event.apply();
    } else {
      t_extract_recirc_event.apply();
    }
    table_5745.apply();
    table_5741.apply();
    table_5742.apply();
    table_5743.apply();
    table_5744.apply();
    table_5737.apply();
    table_5738.apply();
    table_5739.apply();
    table_5740.apply();
    table_5733.apply();
    table_5734.apply();
    table_5735.apply();
    table_5736.apply();
    table_5729.apply();
    table_5730.apply();
    table_5731.apply();
    table_5732.apply();
    table_5728.apply();
    table_5727.apply();
    table_5726.apply();
    table_5725.apply();
  }
} 
control EgressDeparse(packet_out pkt,
    inout hdr_t hdr,
    in meta_t meta,
    in egress_intrinsic_metadata_for_deparser_t eg_dprsr_md){

  apply {
    pkt.emit(hdr);
  }
} 
//Pipeline and main declarations
Pipeline(IngressParser(),
  IngressControl(),
  IngressDeparser(),
  EgressParser(),
  EgressControl(),
  EgressDeparse()) pipe;
Switch(pipe) main;
