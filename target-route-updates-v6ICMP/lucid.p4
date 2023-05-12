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
  bit<5> flag_pad_3347;
  bit<1> update_route;
  bit<1> incoming_tango_traffic;
  bit<1> forward_flow;
}
header update_route_t {
  bit<48> update_route_eth_header_0;
  bit<48> update_route_eth_header_1;
  bit<16> update_route_eth_header_2;
  bit<32> update_route_ip_header_0;
  bit<16> update_route_ip_header_1;
  bit<8> update_route_ip_header_2;
  bit<8> update_route_ip_header_3;
  bit<64> update_route_ip_header_4;
  bit<64> update_route_ip_header_5;
  bit<64> update_route_ip_header_6;
  bit<64> update_route_ip_header_7;
  bit<8> update_route_icmp_header_0;
  bit<8> update_route_icmp_header_1;
  bit<16> update_route_icmp_header_2;
  bit<16> update_route_icmp_header_3;
  bit<16> update_route_icmp_header_4;
  bit<8> update_route_update_0;
  bit<8> update_route_update_1;
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
  bit<8> incoming_tango_traffic_tango_icmp_header_0;
  bit<8> incoming_tango_traffic_tango_icmp_header_1;
  bit<16> incoming_tango_traffic_tango_icmp_header_2;
  bit<16> incoming_tango_traffic_tango_icmp_header_3;
  bit<16> incoming_tango_traffic_tango_icmp_header_4;
  bit<8> incoming_tango_traffic_tango_metrics_header_0;
  bit<16> incoming_tango_traffic_tango_metrics_header_1;
  bit<32> incoming_tango_traffic_tango_metrics_header_2;
  bit<16> incoming_tango_traffic_tango_metrics_header_3;
  bit<8> incoming_tango_traffic_tango_metrics_header_4;
  bit<32> incoming_tango_traffic_encaped_ip_header_0;
  bit<16> incoming_tango_traffic_encaped_ip_header_1;
  bit<8> incoming_tango_traffic_encaped_ip_header_2;
  bit<8> incoming_tango_traffic_encaped_ip_header_3;
  bit<64> incoming_tango_traffic_encaped_ip_header_4;
  bit<64> incoming_tango_traffic_encaped_ip_header_5;
  bit<64> incoming_tango_traffic_encaped_ip_header_6;
  bit<64> incoming_tango_traffic_encaped_ip_header_7;
  bit<16> incoming_tango_traffic_encaped_dup_header_0;
  bit<16> incoming_tango_traffic_encaped_dup_header_1;
  bit<16> incoming_tango_traffic_encaped_dup_header_2;
  bit<16> incoming_tango_traffic_encaped_dup_header_3;
}
header forward_flow_t {
  bit<48> forward_flow_eth_header_0;
  bit<48> forward_flow_eth_header_1;
  bit<16> forward_flow_eth_header_2;
  bit<32> forward_flow_ip_header_0;
  bit<16> forward_flow_ip_header_1;
  bit<8> forward_flow_ip_header_2;
  bit<8> forward_flow_ip_header_3;
  bit<64> forward_flow_ip_header_4;
  bit<64> forward_flow_ip_header_5;
  bit<64> forward_flow_ip_header_6;
  bit<64> forward_flow_ip_header_7;
  bit<16> forward_flow_udp_header_0;
  bit<16> forward_flow_udp_header_1;
  bit<16> forward_flow_udp_header_2;
  bit<16> forward_flow_udp_header_3;
}
struct hdr_t {
  lucid_eth_t lucid_eth;
  wire_ev_t wire_ev;
  bridge_ev_t bridge_ev;
  update_route_t update_route;
  incoming_tango_traffic_t incoming_tango_traffic;
  forward_flow_t forward_flow;
}
struct meta_t {
  bit<8> egress_event_id;
}
Register<bit<8>,_>(32w32) route_manager_0;
Register<bit<16>,_>(32w32) sequence_counters_0;
//Main program components (ingress/egress parser, control, deparser)
parser IngressParser(packet_in pkt,
    out hdr_t hdr,
    out meta_t meta,
    out ingress_intrinsic_metadata_t ig_intr_md){
  state start {
    pkt.extract(ig_intr_md);
    pkt.advance(64);
    transition select(ig_intr_md.ingress_port){
      (264) : port_264_default_update_route;
      (68) : parse_lucid_eth;
      (_) : default_setup;
    }
  }
  state default_setup {
    hdr.wire_ev.setValid();
    hdr.wire_ev.event_id=1;
    hdr.bridge_ev.setValid();
    hdr.bridge_ev.port_event_id=0;
    hdr.bridge_ev.update_route=0;
    hdr.bridge_ev.incoming_tango_traffic=0;
    hdr.bridge_ev.forward_flow=0;
    transition parse_forward_flow;
  }
  state parse_lucid_eth {
    pkt.advance(112);
    transition parse_wire_ev;
  }
  state parse_wire_ev {
    pkt.extract(hdr.wire_ev);
    pkt.extract(hdr.bridge_ev);
    transition select(hdr.wire_ev.event_id){
      (255) : parse_all_events;
      (3) : parse_update_route;
      (2) : parse_incoming_tango_traffic;
      (1) : parse_forward_flow;
    }
  }
  state port_264_default_update_route {
    hdr.wire_ev.setValid();
    hdr.bridge_ev.setValid();
    hdr.wire_ev.event_id=3;
    hdr.bridge_ev.update_route=0;
    hdr.bridge_ev.incoming_tango_traffic=0;
    hdr.bridge_ev.forward_flow=0;
    transition parse_update_route;
  }
  state parse_update_route {
    pkt.extract(hdr.update_route);
    transition accept;
  }
  state parse_incoming_tango_traffic {
    pkt.extract(hdr.incoming_tango_traffic);
    transition accept;
  }
  state parse_forward_flow {
    pkt.extract(hdr.forward_flow);
    transition accept;
  }
  state parse_all_events {
    pkt.extract(hdr.update_route);
    pkt.extract(hdr.incoming_tango_traffic);
    pkt.extract(hdr.forward_flow);
    transition accept;
  }
}
control IngressControl(inout hdr_t hdr,
    inout meta_t meta,
    in ingress_intrinsic_metadata_t ig_intr_md,
    in ingress_intrinsic_metadata_from_parser_t ig_prsr_md,
    inout ingress_intrinsic_metadata_for_deparser_t ig_dprsr_md,
    inout ingress_intrinsic_metadata_for_tm_t ig_tm_md){
  bit<8> route_manager_0_idx_3333;
  action labeledstmt_42(){
    hdr.incoming_tango_traffic.setInvalid();
  }
  action labeledstmt_1(){
    labeledstmt_42();
  }
  bit<64> tango_tunnel_hdr_7;
  action labeledstmt_52(){
    tango_tunnel_hdr_7=64w0;
  }
  bit<64> tango_tunnel_hdr_6;
  action labeledstmt_51(){
    tango_tunnel_hdr_6=64w0;
  }
  bit<64> tango_tunnel_hdr_5;
  action labeledstmt_50(){
    tango_tunnel_hdr_5=64w3252;
  }
  bit<64> tango_tunnel_hdr_4;
  action labeledstmt_49(){
    tango_tunnel_hdr_4=64w2747196614509592830;
  }
  bit<8> tango_tunnel_hdr_3;
  action labeledstmt_48(){
    tango_tunnel_hdr_3=8w220;
  }
  bit<8> tango_tunnel_hdr_2;
  action labeledstmt_47(){
    tango_tunnel_hdr_2=8w58;
  }
  bit<16> tango_tunnel_hdr_1;
  action labeledstmt_46(){
    tango_tunnel_hdr_1=16w0;
  }
  bit<32> tango_tunnel_hdr_0;
  action labeledstmt_45(){
    tango_tunnel_hdr_0=32w1610612736;
  }
  bit<8> RouteManager_get_path_id_ret;
  action labeledstmt_44(){
    RouteManager_get_path_id_ret=8w32;
  }
  bit<8> traffic_class;
  action labeledstmt_43(){
    traffic_class=8w0;
  }
  action labeledstmt_2(){
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
  }
  action labeledstmt_53(){
    route_manager_0_idx_3333=hdr.update_route.update_route_update_0;
  }
  action labeledstmt_3(){
    labeledstmt_53();
  }
  action labeledstmt_4(){
    //NOOP
  }
  action labeledstmt_5(){
    //NOOP
  }
  action labeledstmt_54(){
    traffic_class=8w0;
  }
  action labeledstmt_6(){
    labeledstmt_54();
  }
  action labeledstmt_55(){
    traffic_class=8w1;
  }
  action labeledstmt_7(){
    labeledstmt_55();
  }
  action labeledstmt_56(){
    traffic_class=8w2;
  }
  action labeledstmt_8(){
    labeledstmt_56();
  }
  action labeledstmt_57(){
    traffic_class=8w3;
  }
  action labeledstmt_9(){
    labeledstmt_57();
  }
  action labeledstmt_58(){
    traffic_class=8w4;
  }
  action labeledstmt_10(){
    labeledstmt_58();
  }
  action labeledstmt_59(){
    traffic_class=8w5;
  }
  action labeledstmt_11(){
    labeledstmt_59();
  }
  action labeledstmt_60(){
    traffic_class=8w6;
  }
  action labeledstmt_12(){
    labeledstmt_60();
  }
  action labeledstmt_61(){
    traffic_class=8w7;
  }
  action labeledstmt_13(){
    labeledstmt_61();
  }
  action labeledstmt_62(){
    traffic_class=8w8;
  }
  action labeledstmt_14(){
    labeledstmt_62();
  }
  action labeledstmt_63(){
    traffic_class=8w9;
  }
  action labeledstmt_15(){
    labeledstmt_63();
  }
  action labeledstmt_64(){
    traffic_class=8w10;
  }
  action labeledstmt_16(){
    labeledstmt_64();
  }
  action labeledstmt_65(){
    traffic_class=8w11;
  }
  action labeledstmt_17(){
    labeledstmt_65();
  }
  action labeledstmt_66(){
    traffic_class=8w12;
  }
  action labeledstmt_18(){
    labeledstmt_66();
  }
  action labeledstmt_67(){
    traffic_class=8w13;
  }
  action labeledstmt_19(){
    labeledstmt_67();
  }
  action labeledstmt_68(){
    traffic_class=8w14;
  }
  action labeledstmt_20(){
    labeledstmt_68();
  }
  action labeledstmt_69(){
    traffic_class=8w15;
  }
  action labeledstmt_21(){
    labeledstmt_69();
  }
  action labeledstmt_70(){
    traffic_class=8w30;
  }
  action labeledstmt_22(){
    labeledstmt_70();
  }
  action labeledstmt_71(){
    traffic_class=8w31;
  }
  action labeledstmt_23(){
    labeledstmt_71();
  }
  action labeledstmt_24(){
    //NOOP
  }
  action labeledstmt_72(){
    route_manager_0_idx_3333=traffic_class;
  }
  action labeledstmt_25(){
    labeledstmt_72();
  }
  action labeledstmt_26(){
    //NOOP
  }
  RegisterAction<bit<8>,bit<8>,bit<8>>(route_manager_0)
  route_manager_0_regaction_3334 = {
    void apply(inout bit<8> cell1_remote,
        out bit<8> ret_remote){
      bit<8> cell1_local=cell1_remote;
      bit<8> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_73(){
   
RouteManager_get_path_id_ret=route_manager_0_regaction_3334.execute(route_manager_0_idx_3333);
  }
  action labeledstmt_27(){
    labeledstmt_73();
  }
  RegisterAction<bit<8>,bit<8>,bit<8>>(route_manager_0)
  route_manager_0_regaction_3335 = {
    void apply(inout bit<8> cell1_remote,
        out bit<8> ret_remote){
      bit<8> cell1_local=cell1_remote;
      bit<8> cell2_local=0;
      if(true){
        cell1_remote=hdr.update_route.update_route_update_1;
      }
      //NOOP
    }
  };
  action labeledstmt_74(){
    route_manager_0_regaction_3335.execute(route_manager_0_idx_3333);
  }
  action labeledstmt_28(){
    labeledstmt_74();
  }
  action labeledstmt_29(){
    //NOOP
  }
  bit<8> path_id;
  action labeledstmt_75(){
    path_id=RouteManager_get_path_id_ret;
  }
  action labeledstmt_30(){
    labeledstmt_75();
  }
  action labeledstmt_76(){
    hdr.update_route.setInvalid();
  }
  action labeledstmt_31(){
    labeledstmt_76();
  }
  action labeledstmt_32(){
    //NOOP
  }
  action labeledstmt_86(){
    tango_tunnel_hdr_0=32w1610612736;
  }
  action labeledstmt_85(){
    tango_tunnel_hdr_1=hdr.forward_flow.forward_flow_ip_header_1;
  }
  action labeledstmt_84(){
    tango_tunnel_hdr_2=8w58;
  }
  action labeledstmt_83(){
    tango_tunnel_hdr_3=8w220;
  }
  action labeledstmt_82(){
    tango_tunnel_hdr_4=64w2747196614509592830;
  }
  action labeledstmt_81(){
    tango_tunnel_hdr_5=64w3252;
  }
  action labeledstmt_80(){
    tango_tunnel_hdr_6=64w2739390614537633792;
  }
  action labeledstmt_79(){
    tango_tunnel_hdr_7=64w77;
  }
  bit<16> SequenceNumberManager_increment_ret;
  action labeledstmt_78(){
    SequenceNumberManager_increment_ret=16w32;
  }
  bit<32> time_now;
  action labeledstmt_77(){
    time_now=(ig_intr_md.ingress_mac_tstamp[47:16]);
  }
  action labeledstmt_33(){
    labeledstmt_77();
    labeledstmt_78();
    labeledstmt_79();
    labeledstmt_80();
    labeledstmt_81();
    labeledstmt_82();
    labeledstmt_83();
    labeledstmt_84();
    labeledstmt_85();
    labeledstmt_86();
  }
  action labeledstmt_34(){
    //NOOP
  }
  RegisterAction<bit<16>,bit<8>,bit<16>>(sequence_counters_0)
  sequence_counters_0_regaction_3336 = {
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
  action labeledstmt_88(){
   
SequenceNumberManager_increment_ret=sequence_counters_0_regaction_3336.execute(path_id);
  }
  bit<12> timestamp;
  action labeledstmt_87(){
    timestamp=(time_now[31:20]);
  }
  action labeledstmt_35(){
    labeledstmt_87();
    labeledstmt_88();
  }
  action labeledstmt_36(){
    //NOOP
  }
  bit<16> seq_number;
  action labeledstmt_89(){
    seq_number=SequenceNumberManager_increment_ret;
  }
  action labeledstmt_37(){
    labeledstmt_89();
  }
  action labeledstmt_38(){
    //NOOP
  }
  action labeledstmt_39(){
    hdr.bridge_ev.incoming_tango_traffic=1;
    hdr.incoming_tango_traffic.setValid();
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_eth_header_0=hdr.forward_flow.forward_flow_eth_header_0;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_eth_header_1=hdr.forward_flow.forward_flow_eth_header_1;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_eth_header_2=16w34525;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_0=tango_tunnel_hdr_0;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_1=tango_tunnel_hdr_1;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_2=tango_tunnel_hdr_2;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_3=tango_tunnel_hdr_3;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_4=tango_tunnel_hdr_4;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_5=tango_tunnel_hdr_5;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_6=tango_tunnel_hdr_6;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_7=tango_tunnel_hdr_7;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_icmp_header_0=8w128;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_icmp_header_1=8w0;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_icmp_header_2=16w43981;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_icmp_header_3=16w0;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_icmp_header_4=16w204;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_metrics_header_0=((bit<8>)path_id);
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_metrics_header_1=((bit<16>)timestamp);
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_metrics_header_2=32w0;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_metrics_header_3=seq_number;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_metrics_header_4=8w0;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_0=hdr.forward_flow.forward_flow_ip_header_0;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_1=hdr.forward_flow.forward_flow_ip_header_1;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_2=hdr.forward_flow.forward_flow_ip_header_2;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_3=hdr.forward_flow.forward_flow_ip_header_3;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_4=hdr.forward_flow.forward_flow_ip_header_4;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_5=hdr.forward_flow.forward_flow_ip_header_5;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_6=hdr.forward_flow.forward_flow_ip_header_6;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_7=hdr.forward_flow.forward_flow_ip_header_7;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_dup_header_0=hdr.forward_flow.forward_flow_udp_header_0;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_dup_header_1=hdr.forward_flow.forward_flow_udp_header_1;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_dup_header_2=hdr.forward_flow.forward_flow_udp_header_2;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_dup_header_3=hdr.forward_flow.forward_flow_udp_header_3;
    hdr.bridge_ev.port_event_id=2;
    ig_tm_md.ucast_egress_port=9w264;
  }
  action labeledstmt_40(){
    //NOOP
  }
  action labeledstmt_90(){
    hdr.forward_flow.setInvalid();
  }
  action labeledstmt_41(){
    labeledstmt_90();
  }
  table table_3346 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_1;
      labeledstmt_2;
      labeledstmt_3;
      labeledstmt_4;
    }
    const entries = {
      (2) : labeledstmt_1();
      (1) : labeledstmt_2();
      (3) : labeledstmt_3();
      (_) : labeledstmt_4();
    } 
  } 
  table table_3345 {
    key = {
      hdr.forward_flow.forward_flow_ip_header_2 : ternary;
      hdr.forward_flow.forward_flow_udp_header_1 : ternary;
      hdr.forward_flow.forward_flow_ip_header_6 : ternary;
      hdr.forward_flow.forward_flow_ip_header_7 : ternary;
      hdr.forward_flow.forward_flow_udp_header_0 : ternary;
      hdr.forward_flow.forward_flow_ip_header_4 : ternary;
      hdr.forward_flow.forward_flow_ip_header_5 : ternary;
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_5;
      labeledstmt_6;
      labeledstmt_7;
      labeledstmt_8;
      labeledstmt_9;
      labeledstmt_10;
      labeledstmt_11;
      labeledstmt_12;
      labeledstmt_13;
      labeledstmt_14;
      labeledstmt_15;
      labeledstmt_16;
      labeledstmt_17;
      labeledstmt_18;
      labeledstmt_19;
      labeledstmt_20;
      labeledstmt_21;
      labeledstmt_22;
      labeledstmt_23;
    }
    const entries = {
      (_,_,_,_,50000,_,_,2) : labeledstmt_5();
      (_,_,_,_,50000,_,_,1) : labeledstmt_6();
      (_,_,_,_,50001,_,_,2) : labeledstmt_5();
      (_,_,_,_,50001,_,_,1) : labeledstmt_7();
      (_,_,_,_,50002,_,_,2) : labeledstmt_5();
      (_,_,_,_,50002,_,_,1) : labeledstmt_8();
      (_,_,_,_,50003,_,_,2) : labeledstmt_5();
      (_,_,_,_,50003,_,_,1) : labeledstmt_9();
      (_,_,_,_,50004,_,_,2) : labeledstmt_5();
      (_,_,_,_,50004,_,_,1) : labeledstmt_10();
      (_,_,_,_,50005,_,_,2) : labeledstmt_5();
      (_,_,_,_,50005,_,_,1) : labeledstmt_11();
      (_,_,_,_,50006,_,_,2) : labeledstmt_5();
      (_,_,_,_,50006,_,_,1) : labeledstmt_12();
      (_,_,_,_,50007,_,_,2) : labeledstmt_5();
      (_,_,_,_,50007,_,_,1) : labeledstmt_13();
      (_,_,_,_,60000,_,_,2) : labeledstmt_5();
      (_,_,_,_,60000,_,_,1) : labeledstmt_14();
      (_,_,_,_,60001,_,_,2) : labeledstmt_5();
      (_,_,_,_,60001,_,_,1) : labeledstmt_15();
      (_,_,_,_,60002,_,_,2) : labeledstmt_5();
      (_,_,_,_,60002,_,_,1) : labeledstmt_16();
      (_,_,_,_,60003,_,_,2) : labeledstmt_5();
      (_,_,_,_,60003,_,_,1) : labeledstmt_17();
      (_,_,_,_,60004,_,_,2) : labeledstmt_5();
      (_,_,_,_,60004,_,_,1) : labeledstmt_18();
      (_,_,_,_,60005,_,_,2) : labeledstmt_5();
      (_,_,_,_,60005,_,_,1) : labeledstmt_19();
      (_,_,_,_,60006,_,_,2) : labeledstmt_5();
      (_,_,_,_,60006,_,_,1) : labeledstmt_20();
      (_,_,_,_,60007,_,_,2) : labeledstmt_5();
      (_,_,_,_,60007,_,_,1) : labeledstmt_21();
      (_,_,_,_,50008,_,_,2) : labeledstmt_5();
      (_,_,_,_,50008,_,_,1) : labeledstmt_22();
      (_,_,_,_,_,_,_,2) : labeledstmt_5();
      (_,_,_,_,_,_,_,1) : labeledstmt_23();
      (_,_,_,_,_,_,_,_) : labeledstmt_5();
    } 
  } 
  table table_3344 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_24;
      labeledstmt_25;
    }
    const entries = {
      (2) : labeledstmt_24();
      (1) : labeledstmt_25();
      (_) : labeledstmt_24();
    } 
  } 
  table table_3343 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_26;
      labeledstmt_27;
      labeledstmt_28;
    }
    const entries = {
      (2) : labeledstmt_26();
      (1) : labeledstmt_27();
      (3) : labeledstmt_28();
      (_) : labeledstmt_26();
    } 
  } 
  table table_3342 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_29;
      labeledstmt_30;
      labeledstmt_31;
    }
    const entries = {
      (2) : labeledstmt_29();
      (1) : labeledstmt_30();
      (3) : labeledstmt_31();
      (_) : labeledstmt_29();
    } 
  } 
  table table_3341 {
    key = {
      path_id : ternary;
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_32;
      labeledstmt_33;
    }
    const entries = {
      (_,2) : labeledstmt_32();
      (_,1) : labeledstmt_33();
      (_,_) : labeledstmt_32();
    } 
  } 
  table table_3340 {
    key = {
      path_id : ternary;
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_34;
      labeledstmt_35;
    }
    const entries = {
      (_,2) : labeledstmt_34();
      (_,1) : labeledstmt_35();
      (_,_) : labeledstmt_34();
    } 
  } 
  table table_3339 {
    key = {
      path_id : ternary;
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_36;
      labeledstmt_37;
    }
    const entries = {
      (_,2) : labeledstmt_36();
      (_,1) : labeledstmt_37();
      (_,_) : labeledstmt_36();
    } 
  } 
  table table_3338 {
    key = {
      path_id : ternary;
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_38;
      labeledstmt_39;
    }
    const entries = {
      (_,2) : labeledstmt_38();
      (_,1) : labeledstmt_39();
      (_,_) : labeledstmt_38();
    } 
  } 
  table table_3337 {
    key = {
      path_id : ternary;
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_40;
      labeledstmt_41;
    }
    const entries = {
      (_,2) : labeledstmt_40();
      (_,1) : labeledstmt_41();
      (_,_) : labeledstmt_40();
    } 
  } 
  apply {
    table_3346.apply();
    table_3345.apply();
    table_3344.apply();
    table_3343.apply();
    table_3342.apply();
    table_3341.apply();
    table_3340.apply();
    table_3339.apply();
    table_3338.apply();
    table_3337.apply();
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
    hdr.lucid_eth.setValid();
    hdr.lucid_eth.dst_addr=0;
    hdr.lucid_eth.src_addr=0;
    hdr.lucid_eth.etype=1638;
    pkt.extract(hdr.wire_ev);
    pkt.extract(hdr.bridge_ev);
    meta.egress_event_id=0;
    transition select(hdr.bridge_ev.update_route,
hdr.bridge_ev.incoming_tango_traffic, hdr.bridge_ev.forward_flow){
      (0, 1, 0) : parse_eventset_0;
    }
  }
  state parse_eventset_0 {
    pkt.extract(hdr.incoming_tango_traffic);
    transition accept;
  }
}
control EgressControl(inout hdr_t hdr,
    inout meta_t meta,
    in egress_intrinsic_metadata_t eg_intr_md,
    in egress_intrinsic_metadata_from_parser_t eg_prsr_md,
    inout egress_intrinsic_metadata_for_deparser_t eg_dprsr_md,
    inout egress_intrinsic_metadata_for_output_port_t eg_oport_md){
  @pa_no_overlay("egress","hdr.update_route.update_route_eth_header_0")
  @pa_no_overlay("egress","hdr.update_route.update_route_eth_header_1")
  @pa_no_overlay("egress","hdr.update_route.update_route_eth_header_2")
  @pa_no_overlay("egress","hdr.update_route.update_route_ip_header_0")
  @pa_no_overlay("egress","hdr.update_route.update_route_ip_header_1")
  @pa_no_overlay("egress","hdr.update_route.update_route_ip_header_2")
  @pa_no_overlay("egress","hdr.update_route.update_route_ip_header_3")
  @pa_no_overlay("egress","hdr.update_route.update_route_ip_header_4")
  @pa_no_overlay("egress","hdr.update_route.update_route_ip_header_5")
  @pa_no_overlay("egress","hdr.update_route.update_route_ip_header_6")
  @pa_no_overlay("egress","hdr.update_route.update_route_ip_header_7")
  @pa_no_overlay("egress","hdr.update_route.update_route_icmp_header_0")
  @pa_no_overlay("egress","hdr.update_route.update_route_icmp_header_1")
  @pa_no_overlay("egress","hdr.update_route.update_route_icmp_header_2")
  @pa_no_overlay("egress","hdr.update_route.update_route_icmp_header_3")
  @pa_no_overlay("egress","hdr.update_route.update_route_icmp_header_4")
  @pa_no_overlay("egress","hdr.update_route.update_route_update_0")
  @pa_no_overlay("egress","hdr.update_route.update_route_update_1")
 
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
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_tango_icmp_header_0")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_tango_icmp_header_1")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_tango_icmp_header_2")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_tango_icmp_header_3")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_tango_icmp_header_4")
 
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
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_dup_header_0")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_dup_header_1")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_dup_header_2")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_dup_header_3")
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
  @pa_no_overlay("egress","hdr.forward_flow.forward_flow_udp_header_0")
  @pa_no_overlay("egress","hdr.forward_flow.forward_flow_udp_header_1")
  @pa_no_overlay("egress","hdr.forward_flow.forward_flow_udp_header_2")
  @pa_no_overlay("egress","hdr.forward_flow.forward_flow_udp_header_3")
  action egr_noop(){
    //NOOP
  }
  action update_route_recirc(){
    hdr.incoming_tango_traffic.setInvalid();
    hdr.forward_flow.setInvalid();
    hdr.wire_ev.event_id=3;
    meta.egress_event_id=3;
    hdr.bridge_ev.port_event_id=0;
    hdr.bridge_ev.update_route=0;
    hdr.bridge_ev.incoming_tango_traffic=0;
    hdr.bridge_ev.forward_flow=0;
  }
  action incoming_tango_traffic_recirc(){
    hdr.update_route.setInvalid();
    hdr.forward_flow.setInvalid();
    hdr.wire_ev.event_id=2;
    meta.egress_event_id=2;
    hdr.bridge_ev.port_event_id=0;
    hdr.bridge_ev.update_route=0;
    hdr.bridge_ev.incoming_tango_traffic=0;
    hdr.bridge_ev.forward_flow=0;
  }
  action forward_flow_recirc(){
    hdr.update_route.setInvalid();
    hdr.incoming_tango_traffic.setInvalid();
    hdr.wire_ev.event_id=1;
    meta.egress_event_id=1;
    hdr.bridge_ev.port_event_id=0;
    hdr.bridge_ev.update_route=0;
    hdr.bridge_ev.incoming_tango_traffic=0;
    hdr.bridge_ev.forward_flow=0;
  }
  action update_route_to_external(){
    meta.egress_event_id=3;
    hdr.lucid_eth.setInvalid();
    hdr.wire_ev.setInvalid();
    hdr.bridge_ev.setInvalid();
    hdr.incoming_tango_traffic.setInvalid();
    hdr.forward_flow.setInvalid();
  }
  action incoming_tango_traffic_to_external(){
    meta.egress_event_id=2;
    hdr.lucid_eth.setInvalid();
    hdr.wire_ev.setInvalid();
    hdr.bridge_ev.setInvalid();
    hdr.update_route.setInvalid();
    hdr.forward_flow.setInvalid();
  }
  action forward_flow_to_external(){
    meta.egress_event_id=1;
    hdr.lucid_eth.setInvalid();
    hdr.wire_ev.setInvalid();
    hdr.bridge_ev.setInvalid();
    hdr.update_route.setInvalid();
    hdr.incoming_tango_traffic.setInvalid();
  }
  action update_route_to_internal(){
    meta.egress_event_id=3;
    hdr.wire_ev.event_id=3;
    hdr.bridge_ev.port_event_id=0;
    hdr.bridge_ev.update_route=0;
    hdr.bridge_ev.incoming_tango_traffic=0;
    hdr.bridge_ev.forward_flow=0;
    hdr.incoming_tango_traffic.setInvalid();
    hdr.forward_flow.setInvalid();
  }
  action incoming_tango_traffic_to_internal(){
    meta.egress_event_id=2;
    hdr.wire_ev.event_id=2;
    hdr.bridge_ev.port_event_id=0;
    hdr.bridge_ev.update_route=0;
    hdr.bridge_ev.incoming_tango_traffic=0;
    hdr.bridge_ev.forward_flow=0;
    hdr.update_route.setInvalid();
    hdr.forward_flow.setInvalid();
  }
  action forward_flow_to_internal(){
    meta.egress_event_id=1;
    hdr.wire_ev.event_id=1;
    hdr.bridge_ev.port_event_id=0;
    hdr.bridge_ev.update_route=0;
    hdr.bridge_ev.incoming_tango_traffic=0;
    hdr.bridge_ev.forward_flow=0;
    hdr.update_route.setInvalid();
    hdr.incoming_tango_traffic.setInvalid();
  }
  table t_extract_recirc_event {
    key = {
      eg_intr_md.egress_rid : ternary;
      hdr.bridge_ev.port_event_id : ternary;
      hdr.bridge_ev.update_route : ternary;
      hdr.bridge_ev.incoming_tango_traffic : ternary;
      hdr.bridge_ev.forward_flow : ternary;
    }
    actions = {
      egr_noop;
      update_route_recirc;
      incoming_tango_traffic_recirc;
      forward_flow_recirc;
    }
    const entries = {
      (1,0,0,1,0) : incoming_tango_traffic_recirc();
      (_,_,_,_,_) : egr_noop();
    } 
  } 
  table t_extract_port_event {
    key = {
      hdr.bridge_ev.port_event_id : ternary;
      eg_intr_md.egress_port : ternary;
    }
    actions = {
      update_route_to_external;
      update_route_to_internal;
      incoming_tango_traffic_to_external;
      incoming_tango_traffic_to_internal;
      forward_flow_to_external;
      forward_flow_to_internal;
    }
    const entries = {
      (3,68) : update_route_to_internal();
      (3,_) : update_route_to_external();
      (2,68) : incoming_tango_traffic_to_internal();
      (2,_) : incoming_tango_traffic_to_external();
      (1,68) : forward_flow_to_internal();
      (1,_) : forward_flow_to_external();
    } 
  } 
  apply {
    if ((eg_intr_md.egress_rid==0)){
      t_extract_port_event.apply();
    } else {
      t_extract_recirc_event.apply();
    }
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
