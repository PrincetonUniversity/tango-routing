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
  bit<5> flag_pad_4298;
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
  bit<8> route_manager_0_idx_4285;
  action labeledstmt_55(){
    hdr.incoming_tango_traffic.setInvalid();
  }
  action labeledstmt_1(){
    labeledstmt_55();
  }
  bit<32> time_now;
  action labeledstmt_67(){
    time_now=(ig_intr_md.ingress_mac_tstamp[47:16]);
  }
  bit<16> SequenceNumberManager_increment_ret;
  action labeledstmt_66(){
    SequenceNumberManager_increment_ret=16w32;
  }
  bit<64> tango_tunnel_hdr_7;
  action labeledstmt_65(){
    tango_tunnel_hdr_7=64w0;
  }
  bit<64> tango_tunnel_hdr_6;
  action labeledstmt_64(){
    tango_tunnel_hdr_6=64w0;
  }
  bit<64> tango_tunnel_hdr_5;
  action labeledstmt_63(){
    tango_tunnel_hdr_5=64w3252;
  }
  bit<64> tango_tunnel_hdr_4;
  action labeledstmt_62(){
    tango_tunnel_hdr_4=64w2747196614509592830;
  }
  bit<8> tango_tunnel_hdr_3;
  action labeledstmt_61(){
    tango_tunnel_hdr_3=8w220;
  }
  bit<8> tango_tunnel_hdr_2;
  action labeledstmt_60(){
    tango_tunnel_hdr_2=8w58;
  }
  bit<16> tango_tunnel_hdr_1;
  action labeledstmt_59(){
    tango_tunnel_hdr_1=16w0;
  }
  bit<32> tango_tunnel_hdr_0;
  action labeledstmt_58(){
    tango_tunnel_hdr_0=32w1610612736;
  }
  bit<8> RouteManager_get_path_id_ret;
  action labeledstmt_57(){
    RouteManager_get_path_id_ret=8w32;
  }
  bit<8> traffic_class;
  action labeledstmt_56(){
    traffic_class=8w0;
  }
  action labeledstmt_2(){
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
  }
  action labeledstmt_68(){
    route_manager_0_idx_4285=hdr.update_route.update_route_update_0;
  }
  action labeledstmt_3(){
    labeledstmt_68();
  }
  action labeledstmt_4(){
    //NOOP
  }
  action labeledstmt_5(){
    //NOOP
  }
  bit<12> timestamp;
  action labeledstmt_70(){
    timestamp=(time_now[31:20]);
  }
  action labeledstmt_69(){
    traffic_class=8w0;
  }
  action labeledstmt_6(){
    labeledstmt_69();
    labeledstmt_70();
  }
  action labeledstmt_71(){
    traffic_class=8w1;
  }
  action labeledstmt_7(){
    labeledstmt_71();
    labeledstmt_70();
  }
  action labeledstmt_72(){
    traffic_class=8w2;
  }
  action labeledstmt_8(){
    labeledstmt_72();
    labeledstmt_70();
  }
  action labeledstmt_73(){
    traffic_class=8w3;
  }
  action labeledstmt_9(){
    labeledstmt_73();
    labeledstmt_70();
  }
  action labeledstmt_74(){
    traffic_class=8w4;
  }
  action labeledstmt_10(){
    labeledstmt_74();
    labeledstmt_70();
  }
  action labeledstmt_75(){
    traffic_class=8w5;
  }
  action labeledstmt_11(){
    labeledstmt_75();
    labeledstmt_70();
  }
  action labeledstmt_76(){
    traffic_class=8w6;
  }
  action labeledstmt_12(){
    labeledstmt_76();
    labeledstmt_70();
  }
  action labeledstmt_77(){
    traffic_class=8w7;
  }
  action labeledstmt_13(){
    labeledstmt_77();
    labeledstmt_70();
  }
  action labeledstmt_78(){
    traffic_class=8w8;
  }
  action labeledstmt_14(){
    labeledstmt_78();
    labeledstmt_70();
  }
  action labeledstmt_79(){
    traffic_class=8w9;
  }
  action labeledstmt_15(){
    labeledstmt_79();
    labeledstmt_70();
  }
  action labeledstmt_80(){
    traffic_class=8w10;
  }
  action labeledstmt_16(){
    labeledstmt_80();
    labeledstmt_70();
  }
  action labeledstmt_81(){
    traffic_class=8w11;
  }
  action labeledstmt_17(){
    labeledstmt_81();
    labeledstmt_70();
  }
  action labeledstmt_82(){
    traffic_class=8w12;
  }
  action labeledstmt_18(){
    labeledstmt_82();
    labeledstmt_70();
  }
  action labeledstmt_83(){
    traffic_class=8w13;
  }
  action labeledstmt_19(){
    labeledstmt_83();
    labeledstmt_70();
  }
  action labeledstmt_84(){
    traffic_class=8w14;
  }
  action labeledstmt_20(){
    labeledstmt_84();
    labeledstmt_70();
  }
  action labeledstmt_85(){
    traffic_class=8w15;
  }
  action labeledstmt_21(){
    labeledstmt_85();
    labeledstmt_70();
  }
  action labeledstmt_86(){
    traffic_class=8w30;
  }
  action labeledstmt_22(){
    labeledstmt_86();
    labeledstmt_70();
  }
  action labeledstmt_87(){
    traffic_class=8w31;
  }
  action labeledstmt_23(){
    labeledstmt_87();
    labeledstmt_70();
  }
  action labeledstmt_24(){
    //NOOP
  }
  action labeledstmt_88(){
    route_manager_0_idx_4285=traffic_class;
  }
  action labeledstmt_25(){
    labeledstmt_88();
  }
  action labeledstmt_26(){
    //NOOP
  }
  RegisterAction<bit<8>,bit<8>,bit<8>>(route_manager_0)
  route_manager_0_regaction_4286 = {
    void apply(inout bit<8> cell1_remote,
        out bit<8> ret_remote){
      bit<8> cell1_local=cell1_remote;
      bit<8> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_89(){
   
RouteManager_get_path_id_ret=route_manager_0_regaction_4286.execute(route_manager_0_idx_4285);
  }
  action labeledstmt_27(){
    labeledstmt_89();
  }
  RegisterAction<bit<8>,bit<8>,bit<8>>(route_manager_0)
  route_manager_0_regaction_4287 = {
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
  action labeledstmt_90(){
    route_manager_0_regaction_4287.execute(route_manager_0_idx_4285);
  }
  action labeledstmt_28(){
    labeledstmt_90();
  }
  action labeledstmt_29(){
    //NOOP
  }
  bit<8> path_id;
  action labeledstmt_91(){
    path_id=RouteManager_get_path_id_ret;
  }
  action labeledstmt_30(){
    labeledstmt_91();
  }
  action labeledstmt_92(){
    hdr.update_route.setInvalid();
  }
  action labeledstmt_31(){
    labeledstmt_92();
  }
  action labeledstmt_32(){
    //NOOP
  }
  action labeledstmt_101(){
    tango_tunnel_hdr_0=32w1610612736;
  }
  action labeledstmt_100(){
    tango_tunnel_hdr_1=16w1000;
  }
  action labeledstmt_99(){
    tango_tunnel_hdr_2=8w58;
  }
  action labeledstmt_98(){
    tango_tunnel_hdr_3=8w220;
  }
  action labeledstmt_97(){
    tango_tunnel_hdr_4=64w2747196614509592830;
  }
  action labeledstmt_96(){
    tango_tunnel_hdr_5=64w3252;
  }
  action labeledstmt_95(){
    tango_tunnel_hdr_6=64w2739390614537240576;
  }
  action labeledstmt_94(){
    tango_tunnel_hdr_7=64w1;
  }
  RegisterAction<bit<16>,bit<8>,bit<16>>(sequence_counters_0)
  sequence_counters_0_regaction_4288 = {
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
  action labeledstmt_93(){
   
SequenceNumberManager_increment_ret=sequence_counters_0_regaction_4288.execute(path_id);
  }
  action labeledstmt_33(){
    labeledstmt_93();
    labeledstmt_94();
    labeledstmt_95();
    labeledstmt_96();
    labeledstmt_97();
    labeledstmt_98();
    labeledstmt_99();
    labeledstmt_100();
    labeledstmt_101();
  }
  action labeledstmt_102(){
    tango_tunnel_hdr_6=64w2739390614537306112;
  }
  action labeledstmt_34(){
    labeledstmt_93();
    labeledstmt_94();
    labeledstmt_102();
    labeledstmt_96();
    labeledstmt_97();
    labeledstmt_98();
    labeledstmt_99();
    labeledstmt_100();
    labeledstmt_101();
  }
  action labeledstmt_103(){
    tango_tunnel_hdr_6=64w2739390614537371648;
  }
  action labeledstmt_35(){
    labeledstmt_93();
    labeledstmt_94();
    labeledstmt_103();
    labeledstmt_96();
    labeledstmt_97();
    labeledstmt_98();
    labeledstmt_99();
    labeledstmt_100();
    labeledstmt_101();
  }
  action labeledstmt_104(){
    tango_tunnel_hdr_6=64w2739390614537437184;
  }
  action labeledstmt_36(){
    labeledstmt_93();
    labeledstmt_94();
    labeledstmt_104();
    labeledstmt_96();
    labeledstmt_97();
    labeledstmt_98();
    labeledstmt_99();
    labeledstmt_100();
    labeledstmt_101();
  }
  action labeledstmt_105(){
    tango_tunnel_hdr_6=64w2739390614537502720;
  }
  action labeledstmt_37(){
    labeledstmt_93();
    labeledstmt_94();
    labeledstmt_105();
    labeledstmt_96();
    labeledstmt_97();
    labeledstmt_98();
    labeledstmt_99();
    labeledstmt_100();
    labeledstmt_101();
  }
  action labeledstmt_106(){
    tango_tunnel_hdr_6=64w2739390614537568256;
  }
  action labeledstmt_38(){
    labeledstmt_93();
    labeledstmt_94();
    labeledstmt_106();
    labeledstmt_96();
    labeledstmt_97();
    labeledstmt_98();
    labeledstmt_99();
    labeledstmt_100();
    labeledstmt_101();
  }
  action labeledstmt_107(){
    tango_tunnel_hdr_6=64w2739390614537633792;
  }
  action labeledstmt_39(){
    labeledstmt_93();
    labeledstmt_94();
    labeledstmt_107();
    labeledstmt_96();
    labeledstmt_97();
    labeledstmt_98();
    labeledstmt_99();
    labeledstmt_100();
    labeledstmt_101();
  }
  action labeledstmt_40(){
    labeledstmt_93();
    labeledstmt_94();
    labeledstmt_107();
    labeledstmt_96();
    labeledstmt_97();
    labeledstmt_98();
    labeledstmt_99();
    labeledstmt_100();
    labeledstmt_101();
  }
  action labeledstmt_108(){
    tango_tunnel_hdr_7=64w2;
  }
  action labeledstmt_41(){
    labeledstmt_93();
    labeledstmt_108();
    labeledstmt_95();
    labeledstmt_96();
    labeledstmt_97();
    labeledstmt_98();
    labeledstmt_99();
    labeledstmt_100();
    labeledstmt_101();
  }
  action labeledstmt_42(){
    labeledstmt_93();
    labeledstmt_108();
    labeledstmt_102();
    labeledstmt_96();
    labeledstmt_97();
    labeledstmt_98();
    labeledstmt_99();
    labeledstmt_100();
    labeledstmt_101();
  }
  action labeledstmt_43(){
    labeledstmt_93();
    labeledstmt_108();
    labeledstmt_103();
    labeledstmt_96();
    labeledstmt_97();
    labeledstmt_98();
    labeledstmt_99();
    labeledstmt_100();
    labeledstmt_101();
  }
  action labeledstmt_44(){
    labeledstmt_93();
    labeledstmt_108();
    labeledstmt_104();
    labeledstmt_96();
    labeledstmt_97();
    labeledstmt_98();
    labeledstmt_99();
    labeledstmt_100();
    labeledstmt_101();
  }
  action labeledstmt_45(){
    labeledstmt_93();
    labeledstmt_108();
    labeledstmt_105();
    labeledstmt_96();
    labeledstmt_97();
    labeledstmt_98();
    labeledstmt_99();
    labeledstmt_100();
    labeledstmt_101();
  }
  action labeledstmt_46(){
    labeledstmt_93();
    labeledstmt_108();
    labeledstmt_106();
    labeledstmt_96();
    labeledstmt_97();
    labeledstmt_98();
    labeledstmt_99();
    labeledstmt_100();
    labeledstmt_101();
  }
  action labeledstmt_47(){
    labeledstmt_93();
    labeledstmt_108();
    labeledstmt_107();
    labeledstmt_96();
    labeledstmt_97();
    labeledstmt_98();
    labeledstmt_99();
    labeledstmt_100();
    labeledstmt_101();
  }
  action labeledstmt_109(){
    tango_tunnel_hdr_7=64w77;
  }
  action labeledstmt_48(){
    labeledstmt_93();
    labeledstmt_109();
    labeledstmt_107();
    labeledstmt_96();
    labeledstmt_97();
    labeledstmt_98();
    labeledstmt_99();
    labeledstmt_100();
    labeledstmt_101();
  }
  action labeledstmt_49(){
    //NOOP
  }
  bit<16> seq_number;
  action labeledstmt_110(){
    seq_number=SequenceNumberManager_increment_ret;
  }
  action labeledstmt_50(){
    labeledstmt_110();
  }
  action labeledstmt_51(){
    //NOOP
  }
  action labeledstmt_52(){
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
  action labeledstmt_53(){
    //NOOP
  }
  action labeledstmt_111(){
    hdr.forward_flow.setInvalid();
  }
  action labeledstmt_54(){
    labeledstmt_111();
  }
  table table_4297 {
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
  table table_4296 {
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
      (_,_,_,_,50001,_,_,2) : labeledstmt_5();
      (_,_,_,_,50002,_,_,2) : labeledstmt_5();
      (_,_,_,_,50003,_,_,2) : labeledstmt_5();
      (_,_,_,_,50004,_,_,2) : labeledstmt_5();
      (_,_,_,_,50005,_,_,2) : labeledstmt_5();
      (_,_,_,_,50006,_,_,2) : labeledstmt_5();
      (_,_,_,_,50007,_,_,2) : labeledstmt_5();
      (_,_,_,_,60000,_,_,2) : labeledstmt_5();
      (_,_,_,_,60001,_,_,2) : labeledstmt_5();
      (_,_,_,_,60002,_,_,2) : labeledstmt_5();
      (_,_,_,_,60003,_,_,2) : labeledstmt_5();
      (_,_,_,_,60004,_,_,2) : labeledstmt_5();
      (_,_,_,_,60005,_,_,2) : labeledstmt_5();
      (_,_,_,_,60006,_,_,2) : labeledstmt_5();
      (_,_,_,_,60007,_,_,2) : labeledstmt_5();
      (_,_,_,_,50008,_,_,2) : labeledstmt_5();
      (_,_,_,_,_,_,_,2) : labeledstmt_5();
      (_,_,_,_,50000,_,_,1) : labeledstmt_6();
      (_,_,_,_,50001,_,_,1) : labeledstmt_7();
      (_,_,_,_,50002,_,_,1) : labeledstmt_8();
      (_,_,_,_,50003,_,_,1) : labeledstmt_9();
      (_,_,_,_,50004,_,_,1) : labeledstmt_10();
      (_,_,_,_,50005,_,_,1) : labeledstmt_11();
      (_,_,_,_,50006,_,_,1) : labeledstmt_12();
      (_,_,_,_,50007,_,_,1) : labeledstmt_13();
      (_,_,_,_,60000,_,_,1) : labeledstmt_14();
      (_,_,_,_,60001,_,_,1) : labeledstmt_15();
      (_,_,_,_,60002,_,_,1) : labeledstmt_16();
      (_,_,_,_,60003,_,_,1) : labeledstmt_17();
      (_,_,_,_,60004,_,_,1) : labeledstmt_18();
      (_,_,_,_,60005,_,_,1) : labeledstmt_19();
      (_,_,_,_,60006,_,_,1) : labeledstmt_20();
      (_,_,_,_,60007,_,_,1) : labeledstmt_21();
      (_,_,_,_,50008,_,_,1) : labeledstmt_22();
      (_,_,_,_,_,_,_,1) : labeledstmt_23();
      (_,_,_,_,_,_,_,_) : labeledstmt_5();
    } 
  } 
  table table_4295 {
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
  table table_4294 {
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
  table table_4293 {
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
  table table_4292 {
    key = {
      hdr.wire_ev.event_id : ternary;
      path_id : ternary;
    }
    actions = {
      labeledstmt_32;
      labeledstmt_33;
      labeledstmt_34;
      labeledstmt_35;
      labeledstmt_36;
      labeledstmt_37;
      labeledstmt_38;
      labeledstmt_39;
      labeledstmt_40;
      labeledstmt_41;
      labeledstmt_42;
      labeledstmt_43;
      labeledstmt_44;
      labeledstmt_45;
      labeledstmt_46;
      labeledstmt_47;
      labeledstmt_48;
    }
    const entries = {
      (2,0) : labeledstmt_32();
      (1,0) : labeledstmt_33();
      (2,1) : labeledstmt_32();
      (1,1) : labeledstmt_34();
      (2,2) : labeledstmt_32();
      (1,2) : labeledstmt_35();
      (2,3) : labeledstmt_32();
      (1,3) : labeledstmt_36();
      (2,4) : labeledstmt_32();
      (1,4) : labeledstmt_37();
      (2,5) : labeledstmt_32();
      (1,5) : labeledstmt_38();
      (2,6) : labeledstmt_32();
      (1,6) : labeledstmt_39();
      (2,7) : labeledstmt_32();
      (1,7) : labeledstmt_40();
      (2,8) : labeledstmt_32();
      (1,8) : labeledstmt_41();
      (2,9) : labeledstmt_32();
      (1,9) : labeledstmt_42();
      (2,10) : labeledstmt_32();
      (1,10) : labeledstmt_43();
      (2,11) : labeledstmt_32();
      (1,11) : labeledstmt_44();
      (2,12) : labeledstmt_32();
      (1,12) : labeledstmt_45();
      (2,13) : labeledstmt_32();
      (1,13) : labeledstmt_46();
      (2,14) : labeledstmt_32();
      (1,14) : labeledstmt_47();
      (2,_) : labeledstmt_32();
      (1,_) : labeledstmt_48();
      (_,_) : labeledstmt_32();
    } 
  } 
  table table_4291 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_49;
      labeledstmt_50;
    }
    const entries = {
      (2) : labeledstmt_49();
      (1) : labeledstmt_50();
      (_) : labeledstmt_49();
    } 
  } 
  table table_4290 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_51;
      labeledstmt_52;
    }
    const entries = {
      (2) : labeledstmt_51();
      (1) : labeledstmt_52();
      (_) : labeledstmt_51();
    } 
  } 
  table table_4289 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_53;
      labeledstmt_54;
    }
    const entries = {
      (2) : labeledstmt_53();
      (1) : labeledstmt_54();
      (_) : labeledstmt_53();
    } 
  } 
  apply {
    table_4297.apply();
    table_4296.apply();
    table_4295.apply();
    table_4294.apply();
    table_4293.apply();
    table_4292.apply();
    table_4291.apply();
    table_4290.apply();
    table_4289.apply();
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
