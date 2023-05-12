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
  bit<5> flag_pad_3971;
  bit<1> set_next_signature;
  bit<1> set_signature;
  bit<1> dummy_traffic;
}
header set_next_signature_t {
  bit<48> set_next_signature_eth_header_0;
  bit<48> set_next_signature_eth_header_1;
  bit<16> set_next_signature_eth_header_2;
  bit<32> set_next_signature_ip_header_0;
  bit<16> set_next_signature_ip_header_1;
  bit<8> set_next_signature_ip_header_2;
  bit<8> set_next_signature_ip_header_3;
  bit<64> set_next_signature_ip_header_4;
  bit<64> set_next_signature_ip_header_5;
  bit<64> set_next_signature_ip_header_6;
  bit<64> set_next_signature_ip_header_7;
  bit<16> set_next_signature_udp_header_0;
  bit<16> set_next_signature_udp_header_1;
  bit<16> set_next_signature_udp_header_2;
  bit<16> set_next_signature_udp_header_3;
  bit<8> set_next_signature_sig_type;
  bit<32> set_next_signature_sig_idx;
  bit<8> set_next_signature_block_idx;
  bit<32> set_next_signature_next_signature;
}
header set_signature_t {
  bit<48> set_signature_eth_header_0;
  bit<48> set_signature_eth_header_1;
  bit<16> set_signature_eth_header_2;
  bit<32> set_signature_ip_header_0;
  bit<16> set_signature_ip_header_1;
  bit<8> set_signature_ip_header_2;
  bit<8> set_signature_ip_header_3;
  bit<64> set_signature_ip_header_4;
  bit<64> set_signature_ip_header_5;
  bit<64> set_signature_ip_header_6;
  bit<64> set_signature_ip_header_7;
  bit<16> set_signature_udp_header_0;
  bit<16> set_signature_udp_header_1;
  bit<16> set_signature_udp_header_2;
  bit<16> set_signature_udp_header_3;
  bit<8> set_signature_sig_type;
  bit<32> set_signature_sig_idx;
  bit<8> set_signature_block_idx;
  bit<32> set_signature_curr_signature;
  bit<32> set_signature_next_signature;
}
header dummy_traffic_t {
  bit<48> dummy_traffic_eth_header_0;
  bit<48> dummy_traffic_eth_header_1;
  bit<16> dummy_traffic_eth_header_2;
  bit<8> dummy_traffic_ip_header_0;
  bit<8> dummy_traffic_ip_header_1;
  bit<16> dummy_traffic_ip_header_2;
  bit<16> dummy_traffic_ip_header_3;
  bit<16> dummy_traffic_ip_header_4;
  bit<8> dummy_traffic_ip_header_5;
  bit<8> dummy_traffic_ip_header_6;
  bit<16> dummy_traffic_ip_header_7;
  bit<32> dummy_traffic_ip_header_8;
  bit<32> dummy_traffic_ip_header_9;
  bit<16> dummy_traffic_udp_header_0;
  bit<16> dummy_traffic_udp_header_1;
  bit<16> dummy_traffic_udp_header_2;
  bit<16> dummy_traffic_udp_header_3;
}
struct hdr_t {
  lucid_eth_t lucid_eth;
  wire_ev_t wire_ev;
  bridge_ev_t bridge_ev;
  set_next_signature_t set_next_signature;
  set_signature_t set_signature;
  dummy_traffic_t dummy_traffic;
}
struct meta_t {
  bit<8> egress_event_id;
}
Register<bit<32>,_>(32w1) signature_count;
Register<bit<32>,_>(32w1) first_packet_seen;
Register<bit<32>,_>(32w1)
application_packet_counter;
Register<bit<32>,_>(32w2048)
outgoing_book_signature_manager_0;
Register<bit<32>,_>(32w2048)
outgoing_book_signature_manager_1;
Register<bit<32>,_>(32w16)
outgoing_metric_signature_manager_0;
Register<bit<32>,_>(32w16)
outgoing_metric_signature_manager_1;
Register<bit<32>,_>(32w1) num_pkt_finishes;
Register<bit<32>,_>(32w65536) pkt_finish_times;
//Main program components (ingress/egress parser, control, deparser)
parser IngressParser(packet_in pkt,
    out hdr_t hdr,
    out meta_t meta,
    out ingress_intrinsic_metadata_t ig_intr_md){
  state start {
    pkt.extract(ig_intr_md);
    pkt.advance(64);
    transition select(ig_intr_md.ingress_port){
      (68) : port_68_default_set_signature;
      (28) : port_28_default_set_signature;
      (4) : port_4_default_set_signature;
      (0) : parse_lucid_eth;
      (_) : default_setup;
    }
  }
  state default_setup {
    hdr.wire_ev.setValid();
    hdr.wire_ev.event_id=1;
    hdr.bridge_ev.setValid();
    hdr.bridge_ev.port_event_id=0;
    hdr.bridge_ev.set_next_signature=0;
    hdr.bridge_ev.set_signature=0;
    hdr.bridge_ev.dummy_traffic=0;
    transition parse_dummy_traffic;
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
      (3) : parse_set_next_signature;
      (2) : parse_set_signature;
      (1) : parse_dummy_traffic;
    }
  }
  state port_68_default_set_signature {
    hdr.wire_ev.setValid();
    hdr.bridge_ev.setValid();
    hdr.wire_ev.event_id=2;
    hdr.bridge_ev.set_next_signature=0;
    hdr.bridge_ev.set_signature=0;
    hdr.bridge_ev.dummy_traffic=0;
    transition parse_set_signature;
  }
  state port_28_default_set_signature {
    hdr.wire_ev.setValid();
    hdr.bridge_ev.setValid();
    hdr.wire_ev.event_id=2;
    hdr.bridge_ev.set_next_signature=0;
    hdr.bridge_ev.set_signature=0;
    hdr.bridge_ev.dummy_traffic=0;
    transition parse_set_signature;
  }
  state port_4_default_set_signature {
    hdr.wire_ev.setValid();
    hdr.bridge_ev.setValid();
    hdr.wire_ev.event_id=2;
    hdr.bridge_ev.set_next_signature=0;
    hdr.bridge_ev.set_signature=0;
    hdr.bridge_ev.dummy_traffic=0;
    transition parse_set_signature;
  }
  state parse_set_next_signature {
    pkt.extract(hdr.set_next_signature);
    transition accept;
  }
  state parse_set_signature {
    pkt.extract(hdr.set_signature);
    transition accept;
  }
  state parse_dummy_traffic {
    pkt.extract(hdr.dummy_traffic);
    transition accept;
  }
  state parse_all_events {
    pkt.extract(hdr.set_next_signature);
    pkt.extract(hdr.set_signature);
    pkt.extract(hdr.dummy_traffic);
    transition accept;
  }
}
control IngressControl(inout hdr_t hdr,
    inout meta_t meta,
    in ingress_intrinsic_metadata_t ig_intr_md,
    in ingress_intrinsic_metadata_from_parser_t ig_prsr_md,
    inout ingress_intrinsic_metadata_for_deparser_t ig_dprsr_md,
    inout ingress_intrinsic_metadata_for_tm_t ig_tm_md){
  bit<48> pre_gen_copy_dummy_traffic_eth_header_0;
  bit<48> pre_gen_copy_dummy_traffic_eth_header_1;
  bit<16> pre_gen_copy_dummy_traffic_eth_header_2;
  bit<8> pre_gen_copy_dummy_traffic_ip_header_0;
  bit<8> pre_gen_copy_dummy_traffic_ip_header_1;
  bit<16> pre_gen_copy_dummy_traffic_ip_header_2;
  bit<16> pre_gen_copy_dummy_traffic_ip_header_3;
  bit<16> pre_gen_copy_dummy_traffic_ip_header_4;
  bit<8> pre_gen_copy_dummy_traffic_ip_header_5;
  bit<8> pre_gen_copy_dummy_traffic_ip_header_6;
  bit<16> pre_gen_copy_dummy_traffic_ip_header_7;
  bit<32> pre_gen_copy_dummy_traffic_ip_header_8;
  bit<32> pre_gen_copy_dummy_traffic_ip_header_9;
  bit<16> pre_gen_copy_dummy_traffic_udp_header_0;
  bit<16> pre_gen_copy_dummy_traffic_udp_header_1;
  bit<16> pre_gen_copy_dummy_traffic_udp_header_2;
  bit<16> pre_gen_copy_dummy_traffic_udp_header_3;
  action labeledstmt_35(){
    hdr.set_next_signature.setInvalid();
  }
  action labeledstmt_1(){
    labeledstmt_35();
  }
  action labeledstmt_53(){
   
pre_gen_copy_dummy_traffic_udp_header_3=hdr.dummy_traffic.dummy_traffic_udp_header_3;
  }
  action labeledstmt_52(){
   
pre_gen_copy_dummy_traffic_udp_header_2=hdr.dummy_traffic.dummy_traffic_udp_header_2;
  }
  action labeledstmt_51(){
   
pre_gen_copy_dummy_traffic_udp_header_1=hdr.dummy_traffic.dummy_traffic_udp_header_1;
  }
  action labeledstmt_50(){
   
pre_gen_copy_dummy_traffic_udp_header_0=hdr.dummy_traffic.dummy_traffic_udp_header_0;
  }
  action labeledstmt_49(){
   
pre_gen_copy_dummy_traffic_ip_header_9=hdr.dummy_traffic.dummy_traffic_ip_header_9;
  }
  action labeledstmt_48(){
   
pre_gen_copy_dummy_traffic_ip_header_8=hdr.dummy_traffic.dummy_traffic_ip_header_8;
  }
  action labeledstmt_47(){
   
pre_gen_copy_dummy_traffic_ip_header_7=hdr.dummy_traffic.dummy_traffic_ip_header_7;
  }
  action labeledstmt_46(){
   
pre_gen_copy_dummy_traffic_ip_header_6=hdr.dummy_traffic.dummy_traffic_ip_header_6;
  }
  action labeledstmt_45(){
   
pre_gen_copy_dummy_traffic_ip_header_5=hdr.dummy_traffic.dummy_traffic_ip_header_5;
  }
  action labeledstmt_44(){
   
pre_gen_copy_dummy_traffic_ip_header_4=hdr.dummy_traffic.dummy_traffic_ip_header_4;
  }
  action labeledstmt_43(){
   
pre_gen_copy_dummy_traffic_ip_header_3=hdr.dummy_traffic.dummy_traffic_ip_header_3;
  }
  action labeledstmt_42(){
   
pre_gen_copy_dummy_traffic_ip_header_2=hdr.dummy_traffic.dummy_traffic_ip_header_2;
  }
  action labeledstmt_41(){
   
pre_gen_copy_dummy_traffic_ip_header_1=hdr.dummy_traffic.dummy_traffic_ip_header_1;
  }
  action labeledstmt_40(){
   
pre_gen_copy_dummy_traffic_ip_header_0=hdr.dummy_traffic.dummy_traffic_ip_header_0;
  }
  action labeledstmt_39(){
   
pre_gen_copy_dummy_traffic_eth_header_2=hdr.dummy_traffic.dummy_traffic_eth_header_2;
  }
  action labeledstmt_38(){
   
pre_gen_copy_dummy_traffic_eth_header_1=hdr.dummy_traffic.dummy_traffic_eth_header_1;
  }
  action labeledstmt_37(){
   
pre_gen_copy_dummy_traffic_eth_header_0=hdr.dummy_traffic.dummy_traffic_eth_header_0;
  }
  RegisterAction<bit<32>,bit<32>,bit<32>>(application_packet_counter)
  application_packet_counter_regaction_3949 = {
    void apply(inout bit<32> cell1_remote,
        out bit<32> ret_remote){
      bit<32> cell1_local=cell1_remote;
      bit<32> cell2_local=0;
      if(true){
        cell2_local=(cell1_local+32w1);
      }
      if(true){
        ret_remote=cell2_local;
      }
    }
  };
  action labeledstmt_36(){
    application_packet_counter_regaction_3949.execute(32w0);
  }
  action labeledstmt_2(){
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
    hdr.bridge_ev.dummy_traffic=1;
    hdr.dummy_traffic.setValid();
   
hdr.dummy_traffic.dummy_traffic_eth_header_0=hdr.dummy_traffic.dummy_traffic_eth_header_0;
   
hdr.dummy_traffic.dummy_traffic_eth_header_1=hdr.dummy_traffic.dummy_traffic_eth_header_1;
   
hdr.dummy_traffic.dummy_traffic_eth_header_2=hdr.dummy_traffic.dummy_traffic_eth_header_2;
   
hdr.dummy_traffic.dummy_traffic_ip_header_0=hdr.dummy_traffic.dummy_traffic_ip_header_0;
   
hdr.dummy_traffic.dummy_traffic_ip_header_1=hdr.dummy_traffic.dummy_traffic_ip_header_1;
   
hdr.dummy_traffic.dummy_traffic_ip_header_2=hdr.dummy_traffic.dummy_traffic_ip_header_2;
   
hdr.dummy_traffic.dummy_traffic_ip_header_3=hdr.dummy_traffic.dummy_traffic_ip_header_3;
   
hdr.dummy_traffic.dummy_traffic_ip_header_4=hdr.dummy_traffic.dummy_traffic_ip_header_4;
   
hdr.dummy_traffic.dummy_traffic_ip_header_5=hdr.dummy_traffic.dummy_traffic_ip_header_5;
   
hdr.dummy_traffic.dummy_traffic_ip_header_6=hdr.dummy_traffic.dummy_traffic_ip_header_6;
   
hdr.dummy_traffic.dummy_traffic_ip_header_7=hdr.dummy_traffic.dummy_traffic_ip_header_7;
   
hdr.dummy_traffic.dummy_traffic_ip_header_8=hdr.dummy_traffic.dummy_traffic_ip_header_8;
   
hdr.dummy_traffic.dummy_traffic_ip_header_9=hdr.dummy_traffic.dummy_traffic_ip_header_9;
   
hdr.dummy_traffic.dummy_traffic_udp_header_0=hdr.dummy_traffic.dummy_traffic_udp_header_0;
   
hdr.dummy_traffic.dummy_traffic_udp_header_1=hdr.dummy_traffic.dummy_traffic_udp_header_1;
   
hdr.dummy_traffic.dummy_traffic_udp_header_2=hdr.dummy_traffic.dummy_traffic_udp_header_2;
   
hdr.dummy_traffic.dummy_traffic_udp_header_3=hdr.dummy_traffic.dummy_traffic_udp_header_3;
    hdr.bridge_ev.port_event_id=1;
    ig_tm_md.ucast_egress_port=9w12;
  }
  bit<32> precompute3910;
  action labeledstmt_56(){
    precompute3910=(ig_intr_md.ingress_mac_tstamp[47:16]);
  }
  bit<32> if_precomp;
  action labeledstmt_55(){
    if_precomp=(((bit<32>)hdr.set_signature.set_signature_sig_type)-32w0);
  }
  bit<16> sig_idx_copy;
  CRCPolynomial<bit<16>>(1,false, false, false, 0, 0) hash_39500_crc;
  Hash<bit<16>>(HashAlgorithm_t.CUSTOM,hash_39500_crc) hash_39500;
  action labeledstmt_54(){
    sig_idx_copy=hash_39500.get({hdr.set_signature.set_signature_sig_idx});
  }
  action labeledstmt_3(){
    labeledstmt_54();
    labeledstmt_55();
    labeledstmt_56();
  }
  bit<32> precompute3909;
  action labeledstmt_58(){
    precompute3909=(32w1+hdr.set_signature.set_signature_sig_idx);
  }
  bit<16> precompute3908;
  action labeledstmt_57(){
    precompute3908=(hdr.set_signature.set_signature_ip_header_1-16w32);
  }
  action labeledstmt_4(){
    labeledstmt_54();
    labeledstmt_55();
    labeledstmt_57();
    labeledstmt_58();
  }
  action labeledstmt_5(){
    //NOOP
  }
  action labeledstmt_6(){
    //NOOP
  }
  bit<32> sig_copy;
  CRCPolynomial<bit<32>>(1,false, false, false, 0, 0) hash_39510_crc;
  Hash<bit<32>>(HashAlgorithm_t.CUSTOM,hash_39510_crc) hash_39510;
  action labeledstmt_60(){
   
sig_copy=hash_39510.get({hdr.set_signature.set_signature_curr_signature});
  }
  bit<32> seen_idx;
  RegisterAction<bit<32>,bit<32>,bit<32>>(signature_count)
  signature_count_regaction_3952 = {
    void apply(inout bit<32> cell1_remote,
        out bit<32> ret_remote){
      bit<32> cell1_local=cell1_remote;
      bit<32> cell2_local=0;
      if(true){
        cell1_remote=(cell1_local+32w1);
      }
      if(true){
        cell2_local=cell1_local;
      }
      if(true){
        ret_remote=cell2_local;
      }
    }
  };
  action labeledstmt_59(){
    seen_idx=signature_count_regaction_3952.execute(32w0);
  }
  action labeledstmt_7(){
    labeledstmt_59();
    labeledstmt_60();
  }
  action labeledstmt_8(){
    //NOOP
  }
  bit<32> done_idx;
  RegisterAction<bit<32>,bit<32>,bit<32>>(num_pkt_finishes)
  num_pkt_finishes_regaction_3953 = {
    void apply(inout bit<32> cell1_remote,
        out bit<32> ret_remote){
      bit<32> cell1_local=cell1_remote;
      bit<32> cell2_local=0;
      if(true){
        cell1_remote=(cell1_local+32w1);
      }
      if(true){
        cell2_local=cell1_local;
      }
      if(true){
        ret_remote=cell2_local;
      }
    }
  };
  action labeledstmt_62(){
    done_idx=num_pkt_finishes_regaction_3953.execute(32w0);
  }
  bit<8> block_idx_copy;
  CRCPolynomial<bit<8>>(1,false, false, false, 0, 0) hash_39540_crc;
  Hash<bit<8>>(HashAlgorithm_t.CUSTOM,hash_39540_crc) hash_39540;
  action labeledstmt_61(){
   
block_idx_copy=hash_39540.get({hdr.set_signature.set_signature_block_idx});
  }
  action labeledstmt_9(){
    labeledstmt_61();
    labeledstmt_62();
  }
  action labeledstmt_10(){
    labeledstmt_61();
  }
  action labeledstmt_11(){
    //NOOP
  }
  bit<32> precompute;
  action labeledstmt_63(){
    precompute=(ig_intr_md.ingress_mac_tstamp[47:16]);
  }
  action labeledstmt_12(){
    labeledstmt_63();
  }
  RegisterAction<bit<32>,bit<16>,bit<32>>(outgoing_book_signature_manager_1)
  outgoing_book_signature_manager_1_regaction_3955 = {
    void apply(inout bit<32> cell1_remote,
        out bit<32> ret_remote){
      bit<32> cell1_local=cell1_remote;
      bit<32> cell2_local=0;
      if(true){
        cell1_remote=sig_copy;
      }
      //NOOP
    }
  };
  action labeledstmt_64(){
    outgoing_book_signature_manager_1_regaction_3955.execute(sig_idx_copy);
  }
  action labeledstmt_13(){
    labeledstmt_63();
    labeledstmt_64();
  }
  action labeledstmt_14(){
    labeledstmt_64();
  }
  bit<16> sig_addr;
  action labeledstmt_65(){
    sig_addr=((bit<16>)hdr.set_signature.set_signature_sig_idx);
  }
  action labeledstmt_15(){
    labeledstmt_63();
    labeledstmt_65();
  }
  action labeledstmt_16(){
    labeledstmt_65();
  }
  action labeledstmt_17(){
    labeledstmt_63();
    hdr.bridge_ev.set_next_signature=1;
    hdr.set_next_signature.setValid();
   
hdr.set_next_signature.set_next_signature_eth_header_0=hdr.set_signature.set_signature_eth_header_0;
   
hdr.set_next_signature.set_next_signature_eth_header_1=hdr.set_signature.set_signature_eth_header_1;
   
hdr.set_next_signature.set_next_signature_eth_header_2=hdr.set_signature.set_signature_eth_header_2;
   
hdr.set_next_signature.set_next_signature_ip_header_0=hdr.set_signature.set_signature_ip_header_0;
    hdr.set_next_signature.set_next_signature_ip_header_1=precompute3908;
   
hdr.set_next_signature.set_next_signature_ip_header_2=hdr.set_signature.set_signature_ip_header_2;
   
hdr.set_next_signature.set_next_signature_ip_header_3=hdr.set_signature.set_signature_ip_header_3;
   
hdr.set_next_signature.set_next_signature_ip_header_4=hdr.set_signature.set_signature_ip_header_4;
   
hdr.set_next_signature.set_next_signature_ip_header_5=hdr.set_signature.set_signature_ip_header_5;
   
hdr.set_next_signature.set_next_signature_ip_header_6=hdr.set_signature.set_signature_ip_header_6;
   
hdr.set_next_signature.set_next_signature_ip_header_7=hdr.set_signature.set_signature_ip_header_7;
   
hdr.set_next_signature.set_next_signature_udp_header_0=hdr.set_signature.set_signature_udp_header_0;
   
hdr.set_next_signature.set_next_signature_udp_header_1=hdr.set_signature.set_signature_udp_header_1;
   
hdr.set_next_signature.set_next_signature_udp_header_2=hdr.set_signature.set_signature_udp_header_2;
   
hdr.set_next_signature.set_next_signature_udp_header_3=hdr.set_signature.set_signature_udp_header_3;
   
hdr.set_next_signature.set_next_signature_sig_type=hdr.set_signature.set_signature_sig_type;
    hdr.set_next_signature.set_next_signature_sig_idx=precompute3909;
   
hdr.set_next_signature.set_next_signature_block_idx=hdr.set_signature.set_signature_block_idx;
   
hdr.set_next_signature.set_next_signature_next_signature=hdr.set_signature.set_signature_next_signature;
    hdr.bridge_ev.port_event_id=3;
    ig_tm_md.ucast_egress_port=9w68;
  }
  action labeledstmt_18(){
    hdr.bridge_ev.set_next_signature=1;
    hdr.set_next_signature.setValid();
   
hdr.set_next_signature.set_next_signature_eth_header_0=hdr.set_signature.set_signature_eth_header_0;
   
hdr.set_next_signature.set_next_signature_eth_header_1=hdr.set_signature.set_signature_eth_header_1;
   
hdr.set_next_signature.set_next_signature_eth_header_2=hdr.set_signature.set_signature_eth_header_2;
   
hdr.set_next_signature.set_next_signature_ip_header_0=hdr.set_signature.set_signature_ip_header_0;
    hdr.set_next_signature.set_next_signature_ip_header_1=precompute3908;
   
hdr.set_next_signature.set_next_signature_ip_header_2=hdr.set_signature.set_signature_ip_header_2;
   
hdr.set_next_signature.set_next_signature_ip_header_3=hdr.set_signature.set_signature_ip_header_3;
   
hdr.set_next_signature.set_next_signature_ip_header_4=hdr.set_signature.set_signature_ip_header_4;
   
hdr.set_next_signature.set_next_signature_ip_header_5=hdr.set_signature.set_signature_ip_header_5;
   
hdr.set_next_signature.set_next_signature_ip_header_6=hdr.set_signature.set_signature_ip_header_6;
   
hdr.set_next_signature.set_next_signature_ip_header_7=hdr.set_signature.set_signature_ip_header_7;
   
hdr.set_next_signature.set_next_signature_udp_header_0=hdr.set_signature.set_signature_udp_header_0;
   
hdr.set_next_signature.set_next_signature_udp_header_1=hdr.set_signature.set_signature_udp_header_1;
   
hdr.set_next_signature.set_next_signature_udp_header_2=hdr.set_signature.set_signature_udp_header_2;
   
hdr.set_next_signature.set_next_signature_udp_header_3=hdr.set_signature.set_signature_udp_header_3;
   
hdr.set_next_signature.set_next_signature_sig_type=hdr.set_signature.set_signature_sig_type;
    hdr.set_next_signature.set_next_signature_sig_idx=precompute3909;
   
hdr.set_next_signature.set_next_signature_block_idx=hdr.set_signature.set_signature_block_idx;
   
hdr.set_next_signature.set_next_signature_next_signature=hdr.set_signature.set_signature_next_signature;
    hdr.bridge_ev.port_event_id=3;
    ig_tm_md.ucast_egress_port=9w68;
  }
  action labeledstmt_19(){
    labeledstmt_63();
    labeledstmt_64();
    hdr.bridge_ev.set_next_signature=1;
    hdr.set_next_signature.setValid();
   
hdr.set_next_signature.set_next_signature_eth_header_0=hdr.set_signature.set_signature_eth_header_0;
   
hdr.set_next_signature.set_next_signature_eth_header_1=hdr.set_signature.set_signature_eth_header_1;
   
hdr.set_next_signature.set_next_signature_eth_header_2=hdr.set_signature.set_signature_eth_header_2;
   
hdr.set_next_signature.set_next_signature_ip_header_0=hdr.set_signature.set_signature_ip_header_0;
    hdr.set_next_signature.set_next_signature_ip_header_1=precompute3908;
   
hdr.set_next_signature.set_next_signature_ip_header_2=hdr.set_signature.set_signature_ip_header_2;
   
hdr.set_next_signature.set_next_signature_ip_header_3=hdr.set_signature.set_signature_ip_header_3;
   
hdr.set_next_signature.set_next_signature_ip_header_4=hdr.set_signature.set_signature_ip_header_4;
   
hdr.set_next_signature.set_next_signature_ip_header_5=hdr.set_signature.set_signature_ip_header_5;
   
hdr.set_next_signature.set_next_signature_ip_header_6=hdr.set_signature.set_signature_ip_header_6;
   
hdr.set_next_signature.set_next_signature_ip_header_7=hdr.set_signature.set_signature_ip_header_7;
   
hdr.set_next_signature.set_next_signature_udp_header_0=hdr.set_signature.set_signature_udp_header_0;
   
hdr.set_next_signature.set_next_signature_udp_header_1=hdr.set_signature.set_signature_udp_header_1;
   
hdr.set_next_signature.set_next_signature_udp_header_2=hdr.set_signature.set_signature_udp_header_2;
   
hdr.set_next_signature.set_next_signature_udp_header_3=hdr.set_signature.set_signature_udp_header_3;
   
hdr.set_next_signature.set_next_signature_sig_type=hdr.set_signature.set_signature_sig_type;
    hdr.set_next_signature.set_next_signature_sig_idx=precompute3909;
   
hdr.set_next_signature.set_next_signature_block_idx=hdr.set_signature.set_signature_block_idx;
   
hdr.set_next_signature.set_next_signature_next_signature=hdr.set_signature.set_signature_next_signature;
    hdr.bridge_ev.port_event_id=3;
    ig_tm_md.ucast_egress_port=9w68;
  }
  action labeledstmt_20(){
    labeledstmt_64();
    hdr.bridge_ev.set_next_signature=1;
    hdr.set_next_signature.setValid();
   
hdr.set_next_signature.set_next_signature_eth_header_0=hdr.set_signature.set_signature_eth_header_0;
   
hdr.set_next_signature.set_next_signature_eth_header_1=hdr.set_signature.set_signature_eth_header_1;
   
hdr.set_next_signature.set_next_signature_eth_header_2=hdr.set_signature.set_signature_eth_header_2;
   
hdr.set_next_signature.set_next_signature_ip_header_0=hdr.set_signature.set_signature_ip_header_0;
    hdr.set_next_signature.set_next_signature_ip_header_1=precompute3908;
   
hdr.set_next_signature.set_next_signature_ip_header_2=hdr.set_signature.set_signature_ip_header_2;
   
hdr.set_next_signature.set_next_signature_ip_header_3=hdr.set_signature.set_signature_ip_header_3;
   
hdr.set_next_signature.set_next_signature_ip_header_4=hdr.set_signature.set_signature_ip_header_4;
   
hdr.set_next_signature.set_next_signature_ip_header_5=hdr.set_signature.set_signature_ip_header_5;
   
hdr.set_next_signature.set_next_signature_ip_header_6=hdr.set_signature.set_signature_ip_header_6;
   
hdr.set_next_signature.set_next_signature_ip_header_7=hdr.set_signature.set_signature_ip_header_7;
   
hdr.set_next_signature.set_next_signature_udp_header_0=hdr.set_signature.set_signature_udp_header_0;
   
hdr.set_next_signature.set_next_signature_udp_header_1=hdr.set_signature.set_signature_udp_header_1;
   
hdr.set_next_signature.set_next_signature_udp_header_2=hdr.set_signature.set_signature_udp_header_2;
   
hdr.set_next_signature.set_next_signature_udp_header_3=hdr.set_signature.set_signature_udp_header_3;
   
hdr.set_next_signature.set_next_signature_sig_type=hdr.set_signature.set_signature_sig_type;
    hdr.set_next_signature.set_next_signature_sig_idx=precompute3909;
   
hdr.set_next_signature.set_next_signature_block_idx=hdr.set_signature.set_signature_block_idx;
   
hdr.set_next_signature.set_next_signature_next_signature=hdr.set_signature.set_signature_next_signature;
    hdr.bridge_ev.port_event_id=3;
    ig_tm_md.ucast_egress_port=9w68;
  }
  action labeledstmt_21(){
    labeledstmt_63();
    labeledstmt_65();
    hdr.bridge_ev.set_next_signature=1;
    hdr.set_next_signature.setValid();
   
hdr.set_next_signature.set_next_signature_eth_header_0=hdr.set_signature.set_signature_eth_header_0;
   
hdr.set_next_signature.set_next_signature_eth_header_1=hdr.set_signature.set_signature_eth_header_1;
   
hdr.set_next_signature.set_next_signature_eth_header_2=hdr.set_signature.set_signature_eth_header_2;
   
hdr.set_next_signature.set_next_signature_ip_header_0=hdr.set_signature.set_signature_ip_header_0;
    hdr.set_next_signature.set_next_signature_ip_header_1=precompute3908;
   
hdr.set_next_signature.set_next_signature_ip_header_2=hdr.set_signature.set_signature_ip_header_2;
   
hdr.set_next_signature.set_next_signature_ip_header_3=hdr.set_signature.set_signature_ip_header_3;
   
hdr.set_next_signature.set_next_signature_ip_header_4=hdr.set_signature.set_signature_ip_header_4;
   
hdr.set_next_signature.set_next_signature_ip_header_5=hdr.set_signature.set_signature_ip_header_5;
   
hdr.set_next_signature.set_next_signature_ip_header_6=hdr.set_signature.set_signature_ip_header_6;
   
hdr.set_next_signature.set_next_signature_ip_header_7=hdr.set_signature.set_signature_ip_header_7;
   
hdr.set_next_signature.set_next_signature_udp_header_0=hdr.set_signature.set_signature_udp_header_0;
   
hdr.set_next_signature.set_next_signature_udp_header_1=hdr.set_signature.set_signature_udp_header_1;
   
hdr.set_next_signature.set_next_signature_udp_header_2=hdr.set_signature.set_signature_udp_header_2;
   
hdr.set_next_signature.set_next_signature_udp_header_3=hdr.set_signature.set_signature_udp_header_3;
   
hdr.set_next_signature.set_next_signature_sig_type=hdr.set_signature.set_signature_sig_type;
    hdr.set_next_signature.set_next_signature_sig_idx=precompute3909;
   
hdr.set_next_signature.set_next_signature_block_idx=hdr.set_signature.set_signature_block_idx;
   
hdr.set_next_signature.set_next_signature_next_signature=hdr.set_signature.set_signature_next_signature;
    hdr.bridge_ev.port_event_id=3;
    ig_tm_md.ucast_egress_port=9w68;
  }
  action labeledstmt_22(){
    labeledstmt_65();
    hdr.bridge_ev.set_next_signature=1;
    hdr.set_next_signature.setValid();
   
hdr.set_next_signature.set_next_signature_eth_header_0=hdr.set_signature.set_signature_eth_header_0;
   
hdr.set_next_signature.set_next_signature_eth_header_1=hdr.set_signature.set_signature_eth_header_1;
   
hdr.set_next_signature.set_next_signature_eth_header_2=hdr.set_signature.set_signature_eth_header_2;
   
hdr.set_next_signature.set_next_signature_ip_header_0=hdr.set_signature.set_signature_ip_header_0;
    hdr.set_next_signature.set_next_signature_ip_header_1=precompute3908;
   
hdr.set_next_signature.set_next_signature_ip_header_2=hdr.set_signature.set_signature_ip_header_2;
   
hdr.set_next_signature.set_next_signature_ip_header_3=hdr.set_signature.set_signature_ip_header_3;
   
hdr.set_next_signature.set_next_signature_ip_header_4=hdr.set_signature.set_signature_ip_header_4;
   
hdr.set_next_signature.set_next_signature_ip_header_5=hdr.set_signature.set_signature_ip_header_5;
   
hdr.set_next_signature.set_next_signature_ip_header_6=hdr.set_signature.set_signature_ip_header_6;
   
hdr.set_next_signature.set_next_signature_ip_header_7=hdr.set_signature.set_signature_ip_header_7;
   
hdr.set_next_signature.set_next_signature_udp_header_0=hdr.set_signature.set_signature_udp_header_0;
   
hdr.set_next_signature.set_next_signature_udp_header_1=hdr.set_signature.set_signature_udp_header_1;
   
hdr.set_next_signature.set_next_signature_udp_header_2=hdr.set_signature.set_signature_udp_header_2;
   
hdr.set_next_signature.set_next_signature_udp_header_3=hdr.set_signature.set_signature_udp_header_3;
   
hdr.set_next_signature.set_next_signature_sig_type=hdr.set_signature.set_signature_sig_type;
    hdr.set_next_signature.set_next_signature_sig_idx=precompute3909;
   
hdr.set_next_signature.set_next_signature_block_idx=hdr.set_signature.set_signature_block_idx;
   
hdr.set_next_signature.set_next_signature_next_signature=hdr.set_signature.set_signature_next_signature;
    hdr.bridge_ev.port_event_id=3;
    ig_tm_md.ucast_egress_port=9w68;
  }
  action labeledstmt_23(){
    //NOOP
  }
  RegisterAction<bit<32>,bit<16>,bit<32>>(outgoing_book_signature_manager_0)
  outgoing_book_signature_manager_0_regaction_3956 = {
    void apply(inout bit<32> cell1_remote,
        out bit<32> ret_remote){
      bit<32> cell1_local=cell1_remote;
      bit<32> cell2_local=0;
      if(true){
        cell1_remote=sig_copy;
      }
      //NOOP
    }
  };
  action labeledstmt_66(){
    outgoing_book_signature_manager_0_regaction_3956.execute(sig_idx_copy);
  }
  action labeledstmt_24(){
    labeledstmt_66();
  }
  action labeledstmt_25(){
    //NOOP
  }
  RegisterAction<bit<32>,bit<32>,bit<32>>(pkt_finish_times)
  pkt_finish_times_regaction_3957 = {
    void apply(inout bit<32> cell1_remote,
        out bit<32> ret_remote){
      bit<32> cell1_local=cell1_remote;
      bit<32> cell2_local=0;
      if(true){
        cell1_remote=precompute3910;
      }
      //NOOP
    }
  };
  action labeledstmt_67(){
    pkt_finish_times_regaction_3957.execute(done_idx);
  }
  action labeledstmt_26(){
    labeledstmt_67();
  }
  action labeledstmt_27(){
    //NOOP
  }
  RegisterAction<bit<32>,bit<32>,bit<32>>(first_packet_seen)
  first_packet_seen_regaction_3958 = {
    void apply(inout bit<32> cell1_remote,
        out bit<32> ret_remote){
      bit<32> cell1_local=cell1_remote;
      bit<32> cell2_local=0;
      if(true){
        cell1_remote=precompute;
      }
      //NOOP
    }
  };
  action labeledstmt_68(){
    first_packet_seen_regaction_3958.execute(32w0);
  }
  action labeledstmt_28(){
    labeledstmt_68();
  }
  action labeledstmt_29(){
    //NOOP
  }
 
RegisterAction<bit<32>,bit<16>,bit<32>>(outgoing_metric_signature_manager_1)
  outgoing_metric_signature_manager_1_regaction_3959 = {
    void apply(inout bit<32> cell1_remote,
        out bit<32> ret_remote){
      bit<32> cell1_local=cell1_remote;
      bit<32> cell2_local=0;
      if(true){
        cell1_remote=hdr.set_signature.set_signature_curr_signature;
      }
      //NOOP
    }
  };
  action labeledstmt_69(){
    outgoing_metric_signature_manager_1_regaction_3959.execute(sig_addr);
  }
  action labeledstmt_30(){
    labeledstmt_69();
  }
  action labeledstmt_31(){
    //NOOP
  }
 
RegisterAction<bit<32>,bit<16>,bit<32>>(outgoing_metric_signature_manager_0)
  outgoing_metric_signature_manager_0_regaction_3960 = {
    void apply(inout bit<32> cell1_remote,
        out bit<32> ret_remote){
      bit<32> cell1_local=cell1_remote;
      bit<32> cell2_local=0;
      if(true){
        cell1_remote=hdr.set_signature.set_signature_curr_signature;
      }
      //NOOP
    }
  };
  action labeledstmt_70(){
    outgoing_metric_signature_manager_0_regaction_3960.execute(sig_addr);
  }
  action labeledstmt_32(){
    labeledstmt_70();
  }
  action labeledstmt_33(){
    //NOOP
  }
  action labeledstmt_71(){
    hdr.set_signature.setInvalid();
  }
  action labeledstmt_34(){
    labeledstmt_71();
  }
  @ignore_table_dependency("IngressControl.table_3969")
  @ignore_table_dependency("IngressControl.table_3970")table table_3968 {
    key = {
      hdr.wire_ev.event_id : ternary;
      hdr.set_signature.set_signature_next_signature : ternary;
    }
    actions = {
      labeledstmt_1;
      labeledstmt_2;
      labeledstmt_3;
      labeledstmt_4;
      labeledstmt_5;
    }
    const entries = {
      (3,0) : labeledstmt_1();
      (1,0) : labeledstmt_2();
      (2,0) : labeledstmt_3();
      (3,_) : labeledstmt_1();
      (1,_) : labeledstmt_2();
      (2,_) : labeledstmt_4();
      (_,_) : labeledstmt_5();
    } 
  } 
  @ignore_table_dependency("IngressControl.table_3968")
  @ignore_table_dependency("IngressControl.table_3970")table table_3969 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_6;
      labeledstmt_7;
    }
    const entries = {
      (3) : labeledstmt_6();
      (1) : labeledstmt_6();
      (2) : labeledstmt_7();
      (_) : labeledstmt_6();
    } 
  } 
  @ignore_table_dependency("IngressControl.table_3968")
  @ignore_table_dependency("IngressControl.table_3969")table table_3970 {
    key = {
      hdr.wire_ev.event_id : ternary;
      hdr.set_signature.set_signature_next_signature : ternary;
    }
    actions = {
      labeledstmt_8;
      labeledstmt_9;
      labeledstmt_10;
    }
    const entries = {
      (3,0) : labeledstmt_8();
      (1,0) : labeledstmt_8();
      (2,0) : labeledstmt_9();
      (3,_) : labeledstmt_8();
      (1,_) : labeledstmt_8();
      (2,_) : labeledstmt_10();
      (_,_) : labeledstmt_8();
    } 
  } 
  @ignore_table_dependency("IngressControl.table_3966")
  @ignore_table_dependency("IngressControl.table_3967")table table_3965 {
    key = {
      seen_idx : ternary;
      hdr.wire_ev.event_id : ternary;
      if_precomp : ternary;
      block_idx_copy : ternary;
      hdr.set_signature.set_signature_next_signature : ternary;
    }
    actions = {
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
    }
    const entries = {
      (0,3,0,0,0) : labeledstmt_11();
      (_,3,0,0,0) : labeledstmt_11();
      (0,3,0,_,0) : labeledstmt_11();
      (_,3,0,_,0) : labeledstmt_11();
      (0,3,_,_,0) : labeledstmt_11();
      (_,3,_,_,0) : labeledstmt_11();
      (0,1,0,0,0) : labeledstmt_11();
      (_,1,0,0,0) : labeledstmt_11();
      (0,1,0,_,0) : labeledstmt_11();
      (_,1,0,_,0) : labeledstmt_11();
      (0,1,_,_,0) : labeledstmt_11();
      (_,1,_,_,0) : labeledstmt_11();
      (0,2,0,0,0) : labeledstmt_12();
      (_,2,0,0,0) : labeledstmt_11();
      (0,2,0,_,0) : labeledstmt_13();
      (_,2,0,_,0) : labeledstmt_14();
      (0,2,_,_,0) : labeledstmt_15();
      (_,2,_,_,0) : labeledstmt_16();
      (0,3,0,0,_) : labeledstmt_11();
      (_,3,0,0,_) : labeledstmt_11();
      (0,3,0,_,_) : labeledstmt_11();
      (_,3,0,_,_) : labeledstmt_11();
      (0,3,_,_,_) : labeledstmt_11();
      (_,3,_,_,_) : labeledstmt_11();
      (0,1,0,0,_) : labeledstmt_11();
      (_,1,0,0,_) : labeledstmt_11();
      (0,1,0,_,_) : labeledstmt_11();
      (_,1,0,_,_) : labeledstmt_11();
      (0,1,_,_,_) : labeledstmt_11();
      (_,1,_,_,_) : labeledstmt_11();
      (0,2,0,0,_) : labeledstmt_17();
      (_,2,0,0,_) : labeledstmt_18();
      (0,2,0,_,_) : labeledstmt_19();
      (_,2,0,_,_) : labeledstmt_20();
      (0,2,_,_,_) : labeledstmt_21();
      (_,2,_,_,_) : labeledstmt_22();
      (_,_,_,_,_) : labeledstmt_11();
    } 
  } 
  @ignore_table_dependency("IngressControl.table_3965")
  @ignore_table_dependency("IngressControl.table_3967")table table_3966 {
    key = {
      block_idx_copy : ternary;
      if_precomp : ternary;
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_23;
      labeledstmt_24;
    }
    const entries = {
      (0,0,3) : labeledstmt_23();
      (0,0,1) : labeledstmt_23();
      (0,0,2) : labeledstmt_24();
      (_,_,_) : labeledstmt_23();
    } 
  } 
  @ignore_table_dependency("IngressControl.table_3965")
  @ignore_table_dependency("IngressControl.table_3966")table table_3967 {
    key = {
      hdr.set_signature.set_signature_next_signature : ternary;
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_25;
      labeledstmt_26;
    }
    const entries = {
      (0,3) : labeledstmt_25();
      (0,1) : labeledstmt_25();
      (0,2) : labeledstmt_26();
      (_,_) : labeledstmt_25();
    } 
  } 
  @ignore_table_dependency("IngressControl.table_3963")
  @ignore_table_dependency("IngressControl.table_3964")table table_3962 {
    key = {
      seen_idx : ternary;
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_27;
      labeledstmt_28;
    }
    const entries = {
      (0,3) : labeledstmt_27();
      (0,1) : labeledstmt_27();
      (0,2) : labeledstmt_28();
      (_,_) : labeledstmt_27();
    } 
  } 
  @ignore_table_dependency("IngressControl.table_3962")
  @ignore_table_dependency("IngressControl.table_3964")table table_3963 {
    key = {
      hdr.set_signature.set_signature_block_idx : ternary;
      if_precomp : ternary;
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_29;
      labeledstmt_30;
    }
    const entries = {
      (0,0,3) : labeledstmt_29();
      (0,0,1) : labeledstmt_29();
      (0,0,2) : labeledstmt_29();
      (0,_,3) : labeledstmt_29();
      (0,_,1) : labeledstmt_29();
      (0,_,2) : labeledstmt_29();
      (_,0,3) : labeledstmt_29();
      (_,0,1) : labeledstmt_29();
      (_,0,2) : labeledstmt_29();
      (_,_,3) : labeledstmt_29();
      (_,_,1) : labeledstmt_29();
      (_,_,2) : labeledstmt_30();
      (_,_,_) : labeledstmt_29();
    } 
  } 
  @ignore_table_dependency("IngressControl.table_3962")
  @ignore_table_dependency("IngressControl.table_3963")table table_3964 {
    key = {
      hdr.set_signature.set_signature_block_idx : ternary;
      if_precomp : ternary;
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_31;
      labeledstmt_32;
    }
    const entries = {
      (0,0,3) : labeledstmt_31();
      (0,0,1) : labeledstmt_31();
      (0,0,2) : labeledstmt_31();
      (0,_,3) : labeledstmt_31();
      (0,_,1) : labeledstmt_31();
      (0,_,2) : labeledstmt_32();
      (_,_,_) : labeledstmt_31();
    } 
  } 
  table table_3961 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_33;
      labeledstmt_34;
    }
    const entries = {
      (3) : labeledstmt_33();
      (1) : labeledstmt_33();
      (2) : labeledstmt_34();
      (_) : labeledstmt_33();
    } 
  } 
  apply {
    table_3968.apply();
    table_3969.apply();
    table_3970.apply();
    table_3965.apply();
    table_3966.apply();
    table_3967.apply();
    table_3962.apply();
    table_3963.apply();
    table_3964.apply();
    table_3961.apply();
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
    transition select(hdr.bridge_ev.set_next_signature,
hdr.bridge_ev.set_signature, hdr.bridge_ev.dummy_traffic){
      (0, 0, 1) : parse_eventset_0;
      (1, 0, 0) : parse_eventset_1;
    }
  }
  state parse_eventset_0 {
    pkt.extract(hdr.dummy_traffic);
    transition accept;
  }
  state parse_eventset_1 {
    pkt.extract(hdr.set_next_signature);
    transition accept;
  }
}
control EgressControl(inout hdr_t hdr,
    inout meta_t meta,
    in egress_intrinsic_metadata_t eg_intr_md,
    in egress_intrinsic_metadata_from_parser_t eg_prsr_md,
    inout egress_intrinsic_metadata_for_deparser_t eg_dprsr_md,
    inout egress_intrinsic_metadata_for_output_port_t eg_oport_md){
 
@pa_no_overlay("egress","hdr.set_next_signature.set_next_signature_eth_header_0")
 
@pa_no_overlay("egress","hdr.set_next_signature.set_next_signature_eth_header_1")
 
@pa_no_overlay("egress","hdr.set_next_signature.set_next_signature_eth_header_2")
 
@pa_no_overlay("egress","hdr.set_next_signature.set_next_signature_ip_header_0")
 
@pa_no_overlay("egress","hdr.set_next_signature.set_next_signature_ip_header_1")
 
@pa_no_overlay("egress","hdr.set_next_signature.set_next_signature_ip_header_2")
 
@pa_no_overlay("egress","hdr.set_next_signature.set_next_signature_ip_header_3")
 
@pa_no_overlay("egress","hdr.set_next_signature.set_next_signature_ip_header_4")
 
@pa_no_overlay("egress","hdr.set_next_signature.set_next_signature_ip_header_5")
 
@pa_no_overlay("egress","hdr.set_next_signature.set_next_signature_ip_header_6")
 
@pa_no_overlay("egress","hdr.set_next_signature.set_next_signature_ip_header_7")
 
@pa_no_overlay("egress","hdr.set_next_signature.set_next_signature_udp_header_0")
 
@pa_no_overlay("egress","hdr.set_next_signature.set_next_signature_udp_header_1")
 
@pa_no_overlay("egress","hdr.set_next_signature.set_next_signature_udp_header_2")
 
@pa_no_overlay("egress","hdr.set_next_signature.set_next_signature_udp_header_3")
 
@pa_no_overlay("egress","hdr.set_next_signature.set_next_signature_sig_type")
 
@pa_no_overlay("egress","hdr.set_next_signature.set_next_signature_sig_idx")
 
@pa_no_overlay("egress","hdr.set_next_signature.set_next_signature_block_idx")
 
@pa_no_overlay("egress","hdr.set_next_signature.set_next_signature_next_signature")
  @pa_no_overlay("egress","hdr.set_signature.set_signature_eth_header_0")
  @pa_no_overlay("egress","hdr.set_signature.set_signature_eth_header_1")
  @pa_no_overlay("egress","hdr.set_signature.set_signature_eth_header_2")
  @pa_no_overlay("egress","hdr.set_signature.set_signature_ip_header_0")
  @pa_no_overlay("egress","hdr.set_signature.set_signature_ip_header_1")
  @pa_no_overlay("egress","hdr.set_signature.set_signature_ip_header_2")
  @pa_no_overlay("egress","hdr.set_signature.set_signature_ip_header_3")
  @pa_no_overlay("egress","hdr.set_signature.set_signature_ip_header_4")
  @pa_no_overlay("egress","hdr.set_signature.set_signature_ip_header_5")
  @pa_no_overlay("egress","hdr.set_signature.set_signature_ip_header_6")
  @pa_no_overlay("egress","hdr.set_signature.set_signature_ip_header_7")
  @pa_no_overlay("egress","hdr.set_signature.set_signature_udp_header_0")
  @pa_no_overlay("egress","hdr.set_signature.set_signature_udp_header_1")
  @pa_no_overlay("egress","hdr.set_signature.set_signature_udp_header_2")
  @pa_no_overlay("egress","hdr.set_signature.set_signature_udp_header_3")
  @pa_no_overlay("egress","hdr.set_signature.set_signature_sig_type")
  @pa_no_overlay("egress","hdr.set_signature.set_signature_sig_idx")
  @pa_no_overlay("egress","hdr.set_signature.set_signature_block_idx")
  @pa_no_overlay("egress","hdr.set_signature.set_signature_curr_signature")
  @pa_no_overlay("egress","hdr.set_signature.set_signature_next_signature")
  @pa_no_overlay("egress","hdr.dummy_traffic.dummy_traffic_eth_header_0")
  @pa_no_overlay("egress","hdr.dummy_traffic.dummy_traffic_eth_header_1")
  @pa_no_overlay("egress","hdr.dummy_traffic.dummy_traffic_eth_header_2")
  @pa_no_overlay("egress","hdr.dummy_traffic.dummy_traffic_ip_header_0")
  @pa_no_overlay("egress","hdr.dummy_traffic.dummy_traffic_ip_header_1")
  @pa_no_overlay("egress","hdr.dummy_traffic.dummy_traffic_ip_header_2")
  @pa_no_overlay("egress","hdr.dummy_traffic.dummy_traffic_ip_header_3")
  @pa_no_overlay("egress","hdr.dummy_traffic.dummy_traffic_ip_header_4")
  @pa_no_overlay("egress","hdr.dummy_traffic.dummy_traffic_ip_header_5")
  @pa_no_overlay("egress","hdr.dummy_traffic.dummy_traffic_ip_header_6")
  @pa_no_overlay("egress","hdr.dummy_traffic.dummy_traffic_ip_header_7")
  @pa_no_overlay("egress","hdr.dummy_traffic.dummy_traffic_ip_header_8")
  @pa_no_overlay("egress","hdr.dummy_traffic.dummy_traffic_ip_header_9")
  @pa_no_overlay("egress","hdr.dummy_traffic.dummy_traffic_udp_header_0")
  @pa_no_overlay("egress","hdr.dummy_traffic.dummy_traffic_udp_header_1")
  @pa_no_overlay("egress","hdr.dummy_traffic.dummy_traffic_udp_header_2")
  @pa_no_overlay("egress","hdr.dummy_traffic.dummy_traffic_udp_header_3")
  action egr_noop(){
    //NOOP
  }
  action set_next_signature_recirc(){
    hdr.set_signature.setInvalid();
    hdr.dummy_traffic.setInvalid();
    hdr.wire_ev.event_id=3;
    meta.egress_event_id=3;
    hdr.bridge_ev.port_event_id=0;
    hdr.bridge_ev.set_next_signature=0;
    hdr.bridge_ev.set_signature=0;
    hdr.bridge_ev.dummy_traffic=0;
  }
  action set_signature_recirc(){
    hdr.set_next_signature.setInvalid();
    hdr.dummy_traffic.setInvalid();
    hdr.wire_ev.event_id=2;
    meta.egress_event_id=2;
    hdr.bridge_ev.port_event_id=0;
    hdr.bridge_ev.set_next_signature=0;
    hdr.bridge_ev.set_signature=0;
    hdr.bridge_ev.dummy_traffic=0;
  }
  action dummy_traffic_recirc(){
    hdr.set_next_signature.setInvalid();
    hdr.set_signature.setInvalid();
    hdr.wire_ev.event_id=1;
    meta.egress_event_id=1;
    hdr.bridge_ev.port_event_id=0;
    hdr.bridge_ev.set_next_signature=0;
    hdr.bridge_ev.set_signature=0;
    hdr.bridge_ev.dummy_traffic=0;
  }
  action set_next_signature_to_external(){
    meta.egress_event_id=3;
    hdr.lucid_eth.setInvalid();
    hdr.wire_ev.setInvalid();
    hdr.bridge_ev.setInvalid();
    hdr.set_signature.setInvalid();
    hdr.dummy_traffic.setInvalid();
  }
  action set_signature_to_external(){
    meta.egress_event_id=2;
    hdr.lucid_eth.setInvalid();
    hdr.wire_ev.setInvalid();
    hdr.bridge_ev.setInvalid();
    hdr.set_next_signature.setInvalid();
    hdr.dummy_traffic.setInvalid();
  }
  action dummy_traffic_to_external(){
    meta.egress_event_id=1;
    hdr.lucid_eth.setInvalid();
    hdr.wire_ev.setInvalid();
    hdr.bridge_ev.setInvalid();
    hdr.set_next_signature.setInvalid();
    hdr.set_signature.setInvalid();
  }
  action set_next_signature_to_internal(){
    meta.egress_event_id=3;
    hdr.wire_ev.event_id=3;
    hdr.bridge_ev.port_event_id=0;
    hdr.bridge_ev.set_next_signature=0;
    hdr.bridge_ev.set_signature=0;
    hdr.bridge_ev.dummy_traffic=0;
    hdr.set_signature.setInvalid();
    hdr.dummy_traffic.setInvalid();
  }
  action set_signature_to_internal(){
    meta.egress_event_id=2;
    hdr.wire_ev.event_id=2;
    hdr.bridge_ev.port_event_id=0;
    hdr.bridge_ev.set_next_signature=0;
    hdr.bridge_ev.set_signature=0;
    hdr.bridge_ev.dummy_traffic=0;
    hdr.set_next_signature.setInvalid();
    hdr.dummy_traffic.setInvalid();
  }
  action dummy_traffic_to_internal(){
    meta.egress_event_id=1;
    hdr.wire_ev.event_id=1;
    hdr.bridge_ev.port_event_id=0;
    hdr.bridge_ev.set_next_signature=0;
    hdr.bridge_ev.set_signature=0;
    hdr.bridge_ev.dummy_traffic=0;
    hdr.set_next_signature.setInvalid();
    hdr.set_signature.setInvalid();
  }
  table t_extract_recirc_event {
    key = {
      eg_intr_md.egress_rid : ternary;
      hdr.bridge_ev.port_event_id : ternary;
      hdr.bridge_ev.set_next_signature : ternary;
      hdr.bridge_ev.set_signature : ternary;
      hdr.bridge_ev.dummy_traffic : ternary;
    }
    actions = {
      egr_noop;
      set_next_signature_recirc;
      set_signature_recirc;
      dummy_traffic_recirc;
    }
    const entries = {
      (1,0,0,0,1) : dummy_traffic_recirc();
      (1,0,1,0,0) : set_next_signature_recirc();
    } 
  } 
  table t_extract_port_event {
    key = {
      hdr.bridge_ev.port_event_id : ternary;
      eg_intr_md.egress_port : ternary;
    }
    actions = {
      set_next_signature_to_external;
      set_next_signature_to_internal;
      set_signature_to_external;
      set_signature_to_internal;
      dummy_traffic_to_external;
      dummy_traffic_to_internal;
    }
    const entries = {
      (3,0) : set_next_signature_to_internal();
      (3,_) : set_next_signature_to_external();
      (2,0) : set_signature_to_internal();
      (2,_) : set_signature_to_external();
      (1,0) : dummy_traffic_to_internal();
      (1,_) : dummy_traffic_to_external();
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