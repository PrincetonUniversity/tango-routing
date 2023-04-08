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
  bit<5> flag_pad_5766;
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
Register<bit<32>,_>(32w16)
outgoing_metric_signature_manager_7;
Register<bit<32>,_>(32w16)
outgoing_metric_signature_manager_6;
Register<bit<32>,_>(32w16)
outgoing_metric_signature_manager_5;
Register<bit<32>,_>(32w16)
outgoing_metric_signature_manager_4;
Register<bit<32>,_>(32w16)
outgoing_metric_signature_manager_3;
Register<bit<32>,_>(32w16)
outgoing_metric_signature_manager_2;
Register<bit<32>,_>(32w16)
outgoing_metric_signature_manager_1;
Register<bit<32>,_>(32w16)
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
  action labeledstmt_30(){
    map_path_to_tunnel_header_ret_7=64w32;
  }
  bit<64> map_path_to_tunnel_header_ret_6;
  action labeledstmt_29(){
    map_path_to_tunnel_header_ret_6=64w32;
  }
  bit<64> map_path_to_tunnel_header_ret_5;
  action labeledstmt_28(){
    map_path_to_tunnel_header_ret_5=64w32;
  }
  bit<64> map_path_to_tunnel_header_ret_4;
  action labeledstmt_27(){
    map_path_to_tunnel_header_ret_4=64w32;
  }
  bit<8> map_path_to_tunnel_header_ret_3;
  action labeledstmt_26(){
    map_path_to_tunnel_header_ret_3=8w32;
  }
  bit<8> map_path_to_tunnel_header_ret_2;
  action labeledstmt_25(){
    map_path_to_tunnel_header_ret_2=8w32;
  }
  bit<16> map_path_to_tunnel_header_ret_1;
  action labeledstmt_24(){
    map_path_to_tunnel_header_ret_1=16w32;
  }
  bit<32> map_path_to_tunnel_header_ret_0;
  action labeledstmt_23(){
    map_path_to_tunnel_header_ret_0=32w32;
  }
  bit<8> map_flow_to_traffic_class_ret;
  action labeledstmt_22(){
    map_flow_to_traffic_class_ret=8w32;
  }
  action labeledstmt_1(){
    labeledstmt_22();
    labeledstmt_23();
    labeledstmt_24();
    labeledstmt_25();
    labeledstmt_26();
    labeledstmt_27();
    labeledstmt_28();
    labeledstmt_29();
    labeledstmt_30();
  }
  action labeledstmt_31(){
    hdr.incoming_tango_traffic.setInvalid();
  }
  action labeledstmt_2(){
    labeledstmt_31();
  }
  action labeledstmt_3(){
    //NOOP
  }
  action labeledstmt_32(){
    map_flow_to_traffic_class_ret=8w15;
  }
  action labeledstmt_4(){
    labeledstmt_32();
  }
  action labeledstmt_5(){
    //NOOP
  }
  bit<8> traffic_class;
  action labeledstmt_33(){
    traffic_class=map_flow_to_traffic_class_ret;
  }
  action labeledstmt_6(){
    labeledstmt_33();
  }
  action labeledstmt_7(){
    //NOOP
  }
  bit<8> path_id;
  action labeledstmt_34(){
    path_id=((bit<8>)traffic_class);
  }
  action labeledstmt_8(){
    labeledstmt_34();
  }
  action labeledstmt_9(){
    //NOOP
  }
  action labeledstmt_68(){
    map_path_to_tunnel_header_ret_0=32w0;
  }
  action labeledstmt_67(){
    map_path_to_tunnel_header_ret_1=16w0;
  }
  action labeledstmt_66(){
    map_path_to_tunnel_header_ret_2=8w0;
  }
  action labeledstmt_65(){
    map_path_to_tunnel_header_ret_3=8w0;
  }
  action labeledstmt_64(){
    map_path_to_tunnel_header_ret_4=64w0;
  }
  action labeledstmt_63(){
    map_path_to_tunnel_header_ret_5=64w0;
  }
  action labeledstmt_62(){
    map_path_to_tunnel_header_ret_6=64w0;
  }
  action labeledstmt_61(){
    map_path_to_tunnel_header_ret_7=64w0;
  }
  bit<8> path_id4794;
  action labeledstmt_60(){
    path_id4794=((bit<8>)traffic_class);
  }
  bit<16> SequenceNumberManager_increment_ret;
  action labeledstmt_59(){
    SequenceNumberManager_increment_ret=16w32;
  }
  bit<32> time_now;
  action labeledstmt_58(){
    time_now=(ig_intr_md.ingress_mac_tstamp[47:16]);
  }
  bit<48> egress_packet_arg_0;
  action labeledstmt_57(){
    egress_packet_arg_0=hdr.forward_flow.forward_flow_eth_header_0;
  }
  bit<48> egress_packet_arg_1;
  action labeledstmt_56(){
    egress_packet_arg_1=hdr.forward_flow.forward_flow_eth_header_1;
  }
  bit<16> egress_packet_arg_2;
  action labeledstmt_55(){
    egress_packet_arg_2=hdr.forward_flow.forward_flow_eth_header_2;
  }
  bit<16> egress_packet_arg_4;
  action labeledstmt_54(){
    egress_packet_arg_4=(hdr.forward_flow.forward_flow_ip_header_2+16w88);
  }
  bit<16> egress_packet_arg_11;
  action labeledstmt_53(){
    egress_packet_arg_11=16w8080;
  }
  bit<16> egress_packet_arg_12;
  action labeledstmt_52(){
    egress_packet_arg_12=16w8080;
  }
  bit<16> egress_packet_arg_13;
  action labeledstmt_51(){
    egress_packet_arg_13=16w0;
  }
  bit<16> egress_packet_arg_14;
  action labeledstmt_50(){
    egress_packet_arg_14=16w0;
  }
  bit<8> egress_packet_arg_16;
  action labeledstmt_49(){
    egress_packet_arg_16=traffic_class;
  }
  bit<8> egress_packet_arg_18;
  action labeledstmt_48(){
    egress_packet_arg_18=hdr.forward_flow.forward_flow_ip_header_0;
  }
  bit<8> egress_packet_arg_19;
  action labeledstmt_47(){
    egress_packet_arg_19=hdr.forward_flow.forward_flow_ip_header_1;
  }
  bit<16> egress_packet_arg_20;
  action labeledstmt_46(){
    egress_packet_arg_20=hdr.forward_flow.forward_flow_ip_header_2;
  }
  bit<16> egress_packet_arg_21;
  action labeledstmt_45(){
    egress_packet_arg_21=hdr.forward_flow.forward_flow_ip_header_3;
  }
  bit<16> egress_packet_arg_22;
  action labeledstmt_44(){
    egress_packet_arg_22=hdr.forward_flow.forward_flow_ip_header_4;
  }
  bit<8> egress_packet_arg_23;
  action labeledstmt_43(){
    egress_packet_arg_23=hdr.forward_flow.forward_flow_ip_header_5;
  }
  bit<8> egress_packet_arg_24;
  action labeledstmt_42(){
    egress_packet_arg_24=hdr.forward_flow.forward_flow_ip_header_6;
  }
  bit<16> egress_packet_arg_25;
  action labeledstmt_41(){
    egress_packet_arg_25=hdr.forward_flow.forward_flow_ip_header_7;
  }
  bit<32> egress_packet_arg_26;
  action labeledstmt_40(){
    egress_packet_arg_26=hdr.forward_flow.forward_flow_ip_header_8;
  }
  bit<32> egress_packet_arg_27;
  action labeledstmt_39(){
    egress_packet_arg_27=hdr.forward_flow.forward_flow_ip_header_9;
  }
  bit<16> egress_packet_arg_28;
  action labeledstmt_38(){
    egress_packet_arg_28=hdr.forward_flow.forward_flow_udp_header_0;
  }
  bit<16> egress_packet_arg_29;
  action labeledstmt_37(){
    egress_packet_arg_29=hdr.forward_flow.forward_flow_udp_header_1;
  }
  bit<16> egress_packet_arg_30;
  action labeledstmt_36(){
    egress_packet_arg_30=hdr.forward_flow.forward_flow_udp_header_2;
  }
  bit<16> egress_packet_arg_31;
  action labeledstmt_35(){
    egress_packet_arg_31=hdr.forward_flow.forward_flow_udp_header_3;
  }
  action labeledstmt_10(){
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
    labeledstmt_55();
    labeledstmt_56();
    labeledstmt_57();
    labeledstmt_58();
    labeledstmt_59();
    labeledstmt_60();
    labeledstmt_61();
    labeledstmt_62();
    labeledstmt_63();
    labeledstmt_64();
    labeledstmt_65();
    labeledstmt_66();
    labeledstmt_67();
    labeledstmt_68();
  }
  action labeledstmt_11(){
    //NOOP
  }
  bit<32> tango_tunnel_hdr_0;
  action labeledstmt_78(){
    tango_tunnel_hdr_0=map_path_to_tunnel_header_ret_0;
  }
  bit<16> tango_tunnel_hdr_1;
  action labeledstmt_77(){
    tango_tunnel_hdr_1=map_path_to_tunnel_header_ret_1;
  }
  bit<8> tango_tunnel_hdr_2;
  action labeledstmt_76(){
    tango_tunnel_hdr_2=map_path_to_tunnel_header_ret_2;
  }
  bit<8> tango_tunnel_hdr_3;
  action labeledstmt_75(){
    tango_tunnel_hdr_3=map_path_to_tunnel_header_ret_3;
  }
  bit<64> tango_tunnel_hdr_4;
  action labeledstmt_74(){
    tango_tunnel_hdr_4=map_path_to_tunnel_header_ret_4;
  }
  bit<64> tango_tunnel_hdr_5;
  action labeledstmt_73(){
    tango_tunnel_hdr_5=map_path_to_tunnel_header_ret_5;
  }
  bit<64> tango_tunnel_hdr_6;
  action labeledstmt_72(){
    tango_tunnel_hdr_6=map_path_to_tunnel_header_ret_6;
  }
  bit<64> tango_tunnel_hdr_7;
  action labeledstmt_71(){
    tango_tunnel_hdr_7=map_path_to_tunnel_header_ret_7;
  }
  RegisterAction<bit<16>,bit<8>,bit<16>>(sequence_counters_0)
  sequence_counters_0_regaction_5718 = {
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
  action labeledstmt_70(){
   
SequenceNumberManager_increment_ret=sequence_counters_0_regaction_5718.execute(path_id4794);
  }
  bit<12> timestamp;
  action labeledstmt_69(){
    timestamp=(time_now[31:20]);
  }
  action labeledstmt_12(){
    labeledstmt_69();
    labeledstmt_70();
    labeledstmt_71();
    labeledstmt_72();
    labeledstmt_73();
    labeledstmt_74();
    labeledstmt_75();
    labeledstmt_76();
    labeledstmt_77();
    labeledstmt_78();
  }
  action labeledstmt_13(){
    //NOOP
  }
  bit<32> egress_packet_arg_3;
  action labeledstmt_87(){
    egress_packet_arg_3=tango_tunnel_hdr_0;
  }
  bit<8> egress_packet_arg_5;
  action labeledstmt_86(){
    egress_packet_arg_5=tango_tunnel_hdr_2;
  }
  bit<8> egress_packet_arg_6;
  action labeledstmt_85(){
    egress_packet_arg_6=tango_tunnel_hdr_3;
  }
  bit<64> egress_packet_arg_7;
  action labeledstmt_84(){
    egress_packet_arg_7=tango_tunnel_hdr_4;
  }
  bit<64> egress_packet_arg_8;
  action labeledstmt_83(){
    egress_packet_arg_8=tango_tunnel_hdr_5;
  }
  bit<64> egress_packet_arg_9;
  action labeledstmt_82(){
    egress_packet_arg_9=tango_tunnel_hdr_6;
  }
  bit<64> egress_packet_arg_10;
  action labeledstmt_81(){
    egress_packet_arg_10=tango_tunnel_hdr_7;
  }
  bit<16> seq_number;
  action labeledstmt_80(){
    seq_number=SequenceNumberManager_increment_ret;
  }
  bit<16> egress_packet_arg_17;
  action labeledstmt_79(){
    egress_packet_arg_17=((bit<16>)timestamp);
  }
  action labeledstmt_14(){
    labeledstmt_79();
    labeledstmt_80();
    labeledstmt_81();
    labeledstmt_82();
    labeledstmt_83();
    labeledstmt_84();
    labeledstmt_85();
    labeledstmt_86();
    labeledstmt_87();
  }
  action labeledstmt_15(){
    //NOOP
  }
  bit<16> egress_packet_arg_15;
  action labeledstmt_88(){
    egress_packet_arg_15=seq_number;
  }
  action labeledstmt_16(){
    labeledstmt_88();
  }
  action labeledstmt_17(){
    //NOOP
  }
  action labeledstmt_18(){
    hdr.bridge_ev.attach_signatures=1;
    hdr.attach_signatures.setValid();
   
hdr.attach_signatures.attach_signatures_tango_eth_header_0=egress_packet_arg_0;
   
hdr.attach_signatures.attach_signatures_tango_eth_header_1=egress_packet_arg_1;
   
hdr.attach_signatures.attach_signatures_tango_eth_header_2=egress_packet_arg_2;
   
hdr.attach_signatures.attach_signatures_tango_ip_header_0=egress_packet_arg_3;
   
hdr.attach_signatures.attach_signatures_tango_ip_header_1=egress_packet_arg_4;
   
hdr.attach_signatures.attach_signatures_tango_ip_header_2=egress_packet_arg_5;
   
hdr.attach_signatures.attach_signatures_tango_ip_header_3=egress_packet_arg_6;
   
hdr.attach_signatures.attach_signatures_tango_ip_header_4=egress_packet_arg_7;
   
hdr.attach_signatures.attach_signatures_tango_ip_header_5=egress_packet_arg_8;
   
hdr.attach_signatures.attach_signatures_tango_ip_header_6=egress_packet_arg_9;
   
hdr.attach_signatures.attach_signatures_tango_ip_header_7=egress_packet_arg_10;
   
hdr.attach_signatures.attach_signatures_tango_udp_header_0=egress_packet_arg_11;
   
hdr.attach_signatures.attach_signatures_tango_udp_header_1=egress_packet_arg_12;
   
hdr.attach_signatures.attach_signatures_tango_udp_header_2=egress_packet_arg_13;
   
hdr.attach_signatures.attach_signatures_tango_udp_header_3=egress_packet_arg_14;
    hdr.attach_signatures.attach_signatures_seq_number=egress_packet_arg_15;
   
hdr.attach_signatures.attach_signatures_traffic_class=egress_packet_arg_16;
    hdr.attach_signatures.attach_signatures_timestamp=egress_packet_arg_17;
   
hdr.attach_signatures.attach_signatures_encaped_ip_header_0=egress_packet_arg_18;
   
hdr.attach_signatures.attach_signatures_encaped_ip_header_1=egress_packet_arg_19;
   
hdr.attach_signatures.attach_signatures_encaped_ip_header_2=egress_packet_arg_20;
   
hdr.attach_signatures.attach_signatures_encaped_ip_header_3=egress_packet_arg_21;
   
hdr.attach_signatures.attach_signatures_encaped_ip_header_4=egress_packet_arg_22;
   
hdr.attach_signatures.attach_signatures_encaped_ip_header_5=egress_packet_arg_23;
   
hdr.attach_signatures.attach_signatures_encaped_ip_header_6=egress_packet_arg_24;
   
hdr.attach_signatures.attach_signatures_encaped_ip_header_7=egress_packet_arg_25;
   
hdr.attach_signatures.attach_signatures_encaped_ip_header_8=egress_packet_arg_26;
   
hdr.attach_signatures.attach_signatures_encaped_ip_header_9=egress_packet_arg_27;
   
hdr.attach_signatures.attach_signatures_encaped_udp_header_0=egress_packet_arg_28;
   
hdr.attach_signatures.attach_signatures_encaped_udp_header_1=egress_packet_arg_29;
   
hdr.attach_signatures.attach_signatures_encaped_udp_header_2=egress_packet_arg_30;
   
hdr.attach_signatures.attach_signatures_encaped_udp_header_3=egress_packet_arg_31;
    hdr.bridge_ev.port_event_id=2;
    ig_tm_md.ucast_egress_port=ig_intr_md.ingress_port;
  }
  action labeledstmt_19(){
    //NOOP
  }
  action labeledstmt_89(){
    hdr.forward_flow.setInvalid();
  }
  action labeledstmt_20(){
    labeledstmt_89();
  }
  action labeledstmt_21(){
    //NOOP
  }
  table table_5728 {
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
  table table_5727 {
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
  table table_5726 {
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
  table table_5725 {
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
  table table_5724 {
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
  table table_5723 {
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
  table table_5722 {
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
  table table_5721 {
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
  table table_5720 {
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
  table table_5719 {
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
      labeledstmt_20;
      labeledstmt_21;
    }
    const entries = {
      (_,_,_,_,_,_,3) : labeledstmt_20();
      (_,_,_,_,_,_,_) : labeledstmt_21();
    } 
  } 
  apply {
    table_5728.apply();
    table_5727.apply();
    table_5726.apply();
    table_5725.apply();
    table_5724.apply();
    table_5723.apply();
    table_5722.apply();
    table_5721.apply();
    table_5720.apply();
    table_5719.apply();
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
  bit<16> forward_tango_pkt_arg_33;
  action labeledstmt_172(){
   
forward_tango_pkt_arg_33=hdr.attach_signatures.attach_signatures_encaped_udp_header_3;
  }
  bit<16> forward_tango_pkt_arg_32;
  action labeledstmt_171(){
   
forward_tango_pkt_arg_32=hdr.attach_signatures.attach_signatures_encaped_udp_header_2;
  }
  bit<16> forward_tango_pkt_arg_31;
  action labeledstmt_170(){
   
forward_tango_pkt_arg_31=hdr.attach_signatures.attach_signatures_encaped_udp_header_1;
  }
  bit<16> forward_tango_pkt_arg_30;
  action labeledstmt_169(){
   
forward_tango_pkt_arg_30=hdr.attach_signatures.attach_signatures_encaped_udp_header_0;
  }
  bit<32> forward_tango_pkt_arg_29;
  action labeledstmt_168(){
   
forward_tango_pkt_arg_29=hdr.attach_signatures.attach_signatures_encaped_ip_header_9;
  }
  bit<32> forward_tango_pkt_arg_28;
  action labeledstmt_167(){
   
forward_tango_pkt_arg_28=hdr.attach_signatures.attach_signatures_encaped_ip_header_8;
  }
  bit<16> forward_tango_pkt_arg_27;
  action labeledstmt_166(){
   
forward_tango_pkt_arg_27=hdr.attach_signatures.attach_signatures_encaped_ip_header_7;
  }
  bit<8> forward_tango_pkt_arg_26;
  action labeledstmt_165(){
   
forward_tango_pkt_arg_26=hdr.attach_signatures.attach_signatures_encaped_ip_header_6;
  }
  bit<8> forward_tango_pkt_arg_25;
  action labeledstmt_164(){
   
forward_tango_pkt_arg_25=hdr.attach_signatures.attach_signatures_encaped_ip_header_5;
  }
  bit<16> forward_tango_pkt_arg_24;
  action labeledstmt_163(){
   
forward_tango_pkt_arg_24=hdr.attach_signatures.attach_signatures_encaped_ip_header_4;
  }
  bit<16> forward_tango_pkt_arg_23;
  action labeledstmt_162(){
   
forward_tango_pkt_arg_23=hdr.attach_signatures.attach_signatures_encaped_ip_header_3;
  }
  bit<16> forward_tango_pkt_arg_22;
  action labeledstmt_161(){
   
forward_tango_pkt_arg_22=hdr.attach_signatures.attach_signatures_encaped_ip_header_2;
  }
  bit<8> forward_tango_pkt_arg_21;
  action labeledstmt_160(){
   
forward_tango_pkt_arg_21=hdr.attach_signatures.attach_signatures_encaped_ip_header_1;
  }
  bit<8> forward_tango_pkt_arg_20;
  action labeledstmt_159(){
   
forward_tango_pkt_arg_20=hdr.attach_signatures.attach_signatures_encaped_ip_header_0;
  }
  bit<16> forward_tango_pkt_arg_14;
  action labeledstmt_158(){
   
forward_tango_pkt_arg_14=hdr.attach_signatures.attach_signatures_tango_udp_header_3;
  }
  bit<16> forward_tango_pkt_arg_13;
  action labeledstmt_157(){
   
forward_tango_pkt_arg_13=hdr.attach_signatures.attach_signatures_tango_udp_header_2;
  }
  bit<16> forward_tango_pkt_arg_12;
  action labeledstmt_156(){
   
forward_tango_pkt_arg_12=hdr.attach_signatures.attach_signatures_tango_udp_header_1;
  }
  bit<16> forward_tango_pkt_arg_11;
  action labeledstmt_155(){
   
forward_tango_pkt_arg_11=hdr.attach_signatures.attach_signatures_tango_udp_header_0;
  }
  bit<64> forward_tango_pkt_arg_10;
  action labeledstmt_154(){
   
forward_tango_pkt_arg_10=hdr.attach_signatures.attach_signatures_tango_ip_header_7;
  }
  bit<64> forward_tango_pkt_arg_9;
  action labeledstmt_153(){
   
forward_tango_pkt_arg_9=hdr.attach_signatures.attach_signatures_tango_ip_header_6;
  }
  bit<64> forward_tango_pkt_arg_8;
  action labeledstmt_152(){
   
forward_tango_pkt_arg_8=hdr.attach_signatures.attach_signatures_tango_ip_header_5;
  }
  bit<64> forward_tango_pkt_arg_7;
  action labeledstmt_151(){
   
forward_tango_pkt_arg_7=hdr.attach_signatures.attach_signatures_tango_ip_header_4;
  }
  bit<8> forward_tango_pkt_arg_6;
  action labeledstmt_150(){
   
forward_tango_pkt_arg_6=hdr.attach_signatures.attach_signatures_tango_ip_header_3;
  }
  bit<8> forward_tango_pkt_arg_5;
  action labeledstmt_149(){
   
forward_tango_pkt_arg_5=hdr.attach_signatures.attach_signatures_tango_ip_header_2;
  }
  bit<16> forward_tango_pkt_arg_4;
  action labeledstmt_148(){
   
forward_tango_pkt_arg_4=hdr.attach_signatures.attach_signatures_tango_ip_header_1;
  }
  bit<32> forward_tango_pkt_arg_3;
  action labeledstmt_147(){
   
forward_tango_pkt_arg_3=hdr.attach_signatures.attach_signatures_tango_ip_header_0;
  }
  bit<16> forward_tango_pkt_arg_2;
  action labeledstmt_146(){
   
forward_tango_pkt_arg_2=hdr.attach_signatures.attach_signatures_tango_eth_header_2;
  }
  bit<48> forward_tango_pkt_arg_1;
  action labeledstmt_145(){
   
forward_tango_pkt_arg_1=hdr.attach_signatures.attach_signatures_tango_eth_header_1;
  }
  bit<48> forward_tango_pkt_arg_0;
  action labeledstmt_144(){
   
forward_tango_pkt_arg_0=hdr.attach_signatures.attach_signatures_tango_eth_header_0;
  }
  bit<16> tango_metrics_hdr_3;
  action labeledstmt_143(){
    tango_metrics_hdr_3=hdr.attach_signatures.attach_signatures_seq_number;
  }
  bit<16> tango_metrics_hdr_1;
  action labeledstmt_142(){
    tango_metrics_hdr_1=hdr.attach_signatures.attach_signatures_timestamp;
  }
  bit<8> tango_metrics_hdr_0;
  action labeledstmt_141(){
   
tango_metrics_hdr_0=((bit<8>)hdr.attach_signatures.attach_signatures_traffic_class);
  }
  bit<32> MetricSignatureManager_sign_ret;
  action labeledstmt_140(){
    MetricSignatureManager_sign_ret=32w32;
  }
  bit<3> path_id4836;
  action labeledstmt_139(){
   
path_id4836=((bit<3>)hdr.attach_signatures.attach_signatures_traffic_class);
  }
  bit<12> timestamp4835;
  action labeledstmt_138(){
   
timestamp4835=((bit<12>)hdr.attach_signatures.attach_signatures_timestamp);
  }
  bit<1> BookSignatureManager_sign_ret;
  action labeledstmt_137(){
    BookSignatureManager_sign_ret=1w0;
  }
  bit<3> path_id4832;
  action labeledstmt_136(){
   
path_id4832=((bit<3>)hdr.attach_signatures.attach_signatures_traffic_class);
  }
  action labeledstmt_135(){
    eg_dprsr_md.drop_ctl=3w1;
  }
  action labeledstmt_90(){
    labeledstmt_135();
    labeledstmt_136();
    labeledstmt_137();
    labeledstmt_138();
    labeledstmt_139();
    labeledstmt_140();
    labeledstmt_141();
    labeledstmt_142();
    labeledstmt_143();
    labeledstmt_144();
    labeledstmt_145();
    labeledstmt_146();
    labeledstmt_147();
    labeledstmt_148();
    labeledstmt_149();
    labeledstmt_150();
    labeledstmt_151();
    labeledstmt_152();
    labeledstmt_153();
    labeledstmt_154();
    labeledstmt_155();
    labeledstmt_156();
    labeledstmt_157();
    labeledstmt_158();
    labeledstmt_159();
    labeledstmt_160();
    labeledstmt_161();
    labeledstmt_162();
    labeledstmt_163();
    labeledstmt_164();
    labeledstmt_165();
    labeledstmt_166();
    labeledstmt_167();
    labeledstmt_168();
    labeledstmt_169();
    labeledstmt_170();
    labeledstmt_171();
    labeledstmt_172();
  }
  action labeledstmt_91(){
    //NOOP
  }
  bit<16> forward_tango_pkt_arg_18;
  action labeledstmt_175(){
    forward_tango_pkt_arg_18=tango_metrics_hdr_3;
  }
  bit<16> forward_tango_pkt_arg_16;
  action labeledstmt_174(){
    forward_tango_pkt_arg_16=tango_metrics_hdr_1;
  }
  bit<8> forward_tango_pkt_arg_15;
  action labeledstmt_173(){
    forward_tango_pkt_arg_15=tango_metrics_hdr_0;
  }
  action labeledstmt_92(){
    labeledstmt_173();
    labeledstmt_174();
    labeledstmt_175();
  }
  RegisterAction<bit<1>,bit<16>,bit<1>>(outgoing_book_signature_manager_7)
  outgoing_book_signature_manager_7_regaction_5729 = {
    void apply(inout bit<1> cell1_remote,
        out bit<1> ret_remote){
      bit<1> cell1_local=cell1_remote;
      bit<1> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_176(){
   
BookSignatureManager_sign_ret=outgoing_book_signature_manager_7_regaction_5729.execute(hdr.attach_signatures.attach_signatures_seq_number);
  }
  action labeledstmt_93(){
    labeledstmt_176();
    labeledstmt_173();
    labeledstmt_174();
    labeledstmt_175();
  }
  action labeledstmt_94(){
    //NOOP
  }
  action labeledstmt_95(){
    //NOOP
  }
  RegisterAction<bit<1>,bit<16>,bit<1>>(outgoing_book_signature_manager_6)
  outgoing_book_signature_manager_6_regaction_5730 = {
    void apply(inout bit<1> cell1_remote,
        out bit<1> ret_remote){
      bit<1> cell1_local=cell1_remote;
      bit<1> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_177(){
   
BookSignatureManager_sign_ret=outgoing_book_signature_manager_6_regaction_5730.execute(hdr.attach_signatures.attach_signatures_seq_number);
  }
  action labeledstmt_96(){
    labeledstmt_177();
  }
  action labeledstmt_97(){
    //NOOP
  }
  RegisterAction<bit<1>,bit<16>,bit<1>>(outgoing_book_signature_manager_5)
  outgoing_book_signature_manager_5_regaction_5731 = {
    void apply(inout bit<1> cell1_remote,
        out bit<1> ret_remote){
      bit<1> cell1_local=cell1_remote;
      bit<1> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_178(){
   
BookSignatureManager_sign_ret=outgoing_book_signature_manager_5_regaction_5731.execute(hdr.attach_signatures.attach_signatures_seq_number);
  }
  action labeledstmt_98(){
    labeledstmt_178();
  }
  action labeledstmt_99(){
    //NOOP
  }
  RegisterAction<bit<1>,bit<16>,bit<1>>(outgoing_book_signature_manager_4)
  outgoing_book_signature_manager_4_regaction_5732 = {
    void apply(inout bit<1> cell1_remote,
        out bit<1> ret_remote){
      bit<1> cell1_local=cell1_remote;
      bit<1> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_179(){
   
BookSignatureManager_sign_ret=outgoing_book_signature_manager_4_regaction_5732.execute(hdr.attach_signatures.attach_signatures_seq_number);
  }
  action labeledstmt_100(){
    labeledstmt_179();
  }
  action labeledstmt_101(){
    //NOOP
  }
  RegisterAction<bit<1>,bit<16>,bit<1>>(outgoing_book_signature_manager_3)
  outgoing_book_signature_manager_3_regaction_5733 = {
    void apply(inout bit<1> cell1_remote,
        out bit<1> ret_remote){
      bit<1> cell1_local=cell1_remote;
      bit<1> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_180(){
   
BookSignatureManager_sign_ret=outgoing_book_signature_manager_3_regaction_5733.execute(hdr.attach_signatures.attach_signatures_seq_number);
  }
  action labeledstmt_102(){
    labeledstmt_180();
  }
  action labeledstmt_103(){
    //NOOP
  }
  RegisterAction<bit<1>,bit<16>,bit<1>>(outgoing_book_signature_manager_2)
  outgoing_book_signature_manager_2_regaction_5734 = {
    void apply(inout bit<1> cell1_remote,
        out bit<1> ret_remote){
      bit<1> cell1_local=cell1_remote;
      bit<1> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_181(){
   
BookSignatureManager_sign_ret=outgoing_book_signature_manager_2_regaction_5734.execute(hdr.attach_signatures.attach_signatures_seq_number);
  }
  action labeledstmt_104(){
    labeledstmt_181();
  }
  action labeledstmt_105(){
    //NOOP
  }
  RegisterAction<bit<1>,bit<16>,bit<1>>(outgoing_book_signature_manager_1)
  outgoing_book_signature_manager_1_regaction_5735 = {
    void apply(inout bit<1> cell1_remote,
        out bit<1> ret_remote){
      bit<1> cell1_local=cell1_remote;
      bit<1> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_182(){
   
BookSignatureManager_sign_ret=outgoing_book_signature_manager_1_regaction_5735.execute(hdr.attach_signatures.attach_signatures_seq_number);
  }
  action labeledstmt_106(){
    labeledstmt_182();
  }
  RegisterAction<bit<1>,bit<16>,bit<1>>(outgoing_book_signature_manager_0)
  outgoing_book_signature_manager_0_regaction_5736 = {
    void apply(inout bit<1> cell1_remote,
        out bit<1> ret_remote){
      bit<1> cell1_local=cell1_remote;
      bit<1> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_183(){
   
BookSignatureManager_sign_ret=outgoing_book_signature_manager_0_regaction_5736.execute(hdr.attach_signatures.attach_signatures_seq_number);
  }
  action labeledstmt_107(){
    labeledstmt_183();
  }
  action labeledstmt_108(){
    //NOOP
  }
  bit<1> book_signature;
  action labeledstmt_185(){
    book_signature=BookSignatureManager_sign_ret;
  }
  action labeledstmt_184(){
    hdr.attach_signatures.setInvalid();
  }
  action labeledstmt_109(){
    labeledstmt_184();
    labeledstmt_185();
  }
  RegisterAction<bit<32>,bit<4>,bit<32>>(outgoing_metric_signature_manager_7)
  outgoing_metric_signature_manager_7_regaction_5737 = {
    void apply(inout bit<32> cell1_remote,
        out bit<32> ret_remote){
      bit<32> cell1_local=cell1_remote;
      bit<32> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_186(){
   
MetricSignatureManager_sign_ret=outgoing_metric_signature_manager_7_regaction_5737.execute((timestamp4835[3:0]));
  }
  action labeledstmt_110(){
    labeledstmt_186();
    labeledstmt_184();
    labeledstmt_185();
  }
  action labeledstmt_111(){
    //NOOP
  }
  action labeledstmt_112(){
    //NOOP
  }
  RegisterAction<bit<32>,bit<4>,bit<32>>(outgoing_metric_signature_manager_6)
  outgoing_metric_signature_manager_6_regaction_5738 = {
    void apply(inout bit<32> cell1_remote,
        out bit<32> ret_remote){
      bit<32> cell1_local=cell1_remote;
      bit<32> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_187(){
   
MetricSignatureManager_sign_ret=outgoing_metric_signature_manager_6_regaction_5738.execute((timestamp4835[3:0]));
  }
  action labeledstmt_113(){
    labeledstmt_187();
  }
  action labeledstmt_114(){
    //NOOP
  }
  RegisterAction<bit<32>,bit<4>,bit<32>>(outgoing_metric_signature_manager_5)
  outgoing_metric_signature_manager_5_regaction_5739 = {
    void apply(inout bit<32> cell1_remote,
        out bit<32> ret_remote){
      bit<32> cell1_local=cell1_remote;
      bit<32> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_188(){
   
MetricSignatureManager_sign_ret=outgoing_metric_signature_manager_5_regaction_5739.execute((timestamp4835[3:0]));
  }
  action labeledstmt_115(){
    labeledstmt_188();
  }
  action labeledstmt_116(){
    //NOOP
  }
  RegisterAction<bit<32>,bit<4>,bit<32>>(outgoing_metric_signature_manager_4)
  outgoing_metric_signature_manager_4_regaction_5740 = {
    void apply(inout bit<32> cell1_remote,
        out bit<32> ret_remote){
      bit<32> cell1_local=cell1_remote;
      bit<32> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_189(){
   
MetricSignatureManager_sign_ret=outgoing_metric_signature_manager_4_regaction_5740.execute((timestamp4835[3:0]));
  }
  action labeledstmt_117(){
    labeledstmt_189();
  }
  bit<8> tango_metrics_hdr_4;
  action labeledstmt_190(){
    tango_metrics_hdr_4=((bit<8>)book_signature);
  }
  action labeledstmt_118(){
    labeledstmt_190();
  }
  RegisterAction<bit<32>,bit<4>,bit<32>>(outgoing_metric_signature_manager_3)
  outgoing_metric_signature_manager_3_regaction_5741 = {
    void apply(inout bit<32> cell1_remote,
        out bit<32> ret_remote){
      bit<32> cell1_local=cell1_remote;
      bit<32> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_191(){
   
MetricSignatureManager_sign_ret=outgoing_metric_signature_manager_3_regaction_5741.execute((timestamp4835[3:0]));
  }
  action labeledstmt_119(){
    labeledstmt_191();
    labeledstmt_190();
  }
  action labeledstmt_120(){
    //NOOP
  }
  action labeledstmt_121(){
    //NOOP
  }
  RegisterAction<bit<32>,bit<4>,bit<32>>(outgoing_metric_signature_manager_2)
  outgoing_metric_signature_manager_2_regaction_5742 = {
    void apply(inout bit<32> cell1_remote,
        out bit<32> ret_remote){
      bit<32> cell1_local=cell1_remote;
      bit<32> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_192(){
   
MetricSignatureManager_sign_ret=outgoing_metric_signature_manager_2_regaction_5742.execute((timestamp4835[3:0]));
  }
  action labeledstmt_122(){
    labeledstmt_192();
  }
  action labeledstmt_123(){
    //NOOP
  }
  RegisterAction<bit<32>,bit<4>,bit<32>>(outgoing_metric_signature_manager_1)
  outgoing_metric_signature_manager_1_regaction_5743 = {
    void apply(inout bit<32> cell1_remote,
        out bit<32> ret_remote){
      bit<32> cell1_local=cell1_remote;
      bit<32> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_193(){
   
MetricSignatureManager_sign_ret=outgoing_metric_signature_manager_1_regaction_5743.execute((timestamp4835[3:0]));
  }
  action labeledstmt_124(){
    labeledstmt_193();
  }
  RegisterAction<bit<32>,bit<4>,bit<32>>(outgoing_metric_signature_manager_0)
  outgoing_metric_signature_manager_0_regaction_5744 = {
    void apply(inout bit<32> cell1_remote,
        out bit<32> ret_remote){
      bit<32> cell1_local=cell1_remote;
      bit<32> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_194(){
   
MetricSignatureManager_sign_ret=outgoing_metric_signature_manager_0_regaction_5744.execute((timestamp4835[3:0]));
  }
  action labeledstmt_125(){
    labeledstmt_194();
  }
  action labeledstmt_126(){
    //NOOP
  }
  bit<8> forward_tango_pkt_arg_19;
  action labeledstmt_196(){
    forward_tango_pkt_arg_19=tango_metrics_hdr_4;
  }
  bit<32> ts_signature;
  action labeledstmt_195(){
    ts_signature=MetricSignatureManager_sign_ret;
  }
  action labeledstmt_127(){
    labeledstmt_195();
    labeledstmt_196();
  }
  action labeledstmt_128(){
    //NOOP
  }
  bit<32> tango_metrics_hdr_2;
  action labeledstmt_197(){
    tango_metrics_hdr_2=ts_signature;
  }
  action labeledstmt_129(){
    labeledstmt_197();
  }
  action labeledstmt_130(){
    //NOOP
  }
  bit<32> forward_tango_pkt_arg_17;
  action labeledstmt_198(){
    forward_tango_pkt_arg_17=tango_metrics_hdr_2;
  }
  action labeledstmt_131(){
    labeledstmt_198();
  }
  action labeledstmt_132(){
    //NOOP
  }
  action labeledstmt_133(){
    eg_dprsr_md.drop_ctl=0;
    hdr.incoming_tango_traffic.setValid();
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_eth_header_0=forward_tango_pkt_arg_0;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_eth_header_1=forward_tango_pkt_arg_1;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_eth_header_2=forward_tango_pkt_arg_2;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_0=forward_tango_pkt_arg_3;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_1=forward_tango_pkt_arg_4;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_2=forward_tango_pkt_arg_5;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_3=forward_tango_pkt_arg_6;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_4=forward_tango_pkt_arg_7;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_5=forward_tango_pkt_arg_8;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_6=forward_tango_pkt_arg_9;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_7=forward_tango_pkt_arg_10;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_udp_header_0=forward_tango_pkt_arg_11;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_udp_header_1=forward_tango_pkt_arg_12;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_udp_header_2=forward_tango_pkt_arg_13;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_udp_header_3=forward_tango_pkt_arg_14;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_metrics_header_0=forward_tango_pkt_arg_15;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_metrics_header_1=forward_tango_pkt_arg_16;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_metrics_header_2=forward_tango_pkt_arg_17;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_metrics_header_3=forward_tango_pkt_arg_18;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_metrics_header_4=forward_tango_pkt_arg_19;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_0=forward_tango_pkt_arg_20;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_1=forward_tango_pkt_arg_21;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_2=forward_tango_pkt_arg_22;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_3=forward_tango_pkt_arg_23;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_4=forward_tango_pkt_arg_24;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_5=forward_tango_pkt_arg_25;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_6=forward_tango_pkt_arg_26;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_7=forward_tango_pkt_arg_27;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_8=forward_tango_pkt_arg_28;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_9=forward_tango_pkt_arg_29;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_udp_header_0=forward_tango_pkt_arg_30;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_udp_header_1=forward_tango_pkt_arg_31;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_udp_header_2=forward_tango_pkt_arg_32;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_udp_header_3=forward_tango_pkt_arg_33;
  }
  action labeledstmt_134(){
    //NOOP
  }
  table table_5765 {
    key = {
      meta.egress_event_id : ternary;
    }
    actions = {
      labeledstmt_90;
      labeledstmt_91;
    }
    const entries = {
      (2) : labeledstmt_90();
      (_) : labeledstmt_91();
    } 
  } 
  @ignore_table_dependency("EgressControl.table_5762")
  @ignore_table_dependency("EgressControl.table_5763")
  @ignore_table_dependency("EgressControl.table_5764")table table_5761 {
    key = {
      path_id4832 : ternary;
      meta.egress_event_id : ternary;
      path_id4836 : ternary;
    }
    actions = {
      labeledstmt_92;
      labeledstmt_93;
      labeledstmt_94;
    }
    const entries = {
      (0,2,0) : labeledstmt_92();
      (1,2,0) : labeledstmt_92();
      (2,2,0) : labeledstmt_92();
      (3,2,0) : labeledstmt_92();
      (4,2,0) : labeledstmt_92();
      (5,2,0) : labeledstmt_92();
      (6,2,0) : labeledstmt_92();
      (7,2,0) : labeledstmt_93();
      (_,2,0) : labeledstmt_92();
      (0,2,1) : labeledstmt_92();
      (1,2,1) : labeledstmt_92();
      (2,2,1) : labeledstmt_92();
      (3,2,1) : labeledstmt_92();
      (4,2,1) : labeledstmt_92();
      (5,2,1) : labeledstmt_92();
      (6,2,1) : labeledstmt_92();
      (7,2,1) : labeledstmt_93();
      (_,2,1) : labeledstmt_92();
      (0,2,2) : labeledstmt_92();
      (1,2,2) : labeledstmt_92();
      (2,2,2) : labeledstmt_92();
      (3,2,2) : labeledstmt_92();
      (4,2,2) : labeledstmt_92();
      (5,2,2) : labeledstmt_92();
      (6,2,2) : labeledstmt_92();
      (7,2,2) : labeledstmt_93();
      (_,2,2) : labeledstmt_92();
      (0,2,3) : labeledstmt_92();
      (1,2,3) : labeledstmt_92();
      (2,2,3) : labeledstmt_92();
      (3,2,3) : labeledstmt_92();
      (4,2,3) : labeledstmt_92();
      (5,2,3) : labeledstmt_92();
      (6,2,3) : labeledstmt_92();
      (7,2,3) : labeledstmt_93();
      (_,2,3) : labeledstmt_92();
      (0,2,4) : labeledstmt_92();
      (1,2,4) : labeledstmt_92();
      (2,2,4) : labeledstmt_92();
      (3,2,4) : labeledstmt_92();
      (4,2,4) : labeledstmt_92();
      (5,2,4) : labeledstmt_92();
      (6,2,4) : labeledstmt_92();
      (7,2,4) : labeledstmt_93();
      (_,2,4) : labeledstmt_92();
      (0,2,5) : labeledstmt_92();
      (1,2,5) : labeledstmt_92();
      (2,2,5) : labeledstmt_92();
      (3,2,5) : labeledstmt_92();
      (4,2,5) : labeledstmt_92();
      (5,2,5) : labeledstmt_92();
      (6,2,5) : labeledstmt_92();
      (7,2,5) : labeledstmt_93();
      (_,2,5) : labeledstmt_92();
      (0,2,6) : labeledstmt_92();
      (1,2,6) : labeledstmt_92();
      (2,2,6) : labeledstmt_92();
      (3,2,6) : labeledstmt_92();
      (4,2,6) : labeledstmt_92();
      (5,2,6) : labeledstmt_92();
      (6,2,6) : labeledstmt_92();
      (7,2,6) : labeledstmt_93();
      (_,2,6) : labeledstmt_92();
      (0,2,7) : labeledstmt_92();
      (1,2,7) : labeledstmt_92();
      (2,2,7) : labeledstmt_92();
      (3,2,7) : labeledstmt_92();
      (4,2,7) : labeledstmt_92();
      (5,2,7) : labeledstmt_92();
      (6,2,7) : labeledstmt_92();
      (7,2,7) : labeledstmt_93();
      (_,2,7) : labeledstmt_92();
      (0,2,_) : labeledstmt_92();
      (1,2,_) : labeledstmt_92();
      (2,2,_) : labeledstmt_92();
      (3,2,_) : labeledstmt_92();
      (4,2,_) : labeledstmt_92();
      (5,2,_) : labeledstmt_92();
      (6,2,_) : labeledstmt_92();
      (7,2,_) : labeledstmt_93();
      (_,2,_) : labeledstmt_92();
      (_,_,_) : labeledstmt_94();
    } 
  } 
  @ignore_table_dependency("EgressControl.table_5761")
  @ignore_table_dependency("EgressControl.table_5763")
  @ignore_table_dependency("EgressControl.table_5764")table table_5762 {
    key = {
      path_id4832 : ternary;
      meta.egress_event_id : ternary;
    }
    actions = {
      labeledstmt_95;
      labeledstmt_96;
    }
    const entries = {
      (0,2) : labeledstmt_95();
      (1,2) : labeledstmt_95();
      (2,2) : labeledstmt_95();
      (3,2) : labeledstmt_95();
      (4,2) : labeledstmt_95();
      (5,2) : labeledstmt_95();
      (6,2) : labeledstmt_96();
      (_,_) : labeledstmt_95();
    } 
  } 
  @ignore_table_dependency("EgressControl.table_5761")
  @ignore_table_dependency("EgressControl.table_5762")
  @ignore_table_dependency("EgressControl.table_5764")table table_5763 {
    key = {
      path_id4832 : ternary;
      meta.egress_event_id : ternary;
    }
    actions = {
      labeledstmt_97;
      labeledstmt_98;
    }
    const entries = {
      (0,2) : labeledstmt_97();
      (1,2) : labeledstmt_97();
      (2,2) : labeledstmt_97();
      (3,2) : labeledstmt_97();
      (4,2) : labeledstmt_97();
      (5,2) : labeledstmt_98();
      (_,_) : labeledstmt_97();
    } 
  } 
  @ignore_table_dependency("EgressControl.table_5761")
  @ignore_table_dependency("EgressControl.table_5762")
  @ignore_table_dependency("EgressControl.table_5763")table table_5764 {
    key = {
      path_id4832 : ternary;
      meta.egress_event_id : ternary;
    }
    actions = {
      labeledstmt_99;
      labeledstmt_100;
    }
    const entries = {
      (0,2) : labeledstmt_99();
      (1,2) : labeledstmt_99();
      (2,2) : labeledstmt_99();
      (3,2) : labeledstmt_99();
      (4,2) : labeledstmt_100();
      (_,_) : labeledstmt_99();
    } 
  } 
  @ignore_table_dependency("EgressControl.table_5758")
  @ignore_table_dependency("EgressControl.table_5759")
  @ignore_table_dependency("EgressControl.table_5760")table table_5757 {
    key = {
      path_id4832 : ternary;
      meta.egress_event_id : ternary;
    }
    actions = {
      labeledstmt_101;
      labeledstmt_102;
    }
    const entries = {
      (0,2) : labeledstmt_101();
      (1,2) : labeledstmt_101();
      (2,2) : labeledstmt_101();
      (3,2) : labeledstmt_102();
      (_,_) : labeledstmt_101();
    } 
  } 
  @ignore_table_dependency("EgressControl.table_5757")
  @ignore_table_dependency("EgressControl.table_5759")
  @ignore_table_dependency("EgressControl.table_5760")table table_5758 {
    key = {
      path_id4832 : ternary;
      meta.egress_event_id : ternary;
    }
    actions = {
      labeledstmt_103;
      labeledstmt_104;
    }
    const entries = {
      (0,2) : labeledstmt_103();
      (1,2) : labeledstmt_103();
      (2,2) : labeledstmt_104();
      (_,_) : labeledstmt_103();
    } 
  } 
  @ignore_table_dependency("EgressControl.table_5757")
  @ignore_table_dependency("EgressControl.table_5758")
  @ignore_table_dependency("EgressControl.table_5760")table table_5759 {
    key = {
      path_id4832 : ternary;
      meta.egress_event_id : ternary;
    }
    actions = {
      labeledstmt_105;
      labeledstmt_106;
    }
    const entries = {
      (0,2) : labeledstmt_105();
      (1,2) : labeledstmt_106();
      (_,_) : labeledstmt_105();
    } 
  } 
  @ignore_table_dependency("EgressControl.table_5757")
  @ignore_table_dependency("EgressControl.table_5758")
  @ignore_table_dependency("EgressControl.table_5759")table table_5760 {
    key = {
      path_id4832 : ternary;
      meta.egress_event_id : ternary;
    }
    actions = {
      labeledstmt_107;
      labeledstmt_108;
    }
    const entries = {
      (0,2) : labeledstmt_107();
      (_,_) : labeledstmt_108();
    } 
  } 
  @ignore_table_dependency("EgressControl.table_5754")
  @ignore_table_dependency("EgressControl.table_5755")
  @ignore_table_dependency("EgressControl.table_5756")table table_5753 {
    key = {
      path_id4836 : ternary;
      meta.egress_event_id : ternary;
    }
    actions = {
      labeledstmt_109;
      labeledstmt_110;
      labeledstmt_111;
    }
    const entries = {
      (0,2) : labeledstmt_109();
      (1,2) : labeledstmt_109();
      (2,2) : labeledstmt_109();
      (3,2) : labeledstmt_109();
      (4,2) : labeledstmt_109();
      (5,2) : labeledstmt_109();
      (6,2) : labeledstmt_109();
      (7,2) : labeledstmt_110();
      (_,2) : labeledstmt_109();
      (_,_) : labeledstmt_111();
    } 
  } 
  @ignore_table_dependency("EgressControl.table_5753")
  @ignore_table_dependency("EgressControl.table_5755")
  @ignore_table_dependency("EgressControl.table_5756")table table_5754 {
    key = {
      path_id4836 : ternary;
      meta.egress_event_id : ternary;
    }
    actions = {
      labeledstmt_112;
      labeledstmt_113;
    }
    const entries = {
      (0,2) : labeledstmt_112();
      (1,2) : labeledstmt_112();
      (2,2) : labeledstmt_112();
      (3,2) : labeledstmt_112();
      (4,2) : labeledstmt_112();
      (5,2) : labeledstmt_112();
      (6,2) : labeledstmt_113();
      (_,_) : labeledstmt_112();
    } 
  } 
  @ignore_table_dependency("EgressControl.table_5753")
  @ignore_table_dependency("EgressControl.table_5754")
  @ignore_table_dependency("EgressControl.table_5756")table table_5755 {
    key = {
      path_id4836 : ternary;
      meta.egress_event_id : ternary;
    }
    actions = {
      labeledstmt_114;
      labeledstmt_115;
    }
    const entries = {
      (0,2) : labeledstmt_114();
      (1,2) : labeledstmt_114();
      (2,2) : labeledstmt_114();
      (3,2) : labeledstmt_114();
      (4,2) : labeledstmt_114();
      (5,2) : labeledstmt_115();
      (_,_) : labeledstmt_114();
    } 
  } 
  @ignore_table_dependency("EgressControl.table_5753")
  @ignore_table_dependency("EgressControl.table_5754")
  @ignore_table_dependency("EgressControl.table_5755")table table_5756 {
    key = {
      path_id4836 : ternary;
      meta.egress_event_id : ternary;
    }
    actions = {
      labeledstmt_116;
      labeledstmt_117;
    }
    const entries = {
      (0,2) : labeledstmt_116();
      (1,2) : labeledstmt_116();
      (2,2) : labeledstmt_116();
      (3,2) : labeledstmt_116();
      (4,2) : labeledstmt_117();
      (_,_) : labeledstmt_116();
    } 
  } 
  @ignore_table_dependency("EgressControl.table_5750")
  @ignore_table_dependency("EgressControl.table_5751")
  @ignore_table_dependency("EgressControl.table_5752")table table_5749 {
    key = {
      path_id4836 : ternary;
      meta.egress_event_id : ternary;
    }
    actions = {
      labeledstmt_118;
      labeledstmt_119;
      labeledstmt_120;
    }
    const entries = {
      (0,2) : labeledstmt_118();
      (1,2) : labeledstmt_118();
      (2,2) : labeledstmt_118();
      (3,2) : labeledstmt_119();
      (_,2) : labeledstmt_118();
      (_,_) : labeledstmt_120();
    } 
  } 
  @ignore_table_dependency("EgressControl.table_5749")
  @ignore_table_dependency("EgressControl.table_5751")
  @ignore_table_dependency("EgressControl.table_5752")table table_5750 {
    key = {
      path_id4836 : ternary;
      meta.egress_event_id : ternary;
    }
    actions = {
      labeledstmt_121;
      labeledstmt_122;
    }
    const entries = {
      (0,2) : labeledstmt_121();
      (1,2) : labeledstmt_121();
      (2,2) : labeledstmt_122();
      (_,_) : labeledstmt_121();
    } 
  } 
  @ignore_table_dependency("EgressControl.table_5749")
  @ignore_table_dependency("EgressControl.table_5750")
  @ignore_table_dependency("EgressControl.table_5752")table table_5751 {
    key = {
      path_id4836 : ternary;
      meta.egress_event_id : ternary;
    }
    actions = {
      labeledstmt_123;
      labeledstmt_124;
    }
    const entries = {
      (0,2) : labeledstmt_123();
      (1,2) : labeledstmt_124();
      (_,_) : labeledstmt_123();
    } 
  } 
  @ignore_table_dependency("EgressControl.table_5749")
  @ignore_table_dependency("EgressControl.table_5750")
  @ignore_table_dependency("EgressControl.table_5751")table table_5752 {
    key = {
      path_id4836 : ternary;
      meta.egress_event_id : ternary;
    }
    actions = {
      labeledstmt_125;
      labeledstmt_126;
    }
    const entries = {
      (0,2) : labeledstmt_125();
      (_,_) : labeledstmt_126();
    } 
  } 
  table table_5748 {
    key = {
      meta.egress_event_id : ternary;
    }
    actions = {
      labeledstmt_127;
      labeledstmt_128;
    }
    const entries = {
      (2) : labeledstmt_127();
      (_) : labeledstmt_128();
    } 
  } 
  table table_5747 {
    key = {
      meta.egress_event_id : ternary;
    }
    actions = {
      labeledstmt_129;
      labeledstmt_130;
    }
    const entries = {
      (2) : labeledstmt_129();
      (_) : labeledstmt_130();
    } 
  } 
  table table_5746 {
    key = {
      meta.egress_event_id : ternary;
    }
    actions = {
      labeledstmt_131;
      labeledstmt_132;
    }
    const entries = {
      (2) : labeledstmt_131();
      (_) : labeledstmt_132();
    } 
  } 
  table table_5745 {
    key = {
      meta.egress_event_id : ternary;
    }
    actions = {
      labeledstmt_133;
      labeledstmt_134;
    }
    const entries = {
      (2) : labeledstmt_133();
      (_) : labeledstmt_134();
    } 
  } 
  apply {
    eg_dprsr_md.drop_ctl=0;
    if ((eg_intr_md.egress_rid==0)){
      t_extract_port_event.apply();
    } else {
      t_extract_recirc_event.apply();
    }
    table_5765.apply();
    table_5761.apply();
    table_5762.apply();
    table_5763.apply();
    table_5764.apply();
    table_5757.apply();
    table_5758.apply();
    table_5759.apply();
    table_5760.apply();
    table_5753.apply();
    table_5754.apply();
    table_5755.apply();
    table_5756.apply();
    table_5749.apply();
    table_5750.apply();
    table_5751.apply();
    table_5752.apply();
    table_5748.apply();
    table_5747.apply();
    table_5746.apply();
    table_5745.apply();
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
