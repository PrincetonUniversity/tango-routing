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
  bit<5> flag_pad_4334;
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
  bit<16> update_route_udp_header_0;
  bit<16> update_route_udp_header_1;
  bit<16> update_route_udp_header_2;
  bit<16> update_route_udp_header_3;
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
      (12) : port_12_default_update_route;
      (196) : parse_lucid_eth;
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
  state port_12_default_update_route {
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
  bit<8> route_manager_0_idx_4320;
  action labeledstmt_58(){
    hdr.incoming_tango_traffic.setInvalid();
  }
  action labeledstmt_1(){
    labeledstmt_58();
  }
  bit<16> forward_tango_pkt_arg_33;
  action labeledstmt_93(){
    forward_tango_pkt_arg_33=hdr.forward_flow.forward_flow_udp_header_3;
  }
  bit<16> forward_tango_pkt_arg_32;
  action labeledstmt_92(){
    forward_tango_pkt_arg_32=hdr.forward_flow.forward_flow_udp_header_2;
  }
  bit<16> forward_tango_pkt_arg_31;
  action labeledstmt_91(){
    forward_tango_pkt_arg_31=hdr.forward_flow.forward_flow_udp_header_1;
  }
  bit<16> forward_tango_pkt_arg_30;
  action labeledstmt_90(){
    forward_tango_pkt_arg_30=hdr.forward_flow.forward_flow_udp_header_0;
  }
  bit<32> forward_tango_pkt_arg_29;
  action labeledstmt_89(){
    forward_tango_pkt_arg_29=hdr.forward_flow.forward_flow_ip_header_9;
  }
  bit<32> forward_tango_pkt_arg_28;
  action labeledstmt_88(){
    forward_tango_pkt_arg_28=hdr.forward_flow.forward_flow_ip_header_8;
  }
  bit<16> forward_tango_pkt_arg_27;
  action labeledstmt_87(){
    forward_tango_pkt_arg_27=hdr.forward_flow.forward_flow_ip_header_7;
  }
  bit<8> forward_tango_pkt_arg_26;
  action labeledstmt_86(){
    forward_tango_pkt_arg_26=hdr.forward_flow.forward_flow_ip_header_6;
  }
  bit<8> forward_tango_pkt_arg_25;
  action labeledstmt_85(){
    forward_tango_pkt_arg_25=hdr.forward_flow.forward_flow_ip_header_5;
  }
  bit<16> forward_tango_pkt_arg_24;
  action labeledstmt_84(){
    forward_tango_pkt_arg_24=hdr.forward_flow.forward_flow_ip_header_4;
  }
  bit<16> forward_tango_pkt_arg_23;
  action labeledstmt_83(){
    forward_tango_pkt_arg_23=hdr.forward_flow.forward_flow_ip_header_3;
  }
  bit<16> forward_tango_pkt_arg_22;
  action labeledstmt_82(){
    forward_tango_pkt_arg_22=hdr.forward_flow.forward_flow_ip_header_2;
  }
  bit<8> forward_tango_pkt_arg_21;
  action labeledstmt_81(){
    forward_tango_pkt_arg_21=hdr.forward_flow.forward_flow_ip_header_1;
  }
  bit<8> forward_tango_pkt_arg_20;
  action labeledstmt_80(){
    forward_tango_pkt_arg_20=hdr.forward_flow.forward_flow_ip_header_0;
  }
  bit<16> forward_tango_pkt_arg_14;
  action labeledstmt_79(){
    forward_tango_pkt_arg_14=16w0;
  }
  bit<16> forward_tango_pkt_arg_13;
  action labeledstmt_78(){
   
forward_tango_pkt_arg_13=(hdr.forward_flow.forward_flow_ip_header_2+16w18);
  }
  bit<16> forward_tango_pkt_arg_12;
  action labeledstmt_77(){
    forward_tango_pkt_arg_12=16w8080;
  }
  bit<16> forward_tango_pkt_arg_11;
  action labeledstmt_76(){
    forward_tango_pkt_arg_11=16w8080;
  }
  bit<16> forward_tango_pkt_arg_2;
  action labeledstmt_75(){
    forward_tango_pkt_arg_2=16w34525;
  }
  bit<48> forward_tango_pkt_arg_1;
  action labeledstmt_74(){
    forward_tango_pkt_arg_1=hdr.forward_flow.forward_flow_eth_header_1;
  }
  bit<48> forward_tango_pkt_arg_0;
  action labeledstmt_73(){
    forward_tango_pkt_arg_0=hdr.forward_flow.forward_flow_eth_header_0;
  }
  bit<8> tango_metrics_hdr_4;
  action labeledstmt_72(){
    tango_metrics_hdr_4=8w0;
  }
  bit<32> tango_metrics_hdr_2;
  action labeledstmt_71(){
    tango_metrics_hdr_2=32w0;
  }
  bit<32> time_now;
  action labeledstmt_70(){
    time_now=(ig_intr_md.ingress_mac_tstamp[47:16]);
  }
  bit<16> SequenceNumberManager_increment_ret;
  action labeledstmt_69(){
    SequenceNumberManager_increment_ret=16w32;
  }
  bit<64> tango_tunnel_hdr_7;
  action labeledstmt_68(){
    tango_tunnel_hdr_7=64w0;
  }
  bit<64> tango_tunnel_hdr_6;
  action labeledstmt_67(){
    tango_tunnel_hdr_6=64w0;
  }
  bit<64> tango_tunnel_hdr_5;
  action labeledstmt_66(){
    tango_tunnel_hdr_5=64w3252;
  }
  bit<64> tango_tunnel_hdr_4;
  action labeledstmt_65(){
    tango_tunnel_hdr_4=64w2747196614509592830;
  }
  bit<8> tango_tunnel_hdr_3;
  action labeledstmt_64(){
    tango_tunnel_hdr_3=8w220;
  }
  bit<8> tango_tunnel_hdr_2;
  action labeledstmt_63(){
    tango_tunnel_hdr_2=8w17;
  }
  bit<16> tango_tunnel_hdr_1;
  action labeledstmt_62(){
    tango_tunnel_hdr_1=16w0;
  }
  bit<32> tango_tunnel_hdr_0;
  action labeledstmt_61(){
    tango_tunnel_hdr_0=32w1610612736;
  }
  bit<8> RouteManager_get_path_id_ret;
  action labeledstmt_60(){
    RouteManager_get_path_id_ret=8w32;
  }
  bit<8> traffic_class;
  action labeledstmt_59(){
    traffic_class=8w0;
  }
  action labeledstmt_2(){
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
    labeledstmt_79();
    labeledstmt_80();
    labeledstmt_81();
    labeledstmt_82();
    labeledstmt_83();
    labeledstmt_84();
    labeledstmt_85();
    labeledstmt_86();
    labeledstmt_87();
    labeledstmt_88();
    labeledstmt_89();
    labeledstmt_90();
    labeledstmt_91();
    labeledstmt_92();
    labeledstmt_93();
  }
  action labeledstmt_94(){
    route_manager_0_idx_4320=hdr.update_route.update_route_update_0;
  }
  action labeledstmt_3(){
    labeledstmt_94();
  }
  action labeledstmt_4(){
    //NOOP
  }
  action labeledstmt_5(){
    //NOOP
  }
  bit<8> forward_tango_pkt_arg_19;
  action labeledstmt_98(){
    forward_tango_pkt_arg_19=tango_metrics_hdr_4;
  }
  bit<32> forward_tango_pkt_arg_17;
  action labeledstmt_97(){
    forward_tango_pkt_arg_17=tango_metrics_hdr_2;
  }
  bit<12> timestamp;
  action labeledstmt_96(){
    timestamp=(time_now[31:20]);
  }
  action labeledstmt_95(){
    traffic_class=8w0;
  }
  action labeledstmt_6(){
    labeledstmt_95();
    labeledstmt_96();
    labeledstmt_97();
    labeledstmt_98();
  }
  action labeledstmt_99(){
    traffic_class=8w1;
  }
  action labeledstmt_7(){
    labeledstmt_99();
    labeledstmt_96();
    labeledstmt_97();
    labeledstmt_98();
  }
  action labeledstmt_100(){
    traffic_class=8w2;
  }
  action labeledstmt_8(){
    labeledstmt_100();
    labeledstmt_96();
    labeledstmt_97();
    labeledstmt_98();
  }
  action labeledstmt_101(){
    traffic_class=8w3;
  }
  action labeledstmt_9(){
    labeledstmt_101();
    labeledstmt_96();
    labeledstmt_97();
    labeledstmt_98();
  }
  action labeledstmt_102(){
    traffic_class=8w4;
  }
  action labeledstmt_10(){
    labeledstmt_102();
    labeledstmt_96();
    labeledstmt_97();
    labeledstmt_98();
  }
  action labeledstmt_103(){
    traffic_class=8w5;
  }
  action labeledstmt_11(){
    labeledstmt_103();
    labeledstmt_96();
    labeledstmt_97();
    labeledstmt_98();
  }
  action labeledstmt_104(){
    traffic_class=8w6;
  }
  action labeledstmt_12(){
    labeledstmt_104();
    labeledstmt_96();
    labeledstmt_97();
    labeledstmt_98();
  }
  action labeledstmt_105(){
    traffic_class=8w7;
  }
  action labeledstmt_13(){
    labeledstmt_105();
    labeledstmt_96();
    labeledstmt_97();
    labeledstmt_98();
  }
  action labeledstmt_106(){
    traffic_class=8w8;
  }
  action labeledstmt_14(){
    labeledstmt_106();
    labeledstmt_96();
    labeledstmt_97();
    labeledstmt_98();
  }
  action labeledstmt_107(){
    traffic_class=8w9;
  }
  action labeledstmt_15(){
    labeledstmt_107();
    labeledstmt_96();
    labeledstmt_97();
    labeledstmt_98();
  }
  action labeledstmt_108(){
    traffic_class=8w10;
  }
  action labeledstmt_16(){
    labeledstmt_108();
    labeledstmt_96();
    labeledstmt_97();
    labeledstmt_98();
  }
  action labeledstmt_109(){
    traffic_class=8w11;
  }
  action labeledstmt_17(){
    labeledstmt_109();
    labeledstmt_96();
    labeledstmt_97();
    labeledstmt_98();
  }
  action labeledstmt_110(){
    traffic_class=8w12;
  }
  action labeledstmt_18(){
    labeledstmt_110();
    labeledstmt_96();
    labeledstmt_97();
    labeledstmt_98();
  }
  action labeledstmt_111(){
    traffic_class=8w13;
  }
  action labeledstmt_19(){
    labeledstmt_111();
    labeledstmt_96();
    labeledstmt_97();
    labeledstmt_98();
  }
  action labeledstmt_112(){
    traffic_class=8w14;
  }
  action labeledstmt_20(){
    labeledstmt_112();
    labeledstmt_96();
    labeledstmt_97();
    labeledstmt_98();
  }
  action labeledstmt_113(){
    traffic_class=8w15;
  }
  action labeledstmt_21(){
    labeledstmt_113();
    labeledstmt_96();
    labeledstmt_97();
    labeledstmt_98();
  }
  action labeledstmt_114(){
    traffic_class=8w30;
  }
  action labeledstmt_22(){
    labeledstmt_114();
    labeledstmt_96();
    labeledstmt_97();
    labeledstmt_98();
  }
  action labeledstmt_115(){
    traffic_class=8w31;
  }
  action labeledstmt_23(){
    labeledstmt_115();
    labeledstmt_96();
    labeledstmt_97();
    labeledstmt_98();
  }
  action labeledstmt_24(){
    //NOOP
  }
  bit<16> tango_metrics_hdr_1;
  action labeledstmt_117(){
    tango_metrics_hdr_1=((bit<16>)timestamp);
  }
  action labeledstmt_116(){
    route_manager_0_idx_4320=traffic_class;
  }
  action labeledstmt_25(){
    labeledstmt_116();
    labeledstmt_117();
  }
  action labeledstmt_26(){
    //NOOP
  }
  bit<16> forward_tango_pkt_arg_16;
  action labeledstmt_119(){
    forward_tango_pkt_arg_16=tango_metrics_hdr_1;
  }
  RegisterAction<bit<8>,bit<8>,bit<8>>(route_manager_0)
  route_manager_0_regaction_4321 = {
    void apply(inout bit<8> cell1_remote,
        out bit<8> ret_remote){
      bit<8> cell1_local=cell1_remote;
      bit<8> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_118(){
   
RouteManager_get_path_id_ret=route_manager_0_regaction_4321.execute(route_manager_0_idx_4320);
  }
  action labeledstmt_27(){
    labeledstmt_118();
    labeledstmt_119();
  }
  RegisterAction<bit<8>,bit<8>,bit<8>>(route_manager_0)
  route_manager_0_regaction_4322 = {
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
  action labeledstmt_120(){
    route_manager_0_regaction_4322.execute(route_manager_0_idx_4320);
  }
  action labeledstmt_28(){
    labeledstmt_120();
  }
  action labeledstmt_29(){
    //NOOP
  }
  bit<8> path_id;
  action labeledstmt_121(){
    path_id=RouteManager_get_path_id_ret;
  }
  action labeledstmt_30(){
    labeledstmt_121();
  }
  action labeledstmt_122(){
    hdr.update_route.setInvalid();
  }
  action labeledstmt_31(){
    labeledstmt_122();
  }
  action labeledstmt_32(){
    //NOOP
  }
  action labeledstmt_132(){
    tango_tunnel_hdr_0=32w1610612736;
  }
  action labeledstmt_131(){
    tango_tunnel_hdr_1=(hdr.forward_flow.forward_flow_ip_header_2+16w18);
  }
  action labeledstmt_130(){
    tango_tunnel_hdr_2=8w17;
  }
  action labeledstmt_129(){
    tango_tunnel_hdr_3=8w220;
  }
  action labeledstmt_128(){
    tango_tunnel_hdr_4=64w2747196614509592830;
  }
  action labeledstmt_127(){
    tango_tunnel_hdr_5=64w3252;
  }
  action labeledstmt_126(){
    tango_tunnel_hdr_6=64w2739390614536716288;
  }
  action labeledstmt_125(){
    tango_tunnel_hdr_7=64w1;
  }
  RegisterAction<bit<16>,bit<8>,bit<16>>(sequence_counters_0)
  sequence_counters_0_regaction_4323 = {
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
  action labeledstmt_124(){
   
SequenceNumberManager_increment_ret=sequence_counters_0_regaction_4323.execute(path_id);
  }
  bit<8> tango_metrics_hdr_0;
  action labeledstmt_123(){
    tango_metrics_hdr_0=((bit<8>)path_id);
  }
  action labeledstmt_33(){
    labeledstmt_123();
    labeledstmt_124();
    labeledstmt_125();
    labeledstmt_126();
    labeledstmt_127();
    labeledstmt_128();
    labeledstmt_129();
    labeledstmt_130();
    labeledstmt_131();
    labeledstmt_132();
  }
  action labeledstmt_34(){
    labeledstmt_123();
    labeledstmt_124();
    labeledstmt_125();
    labeledstmt_126();
    labeledstmt_127();
    labeledstmt_128();
    labeledstmt_129();
    labeledstmt_130();
    labeledstmt_131();
    labeledstmt_132();
  }
  action labeledstmt_35(){
    labeledstmt_123();
    labeledstmt_124();
    labeledstmt_125();
    labeledstmt_126();
    labeledstmt_127();
    labeledstmt_128();
    labeledstmt_129();
    labeledstmt_130();
    labeledstmt_131();
    labeledstmt_132();
  }
  action labeledstmt_36(){
    labeledstmt_123();
    labeledstmt_124();
    labeledstmt_125();
    labeledstmt_126();
    labeledstmt_127();
    labeledstmt_128();
    labeledstmt_129();
    labeledstmt_130();
    labeledstmt_131();
    labeledstmt_132();
  }
  action labeledstmt_37(){
    labeledstmt_123();
    labeledstmt_124();
    labeledstmt_125();
    labeledstmt_126();
    labeledstmt_127();
    labeledstmt_128();
    labeledstmt_129();
    labeledstmt_130();
    labeledstmt_131();
    labeledstmt_132();
  }
  action labeledstmt_38(){
    labeledstmt_123();
    labeledstmt_124();
    labeledstmt_125();
    labeledstmt_126();
    labeledstmt_127();
    labeledstmt_128();
    labeledstmt_129();
    labeledstmt_130();
    labeledstmt_131();
    labeledstmt_132();
  }
  action labeledstmt_39(){
    labeledstmt_123();
    labeledstmt_124();
    labeledstmt_125();
    labeledstmt_126();
    labeledstmt_127();
    labeledstmt_128();
    labeledstmt_129();
    labeledstmt_130();
    labeledstmt_131();
    labeledstmt_132();
  }
  action labeledstmt_40(){
    labeledstmt_123();
    labeledstmt_124();
    labeledstmt_125();
    labeledstmt_126();
    labeledstmt_127();
    labeledstmt_128();
    labeledstmt_129();
    labeledstmt_130();
    labeledstmt_131();
    labeledstmt_132();
  }
  action labeledstmt_41(){
    labeledstmt_123();
    labeledstmt_124();
    labeledstmt_125();
    labeledstmt_126();
    labeledstmt_127();
    labeledstmt_128();
    labeledstmt_129();
    labeledstmt_130();
    labeledstmt_131();
    labeledstmt_132();
  }
  action labeledstmt_42(){
    labeledstmt_123();
    labeledstmt_124();
    labeledstmt_125();
    labeledstmt_126();
    labeledstmt_127();
    labeledstmt_128();
    labeledstmt_129();
    labeledstmt_130();
    labeledstmt_131();
    labeledstmt_132();
  }
  action labeledstmt_43(){
    labeledstmt_123();
    labeledstmt_124();
    labeledstmt_125();
    labeledstmt_126();
    labeledstmt_127();
    labeledstmt_128();
    labeledstmt_129();
    labeledstmt_130();
    labeledstmt_131();
    labeledstmt_132();
  }
  action labeledstmt_44(){
    labeledstmt_123();
    labeledstmt_124();
    labeledstmt_125();
    labeledstmt_126();
    labeledstmt_127();
    labeledstmt_128();
    labeledstmt_129();
    labeledstmt_130();
    labeledstmt_131();
    labeledstmt_132();
  }
  action labeledstmt_45(){
    labeledstmt_123();
    labeledstmt_124();
    labeledstmt_125();
    labeledstmt_126();
    labeledstmt_127();
    labeledstmt_128();
    labeledstmt_129();
    labeledstmt_130();
    labeledstmt_131();
    labeledstmt_132();
  }
  action labeledstmt_46(){
    labeledstmt_123();
    labeledstmt_124();
    labeledstmt_125();
    labeledstmt_126();
    labeledstmt_127();
    labeledstmt_128();
    labeledstmt_129();
    labeledstmt_130();
    labeledstmt_131();
    labeledstmt_132();
  }
  action labeledstmt_47(){
    labeledstmt_123();
    labeledstmt_124();
    labeledstmt_125();
    labeledstmt_126();
    labeledstmt_127();
    labeledstmt_128();
    labeledstmt_129();
    labeledstmt_130();
    labeledstmt_131();
    labeledstmt_132();
  }
  action labeledstmt_48(){
    labeledstmt_123();
    labeledstmt_124();
    labeledstmt_125();
    labeledstmt_126();
    labeledstmt_127();
    labeledstmt_128();
    labeledstmt_129();
    labeledstmt_130();
    labeledstmt_131();
    labeledstmt_132();
  }
  action labeledstmt_49(){
    labeledstmt_123();
    labeledstmt_124();
  }
  action labeledstmt_50(){
    //NOOP
  }
  bit<32> forward_tango_pkt_arg_3;
  action labeledstmt_143(){
    forward_tango_pkt_arg_3=tango_tunnel_hdr_0;
  }
  bit<16> forward_tango_pkt_arg_4;
  action labeledstmt_142(){
    forward_tango_pkt_arg_4=tango_tunnel_hdr_1;
  }
  action labeledstmt_141(){
    hdr.forward_flow.setInvalid();
  }
  bit<8> forward_tango_pkt_arg_5;
  action labeledstmt_140(){
    forward_tango_pkt_arg_5=tango_tunnel_hdr_2;
  }
  bit<8> forward_tango_pkt_arg_6;
  action labeledstmt_139(){
    forward_tango_pkt_arg_6=tango_tunnel_hdr_3;
  }
  bit<64> forward_tango_pkt_arg_7;
  action labeledstmt_138(){
    forward_tango_pkt_arg_7=tango_tunnel_hdr_4;
  }
  bit<64> forward_tango_pkt_arg_8;
  action labeledstmt_137(){
    forward_tango_pkt_arg_8=tango_tunnel_hdr_5;
  }
  bit<64> forward_tango_pkt_arg_9;
  action labeledstmt_136(){
    forward_tango_pkt_arg_9=tango_tunnel_hdr_6;
  }
  bit<64> forward_tango_pkt_arg_10;
  action labeledstmt_135(){
    forward_tango_pkt_arg_10=tango_tunnel_hdr_7;
  }
  bit<16> seq_number;
  action labeledstmt_134(){
    seq_number=SequenceNumberManager_increment_ret;
  }
  bit<8> forward_tango_pkt_arg_15;
  action labeledstmt_133(){
    forward_tango_pkt_arg_15=tango_metrics_hdr_0;
  }
  action labeledstmt_51(){
    labeledstmt_133();
    labeledstmt_134();
    labeledstmt_135();
    labeledstmt_136();
    labeledstmt_137();
    labeledstmt_138();
    labeledstmt_139();
    labeledstmt_140();
    labeledstmt_141();
    labeledstmt_142();
    labeledstmt_143();
  }
  action labeledstmt_52(){
    //NOOP
  }
  bit<16> tango_metrics_hdr_3;
  action labeledstmt_144(){
    tango_metrics_hdr_3=seq_number;
  }
  action labeledstmt_53(){
    labeledstmt_144();
  }
  action labeledstmt_54(){
    //NOOP
  }
  bit<16> forward_tango_pkt_arg_18;
  action labeledstmt_145(){
    forward_tango_pkt_arg_18=tango_metrics_hdr_3;
  }
  action labeledstmt_55(){
    labeledstmt_145();
  }
  action labeledstmt_56(){
    //NOOP
  }
  action labeledstmt_57(){
    hdr.bridge_ev.incoming_tango_traffic=1;
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
    hdr.bridge_ev.port_event_id=2;
    ig_tm_md.ucast_egress_port=9w12;
  }
  table table_4333 {
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
  table table_4332 {
    key = {
      hdr.forward_flow.forward_flow_ip_header_6 : ternary;
      hdr.forward_flow.forward_flow_udp_header_1 : ternary;
      hdr.forward_flow.forward_flow_ip_header_9 : ternary;
      hdr.forward_flow.forward_flow_udp_header_0 : ternary;
      hdr.forward_flow.forward_flow_ip_header_8 : ternary;
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
      (_,_,_,5000,_,2) : labeledstmt_5();
      (_,_,_,5001,_,2) : labeledstmt_5();
      (_,_,_,5002,_,2) : labeledstmt_5();
      (_,_,_,5003,_,2) : labeledstmt_5();
      (_,_,_,5004,_,2) : labeledstmt_5();
      (_,_,_,5005,_,2) : labeledstmt_5();
      (_,_,_,5006,_,2) : labeledstmt_5();
      (_,_,_,5007,_,2) : labeledstmt_5();
      (_,_,_,6000,_,2) : labeledstmt_5();
      (_,_,_,6001,_,2) : labeledstmt_5();
      (_,_,_,6002,_,2) : labeledstmt_5();
      (_,_,_,6003,_,2) : labeledstmt_5();
      (_,_,_,6004,_,2) : labeledstmt_5();
      (_,_,_,6005,_,2) : labeledstmt_5();
      (_,_,_,6006,_,2) : labeledstmt_5();
      (_,_,_,6007,_,2) : labeledstmt_5();
      (_,_,_,5008,_,2) : labeledstmt_5();
      (_,_,_,_,_,2) : labeledstmt_5();
      (_,_,_,5000,_,1) : labeledstmt_6();
      (_,_,_,5001,_,1) : labeledstmt_7();
      (_,_,_,5002,_,1) : labeledstmt_8();
      (_,_,_,5003,_,1) : labeledstmt_9();
      (_,_,_,5004,_,1) : labeledstmt_10();
      (_,_,_,5005,_,1) : labeledstmt_11();
      (_,_,_,5006,_,1) : labeledstmt_12();
      (_,_,_,5007,_,1) : labeledstmt_13();
      (_,_,_,6000,_,1) : labeledstmt_14();
      (_,_,_,6001,_,1) : labeledstmt_15();
      (_,_,_,6002,_,1) : labeledstmt_16();
      (_,_,_,6003,_,1) : labeledstmt_17();
      (_,_,_,6004,_,1) : labeledstmt_18();
      (_,_,_,6005,_,1) : labeledstmt_19();
      (_,_,_,6006,_,1) : labeledstmt_20();
      (_,_,_,6007,_,1) : labeledstmt_21();
      (_,_,_,5008,_,1) : labeledstmt_22();
      (_,_,_,_,_,1) : labeledstmt_23();
      (_,_,_,_,_,_) : labeledstmt_5();
    } 
  } 
  table table_4331 {
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
  table table_4330 {
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
  table table_4329 {
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
  table table_4328 {
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
      labeledstmt_49;
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
      (2,15) : labeledstmt_32();
      (1,15) : labeledstmt_48();
      (2,_) : labeledstmt_32();
      (1,_) : labeledstmt_49();
      (_,_) : labeledstmt_32();
    } 
  } 
  table table_4327 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_50;
      labeledstmt_51;
    }
    const entries = {
      (2) : labeledstmt_50();
      (1) : labeledstmt_51();
      (_) : labeledstmt_50();
    } 
  } 
  table table_4326 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_52;
      labeledstmt_53;
    }
    const entries = {
      (2) : labeledstmt_52();
      (1) : labeledstmt_53();
      (_) : labeledstmt_52();
    } 
  } 
  table table_4325 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_54;
      labeledstmt_55;
    }
    const entries = {
      (2) : labeledstmt_54();
      (1) : labeledstmt_55();
      (_) : labeledstmt_54();
    } 
  } 
  table table_4324 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_56;
      labeledstmt_57;
    }
    const entries = {
      (2) : labeledstmt_56();
      (1) : labeledstmt_57();
      (_) : labeledstmt_56();
    } 
  } 
  apply {
    table_4333.apply();
    table_4332.apply();
    table_4331.apply();
    table_4330.apply();
    table_4329.apply();
    table_4328.apply();
    table_4327.apply();
    table_4326.apply();
    table_4325.apply();
    table_4324.apply();
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
  @pa_no_overlay("egress","hdr.update_route.update_route_udp_header_0")
  @pa_no_overlay("egress","hdr.update_route.update_route_udp_header_1")
  @pa_no_overlay("egress","hdr.update_route.update_route_udp_header_2")
  @pa_no_overlay("egress","hdr.update_route.update_route_udp_header_3")
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
      (3,196) : update_route_to_internal();
      (3,_) : update_route_to_external();
      (2,196) : incoming_tango_traffic_to_internal();
      (2,_) : incoming_tango_traffic_to_external();
      (1,196) : forward_flow_to_internal();
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
