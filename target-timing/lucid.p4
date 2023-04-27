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
  bit<5> flag_pad_3955;
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
  bit<16> set_next_signature_sig_idx;
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
  bit<16> set_signature_sig_idx;
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
Register<bit<32>,_>(32w1) start_time;
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
Register<bit<32>,_>(32w128) pkt_finish_times;
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
  action labeledstmt_31(){
    hdr.set_next_signature.setInvalid();
  }
  action labeledstmt_1(){
    labeledstmt_31();
  }
  action labeledstmt_49(){
   
pre_gen_copy_dummy_traffic_udp_header_3=hdr.dummy_traffic.dummy_traffic_udp_header_3;
  }
  action labeledstmt_48(){
   
pre_gen_copy_dummy_traffic_udp_header_2=hdr.dummy_traffic.dummy_traffic_udp_header_2;
  }
  action labeledstmt_47(){
   
pre_gen_copy_dummy_traffic_udp_header_1=hdr.dummy_traffic.dummy_traffic_udp_header_1;
  }
  action labeledstmt_46(){
   
pre_gen_copy_dummy_traffic_udp_header_0=hdr.dummy_traffic.dummy_traffic_udp_header_0;
  }
  action labeledstmt_45(){
   
pre_gen_copy_dummy_traffic_ip_header_9=hdr.dummy_traffic.dummy_traffic_ip_header_9;
  }
  action labeledstmt_44(){
   
pre_gen_copy_dummy_traffic_ip_header_8=hdr.dummy_traffic.dummy_traffic_ip_header_8;
  }
  action labeledstmt_43(){
   
pre_gen_copy_dummy_traffic_ip_header_7=hdr.dummy_traffic.dummy_traffic_ip_header_7;
  }
  action labeledstmt_42(){
   
pre_gen_copy_dummy_traffic_ip_header_6=hdr.dummy_traffic.dummy_traffic_ip_header_6;
  }
  action labeledstmt_41(){
   
pre_gen_copy_dummy_traffic_ip_header_5=hdr.dummy_traffic.dummy_traffic_ip_header_5;
  }
  action labeledstmt_40(){
   
pre_gen_copy_dummy_traffic_ip_header_4=hdr.dummy_traffic.dummy_traffic_ip_header_4;
  }
  action labeledstmt_39(){
   
pre_gen_copy_dummy_traffic_ip_header_3=hdr.dummy_traffic.dummy_traffic_ip_header_3;
  }
  action labeledstmt_38(){
   
pre_gen_copy_dummy_traffic_ip_header_2=hdr.dummy_traffic.dummy_traffic_ip_header_2;
  }
  action labeledstmt_37(){
   
pre_gen_copy_dummy_traffic_ip_header_1=hdr.dummy_traffic.dummy_traffic_ip_header_1;
  }
  action labeledstmt_36(){
   
pre_gen_copy_dummy_traffic_ip_header_0=hdr.dummy_traffic.dummy_traffic_ip_header_0;
  }
  action labeledstmt_35(){
   
pre_gen_copy_dummy_traffic_eth_header_2=hdr.dummy_traffic.dummy_traffic_eth_header_2;
  }
  action labeledstmt_34(){
   
pre_gen_copy_dummy_traffic_eth_header_1=hdr.dummy_traffic.dummy_traffic_eth_header_1;
  }
  action labeledstmt_33(){
   
pre_gen_copy_dummy_traffic_eth_header_0=hdr.dummy_traffic.dummy_traffic_eth_header_0;
  }
  RegisterAction<bit<32>,bit<32>,bit<32>>(application_packet_counter)
  application_packet_counter_regaction_3933 = {
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
  action labeledstmt_32(){
    application_packet_counter_regaction_3933.execute(32w0);
  }
  action labeledstmt_2(){
    labeledstmt_32();
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
    labeledstmt_45();
    labeledstmt_46();
    labeledstmt_47();
    labeledstmt_48();
    labeledstmt_49();
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
  bit<32> precompute3894;
  action labeledstmt_52(){
    precompute3894=(ig_intr_md.ingress_mac_tstamp[47:16]);
  }
  bit<32> if_precomp;
  action labeledstmt_51(){
    if_precomp=(((bit<32>)hdr.set_signature.set_signature_sig_type)-32w0);
  }
  bit<16> sig_idx_copy;
  CRCPolynomial<bit<16>>(1,false, false, false, 0, 0) hash_39340_crc;
  Hash<bit<16>>(HashAlgorithm_t.CUSTOM,hash_39340_crc) hash_39340;
  action labeledstmt_50(){
    sig_idx_copy=hash_39340.get({hdr.set_signature.set_signature_sig_idx});
  }
  action labeledstmt_3(){
    labeledstmt_50();
    labeledstmt_51();
    labeledstmt_52();
  }
  bit<16> precompute3893;
  action labeledstmt_54(){
    precompute3893=(16w1+hdr.set_signature.set_signature_sig_idx);
  }
  bit<16> precompute3892;
  action labeledstmt_53(){
    precompute3892=(hdr.set_signature.set_signature_ip_header_1-16w32);
  }
  action labeledstmt_4(){
    labeledstmt_50();
    labeledstmt_51();
    labeledstmt_53();
    labeledstmt_54();
  }
  action labeledstmt_5(){
    //NOOP
  }
  action labeledstmt_6(){
    //NOOP
  }
  bit<32> sig_copy;
  CRCPolynomial<bit<32>>(1,false, false, false, 0, 0) hash_39350_crc;
  Hash<bit<32>>(HashAlgorithm_t.CUSTOM,hash_39350_crc) hash_39350;
  action labeledstmt_56(){
   
sig_copy=hash_39350.get({hdr.set_signature.set_signature_curr_signature});
  }
  bit<32> num_sigs_written;
  RegisterAction<bit<32>,bit<32>,bit<32>>(signature_count)
  signature_count_regaction_3936 = {
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
  action labeledstmt_55(){
    num_sigs_written=signature_count_regaction_3936.execute(32w0);
  }
  action labeledstmt_7(){
    labeledstmt_55();
    labeledstmt_56();
  }
  action labeledstmt_8(){
    //NOOP
  }
  bit<32> done_idx;
  RegisterAction<bit<32>,bit<32>,bit<32>>(num_pkt_finishes)
  num_pkt_finishes_regaction_3937 = {
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
  action labeledstmt_58(){
    done_idx=num_pkt_finishes_regaction_3937.execute(32w0);
  }
  bit<8> block_idx_copy;
  CRCPolynomial<bit<8>>(1,false, false, false, 0, 0) hash_39380_crc;
  Hash<bit<8>>(HashAlgorithm_t.CUSTOM,hash_39380_crc) hash_39380;
  action labeledstmt_57(){
   
block_idx_copy=hash_39380.get({hdr.set_signature.set_signature_block_idx});
  }
  action labeledstmt_9(){
    labeledstmt_57();
    labeledstmt_58();
  }
  action labeledstmt_10(){
    labeledstmt_57();
  }
  action labeledstmt_11(){
    //NOOP
  }
  bit<32> precompute;
  action labeledstmt_59(){
    precompute=(ig_intr_md.ingress_mac_tstamp[47:16]);
  }
  action labeledstmt_12(){
    labeledstmt_59();
  }
 
RegisterAction<bit<32>,bit<16>,bit<32>>(outgoing_metric_signature_manager_1)
  outgoing_metric_signature_manager_1_regaction_3939 = {
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
  action labeledstmt_60(){
   
outgoing_metric_signature_manager_1_regaction_3939.execute(hdr.set_signature.set_signature_sig_idx);
  }
  action labeledstmt_13(){
    labeledstmt_59();
    labeledstmt_60();
  }
  action labeledstmt_14(){
    labeledstmt_60();
  }
  action labeledstmt_15(){
    labeledstmt_59();
    hdr.bridge_ev.set_next_signature=1;
    hdr.set_next_signature.setValid();
   
hdr.set_next_signature.set_next_signature_eth_header_0=hdr.set_signature.set_signature_eth_header_0;
   
hdr.set_next_signature.set_next_signature_eth_header_1=hdr.set_signature.set_signature_eth_header_1;
   
hdr.set_next_signature.set_next_signature_eth_header_2=hdr.set_signature.set_signature_eth_header_2;
   
hdr.set_next_signature.set_next_signature_ip_header_0=hdr.set_signature.set_signature_ip_header_0;
    hdr.set_next_signature.set_next_signature_ip_header_1=precompute3892;
   
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
    hdr.set_next_signature.set_next_signature_sig_idx=precompute3893;
   
hdr.set_next_signature.set_next_signature_block_idx=hdr.set_signature.set_signature_block_idx;
   
hdr.set_next_signature.set_next_signature_next_signature=hdr.set_signature.set_signature_next_signature;
    hdr.bridge_ev.port_event_id=3;
    ig_tm_md.ucast_egress_port=9w68;
  }
  action labeledstmt_16(){
    hdr.bridge_ev.set_next_signature=1;
    hdr.set_next_signature.setValid();
   
hdr.set_next_signature.set_next_signature_eth_header_0=hdr.set_signature.set_signature_eth_header_0;
   
hdr.set_next_signature.set_next_signature_eth_header_1=hdr.set_signature.set_signature_eth_header_1;
   
hdr.set_next_signature.set_next_signature_eth_header_2=hdr.set_signature.set_signature_eth_header_2;
   
hdr.set_next_signature.set_next_signature_ip_header_0=hdr.set_signature.set_signature_ip_header_0;
    hdr.set_next_signature.set_next_signature_ip_header_1=precompute3892;
   
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
    hdr.set_next_signature.set_next_signature_sig_idx=precompute3893;
   
hdr.set_next_signature.set_next_signature_block_idx=hdr.set_signature.set_signature_block_idx;
   
hdr.set_next_signature.set_next_signature_next_signature=hdr.set_signature.set_signature_next_signature;
    hdr.bridge_ev.port_event_id=3;
    ig_tm_md.ucast_egress_port=9w68;
  }
  action labeledstmt_17(){
    labeledstmt_59();
    labeledstmt_60();
    hdr.bridge_ev.set_next_signature=1;
    hdr.set_next_signature.setValid();
   
hdr.set_next_signature.set_next_signature_eth_header_0=hdr.set_signature.set_signature_eth_header_0;
   
hdr.set_next_signature.set_next_signature_eth_header_1=hdr.set_signature.set_signature_eth_header_1;
   
hdr.set_next_signature.set_next_signature_eth_header_2=hdr.set_signature.set_signature_eth_header_2;
   
hdr.set_next_signature.set_next_signature_ip_header_0=hdr.set_signature.set_signature_ip_header_0;
    hdr.set_next_signature.set_next_signature_ip_header_1=precompute3892;
   
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
    hdr.set_next_signature.set_next_signature_sig_idx=precompute3893;
   
hdr.set_next_signature.set_next_signature_block_idx=hdr.set_signature.set_signature_block_idx;
   
hdr.set_next_signature.set_next_signature_next_signature=hdr.set_signature.set_signature_next_signature;
    hdr.bridge_ev.port_event_id=3;
    ig_tm_md.ucast_egress_port=9w68;
  }
  action labeledstmt_18(){
    labeledstmt_60();
    hdr.bridge_ev.set_next_signature=1;
    hdr.set_next_signature.setValid();
   
hdr.set_next_signature.set_next_signature_eth_header_0=hdr.set_signature.set_signature_eth_header_0;
   
hdr.set_next_signature.set_next_signature_eth_header_1=hdr.set_signature.set_signature_eth_header_1;
   
hdr.set_next_signature.set_next_signature_eth_header_2=hdr.set_signature.set_signature_eth_header_2;
   
hdr.set_next_signature.set_next_signature_ip_header_0=hdr.set_signature.set_signature_ip_header_0;
    hdr.set_next_signature.set_next_signature_ip_header_1=precompute3892;
   
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
    hdr.set_next_signature.set_next_signature_sig_idx=precompute3893;
   
hdr.set_next_signature.set_next_signature_block_idx=hdr.set_signature.set_signature_block_idx;
   
hdr.set_next_signature.set_next_signature_next_signature=hdr.set_signature.set_signature_next_signature;
    hdr.bridge_ev.port_event_id=3;
    ig_tm_md.ucast_egress_port=9w68;
  }
  action labeledstmt_19(){
    //NOOP
  }
 
RegisterAction<bit<32>,bit<16>,bit<32>>(outgoing_metric_signature_manager_0)
  outgoing_metric_signature_manager_0_regaction_3940 = {
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
  action labeledstmt_61(){
   
outgoing_metric_signature_manager_0_regaction_3940.execute(hdr.set_signature.set_signature_sig_idx);
  }
  action labeledstmt_20(){
    labeledstmt_61();
  }
  action labeledstmt_21(){
    //NOOP
  }
  RegisterAction<bit<32>,bit<16>,bit<32>>(outgoing_book_signature_manager_1)
  outgoing_book_signature_manager_1_regaction_3941 = {
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
  action labeledstmt_62(){
    outgoing_book_signature_manager_1_regaction_3941.execute(sig_idx_copy);
  }
  action labeledstmt_22(){
    labeledstmt_62();
  }
  action labeledstmt_23(){
    //NOOP
  }
  RegisterAction<bit<32>,bit<16>,bit<32>>(outgoing_book_signature_manager_0)
  outgoing_book_signature_manager_0_regaction_3942 = {
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
  action labeledstmt_63(){
    outgoing_book_signature_manager_0_regaction_3942.execute(sig_idx_copy);
  }
  action labeledstmt_24(){
    labeledstmt_63();
  }
  action labeledstmt_25(){
    //NOOP
  }
  RegisterAction<bit<32>,bit<32>,bit<32>>(pkt_finish_times)
  pkt_finish_times_regaction_3943 = {
    void apply(inout bit<32> cell1_remote,
        out bit<32> ret_remote){
      bit<32> cell1_local=cell1_remote;
      bit<32> cell2_local=0;
      if(true){
        cell1_remote=precompute3894;
      }
      //NOOP
    }
  };
  action labeledstmt_64(){
    pkt_finish_times_regaction_3943.execute(done_idx);
  }
  action labeledstmt_26(){
    labeledstmt_64();
  }
  action labeledstmt_27(){
    //NOOP
  }
  RegisterAction<bit<32>,bit<32>,bit<32>>(start_time)
  start_time_regaction_3944 = {
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
  action labeledstmt_65(){
    start_time_regaction_3944.execute(32w0);
  }
  action labeledstmt_28(){
    labeledstmt_65();
  }
  action labeledstmt_29(){
    //NOOP
  }
  action labeledstmt_66(){
    hdr.set_signature.setInvalid();
  }
  action labeledstmt_30(){
    labeledstmt_66();
  }
  @ignore_table_dependency("IngressControl.table_3953")
  @ignore_table_dependency("IngressControl.table_3954")table table_3952 {
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
  @ignore_table_dependency("IngressControl.table_3952")
  @ignore_table_dependency("IngressControl.table_3954")table table_3953 {
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
  @ignore_table_dependency("IngressControl.table_3952")
  @ignore_table_dependency("IngressControl.table_3953")table table_3954 {
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
  @ignore_table_dependency("IngressControl.table_3949")
  @ignore_table_dependency("IngressControl.table_3950")
  @ignore_table_dependency("IngressControl.table_3951")table table_3948 {
    key = {
      num_sigs_written : ternary;
      hdr.wire_ev.event_id : ternary;
      hdr.set_signature.set_signature_block_idx : ternary;
      if_precomp : ternary;
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
    }
    const entries = {
      (0,3,0,0,0) : labeledstmt_11();
      (_,3,0,0,0) : labeledstmt_11();
      (0,3,0,_,0) : labeledstmt_11();
      (_,3,0,_,0) : labeledstmt_11();
      (0,3,_,0,0) : labeledstmt_11();
      (_,3,_,0,0) : labeledstmt_11();
      (0,3,_,_,0) : labeledstmt_11();
      (_,3,_,_,0) : labeledstmt_11();
      (0,1,0,0,0) : labeledstmt_11();
      (_,1,0,0,0) : labeledstmt_11();
      (0,1,0,_,0) : labeledstmt_11();
      (_,1,0,_,0) : labeledstmt_11();
      (0,1,_,0,0) : labeledstmt_11();
      (_,1,_,0,0) : labeledstmt_11();
      (0,1,_,_,0) : labeledstmt_11();
      (_,1,_,_,0) : labeledstmt_11();
      (0,2,0,0,0) : labeledstmt_12();
      (_,2,0,0,0) : labeledstmt_11();
      (0,2,0,_,0) : labeledstmt_12();
      (_,2,0,_,0) : labeledstmt_11();
      (0,2,_,0,0) : labeledstmt_12();
      (_,2,_,0,0) : labeledstmt_11();
      (0,2,_,_,0) : labeledstmt_13();
      (_,2,_,_,0) : labeledstmt_14();
      (0,3,0,0,_) : labeledstmt_11();
      (_,3,0,0,_) : labeledstmt_11();
      (0,3,0,_,_) : labeledstmt_11();
      (_,3,0,_,_) : labeledstmt_11();
      (0,3,_,0,_) : labeledstmt_11();
      (_,3,_,0,_) : labeledstmt_11();
      (0,3,_,_,_) : labeledstmt_11();
      (_,3,_,_,_) : labeledstmt_11();
      (0,1,0,0,_) : labeledstmt_11();
      (_,1,0,0,_) : labeledstmt_11();
      (0,1,0,_,_) : labeledstmt_11();
      (_,1,0,_,_) : labeledstmt_11();
      (0,1,_,0,_) : labeledstmt_11();
      (_,1,_,0,_) : labeledstmt_11();
      (0,1,_,_,_) : labeledstmt_11();
      (_,1,_,_,_) : labeledstmt_11();
      (0,2,0,0,_) : labeledstmt_15();
      (_,2,0,0,_) : labeledstmt_16();
      (0,2,0,_,_) : labeledstmt_15();
      (_,2,0,_,_) : labeledstmt_16();
      (0,2,_,0,_) : labeledstmt_15();
      (_,2,_,0,_) : labeledstmt_16();
      (0,2,_,_,_) : labeledstmt_17();
      (_,2,_,_,_) : labeledstmt_18();
      (_,_,_,_,_) : labeledstmt_11();
    } 
  } 
  @ignore_table_dependency("IngressControl.table_3948")
  @ignore_table_dependency("IngressControl.table_3950")
  @ignore_table_dependency("IngressControl.table_3951")table table_3949 {
    key = {
      hdr.set_signature.set_signature_block_idx : ternary;
      if_precomp : ternary;
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_19;
      labeledstmt_20;
    }
    const entries = {
      (0,0,3) : labeledstmt_19();
      (0,0,1) : labeledstmt_19();
      (0,0,2) : labeledstmt_19();
      (0,_,3) : labeledstmt_19();
      (0,_,1) : labeledstmt_19();
      (0,_,2) : labeledstmt_20();
      (_,_,_) : labeledstmt_19();
    } 
  } 
  @ignore_table_dependency("IngressControl.table_3948")
  @ignore_table_dependency("IngressControl.table_3949")
  @ignore_table_dependency("IngressControl.table_3951")table table_3950 {
    key = {
      block_idx_copy : ternary;
      if_precomp : ternary;
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_21;
      labeledstmt_22;
    }
    const entries = {
      (0,0,3) : labeledstmt_21();
      (0,0,1) : labeledstmt_21();
      (0,0,2) : labeledstmt_21();
      (_,0,3) : labeledstmt_21();
      (_,0,1) : labeledstmt_21();
      (_,0,2) : labeledstmt_22();
      (_,_,_) : labeledstmt_21();
    } 
  } 
  @ignore_table_dependency("IngressControl.table_3948")
  @ignore_table_dependency("IngressControl.table_3949")
  @ignore_table_dependency("IngressControl.table_3950")table table_3951 {
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
  @ignore_table_dependency("IngressControl.table_3947")table table_3946 {
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
  @ignore_table_dependency("IngressControl.table_3946")table table_3947 {
    key = {
      num_sigs_written : ternary;
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
  table table_3945 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_29;
      labeledstmt_30;
    }
    const entries = {
      (3) : labeledstmt_29();
      (1) : labeledstmt_29();
      (2) : labeledstmt_30();
      (_) : labeledstmt_29();
    } 
  } 
  apply {
    table_3952.apply();
    table_3953.apply();
    table_3954.apply();
    table_3948.apply();
    table_3949.apply();
    table_3950.apply();
    table_3951.apply();
    table_3946.apply();
    table_3947.apply();
    table_3945.apply();
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
