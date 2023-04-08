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
  bit<6> flag_pad_2042;
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
  incoming_tango_traffic_t incoming_tango_traffic;
  forward_flow_t forward_flow;
}
struct meta_t {  }
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
  bit<8> merged_var_traffic_class_traffic_cls_2026;
  action labeledstmt_28(){
    hdr.incoming_tango_traffic.setInvalid();
  }
  action labeledstmt_1(){
    labeledstmt_28();
  }
  bit<13> if_precomp2011;
  action labeledstmt_30(){
    if_precomp2011=((hdr.forward_flow.forward_flow_udp_header_1[15:3])-13w0);
  }
  bit<12> if_precomp;
  action labeledstmt_29(){
    if_precomp=((hdr.forward_flow.forward_flow_udp_header_0[15:4])-12w0);
  }
  action labeledstmt_2(){
    labeledstmt_29();
    labeledstmt_30();
  }
  action labeledstmt_3(){
    //NOOP
  }
  action labeledstmt_4(){
    //NOOP
  }
  action labeledstmt_32(){
   
merged_var_traffic_class_traffic_cls_2026=(hdr.forward_flow.forward_flow_udp_header_0[7:0]);
  }
  bit<8> path_id;
  action labeledstmt_31(){
    path_id=(hdr.forward_flow.forward_flow_udp_header_1[7:0]);
  }
  action labeledstmt_5(){
    labeledstmt_31();
    labeledstmt_32();
  }
  action labeledstmt_42(){
    merged_var_traffic_class_traffic_cls_2026=8w0;
  }
  bit<8> RouteManager_get_path_id_ret;
  action labeledstmt_41(){
    RouteManager_get_path_id_ret=8w32;
  }
  bit<32> tango_tunnel_hdr_0;
  action labeledstmt_40(){
    tango_tunnel_hdr_0=32w6291456;
  }
  bit<16> tango_tunnel_hdr_1;
  action labeledstmt_39(){
    tango_tunnel_hdr_1=16w0;
  }
  bit<8> tango_tunnel_hdr_2;
  action labeledstmt_38(){
    tango_tunnel_hdr_2=8w17;
  }
  bit<8> tango_tunnel_hdr_3;
  action labeledstmt_37(){
    tango_tunnel_hdr_3=8w220;
  }
  bit<64> tango_tunnel_hdr_4;
  action labeledstmt_36(){
    tango_tunnel_hdr_4=64w57545994539572;
  }
  bit<64> tango_tunnel_hdr_5;
  action labeledstmt_35(){
    tango_tunnel_hdr_5=64w20015998341138;
  }
  bit<64> tango_tunnel_hdr_6;
  action labeledstmt_34(){
    tango_tunnel_hdr_6=64w0;
  }
  bit<64> tango_tunnel_hdr_7;
  action labeledstmt_33(){
    tango_tunnel_hdr_7=64w0;
  }
  action labeledstmt_6(){
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
  }
  action labeledstmt_7(){
    //NOOP
  }
  action labeledstmt_43(){
    merged_var_traffic_class_traffic_cls_2026=8w15;
  }
  action labeledstmt_8(){
    labeledstmt_43();
  }
  action labeledstmt_9(){
    //NOOP
  }
  RegisterAction<bit<8>,bit<8>,bit<8>>(route_manager_0)
  route_manager_0_regaction_2027 = {
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
  action labeledstmt_44(){
   
route_manager_0_regaction_2027.execute(merged_var_traffic_class_traffic_cls_2026);
  }
  action labeledstmt_10(){
    labeledstmt_44();
  }
  RegisterAction<bit<8>,bit<8>,bit<8>>(route_manager_0)
  route_manager_0_regaction_2028 = {
    void apply(inout bit<8> cell1_remote,
        out bit<8> ret_remote){
      bit<8> cell1_local=cell1_remote;
      bit<8> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_45(){
   
RouteManager_get_path_id_ret=route_manager_0_regaction_2028.execute(merged_var_traffic_class_traffic_cls_2026);
  }
  action labeledstmt_11(){
    labeledstmt_45();
  }
  action labeledstmt_12(){
    //NOOP
  }
  bit<8> path_id1688;
  action labeledstmt_46(){
    path_id1688=RouteManager_get_path_id_ret;
  }
  action labeledstmt_13(){
    labeledstmt_46();
  }
  action labeledstmt_14(){
    //NOOP
  }
  action labeledstmt_80(){
    tango_tunnel_hdr_0=32w6291456;
  }
  action labeledstmt_79(){
    tango_tunnel_hdr_1=(hdr.forward_flow.forward_flow_ip_header_2+16w18);
  }
  action labeledstmt_78(){
    tango_tunnel_hdr_2=8w17;
  }
  action labeledstmt_77(){
    tango_tunnel_hdr_3=8w220;
  }
  action labeledstmt_76(){
    tango_tunnel_hdr_4=64w57545994539572;
  }
  action labeledstmt_75(){
    tango_tunnel_hdr_5=64w20015998341138;
  }
  action labeledstmt_74(){
    tango_tunnel_hdr_6=64w2739390614536716288;
  }
  action labeledstmt_73(){
    tango_tunnel_hdr_7=64w1;
  }
  bit<16> SequenceNumberManager_increment_ret;
  action labeledstmt_72(){
    SequenceNumberManager_increment_ret=16w32;
  }
  bit<32> time_now;
  action labeledstmt_71(){
    time_now=(ig_intr_md.ingress_mac_tstamp[47:16]);
  }
  bit<8> tango_metrics_hdr_0;
  action labeledstmt_70(){
    tango_metrics_hdr_0=((bit<8>)path_id1688);
  }
  bit<32> tango_metrics_hdr_2;
  action labeledstmt_69(){
    tango_metrics_hdr_2=32w0;
  }
  bit<8> tango_metrics_hdr_4;
  action labeledstmt_68(){
    tango_metrics_hdr_4=8w0;
  }
  bit<48> forward_tango_pkt_arg_0;
  action labeledstmt_67(){
    forward_tango_pkt_arg_0=hdr.forward_flow.forward_flow_eth_header_0;
  }
  bit<48> forward_tango_pkt_arg_1;
  action labeledstmt_66(){
    forward_tango_pkt_arg_1=hdr.forward_flow.forward_flow_eth_header_1;
  }
  bit<16> forward_tango_pkt_arg_2;
  action labeledstmt_65(){
    forward_tango_pkt_arg_2=hdr.forward_flow.forward_flow_eth_header_2;
  }
  bit<16> forward_tango_pkt_arg_11;
  action labeledstmt_64(){
    forward_tango_pkt_arg_11=16w8080;
  }
  bit<16> forward_tango_pkt_arg_12;
  action labeledstmt_63(){
    forward_tango_pkt_arg_12=16w8080;
  }
  bit<16> forward_tango_pkt_arg_13;
  action labeledstmt_62(){
   
forward_tango_pkt_arg_13=(hdr.forward_flow.forward_flow_ip_header_2+16w18);
  }
  bit<16> forward_tango_pkt_arg_14;
  action labeledstmt_61(){
    forward_tango_pkt_arg_14=16w0;
  }
  bit<8> forward_tango_pkt_arg_20;
  action labeledstmt_60(){
    forward_tango_pkt_arg_20=hdr.forward_flow.forward_flow_ip_header_0;
  }
  bit<8> forward_tango_pkt_arg_21;
  action labeledstmt_59(){
    forward_tango_pkt_arg_21=hdr.forward_flow.forward_flow_ip_header_1;
  }
  bit<16> forward_tango_pkt_arg_22;
  action labeledstmt_58(){
    forward_tango_pkt_arg_22=hdr.forward_flow.forward_flow_ip_header_2;
  }
  bit<16> forward_tango_pkt_arg_23;
  action labeledstmt_57(){
    forward_tango_pkt_arg_23=hdr.forward_flow.forward_flow_ip_header_3;
  }
  bit<16> forward_tango_pkt_arg_24;
  action labeledstmt_56(){
    forward_tango_pkt_arg_24=hdr.forward_flow.forward_flow_ip_header_4;
  }
  bit<8> forward_tango_pkt_arg_25;
  action labeledstmt_55(){
    forward_tango_pkt_arg_25=hdr.forward_flow.forward_flow_ip_header_5;
  }
  bit<8> forward_tango_pkt_arg_26;
  action labeledstmt_54(){
    forward_tango_pkt_arg_26=hdr.forward_flow.forward_flow_ip_header_6;
  }
  bit<16> forward_tango_pkt_arg_27;
  action labeledstmt_53(){
    forward_tango_pkt_arg_27=hdr.forward_flow.forward_flow_ip_header_7;
  }
  bit<32> forward_tango_pkt_arg_28;
  action labeledstmt_52(){
    forward_tango_pkt_arg_28=hdr.forward_flow.forward_flow_ip_header_8;
  }
  bit<32> forward_tango_pkt_arg_29;
  action labeledstmt_51(){
    forward_tango_pkt_arg_29=hdr.forward_flow.forward_flow_ip_header_9;
  }
  bit<16> forward_tango_pkt_arg_30;
  action labeledstmt_50(){
    forward_tango_pkt_arg_30=hdr.forward_flow.forward_flow_udp_header_0;
  }
  bit<16> forward_tango_pkt_arg_31;
  action labeledstmt_49(){
    forward_tango_pkt_arg_31=hdr.forward_flow.forward_flow_udp_header_1;
  }
  bit<16> forward_tango_pkt_arg_32;
  action labeledstmt_48(){
    forward_tango_pkt_arg_32=hdr.forward_flow.forward_flow_udp_header_2;
  }
  bit<16> forward_tango_pkt_arg_33;
  action labeledstmt_47(){
    forward_tango_pkt_arg_33=hdr.forward_flow.forward_flow_udp_header_3;
  }
  action labeledstmt_15(){
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
  action labeledstmt_16(){
    //NOOP
  }
  bit<32> forward_tango_pkt_arg_3;
  action labeledstmt_93(){
    forward_tango_pkt_arg_3=tango_tunnel_hdr_0;
  }
  bit<16> forward_tango_pkt_arg_4;
  action labeledstmt_92(){
    forward_tango_pkt_arg_4=tango_tunnel_hdr_1;
  }
  bit<8> forward_tango_pkt_arg_5;
  action labeledstmt_91(){
    forward_tango_pkt_arg_5=tango_tunnel_hdr_2;
  }
  bit<8> forward_tango_pkt_arg_6;
  action labeledstmt_90(){
    forward_tango_pkt_arg_6=tango_tunnel_hdr_3;
  }
  bit<64> forward_tango_pkt_arg_7;
  action labeledstmt_89(){
    forward_tango_pkt_arg_7=tango_tunnel_hdr_4;
  }
  bit<64> forward_tango_pkt_arg_8;
  action labeledstmt_88(){
    forward_tango_pkt_arg_8=tango_tunnel_hdr_5;
  }
  bit<64> forward_tango_pkt_arg_9;
  action labeledstmt_87(){
    forward_tango_pkt_arg_9=tango_tunnel_hdr_6;
  }
  bit<64> forward_tango_pkt_arg_10;
  action labeledstmt_86(){
    forward_tango_pkt_arg_10=tango_tunnel_hdr_7;
  }
  RegisterAction<bit<16>,bit<8>,bit<16>>(sequence_counters_0)
  sequence_counters_0_regaction_2029 = {
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
   
SequenceNumberManager_increment_ret=sequence_counters_0_regaction_2029.execute(path_id1688);
  }
  bit<12> timestamp;
  action labeledstmt_84(){
    timestamp=(time_now[31:20]);
  }
  bit<8> forward_tango_pkt_arg_15;
  action labeledstmt_83(){
    forward_tango_pkt_arg_15=tango_metrics_hdr_0;
  }
  bit<32> forward_tango_pkt_arg_17;
  action labeledstmt_82(){
    forward_tango_pkt_arg_17=tango_metrics_hdr_2;
  }
  bit<8> forward_tango_pkt_arg_19;
  action labeledstmt_81(){
    forward_tango_pkt_arg_19=tango_metrics_hdr_4;
  }
  action labeledstmt_17(){
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
  action labeledstmt_18(){
    //NOOP
  }
  bit<16> seq_number;
  action labeledstmt_95(){
    seq_number=SequenceNumberManager_increment_ret;
  }
  bit<16> tango_metrics_hdr_1;
  action labeledstmt_94(){
    tango_metrics_hdr_1=((bit<16>)timestamp);
  }
  action labeledstmt_19(){
    labeledstmt_94();
    labeledstmt_95();
  }
  action labeledstmt_20(){
    //NOOP
  }
  bit<16> tango_metrics_hdr_3;
  action labeledstmt_97(){
    tango_metrics_hdr_3=seq_number;
  }
  bit<16> forward_tango_pkt_arg_16;
  action labeledstmt_96(){
    forward_tango_pkt_arg_16=tango_metrics_hdr_1;
  }
  action labeledstmt_21(){
    labeledstmt_96();
    labeledstmt_97();
  }
  action labeledstmt_22(){
    //NOOP
  }
  bit<16> forward_tango_pkt_arg_18;
  action labeledstmt_98(){
    forward_tango_pkt_arg_18=tango_metrics_hdr_3;
  }
  action labeledstmt_23(){
    labeledstmt_98();
  }
  action labeledstmt_24(){
    //NOOP
  }
  action labeledstmt_25(){
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
    ig_tm_md.ucast_egress_port=9w128;
  }
  action labeledstmt_26(){
    //NOOP
  }
  action labeledstmt_99(){
    hdr.forward_flow.setInvalid();
  }
  action labeledstmt_27(){
    labeledstmt_99();
  }
  table table_2041 {
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
  table table_2040 {
    key = {
      hdr.forward_flow.forward_flow_ip_header_6 : ternary;
      hdr.forward_flow.forward_flow_udp_header_1 : ternary;
      hdr.forward_flow.forward_flow_ip_header_9 : ternary;
      hdr.forward_flow.forward_flow_udp_header_0 : ternary;
      hdr.forward_flow.forward_flow_ip_header_8 : ternary;
      if_precomp2011 : ternary;
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
  table table_2039 {
    key = {
      hdr.forward_flow.forward_flow_ip_header_6 : ternary;
      hdr.forward_flow.forward_flow_udp_header_1 : ternary;
      hdr.forward_flow.forward_flow_ip_header_9 : ternary;
      hdr.forward_flow.forward_flow_udp_header_0 : ternary;
      hdr.forward_flow.forward_flow_ip_header_8 : ternary;
      if_precomp2011 : ternary;
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
  table table_2038 {
    key = {
      if_precomp2011 : ternary;
      if_precomp : ternary;
      hdr.wire_ev.event_id : ternary;
      hdr.forward_flow.forward_flow_ip_header_6 : ternary;
      hdr.forward_flow.forward_flow_udp_header_1 : ternary;
      hdr.forward_flow.forward_flow_ip_header_9 : ternary;
      hdr.forward_flow.forward_flow_udp_header_0 : ternary;
      hdr.forward_flow.forward_flow_ip_header_8 : ternary;
    }
    actions = {
      labeledstmt_9;
      labeledstmt_10;
      labeledstmt_11;
    }
    const entries = {
      (0,0,2,_,_,_,_,_) : labeledstmt_9();
      (0,0,1,_,_,_,_,_) : labeledstmt_10();
      (_,_,2,_,_,_,_,_) : labeledstmt_9();
      (_,_,1,_,_,_,_,_) : labeledstmt_11();
      (_,_,_,_,_,_,_,_) : labeledstmt_9();
    } 
  } 
  table table_2037 {
    key = {
      hdr.forward_flow.forward_flow_ip_header_6 : ternary;
      hdr.forward_flow.forward_flow_udp_header_1 : ternary;
      hdr.forward_flow.forward_flow_ip_header_9 : ternary;
      hdr.forward_flow.forward_flow_udp_header_0 : ternary;
      hdr.forward_flow.forward_flow_ip_header_8 : ternary;
      if_precomp2011 : ternary;
      if_precomp : ternary;
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_12;
      labeledstmt_13;
    }
    const entries = {
      (_,_,_,_,_,0,0,2) : labeledstmt_12();
      (_,_,_,_,_,0,0,1) : labeledstmt_12();
      (_,_,_,_,_,_,_,2) : labeledstmt_12();
      (_,_,_,_,_,_,_,1) : labeledstmt_13();
      (_,_,_,_,_,_,_,_) : labeledstmt_12();
    } 
  } 
  table table_2036 {
    key = {
      path_id1688 : ternary;
      hdr.forward_flow.forward_flow_ip_header_6 : ternary;
      hdr.forward_flow.forward_flow_udp_header_1 : ternary;
      hdr.forward_flow.forward_flow_ip_header_9 : ternary;
      hdr.forward_flow.forward_flow_udp_header_0 : ternary;
      hdr.forward_flow.forward_flow_ip_header_8 : ternary;
      if_precomp2011 : ternary;
      if_precomp : ternary;
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_14;
      labeledstmt_15;
    }
    const entries = {
      (_,_,_,_,_,_,0,0,2) : labeledstmt_14();
      (_,_,_,_,_,_,0,0,1) : labeledstmt_14();
      (_,_,_,_,_,_,_,_,2) : labeledstmt_14();
      (_,_,_,_,_,_,_,_,1) : labeledstmt_15();
      (_,_,_,_,_,_,_,_,_) : labeledstmt_14();
    } 
  } 
  table table_2035 {
    key = {
      path_id1688 : ternary;
      hdr.forward_flow.forward_flow_ip_header_6 : ternary;
      hdr.forward_flow.forward_flow_udp_header_1 : ternary;
      hdr.forward_flow.forward_flow_ip_header_9 : ternary;
      hdr.forward_flow.forward_flow_udp_header_0 : ternary;
      hdr.forward_flow.forward_flow_ip_header_8 : ternary;
      if_precomp2011 : ternary;
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
  table table_2034 {
    key = {
      path_id1688 : ternary;
      hdr.forward_flow.forward_flow_ip_header_6 : ternary;
      hdr.forward_flow.forward_flow_udp_header_1 : ternary;
      hdr.forward_flow.forward_flow_ip_header_9 : ternary;
      hdr.forward_flow.forward_flow_udp_header_0 : ternary;
      hdr.forward_flow.forward_flow_ip_header_8 : ternary;
      if_precomp2011 : ternary;
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
  table table_2033 {
    key = {
      path_id1688 : ternary;
      hdr.forward_flow.forward_flow_ip_header_6 : ternary;
      hdr.forward_flow.forward_flow_udp_header_1 : ternary;
      hdr.forward_flow.forward_flow_ip_header_9 : ternary;
      hdr.forward_flow.forward_flow_udp_header_0 : ternary;
      hdr.forward_flow.forward_flow_ip_header_8 : ternary;
      if_precomp2011 : ternary;
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
  table table_2032 {
    key = {
      path_id1688 : ternary;
      hdr.forward_flow.forward_flow_ip_header_6 : ternary;
      hdr.forward_flow.forward_flow_udp_header_1 : ternary;
      hdr.forward_flow.forward_flow_ip_header_9 : ternary;
      hdr.forward_flow.forward_flow_udp_header_0 : ternary;
      hdr.forward_flow.forward_flow_ip_header_8 : ternary;
      if_precomp2011 : ternary;
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
  table table_2031 {
    key = {
      path_id1688 : ternary;
      hdr.forward_flow.forward_flow_ip_header_6 : ternary;
      hdr.forward_flow.forward_flow_udp_header_1 : ternary;
      hdr.forward_flow.forward_flow_ip_header_9 : ternary;
      hdr.forward_flow.forward_flow_udp_header_0 : ternary;
      hdr.forward_flow.forward_flow_ip_header_8 : ternary;
      if_precomp2011 : ternary;
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
  table table_2030 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_26;
      labeledstmt_27;
    }
    const entries = {
      (2) : labeledstmt_26();
      (1) : labeledstmt_27();
      (_) : labeledstmt_26();
    } 
  } 
  apply {
    table_2041.apply();
    table_2040.apply();
    table_2039.apply();
    table_2038.apply();
    table_2037.apply();
    table_2036.apply();
    table_2035.apply();
    table_2034.apply();
    table_2033.apply();
    table_2032.apply();
    table_2031.apply();
    table_2030.apply();
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
