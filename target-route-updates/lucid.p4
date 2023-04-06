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
  bit<6> flag_pad_2409;
  bit<1> incoming_tango_traffic;
  bit<1> forward_flow;
}
header incoming_tango_traffic_t {
  bit<48> incoming_tango_traffic_tango_eth_header_0;
  bit<48> incoming_tango_traffic_tango_eth_header_1;
  bit<16> incoming_tango_traffic_tango_eth_header_2;
  bit<32> incoming_tango_traffic_tango_ip_header_0;
  bit<16> incoming_tango_traffic_tango_ip_header_1;
  bit<8> incoming_tango_traffic_tango_ip_header_2;
  bit<8> incoming_tango_traffic_tango_ip_header_3;
  bit<128> incoming_tango_traffic_tango_ip_header_4;
  bit<128> incoming_tango_traffic_tango_ip_header_5;
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
  incoming_tango_traffic_t incoming_tango_traffic;
  forward_flow_t forward_flow;
}
struct meta_t {  }
Register<bit<8>,_>(32w16) route_manager_0;
Register<bit<16>,_>(32w8) sequence_counters_0;
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
    hdr.wire_ev.event_id=1;
    hdr.bridge_ev.setValid();
    hdr.bridge_ev.port_event_id=0;
    hdr.bridge_ev.incoming_tango_traffic=0;
    hdr.bridge_ev.forward_flow=0;
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
      (2) : parse_incoming_tango_traffic;
      (1) : parse_forward_flow;
    }
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
  bit<8> merged_var_traffic_class_traffic_cls_2392;
  action labeledstmt_30(){
    hdr.incoming_tango_traffic.setInvalid();
  }
  action labeledstmt_1(){
    labeledstmt_30();
  }
  bit<13> if_precomp2377;
  action labeledstmt_32(){
    if_precomp2377=((hdr.forward_flow.forward_flow_udp_header_1[15:3])-13w0);
  }
  bit<12> if_precomp;
  action labeledstmt_31(){
    if_precomp=((hdr.forward_flow.forward_flow_udp_header_0[15:4])-12w0);
  }
  action labeledstmt_2(){
    labeledstmt_31();
    labeledstmt_32();
  }
  action labeledstmt_3(){
    //NOOP
  }
  action labeledstmt_4(){
    //NOOP
  }
  action labeledstmt_34(){
   
merged_var_traffic_class_traffic_cls_2392=(hdr.forward_flow.forward_flow_udp_header_0[7:0]);
  }
  bit<8> path_id;
  action labeledstmt_33(){
    path_id=(hdr.forward_flow.forward_flow_udp_header_1[7:0]);
  }
  action labeledstmt_5(){
    labeledstmt_33();
    labeledstmt_34();
  }
  bit<8> map_flow_to_traffic_class_ret;
  action labeledstmt_42(){
    map_flow_to_traffic_class_ret=8w32;
  }
  bit<8> RouteManager_get_path_id_ret;
  action labeledstmt_41(){
    RouteManager_get_path_id_ret=8w32;
  }
  bit<32> map_path_to_tunnel_header_ret_0;
  action labeledstmt_40(){
    map_path_to_tunnel_header_ret_0=32w32;
  }
  bit<16> map_path_to_tunnel_header_ret_1;
  action labeledstmt_39(){
    map_path_to_tunnel_header_ret_1=16w32;
  }
  bit<8> map_path_to_tunnel_header_ret_2;
  action labeledstmt_38(){
    map_path_to_tunnel_header_ret_2=8w32;
  }
  bit<8> map_path_to_tunnel_header_ret_3;
  action labeledstmt_37(){
    map_path_to_tunnel_header_ret_3=8w32;
  }
  bit<128> map_path_to_tunnel_header_ret_4;
  action labeledstmt_36(){
    map_path_to_tunnel_header_ret_4=128w32;
  }
  bit<128> map_path_to_tunnel_header_ret_5;
  action labeledstmt_35(){
    map_path_to_tunnel_header_ret_5=128w32;
  }
  action labeledstmt_6(){
    labeledstmt_35();
    labeledstmt_36();
    labeledstmt_37();
    labeledstmt_38();
    labeledstmt_39();
    labeledstmt_40();
    labeledstmt_41();
    labeledstmt_42();
  }
  action labeledstmt_7(){
    //NOOP
  }
  action labeledstmt_43(){
    map_flow_to_traffic_class_ret=8w15;
  }
  action labeledstmt_8(){
    labeledstmt_43();
  }
  action labeledstmt_9(){
    //NOOP
  }
  action labeledstmt_44(){
    merged_var_traffic_class_traffic_cls_2392=map_flow_to_traffic_class_ret;
  }
  action labeledstmt_10(){
    labeledstmt_44();
  }
  action labeledstmt_11(){
    //NOOP
  }
  RegisterAction<bit<8>,bit<8>,bit<8>>(route_manager_0)
  route_manager_0_regaction_2393 = {
    void apply(inout bit<8> cell1_remote,
        out bit<8> ret_remote){
      bit<8> cell1_local=cell1_remote;
      bit<8> cell2_local=0;
      if(true){
        cell1_remote=path_id;
      }
      //NOOP
    }
  };
  action labeledstmt_45(){
   
route_manager_0_regaction_2393.execute(merged_var_traffic_class_traffic_cls_2392);
  }
  action labeledstmt_12(){
    labeledstmt_45();
  }
  RegisterAction<bit<8>,bit<8>,bit<8>>(route_manager_0)
  route_manager_0_regaction_2394 = {
    void apply(inout bit<8> cell1_remote,
        out bit<8> ret_remote){
      bit<8> cell1_local=cell1_remote;
      bit<8> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_46(){
   
RouteManager_get_path_id_ret=route_manager_0_regaction_2394.execute(merged_var_traffic_class_traffic_cls_2392);
  }
  action labeledstmt_13(){
    labeledstmt_46();
  }
  action labeledstmt_14(){
    //NOOP
  }
  bit<8> path_id2044;
  action labeledstmt_47(){
    path_id2044=RouteManager_get_path_id_ret;
  }
  action labeledstmt_15(){
    labeledstmt_47();
  }
  action labeledstmt_16(){
    //NOOP
  }
  action labeledstmt_80(){
    map_path_to_tunnel_header_ret_0=32w0;
  }
  action labeledstmt_79(){
    map_path_to_tunnel_header_ret_1=16w0;
  }
  action labeledstmt_78(){
    map_path_to_tunnel_header_ret_2=8w0;
  }
  action labeledstmt_77(){
    map_path_to_tunnel_header_ret_3=8w0;
  }
  action labeledstmt_76(){
    map_path_to_tunnel_header_ret_4=128w0;
  }
  action labeledstmt_75(){
    map_path_to_tunnel_header_ret_5=128w0;
  }
  bit<16> SequenceNumberManager_increment_ret;
  action labeledstmt_74(){
    SequenceNumberManager_increment_ret=16w32;
  }
  bit<32> time_now;
  action labeledstmt_73(){
    time_now=(ig_intr_md.ingress_mac_tstamp[47:16]);
  }
  bit<8> tango_metrics_hdr_0;
  action labeledstmt_72(){
    tango_metrics_hdr_0=((bit<8>)path_id2044);
  }
  bit<32> tango_metrics_hdr_2;
  action labeledstmt_71(){
    tango_metrics_hdr_2=32w0;
  }
  bit<8> tango_metrics_hdr_4;
  action labeledstmt_70(){
    tango_metrics_hdr_4=8w0;
  }
  bit<48> forward_tango_pkt_arg_0;
  action labeledstmt_69(){
    forward_tango_pkt_arg_0=hdr.forward_flow.forward_flow_eth_header_0;
  }
  bit<48> forward_tango_pkt_arg_1;
  action labeledstmt_68(){
    forward_tango_pkt_arg_1=hdr.forward_flow.forward_flow_eth_header_1;
  }
  bit<16> forward_tango_pkt_arg_2;
  action labeledstmt_67(){
    forward_tango_pkt_arg_2=hdr.forward_flow.forward_flow_eth_header_2;
  }
  bit<16> forward_tango_pkt_arg_4;
  action labeledstmt_66(){
   
forward_tango_pkt_arg_4=(hdr.forward_flow.forward_flow_ip_header_2+16w18);
  }
  bit<16> forward_tango_pkt_arg_9;
  action labeledstmt_65(){
    forward_tango_pkt_arg_9=16w8080;
  }
  bit<16> forward_tango_pkt_arg_10;
  action labeledstmt_64(){
    forward_tango_pkt_arg_10=16w8080;
  }
  bit<16> forward_tango_pkt_arg_11;
  action labeledstmt_63(){
   
forward_tango_pkt_arg_11=(hdr.forward_flow.forward_flow_ip_header_2+16w18);
  }
  bit<16> forward_tango_pkt_arg_12;
  action labeledstmt_62(){
    forward_tango_pkt_arg_12=16w0;
  }
  bit<8> forward_tango_pkt_arg_18;
  action labeledstmt_61(){
    forward_tango_pkt_arg_18=hdr.forward_flow.forward_flow_ip_header_0;
  }
  bit<8> forward_tango_pkt_arg_19;
  action labeledstmt_60(){
    forward_tango_pkt_arg_19=hdr.forward_flow.forward_flow_ip_header_1;
  }
  bit<16> forward_tango_pkt_arg_20;
  action labeledstmt_59(){
    forward_tango_pkt_arg_20=hdr.forward_flow.forward_flow_ip_header_2;
  }
  bit<16> forward_tango_pkt_arg_21;
  action labeledstmt_58(){
    forward_tango_pkt_arg_21=hdr.forward_flow.forward_flow_ip_header_3;
  }
  bit<16> forward_tango_pkt_arg_22;
  action labeledstmt_57(){
    forward_tango_pkt_arg_22=hdr.forward_flow.forward_flow_ip_header_4;
  }
  bit<8> forward_tango_pkt_arg_23;
  action labeledstmt_56(){
    forward_tango_pkt_arg_23=hdr.forward_flow.forward_flow_ip_header_5;
  }
  bit<8> forward_tango_pkt_arg_24;
  action labeledstmt_55(){
    forward_tango_pkt_arg_24=hdr.forward_flow.forward_flow_ip_header_6;
  }
  bit<16> forward_tango_pkt_arg_25;
  action labeledstmt_54(){
    forward_tango_pkt_arg_25=hdr.forward_flow.forward_flow_ip_header_7;
  }
  bit<32> forward_tango_pkt_arg_26;
  action labeledstmt_53(){
    forward_tango_pkt_arg_26=hdr.forward_flow.forward_flow_ip_header_8;
  }
  bit<32> forward_tango_pkt_arg_27;
  action labeledstmt_52(){
    forward_tango_pkt_arg_27=hdr.forward_flow.forward_flow_ip_header_9;
  }
  bit<16> forward_tango_pkt_arg_28;
  action labeledstmt_51(){
    forward_tango_pkt_arg_28=hdr.forward_flow.forward_flow_udp_header_0;
  }
  bit<16> forward_tango_pkt_arg_29;
  action labeledstmt_50(){
    forward_tango_pkt_arg_29=hdr.forward_flow.forward_flow_udp_header_1;
  }
  bit<16> forward_tango_pkt_arg_30;
  action labeledstmt_49(){
    forward_tango_pkt_arg_30=hdr.forward_flow.forward_flow_udp_header_2;
  }
  bit<16> forward_tango_pkt_arg_31;
  action labeledstmt_48(){
    forward_tango_pkt_arg_31=hdr.forward_flow.forward_flow_udp_header_3;
  }
  action labeledstmt_17(){
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
  }
  action labeledstmt_18(){
    //NOOP
  }
  bit<32> tango_tunnel_hdr_0;
  action labeledstmt_91(){
    tango_tunnel_hdr_0=map_path_to_tunnel_header_ret_0;
  }
  bit<16> tango_tunnel_hdr_1;
  action labeledstmt_90(){
    tango_tunnel_hdr_1=map_path_to_tunnel_header_ret_1;
  }
  bit<8> tango_tunnel_hdr_2;
  action labeledstmt_89(){
    tango_tunnel_hdr_2=map_path_to_tunnel_header_ret_2;
  }
  bit<8> tango_tunnel_hdr_3;
  action labeledstmt_88(){
    tango_tunnel_hdr_3=map_path_to_tunnel_header_ret_3;
  }
  bit<128> tango_tunnel_hdr_4;
  action labeledstmt_87(){
    tango_tunnel_hdr_4=map_path_to_tunnel_header_ret_4;
  }
  bit<128> tango_tunnel_hdr_5;
  action labeledstmt_86(){
    tango_tunnel_hdr_5=map_path_to_tunnel_header_ret_5;
  }
  RegisterAction<bit<16>,bit<8>,bit<16>>(sequence_counters_0)
  sequence_counters_0_regaction_2395 = {
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
  action labeledstmt_85(){
   
SequenceNumberManager_increment_ret=sequence_counters_0_regaction_2395.execute(path_id2044);
  }
  bit<12> timestamp;
  action labeledstmt_84(){
    timestamp=(time_now[31:20]);
  }
  bit<8> forward_tango_pkt_arg_13;
  action labeledstmt_83(){
    forward_tango_pkt_arg_13=tango_metrics_hdr_0;
  }
  bit<32> forward_tango_pkt_arg_15;
  action labeledstmt_82(){
    forward_tango_pkt_arg_15=tango_metrics_hdr_2;
  }
  bit<8> forward_tango_pkt_arg_17;
  action labeledstmt_81(){
    forward_tango_pkt_arg_17=tango_metrics_hdr_4;
  }
  action labeledstmt_19(){
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
  }
  action labeledstmt_20(){
    //NOOP
  }
  bit<32> forward_tango_pkt_arg_3;
  action labeledstmt_98(){
    forward_tango_pkt_arg_3=tango_tunnel_hdr_0;
  }
  bit<8> forward_tango_pkt_arg_5;
  action labeledstmt_97(){
    forward_tango_pkt_arg_5=tango_tunnel_hdr_2;
  }
  bit<8> forward_tango_pkt_arg_6;
  action labeledstmt_96(){
    forward_tango_pkt_arg_6=tango_tunnel_hdr_3;
  }
  bit<128> forward_tango_pkt_arg_7;
  action labeledstmt_95(){
    forward_tango_pkt_arg_7=tango_tunnel_hdr_4;
  }
  bit<128> forward_tango_pkt_arg_8;
  action labeledstmt_94(){
    forward_tango_pkt_arg_8=tango_tunnel_hdr_5;
  }
  bit<16> seq_number;
  action labeledstmt_93(){
    seq_number=SequenceNumberManager_increment_ret;
  }
  bit<16> tango_metrics_hdr_1;
  action labeledstmt_92(){
    tango_metrics_hdr_1=((bit<16>)timestamp);
  }
  action labeledstmt_21(){
    labeledstmt_92();
    labeledstmt_93();
    labeledstmt_94();
    labeledstmt_95();
    labeledstmt_96();
    labeledstmt_97();
    labeledstmt_98();
  }
  action labeledstmt_22(){
    //NOOP
  }
  bit<16> tango_metrics_hdr_3;
  action labeledstmt_100(){
    tango_metrics_hdr_3=seq_number;
  }
  bit<16> forward_tango_pkt_arg_14;
  action labeledstmt_99(){
    forward_tango_pkt_arg_14=tango_metrics_hdr_1;
  }
  action labeledstmt_23(){
    labeledstmt_99();
    labeledstmt_100();
  }
  action labeledstmt_24(){
    //NOOP
  }
  bit<16> forward_tango_pkt_arg_16;
  action labeledstmt_101(){
    forward_tango_pkt_arg_16=tango_metrics_hdr_3;
  }
  action labeledstmt_25(){
    labeledstmt_101();
  }
  action labeledstmt_26(){
    //NOOP
  }
  action labeledstmt_27(){
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
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_udp_header_0=forward_tango_pkt_arg_9;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_udp_header_1=forward_tango_pkt_arg_10;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_udp_header_2=forward_tango_pkt_arg_11;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_udp_header_3=forward_tango_pkt_arg_12;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_metrics_header_0=forward_tango_pkt_arg_13;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_metrics_header_1=forward_tango_pkt_arg_14;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_metrics_header_2=forward_tango_pkt_arg_15;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_metrics_header_3=forward_tango_pkt_arg_16;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_metrics_header_4=forward_tango_pkt_arg_17;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_0=forward_tango_pkt_arg_18;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_1=forward_tango_pkt_arg_19;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_2=forward_tango_pkt_arg_20;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_3=forward_tango_pkt_arg_21;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_4=forward_tango_pkt_arg_22;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_5=forward_tango_pkt_arg_23;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_6=forward_tango_pkt_arg_24;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_7=forward_tango_pkt_arg_25;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_8=forward_tango_pkt_arg_26;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_9=forward_tango_pkt_arg_27;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_udp_header_0=forward_tango_pkt_arg_28;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_udp_header_1=forward_tango_pkt_arg_29;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_udp_header_2=forward_tango_pkt_arg_30;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_udp_header_3=forward_tango_pkt_arg_31;
    hdr.bridge_ev.port_event_id=2;
    ig_tm_md.ucast_egress_port=9w2;
  }
  action labeledstmt_28(){
    //NOOP
  }
  action labeledstmt_102(){
    hdr.forward_flow.setInvalid();
  }
  action labeledstmt_29(){
    labeledstmt_102();
  }
  table table_2408 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_1;
      labeledstmt_2;
      labeledstmt_3;
    }
    const entries = {
      (2) : labeledstmt_1();
      (1) : labeledstmt_2();
      (_) : labeledstmt_3();
    } 
  } 
  table table_2407 {
    key = {
      hdr.forward_flow.forward_flow_ip_header_6 : ternary;
      hdr.forward_flow.forward_flow_udp_header_1 : ternary;
      hdr.forward_flow.forward_flow_ip_header_9 : ternary;
      hdr.forward_flow.forward_flow_udp_header_0 : ternary;
      hdr.forward_flow.forward_flow_ip_header_8 : ternary;
      if_precomp2377 : ternary;
      if_precomp : ternary;
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_4;
      labeledstmt_5;
      labeledstmt_6;
    }
    const entries = {
      (_,_,_,_,_,0,0,2) : labeledstmt_4();
      (_,_,_,_,_,0,0,1) : labeledstmt_5();
      (_,_,_,_,_,_,_,2) : labeledstmt_4();
      (_,_,_,_,_,_,_,1) : labeledstmt_6();
      (_,_,_,_,_,_,_,_) : labeledstmt_4();
    } 
  } 
  table table_2406 {
    key = {
      hdr.forward_flow.forward_flow_ip_header_6 : ternary;
      hdr.forward_flow.forward_flow_udp_header_1 : ternary;
      hdr.forward_flow.forward_flow_ip_header_9 : ternary;
      hdr.forward_flow.forward_flow_udp_header_0 : ternary;
      hdr.forward_flow.forward_flow_ip_header_8 : ternary;
      if_precomp2377 : ternary;
      if_precomp : ternary;
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_7;
      labeledstmt_8;
    }
    const entries = {
      (_,_,_,_,_,0,0,2) : labeledstmt_7();
      (_,_,_,_,_,0,0,1) : labeledstmt_7();
      (_,_,_,_,_,_,_,2) : labeledstmt_7();
      (_,_,_,_,_,_,_,1) : labeledstmt_8();
      (_,_,_,_,_,_,_,_) : labeledstmt_7();
    } 
  } 
  table table_2405 {
    key = {
      hdr.forward_flow.forward_flow_ip_header_6 : ternary;
      hdr.forward_flow.forward_flow_udp_header_1 : ternary;
      hdr.forward_flow.forward_flow_ip_header_9 : ternary;
      hdr.forward_flow.forward_flow_udp_header_0 : ternary;
      hdr.forward_flow.forward_flow_ip_header_8 : ternary;
      if_precomp2377 : ternary;
      if_precomp : ternary;
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_9;
      labeledstmt_10;
    }
    const entries = {
      (_,_,_,_,_,0,0,2) : labeledstmt_9();
      (_,_,_,_,_,0,0,1) : labeledstmt_9();
      (_,_,_,_,_,_,_,2) : labeledstmt_9();
      (_,_,_,_,_,_,_,1) : labeledstmt_10();
      (_,_,_,_,_,_,_,_) : labeledstmt_9();
    } 
  } 
  table table_2404 {
    key = {
      if_precomp2377 : ternary;
      if_precomp : ternary;
      hdr.wire_ev.event_id : ternary;
      hdr.forward_flow.forward_flow_ip_header_6 : ternary;
      hdr.forward_flow.forward_flow_udp_header_1 : ternary;
      hdr.forward_flow.forward_flow_ip_header_9 : ternary;
      hdr.forward_flow.forward_flow_udp_header_0 : ternary;
      hdr.forward_flow.forward_flow_ip_header_8 : ternary;
    }
    actions = {
      labeledstmt_11;
      labeledstmt_12;
      labeledstmt_13;
    }
    const entries = {
      (0,0,2,_,_,_,_,_) : labeledstmt_11();
      (0,0,1,_,_,_,_,_) : labeledstmt_12();
      (_,_,2,_,_,_,_,_) : labeledstmt_11();
      (_,_,1,_,_,_,_,_) : labeledstmt_13();
      (_,_,_,_,_,_,_,_) : labeledstmt_11();
    } 
  } 
  table table_2403 {
    key = {
      hdr.forward_flow.forward_flow_ip_header_6 : ternary;
      hdr.forward_flow.forward_flow_udp_header_1 : ternary;
      hdr.forward_flow.forward_flow_ip_header_9 : ternary;
      hdr.forward_flow.forward_flow_udp_header_0 : ternary;
      hdr.forward_flow.forward_flow_ip_header_8 : ternary;
      if_precomp2377 : ternary;
      if_precomp : ternary;
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_14;
      labeledstmt_15;
    }
    const entries = {
      (_,_,_,_,_,0,0,2) : labeledstmt_14();
      (_,_,_,_,_,0,0,1) : labeledstmt_14();
      (_,_,_,_,_,_,_,2) : labeledstmt_14();
      (_,_,_,_,_,_,_,1) : labeledstmt_15();
      (_,_,_,_,_,_,_,_) : labeledstmt_14();
    } 
  } 
  table table_2402 {
    key = {
      path_id2044 : ternary;
      hdr.forward_flow.forward_flow_ip_header_6 : ternary;
      hdr.forward_flow.forward_flow_udp_header_1 : ternary;
      hdr.forward_flow.forward_flow_ip_header_9 : ternary;
      hdr.forward_flow.forward_flow_udp_header_0 : ternary;
      hdr.forward_flow.forward_flow_ip_header_8 : ternary;
      if_precomp2377 : ternary;
      if_precomp : ternary;
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_16;
      labeledstmt_17;
    }
    const entries = {
      (_,_,_,_,_,_,0,0,2) : labeledstmt_16();
      (_,_,_,_,_,_,0,0,1) : labeledstmt_16();
      (_,_,_,_,_,_,_,_,2) : labeledstmt_16();
      (_,_,_,_,_,_,_,_,1) : labeledstmt_17();
      (_,_,_,_,_,_,_,_,_) : labeledstmt_16();
    } 
  } 
  table table_2401 {
    key = {
      path_id2044 : ternary;
      hdr.forward_flow.forward_flow_ip_header_6 : ternary;
      hdr.forward_flow.forward_flow_udp_header_1 : ternary;
      hdr.forward_flow.forward_flow_ip_header_9 : ternary;
      hdr.forward_flow.forward_flow_udp_header_0 : ternary;
      hdr.forward_flow.forward_flow_ip_header_8 : ternary;
      if_precomp2377 : ternary;
      if_precomp : ternary;
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_18;
      labeledstmt_19;
    }
    const entries = {
      (_,_,_,_,_,_,0,0,2) : labeledstmt_18();
      (_,_,_,_,_,_,0,0,1) : labeledstmt_18();
      (_,_,_,_,_,_,_,_,2) : labeledstmt_18();
      (_,_,_,_,_,_,_,_,1) : labeledstmt_19();
      (_,_,_,_,_,_,_,_,_) : labeledstmt_18();
    } 
  } 
  table table_2400 {
    key = {
      path_id2044 : ternary;
      hdr.forward_flow.forward_flow_ip_header_6 : ternary;
      hdr.forward_flow.forward_flow_udp_header_1 : ternary;
      hdr.forward_flow.forward_flow_ip_header_9 : ternary;
      hdr.forward_flow.forward_flow_udp_header_0 : ternary;
      hdr.forward_flow.forward_flow_ip_header_8 : ternary;
      if_precomp2377 : ternary;
      if_precomp : ternary;
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_20;
      labeledstmt_21;
    }
    const entries = {
      (_,_,_,_,_,_,0,0,2) : labeledstmt_20();
      (_,_,_,_,_,_,0,0,1) : labeledstmt_20();
      (_,_,_,_,_,_,_,_,2) : labeledstmt_20();
      (_,_,_,_,_,_,_,_,1) : labeledstmt_21();
      (_,_,_,_,_,_,_,_,_) : labeledstmt_20();
    } 
  } 
  table table_2399 {
    key = {
      path_id2044 : ternary;
      hdr.forward_flow.forward_flow_ip_header_6 : ternary;
      hdr.forward_flow.forward_flow_udp_header_1 : ternary;
      hdr.forward_flow.forward_flow_ip_header_9 : ternary;
      hdr.forward_flow.forward_flow_udp_header_0 : ternary;
      hdr.forward_flow.forward_flow_ip_header_8 : ternary;
      if_precomp2377 : ternary;
      if_precomp : ternary;
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_22;
      labeledstmt_23;
    }
    const entries = {
      (_,_,_,_,_,_,0,0,2) : labeledstmt_22();
      (_,_,_,_,_,_,0,0,1) : labeledstmt_22();
      (_,_,_,_,_,_,_,_,2) : labeledstmt_22();
      (_,_,_,_,_,_,_,_,1) : labeledstmt_23();
      (_,_,_,_,_,_,_,_,_) : labeledstmt_22();
    } 
  } 
  table table_2398 {
    key = {
      path_id2044 : ternary;
      hdr.forward_flow.forward_flow_ip_header_6 : ternary;
      hdr.forward_flow.forward_flow_udp_header_1 : ternary;
      hdr.forward_flow.forward_flow_ip_header_9 : ternary;
      hdr.forward_flow.forward_flow_udp_header_0 : ternary;
      hdr.forward_flow.forward_flow_ip_header_8 : ternary;
      if_precomp2377 : ternary;
      if_precomp : ternary;
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_24;
      labeledstmt_25;
    }
    const entries = {
      (_,_,_,_,_,_,0,0,2) : labeledstmt_24();
      (_,_,_,_,_,_,0,0,1) : labeledstmt_24();
      (_,_,_,_,_,_,_,_,2) : labeledstmt_24();
      (_,_,_,_,_,_,_,_,1) : labeledstmt_25();
      (_,_,_,_,_,_,_,_,_) : labeledstmt_24();
    } 
  } 
  table table_2397 {
    key = {
      path_id2044 : ternary;
      hdr.forward_flow.forward_flow_ip_header_6 : ternary;
      hdr.forward_flow.forward_flow_udp_header_1 : ternary;
      hdr.forward_flow.forward_flow_ip_header_9 : ternary;
      hdr.forward_flow.forward_flow_udp_header_0 : ternary;
      hdr.forward_flow.forward_flow_ip_header_8 : ternary;
      if_precomp2377 : ternary;
      if_precomp : ternary;
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_26;
      labeledstmt_27;
    }
    const entries = {
      (_,_,_,_,_,_,0,0,2) : labeledstmt_26();
      (_,_,_,_,_,_,0,0,1) : labeledstmt_26();
      (_,_,_,_,_,_,_,_,2) : labeledstmt_26();
      (_,_,_,_,_,_,_,_,1) : labeledstmt_27();
      (_,_,_,_,_,_,_,_,_) : labeledstmt_26();
    } 
  } 
  table table_2396 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_28;
      labeledstmt_29;
    }
    const entries = {
      (2) : labeledstmt_28();
      (1) : labeledstmt_29();
      (_) : labeledstmt_28();
    } 
  } 
  apply {
    table_2408.apply();
    table_2407.apply();
    table_2406.apply();
    table_2405.apply();
    table_2404.apply();
    table_2403.apply();
    table_2402.apply();
    table_2401.apply();
    table_2400.apply();
    table_2399.apply();
    table_2398.apply();
    table_2397.apply();
    table_2396.apply();
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
    transition select(hdr.bridge_ev.incoming_tango_traffic,
hdr.bridge_ev.forward_flow){
      (1, 0) : parse_eventset_0;
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
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_tango_eth_header_0")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_tango_eth_header_1")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_tango_eth_header_2")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_0")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_1")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_2")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_3")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_4")
 
@pa_no_overlay("egress","hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_5")
 
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
  action incoming_tango_traffic_recirc(){
    hdr.forward_flow.setInvalid();
    hdr.wire_ev.event_id=2;
    hdr.bridge_ev.port_event_id=0;
    hdr.bridge_ev.incoming_tango_traffic=0;
    hdr.bridge_ev.forward_flow=0;
  }
  action forward_flow_recirc(){
    hdr.incoming_tango_traffic.setInvalid();
    hdr.wire_ev.event_id=1;
    hdr.bridge_ev.port_event_id=0;
    hdr.bridge_ev.incoming_tango_traffic=0;
    hdr.bridge_ev.forward_flow=0;
  }
  action incoming_tango_traffic_to_external(){
    hdr.lucid_eth.setInvalid();
    hdr.wire_ev.setInvalid();
    hdr.bridge_ev.setInvalid();
    hdr.forward_flow.setInvalid();
  }
  action forward_flow_to_external(){
    hdr.lucid_eth.setInvalid();
    hdr.wire_ev.setInvalid();
    hdr.bridge_ev.setInvalid();
    hdr.incoming_tango_traffic.setInvalid();
  }
  action incoming_tango_traffic_to_internal(){
    hdr.wire_ev.event_id=2;
    hdr.bridge_ev.port_event_id=0;
    hdr.bridge_ev.incoming_tango_traffic=0;
    hdr.bridge_ev.forward_flow=0;
    hdr.forward_flow.setInvalid();
  }
  action forward_flow_to_internal(){
    hdr.wire_ev.event_id=1;
    hdr.bridge_ev.port_event_id=0;
    hdr.bridge_ev.incoming_tango_traffic=0;
    hdr.bridge_ev.forward_flow=0;
    hdr.incoming_tango_traffic.setInvalid();
  }
  table t_extract_recirc_event {
    key = {
      eg_intr_md.egress_rid : ternary;
      hdr.bridge_ev.port_event_id : ternary;
      hdr.bridge_ev.incoming_tango_traffic : ternary;
      hdr.bridge_ev.forward_flow : ternary;
    }
    actions = {
      egr_noop;
      incoming_tango_traffic_recirc;
      forward_flow_recirc;
    }
    const entries = {
      (1,0,1,0) : incoming_tango_traffic_recirc();
      (_,_,_,_) : egr_noop();
    } 
  } 
  table t_extract_port_event {
    key = {
      hdr.bridge_ev.port_event_id : ternary;
      eg_intr_md.egress_port : ternary;
    }
    actions = {
      incoming_tango_traffic_to_external;
      incoming_tango_traffic_to_internal;
      forward_flow_to_external;
      forward_flow_to_internal;
    }
    const entries = {
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
