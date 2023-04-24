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
  bit<4> flag_pad_4722;
  bit<1> set_next_signature;
  bit<1> set_signature;
  bit<1> incoming_tango_traffic;
  bit<1> forward_flow;
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
  set_next_signature_t set_next_signature;
  set_signature_t set_signature;
  incoming_tango_traffic_t incoming_tango_traffic;
  forward_flow_t forward_flow;
}
struct meta_t {
  bit<8> egress_event_id;
}
Register<bit<16>,_>(32w1) sequence_counters_0;
Register<bit<32>,_>(32w2048)
outgoing_book_signature_manager_0;
Register<bit<32>,_>(32w2048)
outgoing_book_signature_manager_1;
Register<bit<32>,_>(32w16)
outgoing_metric_signature_manager_0;
Register<bit<32>,_>(32w16) outgoing_metric_signature_manager_1;
//Main program components (ingress/egress parser, control, deparser)
parser IngressParser(packet_in pkt,
    out hdr_t hdr,
    out meta_t meta,
    out ingress_intrinsic_metadata_t ig_intr_md){
  state start {
    pkt.extract(ig_intr_md);
    pkt.advance(64);
    transition select(ig_intr_md.ingress_port){
      (196) : port_196_default_set_signature;
      (128) : port_128_default_set_signature;
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
      (4) : parse_set_next_signature;
      (3) : parse_set_signature;
      (2) : parse_incoming_tango_traffic;
      (1) : parse_forward_flow;
    }
  }
  state port_196_default_set_signature {
    hdr.wire_ev.setValid();
    hdr.bridge_ev.setValid();
    hdr.wire_ev.event_id=3;
    hdr.bridge_ev.set_next_signature=0;
    hdr.bridge_ev.set_signature=0;
    hdr.bridge_ev.incoming_tango_traffic=0;
    hdr.bridge_ev.forward_flow=0;
    transition parse_set_signature;
  }
  state port_128_default_set_signature {
    hdr.wire_ev.setValid();
    hdr.bridge_ev.setValid();
    hdr.wire_ev.event_id=3;
    hdr.bridge_ev.set_next_signature=0;
    hdr.bridge_ev.set_signature=0;
    hdr.bridge_ev.incoming_tango_traffic=0;
    hdr.bridge_ev.forward_flow=0;
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
  state parse_incoming_tango_traffic {
    pkt.extract(hdr.incoming_tango_traffic);
    transition accept;
  }
  state parse_forward_flow {
    pkt.extract(hdr.forward_flow);
    transition accept;
  }
  state parse_all_events {
    pkt.extract(hdr.set_next_signature);
    pkt.extract(hdr.set_signature);
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
  bit<16> outgoing_metric_signature_manager_1_idx_4692;
  bit<16> outgoing_metric_signature_manager_0_idx_4691;
  bit<16>
merged_var_merged_var_sig_idx_copy_precompute_4689_precompute4639_4690;
  bit<16> merged_var_sig_idx_copy_precompute_4689;
  action labeledstmt_82(){
    hdr.incoming_tango_traffic.setInvalid();
  }
  action labeledstmt_1(){
    labeledstmt_82();
  }
  action labeledstmt_83(){
    hdr.set_next_signature.setInvalid();
  }
  action labeledstmt_2(){
    labeledstmt_83();
  }
  bit<16> precompute4642;
  action labeledstmt_93(){
    precompute4642=(hdr.forward_flow.forward_flow_ip_header_2+16w18);
  }
  bit<8> tango_metrics_hdr_0;
  action labeledstmt_92(){
    tango_metrics_hdr_0=8w0;
  }
  bit<32> if_precomp4646;
  action labeledstmt_91(){
    if_precomp4646=(32w0-32w0);
  }
  bit<32> MetricSignatureManager_sign_ret;
  action labeledstmt_90(){
    MetricSignatureManager_sign_ret=32w32;
  }
  bit<32> if_precomp;
  action labeledstmt_89(){
    if_precomp=(32w0-32w0);
  }
  bit<32> sig_bitstring;
  action labeledstmt_88(){
    sig_bitstring=32w0;
  }
  bit<1> BookSignatureManager_sign_ret;
  action labeledstmt_87(){
    BookSignatureManager_sign_ret=1w0;
  }
  bit<32> time_now;
  action labeledstmt_86(){
    time_now=(ig_intr_md.ingress_mac_tstamp[47:16]);
  }
  bit<16> to_immediate_tmp;
  RegisterAction<bit<16>,bit<32>,bit<16>>(sequence_counters_0)
  sequence_counters_0_regaction_4693 = {
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
    to_immediate_tmp=sequence_counters_0_regaction_4693.execute(32w0);
  }
  bit<16> SequenceNumberManager_increment_ret;
  action labeledstmt_84(){
    SequenceNumberManager_increment_ret=16w32;
  }
  action labeledstmt_3(){
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
  bit<32> if_precomp4647;
  action labeledstmt_95(){
   
if_precomp4647=(((bit<32>)hdr.set_signature.set_signature_sig_type)-32w0);
  }
  CRCPolynomial<bit<16>>(1,false, false, false, 0, 0) hash_46940_crc;
  Hash<bit<16>>(HashAlgorithm_t.CUSTOM,hash_46940_crc) hash_46940;
  action labeledstmt_94(){
   
merged_var_merged_var_sig_idx_copy_precompute_4689_precompute4639_4690=hash_46940.get({hdr.set_signature.set_signature_sig_idx});
  }
  action labeledstmt_4(){
    labeledstmt_94();
    labeledstmt_95();
  }
  bit<16> precompute4644;
  action labeledstmt_97(){
    precompute4644=(16w1+hdr.set_signature.set_signature_sig_idx);
  }
  bit<16> precompute4643;
  action labeledstmt_96(){
    precompute4643=(hdr.set_signature.set_signature_ip_header_1-16w32);
  }
  action labeledstmt_5(){
    labeledstmt_94();
    labeledstmt_95();
    labeledstmt_96();
    labeledstmt_97();
  }
  action labeledstmt_6(){
    //NOOP
  }
  action labeledstmt_7(){
    //NOOP
  }
  bit<32> sig_copy;
  CRCPolynomial<bit<32>>(1,false, false, false, 0, 0) hash_46950_crc;
  Hash<bit<32>>(HashAlgorithm_t.CUSTOM,hash_46950_crc) hash_46950;
  action labeledstmt_98(){
   
sig_copy=hash_46950.get({hdr.set_signature.set_signature_curr_signature});
  }
  action labeledstmt_8(){
    labeledstmt_98();
  }
  action labeledstmt_9(){
    //NOOP
  }
  bit<8> block_idx_copy;
  CRCPolynomial<bit<8>>(1,false, false, false, 0, 0) hash_46960_crc;
  Hash<bit<8>>(HashAlgorithm_t.CUSTOM,hash_46960_crc) hash_46960;
  action labeledstmt_99(){
   
block_idx_copy=hash_46960.get({hdr.set_signature.set_signature_block_idx});
  }
  action labeledstmt_10(){
    labeledstmt_99();
  }
  action labeledstmt_11(){
    //NOOP
  }
  bit<12> timestamp;
  action labeledstmt_101(){
    timestamp=(time_now[31:20]);
  }
  action labeledstmt_100(){
    SequenceNumberManager_increment_ret=((bit<16>)to_immediate_tmp);
  }
  action labeledstmt_12(){
    labeledstmt_100();
    labeledstmt_101();
  }
  action labeledstmt_102(){
   
outgoing_metric_signature_manager_0_idx_4691=hdr.set_signature.set_signature_sig_idx;
  }
  action labeledstmt_13(){
    labeledstmt_102();
  }
  action labeledstmt_103(){
   
outgoing_metric_signature_manager_1_idx_4692=hdr.set_signature.set_signature_sig_idx;
  }
  action labeledstmt_14(){
    labeledstmt_103();
  }
  action labeledstmt_15(){
    hdr.bridge_ev.set_next_signature=1;
    hdr.set_next_signature.setValid();
   
hdr.set_next_signature.set_next_signature_eth_header_0=hdr.set_signature.set_signature_eth_header_0;
   
hdr.set_next_signature.set_next_signature_eth_header_1=hdr.set_signature.set_signature_eth_header_1;
   
hdr.set_next_signature.set_next_signature_eth_header_2=hdr.set_signature.set_signature_eth_header_2;
   
hdr.set_next_signature.set_next_signature_ip_header_0=hdr.set_signature.set_signature_ip_header_0;
    hdr.set_next_signature.set_next_signature_ip_header_1=precompute4643;
   
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
    hdr.set_next_signature.set_next_signature_sig_idx=precompute4644;
   
hdr.set_next_signature.set_next_signature_block_idx=hdr.set_signature.set_signature_block_idx;
   
hdr.set_next_signature.set_next_signature_next_signature=hdr.set_signature.set_signature_next_signature;
    hdr.bridge_ev.port_event_id=4;
    ig_tm_md.ucast_egress_port=9w196;
  }
  action labeledstmt_16(){
    labeledstmt_102();
    hdr.bridge_ev.set_next_signature=1;
    hdr.set_next_signature.setValid();
   
hdr.set_next_signature.set_next_signature_eth_header_0=hdr.set_signature.set_signature_eth_header_0;
   
hdr.set_next_signature.set_next_signature_eth_header_1=hdr.set_signature.set_signature_eth_header_1;
   
hdr.set_next_signature.set_next_signature_eth_header_2=hdr.set_signature.set_signature_eth_header_2;
   
hdr.set_next_signature.set_next_signature_ip_header_0=hdr.set_signature.set_signature_ip_header_0;
    hdr.set_next_signature.set_next_signature_ip_header_1=precompute4643;
   
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
    hdr.set_next_signature.set_next_signature_sig_idx=precompute4644;
   
hdr.set_next_signature.set_next_signature_block_idx=hdr.set_signature.set_signature_block_idx;
   
hdr.set_next_signature.set_next_signature_next_signature=hdr.set_signature.set_signature_next_signature;
    hdr.bridge_ev.port_event_id=4;
    ig_tm_md.ucast_egress_port=9w196;
  }
  action labeledstmt_17(){
    labeledstmt_103();
    hdr.bridge_ev.set_next_signature=1;
    hdr.set_next_signature.setValid();
   
hdr.set_next_signature.set_next_signature_eth_header_0=hdr.set_signature.set_signature_eth_header_0;
   
hdr.set_next_signature.set_next_signature_eth_header_1=hdr.set_signature.set_signature_eth_header_1;
   
hdr.set_next_signature.set_next_signature_eth_header_2=hdr.set_signature.set_signature_eth_header_2;
   
hdr.set_next_signature.set_next_signature_ip_header_0=hdr.set_signature.set_signature_ip_header_0;
    hdr.set_next_signature.set_next_signature_ip_header_1=precompute4643;
   
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
    hdr.set_next_signature.set_next_signature_sig_idx=precompute4644;
   
hdr.set_next_signature.set_next_signature_block_idx=hdr.set_signature.set_signature_block_idx;
   
hdr.set_next_signature.set_next_signature_next_signature=hdr.set_signature.set_signature_next_signature;
    hdr.bridge_ev.port_event_id=4;
    ig_tm_md.ucast_egress_port=9w196;
  }
  action labeledstmt_18(){
    //NOOP
  }
  bit<16> precompute4640;
  action labeledstmt_106(){
    precompute4640=((bit<16>)(timestamp[3:0]));
  }
  bit<16> tango_metrics_hdr_1;
  CRCPolynomial<bit<16>>(1,false, false, false, 0, 0) hash_46970_crc;
  Hash<bit<16>>(HashAlgorithm_t.CUSTOM,hash_46970_crc) hash_46970;
  action labeledstmt_105(){
    tango_metrics_hdr_1=hash_46970.get({timestamp});
  }
  bit<16> seq_number;
  action labeledstmt_104(){
    seq_number=SequenceNumberManager_increment_ret;
  }
  action labeledstmt_19(){
    labeledstmt_104();
    labeledstmt_105();
    labeledstmt_106();
  }
  bit<16> precompute4641;
  action labeledstmt_107(){
    precompute4641=((bit<16>)(timestamp[3:0]));
  }
  action labeledstmt_20(){
    labeledstmt_104();
    labeledstmt_105();
    labeledstmt_107();
  }
  action labeledstmt_21(){
    //NOOP
  }
  action labeledstmt_111(){
    outgoing_metric_signature_manager_0_idx_4691=precompute4640;
  }
  action labeledstmt_110(){
   
merged_var_merged_var_sig_idx_copy_precompute_4689_precompute4639_4690=((bit<16>)(seq_number[15:5]));
  }
  bit<5> bitwhack_index;
  action labeledstmt_109(){
    bitwhack_index=(seq_number[4:0]);
  }
  bit<16> tango_metrics_hdr_3;
  action labeledstmt_108(){
    tango_metrics_hdr_3=((bit<16>)seq_number);
  }
  action labeledstmt_22(){
    labeledstmt_108();
    labeledstmt_109();
    labeledstmt_110();
    labeledstmt_111();
  }
  action labeledstmt_23(){
    labeledstmt_108();
    labeledstmt_109();
    labeledstmt_110();
    labeledstmt_111();
  }
  action labeledstmt_112(){
    outgoing_metric_signature_manager_1_idx_4692=precompute4641;
  }
  action labeledstmt_24(){
    labeledstmt_108();
    labeledstmt_109();
    labeledstmt_110();
    labeledstmt_112();
  }
  action labeledstmt_25(){
    labeledstmt_108();
    labeledstmt_109();
    labeledstmt_110();
    labeledstmt_112();
  }
  action labeledstmt_26(){
    //NOOP
  }
  RegisterAction<bit<32>,bit<16>,bit<32>>(outgoing_book_signature_manager_1)
  outgoing_book_signature_manager_1_regaction_4698 = {
    void apply(inout bit<32> cell1_remote,
        out bit<32> ret_remote){
      bit<32> cell1_local=cell1_remote;
      bit<32> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_113(){
   
sig_bitstring=outgoing_book_signature_manager_1_regaction_4698.execute(merged_var_merged_var_sig_idx_copy_precompute_4689_precompute4639_4690);
  }
  action labeledstmt_27(){
    labeledstmt_113();
  }
  RegisterAction<bit<32>,bit<16>,bit<32>>(outgoing_book_signature_manager_1)
  outgoing_book_signature_manager_1_regaction_4699 = {
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
  action labeledstmt_114(){
   
outgoing_book_signature_manager_1_regaction_4699.execute(merged_var_merged_var_sig_idx_copy_precompute_4689_precompute4639_4690);
  }
  action labeledstmt_28(){
    labeledstmt_114();
  }
  action labeledstmt_29(){
    //NOOP
  }
  RegisterAction<bit<32>,bit<16>,bit<32>>(outgoing_book_signature_manager_0)
  outgoing_book_signature_manager_0_regaction_4700 = {
    void apply(inout bit<32> cell1_remote,
        out bit<32> ret_remote){
      bit<32> cell1_local=cell1_remote;
      bit<32> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_115(){
   
sig_bitstring=outgoing_book_signature_manager_0_regaction_4700.execute(merged_var_merged_var_sig_idx_copy_precompute_4689_precompute4639_4690);
  }
  action labeledstmt_30(){
    labeledstmt_115();
  }
  RegisterAction<bit<32>,bit<16>,bit<32>>(outgoing_book_signature_manager_0)
  outgoing_book_signature_manager_0_regaction_4701 = {
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
  action labeledstmt_116(){
   
outgoing_book_signature_manager_0_regaction_4701.execute(merged_var_merged_var_sig_idx_copy_precompute_4689_precompute4639_4690);
  }
  action labeledstmt_31(){
    labeledstmt_116();
  }
  action labeledstmt_32(){
    //NOOP
  }
 
RegisterAction<bit<32>,bit<16>,bit<32>>(outgoing_metric_signature_manager_1)
  outgoing_metric_signature_manager_1_regaction_4702 = {
    void apply(inout bit<32> cell1_remote,
        out bit<32> ret_remote){
      bit<32> cell1_local=cell1_remote;
      bit<32> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_117(){
   
MetricSignatureManager_sign_ret=outgoing_metric_signature_manager_1_regaction_4702.execute(outgoing_metric_signature_manager_1_idx_4692);
  }
  action labeledstmt_33(){
    labeledstmt_117();
  }
 
RegisterAction<bit<32>,bit<16>,bit<32>>(outgoing_metric_signature_manager_1)
  outgoing_metric_signature_manager_1_regaction_4703 = {
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
  action labeledstmt_118(){
   
outgoing_metric_signature_manager_1_regaction_4703.execute(outgoing_metric_signature_manager_1_idx_4692);
  }
  action labeledstmt_34(){
    labeledstmt_118();
  }
  action labeledstmt_35(){
    //NOOP
  }
 
RegisterAction<bit<32>,bit<16>,bit<32>>(outgoing_metric_signature_manager_0)
  outgoing_metric_signature_manager_0_regaction_4704 = {
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
   
MetricSignatureManager_sign_ret=outgoing_metric_signature_manager_0_regaction_4704.execute(outgoing_metric_signature_manager_0_idx_4691);
  }
  action labeledstmt_36(){
    labeledstmt_119();
  }
 
RegisterAction<bit<32>,bit<16>,bit<32>>(outgoing_metric_signature_manager_0)
  outgoing_metric_signature_manager_0_regaction_4705 = {
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
  action labeledstmt_120(){
   
outgoing_metric_signature_manager_0_regaction_4705.execute(outgoing_metric_signature_manager_0_idx_4691);
  }
  action labeledstmt_37(){
    labeledstmt_120();
  }
  action labeledstmt_38(){
    //NOOP
  }
  action labeledstmt_121(){
    BookSignatureManager_sign_ret=(sig_bitstring[0:0]);
  }
  action labeledstmt_39(){
    labeledstmt_121();
  }
  action labeledstmt_122(){
    BookSignatureManager_sign_ret=(sig_bitstring[1:1]);
  }
  action labeledstmt_40(){
    labeledstmt_122();
  }
  action labeledstmt_123(){
    BookSignatureManager_sign_ret=(sig_bitstring[2:2]);
  }
  action labeledstmt_41(){
    labeledstmt_123();
  }
  action labeledstmt_124(){
    BookSignatureManager_sign_ret=(sig_bitstring[3:3]);
  }
  action labeledstmt_42(){
    labeledstmt_124();
  }
  action labeledstmt_125(){
    BookSignatureManager_sign_ret=(sig_bitstring[4:4]);
  }
  action labeledstmt_43(){
    labeledstmt_125();
  }
  action labeledstmt_126(){
    BookSignatureManager_sign_ret=(sig_bitstring[5:5]);
  }
  action labeledstmt_44(){
    labeledstmt_126();
  }
  action labeledstmt_127(){
    BookSignatureManager_sign_ret=(sig_bitstring[6:6]);
  }
  action labeledstmt_45(){
    labeledstmt_127();
  }
  action labeledstmt_128(){
    BookSignatureManager_sign_ret=(sig_bitstring[7:7]);
  }
  action labeledstmt_46(){
    labeledstmt_128();
  }
  action labeledstmt_129(){
    BookSignatureManager_sign_ret=(sig_bitstring[8:8]);
  }
  action labeledstmt_47(){
    labeledstmt_129();
  }
  action labeledstmt_130(){
    BookSignatureManager_sign_ret=(sig_bitstring[9:9]);
  }
  action labeledstmt_48(){
    labeledstmt_130();
  }
  action labeledstmt_131(){
    BookSignatureManager_sign_ret=(sig_bitstring[10:10]);
  }
  action labeledstmt_49(){
    labeledstmt_131();
  }
  action labeledstmt_132(){
    BookSignatureManager_sign_ret=(sig_bitstring[11:11]);
  }
  action labeledstmt_50(){
    labeledstmt_132();
  }
  action labeledstmt_133(){
    BookSignatureManager_sign_ret=(sig_bitstring[12:12]);
  }
  action labeledstmt_51(){
    labeledstmt_133();
  }
  action labeledstmt_134(){
    BookSignatureManager_sign_ret=(sig_bitstring[13:13]);
  }
  action labeledstmt_52(){
    labeledstmt_134();
  }
  action labeledstmt_135(){
    BookSignatureManager_sign_ret=(sig_bitstring[14:14]);
  }
  action labeledstmt_53(){
    labeledstmt_135();
  }
  action labeledstmt_136(){
    BookSignatureManager_sign_ret=(sig_bitstring[15:15]);
  }
  action labeledstmt_54(){
    labeledstmt_136();
  }
  action labeledstmt_137(){
    BookSignatureManager_sign_ret=(sig_bitstring[16:16]);
  }
  action labeledstmt_55(){
    labeledstmt_137();
  }
  action labeledstmt_138(){
    BookSignatureManager_sign_ret=(sig_bitstring[17:17]);
  }
  action labeledstmt_56(){
    labeledstmt_138();
  }
  action labeledstmt_139(){
    BookSignatureManager_sign_ret=(sig_bitstring[18:18]);
  }
  action labeledstmt_57(){
    labeledstmt_139();
  }
  action labeledstmt_140(){
    BookSignatureManager_sign_ret=(sig_bitstring[19:19]);
  }
  action labeledstmt_58(){
    labeledstmt_140();
  }
  action labeledstmt_141(){
    BookSignatureManager_sign_ret=(sig_bitstring[20:20]);
  }
  action labeledstmt_59(){
    labeledstmt_141();
  }
  action labeledstmt_142(){
    BookSignatureManager_sign_ret=(sig_bitstring[21:21]);
  }
  action labeledstmt_60(){
    labeledstmt_142();
  }
  action labeledstmt_143(){
    BookSignatureManager_sign_ret=(sig_bitstring[22:22]);
  }
  action labeledstmt_61(){
    labeledstmt_143();
  }
  action labeledstmt_144(){
    BookSignatureManager_sign_ret=(sig_bitstring[23:23]);
  }
  action labeledstmt_62(){
    labeledstmt_144();
  }
  action labeledstmt_145(){
    BookSignatureManager_sign_ret=(sig_bitstring[24:24]);
  }
  action labeledstmt_63(){
    labeledstmt_145();
  }
  action labeledstmt_146(){
    BookSignatureManager_sign_ret=(sig_bitstring[25:25]);
  }
  action labeledstmt_64(){
    labeledstmt_146();
  }
  action labeledstmt_147(){
    BookSignatureManager_sign_ret=(sig_bitstring[26:26]);
  }
  action labeledstmt_65(){
    labeledstmt_147();
  }
  action labeledstmt_148(){
    BookSignatureManager_sign_ret=(sig_bitstring[27:27]);
  }
  action labeledstmt_66(){
    labeledstmt_148();
  }
  action labeledstmt_149(){
    BookSignatureManager_sign_ret=(sig_bitstring[28:28]);
  }
  action labeledstmt_67(){
    labeledstmt_149();
  }
  action labeledstmt_150(){
    BookSignatureManager_sign_ret=(sig_bitstring[29:29]);
  }
  action labeledstmt_68(){
    labeledstmt_150();
  }
  action labeledstmt_151(){
    BookSignatureManager_sign_ret=(sig_bitstring[30:30]);
  }
  action labeledstmt_69(){
    labeledstmt_151();
  }
  action labeledstmt_152(){
    BookSignatureManager_sign_ret=(sig_bitstring[31:31]);
  }
  action labeledstmt_70(){
    labeledstmt_152();
  }
  action labeledstmt_71(){
    //NOOP
  }
  bit<32> ts_signature;
  action labeledstmt_153(){
    ts_signature=MetricSignatureManager_sign_ret;
  }
  action labeledstmt_72(){
    labeledstmt_153();
  }
  action labeledstmt_154(){
    hdr.set_signature.setInvalid();
  }
  action labeledstmt_73(){
    labeledstmt_154();
  }
  action labeledstmt_74(){
    //NOOP
  }
  bit<32> tango_metrics_hdr_2;
  action labeledstmt_156(){
    tango_metrics_hdr_2=ts_signature;
  }
  bit<1> book_signature;
  action labeledstmt_155(){
    book_signature=BookSignatureManager_sign_ret;
  }
  action labeledstmt_75(){
    labeledstmt_155();
    labeledstmt_156();
  }
  action labeledstmt_76(){
    //NOOP
  }
  bit<8> tango_metrics_hdr_4;
  action labeledstmt_157(){
    tango_metrics_hdr_4=((bit<8>)book_signature);
  }
  action labeledstmt_77(){
    labeledstmt_157();
  }
  action labeledstmt_78(){
    //NOOP
  }
  action labeledstmt_79(){
    hdr.bridge_ev.incoming_tango_traffic=1;
    hdr.incoming_tango_traffic.setValid();
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_eth_header_0=hdr.forward_flow.forward_flow_eth_header_0;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_eth_header_1=hdr.forward_flow.forward_flow_eth_header_1;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_eth_header_2=16w34525;
    hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_0=32w0;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_1=precompute4642;
    hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_2=8w0;
    hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_3=8w0;
    hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_4=64w0;
    hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_5=64w0;
    hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_6=64w0;
    hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_7=64w0;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_udp_header_0=16w8080;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_udp_header_1=16w8080;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_udp_header_2=16w0;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_udp_header_3=16w0;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_metrics_header_0=tango_metrics_hdr_0;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_metrics_header_1=tango_metrics_hdr_1;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_metrics_header_2=tango_metrics_hdr_2;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_metrics_header_3=tango_metrics_hdr_3;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_metrics_header_4=tango_metrics_hdr_4;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_0=hdr.forward_flow.forward_flow_ip_header_0;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_1=hdr.forward_flow.forward_flow_ip_header_1;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_2=hdr.forward_flow.forward_flow_ip_header_2;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_3=hdr.forward_flow.forward_flow_ip_header_3;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_4=hdr.forward_flow.forward_flow_ip_header_4;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_5=hdr.forward_flow.forward_flow_ip_header_5;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_6=hdr.forward_flow.forward_flow_ip_header_6;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_7=hdr.forward_flow.forward_flow_ip_header_7;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_8=hdr.forward_flow.forward_flow_ip_header_8;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_ip_header_9=hdr.forward_flow.forward_flow_ip_header_9;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_udp_header_0=hdr.forward_flow.forward_flow_udp_header_0;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_udp_header_1=hdr.forward_flow.forward_flow_udp_header_1;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_udp_header_2=hdr.forward_flow.forward_flow_udp_header_2;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_encaped_udp_header_3=hdr.forward_flow.forward_flow_udp_header_3;
    hdr.bridge_ev.port_event_id=2;
    ig_tm_md.ucast_egress_port=9w128;
  }
  action labeledstmt_80(){
    //NOOP
  }
  action labeledstmt_158(){
    hdr.forward_flow.setInvalid();
  }
  action labeledstmt_81(){
    labeledstmt_158();
  }
  @ignore_table_dependency("IngressControl.table_4720")
  @ignore_table_dependency("IngressControl.table_4721")table table_4719 {
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
      labeledstmt_6;
    }
    const entries = {
      (2,0) : labeledstmt_1();
      (4,0) : labeledstmt_2();
      (1,0) : labeledstmt_3();
      (3,0) : labeledstmt_4();
      (2,_) : labeledstmt_1();
      (4,_) : labeledstmt_2();
      (1,_) : labeledstmt_3();
      (3,_) : labeledstmt_5();
      (_,_) : labeledstmt_6();
    } 
  } 
  @ignore_table_dependency("IngressControl.table_4719")
  @ignore_table_dependency("IngressControl.table_4721")table table_4720 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_7;
      labeledstmt_8;
    }
    const entries = {
      (2) : labeledstmt_7();
      (4) : labeledstmt_7();
      (1) : labeledstmt_7();
      (3) : labeledstmt_8();
      (_) : labeledstmt_7();
    } 
  } 
  @ignore_table_dependency("IngressControl.table_4719")
  @ignore_table_dependency("IngressControl.table_4720")table table_4721 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_9;
      labeledstmt_10;
    }
    const entries = {
      (2) : labeledstmt_9();
      (4) : labeledstmt_9();
      (1) : labeledstmt_9();
      (3) : labeledstmt_10();
      (_) : labeledstmt_9();
    } 
  } 
  table table_4718 {
    key = {
      hdr.wire_ev.event_id : ternary;
      hdr.set_signature.set_signature_block_idx : ternary;
      if_precomp4647 : ternary;
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
    }
    const entries = {
      (2,0,0,0) : labeledstmt_11();
      (2,0,_,0) : labeledstmt_11();
      (2,_,0,0) : labeledstmt_11();
      (2,_,_,0) : labeledstmt_11();
      (4,0,0,0) : labeledstmt_11();
      (4,0,_,0) : labeledstmt_11();
      (4,_,0,0) : labeledstmt_11();
      (4,_,_,0) : labeledstmt_11();
      (1,0,0,0) : labeledstmt_12();
      (1,0,_,0) : labeledstmt_12();
      (1,_,0,0) : labeledstmt_12();
      (1,_,_,0) : labeledstmt_12();
      (3,0,0,0) : labeledstmt_11();
      (3,0,_,0) : labeledstmt_13();
      (3,_,0,0) : labeledstmt_11();
      (3,_,_,0) : labeledstmt_14();
      (2,0,0,_) : labeledstmt_11();
      (2,0,_,_) : labeledstmt_11();
      (2,_,0,_) : labeledstmt_11();
      (2,_,_,_) : labeledstmt_11();
      (4,0,0,_) : labeledstmt_11();
      (4,0,_,_) : labeledstmt_11();
      (4,_,0,_) : labeledstmt_11();
      (4,_,_,_) : labeledstmt_11();
      (1,0,0,_) : labeledstmt_12();
      (1,0,_,_) : labeledstmt_12();
      (1,_,0,_) : labeledstmt_12();
      (1,_,_,_) : labeledstmt_12();
      (3,0,0,_) : labeledstmt_15();
      (3,0,_,_) : labeledstmt_16();
      (3,_,0,_) : labeledstmt_15();
      (3,_,_,_) : labeledstmt_17();
      (_,_,_,_) : labeledstmt_11();
    } 
  } 
  table table_4717 {
    key = {
      hdr.wire_ev.event_id : ternary;
      if_precomp4646 : ternary;
    }
    actions = {
      labeledstmt_18;
      labeledstmt_19;
      labeledstmt_20;
    }
    const entries = {
      (2,0) : labeledstmt_18();
      (4,0) : labeledstmt_18();
      (1,0) : labeledstmt_19();
      (2,_) : labeledstmt_18();
      (4,_) : labeledstmt_18();
      (1,_) : labeledstmt_20();
      (_,_) : labeledstmt_18();
    } 
  } 
  table table_4716 {
    key = {
      hdr.wire_ev.event_id : ternary;
      if_precomp : ternary;
      if_precomp4646 : ternary;
    }
    actions = {
      labeledstmt_21;
      labeledstmt_22;
      labeledstmt_23;
      labeledstmt_24;
      labeledstmt_25;
    }
    const entries = {
      (2,0,0) : labeledstmt_21();
      (2,_,0) : labeledstmt_21();
      (4,0,0) : labeledstmt_21();
      (4,_,0) : labeledstmt_21();
      (1,0,0) : labeledstmt_22();
      (1,_,0) : labeledstmt_23();
      (2,0,_) : labeledstmt_21();
      (2,_,_) : labeledstmt_21();
      (4,0,_) : labeledstmt_21();
      (4,_,_) : labeledstmt_21();
      (1,0,_) : labeledstmt_24();
      (1,_,_) : labeledstmt_25();
      (_,_,_) : labeledstmt_21();
    } 
  } 
  @ignore_table_dependency("IngressControl.table_4713")
  @ignore_table_dependency("IngressControl.table_4714")
  @ignore_table_dependency("IngressControl.table_4715")table table_4712 {
    key = {
      if_precomp : ternary;
      hdr.wire_ev.event_id : ternary;
      block_idx_copy : ternary;
      if_precomp4647 : ternary;
    }
    actions = {
      labeledstmt_26;
      labeledstmt_27;
      labeledstmt_28;
    }
    const entries = {
      (0,2,0,0) : labeledstmt_26();
      (_,2,0,0) : labeledstmt_26();
      (0,4,0,0) : labeledstmt_26();
      (_,4,0,0) : labeledstmt_26();
      (0,1,0,0) : labeledstmt_26();
      (_,1,0,0) : labeledstmt_27();
      (_,3,0,0) : labeledstmt_26();
      (0,2,_,0) : labeledstmt_26();
      (_,2,_,0) : labeledstmt_26();
      (0,4,_,0) : labeledstmt_26();
      (_,4,_,0) : labeledstmt_26();
      (0,1,_,0) : labeledstmt_26();
      (_,1,_,0) : labeledstmt_27();
      (_,3,_,0) : labeledstmt_28();
      (0,2,_,_) : labeledstmt_26();
      (0,4,_,_) : labeledstmt_26();
      (0,1,_,_) : labeledstmt_26();
      (_,2,_,_) : labeledstmt_26();
      (_,4,_,_) : labeledstmt_26();
      (_,1,_,_) : labeledstmt_27();
      (_,_,_,_) : labeledstmt_26();
    } 
  } 
  @ignore_table_dependency("IngressControl.table_4712")
  @ignore_table_dependency("IngressControl.table_4714")
  @ignore_table_dependency("IngressControl.table_4715")table table_4713 {
    key = {
      if_precomp : ternary;
      hdr.wire_ev.event_id : ternary;
      block_idx_copy : ternary;
      if_precomp4647 : ternary;
    }
    actions = {
      labeledstmt_29;
      labeledstmt_30;
      labeledstmt_31;
    }
    const entries = {
      (0,2,0,0) : labeledstmt_29();
      (_,2,0,0) : labeledstmt_29();
      (0,4,0,0) : labeledstmt_29();
      (_,4,0,0) : labeledstmt_29();
      (0,1,0,0) : labeledstmt_30();
      (_,1,0,0) : labeledstmt_29();
      (_,3,0,0) : labeledstmt_31();
      (0,2,_,_) : labeledstmt_29();
      (0,4,_,_) : labeledstmt_29();
      (0,1,_,_) : labeledstmt_30();
      (_,_,_,_) : labeledstmt_29();
    } 
  } 
  @ignore_table_dependency("IngressControl.table_4712")
  @ignore_table_dependency("IngressControl.table_4713")
  @ignore_table_dependency("IngressControl.table_4715")table table_4714 {
    key = {
      if_precomp4646 : ternary;
      hdr.wire_ev.event_id : ternary;
      hdr.set_signature.set_signature_block_idx : ternary;
      if_precomp4647 : ternary;
    }
    actions = {
      labeledstmt_32;
      labeledstmt_33;
      labeledstmt_34;
    }
    const entries = {
      (0,2,0,0) : labeledstmt_32();
      (_,2,0,0) : labeledstmt_32();
      (0,4,0,0) : labeledstmt_32();
      (_,4,0,0) : labeledstmt_32();
      (0,1,0,0) : labeledstmt_32();
      (_,1,0,0) : labeledstmt_33();
      (_,3,0,0) : labeledstmt_32();
      (0,2,0,_) : labeledstmt_32();
      (_,2,0,_) : labeledstmt_32();
      (0,4,0,_) : labeledstmt_32();
      (_,4,0,_) : labeledstmt_32();
      (0,1,0,_) : labeledstmt_32();
      (_,1,0,_) : labeledstmt_33();
      (_,3,0,_) : labeledstmt_32();
      (0,2,_,0) : labeledstmt_32();
      (_,2,_,0) : labeledstmt_32();
      (0,4,_,0) : labeledstmt_32();
      (_,4,_,0) : labeledstmt_32();
      (0,1,_,0) : labeledstmt_32();
      (_,1,_,0) : labeledstmt_33();
      (_,3,_,0) : labeledstmt_32();
      (0,2,_,_) : labeledstmt_32();
      (_,2,_,_) : labeledstmt_32();
      (0,4,_,_) : labeledstmt_32();
      (_,4,_,_) : labeledstmt_32();
      (0,1,_,_) : labeledstmt_32();
      (_,1,_,_) : labeledstmt_33();
      (_,3,_,_) : labeledstmt_34();
      (_,_,_,_) : labeledstmt_32();
    } 
  } 
  @ignore_table_dependency("IngressControl.table_4712")
  @ignore_table_dependency("IngressControl.table_4713")
  @ignore_table_dependency("IngressControl.table_4714")table table_4715 {
    key = {
      if_precomp4646 : ternary;
      hdr.wire_ev.event_id : ternary;
      hdr.set_signature.set_signature_block_idx : ternary;
      if_precomp4647 : ternary;
    }
    actions = {
      labeledstmt_35;
      labeledstmt_36;
      labeledstmt_37;
    }
    const entries = {
      (0,2,0,0) : labeledstmt_35();
      (_,2,0,0) : labeledstmt_35();
      (0,4,0,0) : labeledstmt_35();
      (_,4,0,0) : labeledstmt_35();
      (0,1,0,0) : labeledstmt_36();
      (_,1,0,0) : labeledstmt_35();
      (_,3,0,0) : labeledstmt_35();
      (0,2,0,_) : labeledstmt_35();
      (_,2,0,_) : labeledstmt_35();
      (0,4,0,_) : labeledstmt_35();
      (_,4,0,_) : labeledstmt_35();
      (0,1,0,_) : labeledstmt_36();
      (_,1,0,_) : labeledstmt_35();
      (_,3,0,_) : labeledstmt_37();
      (0,2,_,_) : labeledstmt_35();
      (0,4,_,_) : labeledstmt_35();
      (0,1,_,_) : labeledstmt_36();
      (_,_,_,_) : labeledstmt_35();
    } 
  } 
  @ignore_table_dependency("IngressControl.table_4711")table table_4710 {
    key = {
      hdr.wire_ev.event_id : ternary;
      bitwhack_index : ternary;
    }
    actions = {
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
      labeledstmt_50;
      labeledstmt_51;
      labeledstmt_52;
      labeledstmt_53;
      labeledstmt_54;
      labeledstmt_55;
      labeledstmt_56;
      labeledstmt_57;
      labeledstmt_58;
      labeledstmt_59;
      labeledstmt_60;
      labeledstmt_61;
      labeledstmt_62;
      labeledstmt_63;
      labeledstmt_64;
      labeledstmt_65;
      labeledstmt_66;
      labeledstmt_67;
      labeledstmt_68;
      labeledstmt_69;
      labeledstmt_70;
    }
    const entries = {
      (2,_) : labeledstmt_38();
      (4,_) : labeledstmt_38();
      (1,0) : labeledstmt_39();
      (1,1) : labeledstmt_40();
      (1,2) : labeledstmt_41();
      (1,3) : labeledstmt_42();
      (1,4) : labeledstmt_43();
      (1,5) : labeledstmt_44();
      (1,6) : labeledstmt_45();
      (1,7) : labeledstmt_46();
      (1,8) : labeledstmt_47();
      (1,9) : labeledstmt_48();
      (1,10) : labeledstmt_49();
      (1,11) : labeledstmt_50();
      (1,12) : labeledstmt_51();
      (1,13) : labeledstmt_52();
      (1,14) : labeledstmt_53();
      (1,15) : labeledstmt_54();
      (1,16) : labeledstmt_55();
      (1,17) : labeledstmt_56();
      (1,18) : labeledstmt_57();
      (1,19) : labeledstmt_58();
      (1,20) : labeledstmt_59();
      (1,21) : labeledstmt_60();
      (1,22) : labeledstmt_61();
      (1,23) : labeledstmt_62();
      (1,24) : labeledstmt_63();
      (1,25) : labeledstmt_64();
      (1,26) : labeledstmt_65();
      (1,27) : labeledstmt_66();
      (1,28) : labeledstmt_67();
      (1,29) : labeledstmt_68();
      (1,30) : labeledstmt_69();
      (1,_) : labeledstmt_70();
      (_,_) : labeledstmt_38();
    } 
  } 
  @ignore_table_dependency("IngressControl.table_4710")table table_4711 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_71;
      labeledstmt_72;
      labeledstmt_73;
    }
    const entries = {
      (2) : labeledstmt_71();
      (4) : labeledstmt_71();
      (1) : labeledstmt_72();
      (3) : labeledstmt_73();
      (_) : labeledstmt_71();
    } 
  } 
  table table_4709 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_74;
      labeledstmt_75;
    }
    const entries = {
      (2) : labeledstmt_74();
      (4) : labeledstmt_74();
      (1) : labeledstmt_75();
      (_) : labeledstmt_74();
    } 
  } 
  table table_4708 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_76;
      labeledstmt_77;
    }
    const entries = {
      (2) : labeledstmt_76();
      (4) : labeledstmt_76();
      (1) : labeledstmt_77();
      (_) : labeledstmt_76();
    } 
  } 
  table table_4707 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_78;
      labeledstmt_79;
    }
    const entries = {
      (2) : labeledstmt_78();
      (4) : labeledstmt_78();
      (1) : labeledstmt_79();
      (_) : labeledstmt_78();
    } 
  } 
  table table_4706 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_80;
      labeledstmt_81;
    }
    const entries = {
      (2) : labeledstmt_80();
      (4) : labeledstmt_80();
      (1) : labeledstmt_81();
      (_) : labeledstmt_80();
    } 
  } 
  apply {
    table_4719.apply();
    table_4720.apply();
    table_4721.apply();
    table_4718.apply();
    table_4717.apply();
    table_4716.apply();
    table_4712.apply();
    table_4713.apply();
    table_4714.apply();
    table_4715.apply();
    table_4710.apply();
    table_4711.apply();
    table_4709.apply();
    table_4708.apply();
    table_4707.apply();
    table_4706.apply();
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
hdr.bridge_ev.set_signature, hdr.bridge_ev.incoming_tango_traffic,
hdr.bridge_ev.forward_flow){
      (0, 0, 1, 0) : parse_eventset_0;
      (1, 0, 0, 0) : parse_eventset_1;
    }
  }
  state parse_eventset_0 {
    pkt.extract(hdr.incoming_tango_traffic);
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
  action set_next_signature_recirc(){
    hdr.set_signature.setInvalid();
    hdr.incoming_tango_traffic.setInvalid();
    hdr.forward_flow.setInvalid();
    hdr.wire_ev.event_id=4;
    meta.egress_event_id=4;
    hdr.bridge_ev.port_event_id=0;
    hdr.bridge_ev.set_next_signature=0;
    hdr.bridge_ev.set_signature=0;
    hdr.bridge_ev.incoming_tango_traffic=0;
    hdr.bridge_ev.forward_flow=0;
  }
  action set_signature_recirc(){
    hdr.set_next_signature.setInvalid();
    hdr.incoming_tango_traffic.setInvalid();
    hdr.forward_flow.setInvalid();
    hdr.wire_ev.event_id=3;
    meta.egress_event_id=3;
    hdr.bridge_ev.port_event_id=0;
    hdr.bridge_ev.set_next_signature=0;
    hdr.bridge_ev.set_signature=0;
    hdr.bridge_ev.incoming_tango_traffic=0;
    hdr.bridge_ev.forward_flow=0;
  }
  action incoming_tango_traffic_recirc(){
    hdr.set_next_signature.setInvalid();
    hdr.set_signature.setInvalid();
    hdr.forward_flow.setInvalid();
    hdr.wire_ev.event_id=2;
    meta.egress_event_id=2;
    hdr.bridge_ev.port_event_id=0;
    hdr.bridge_ev.set_next_signature=0;
    hdr.bridge_ev.set_signature=0;
    hdr.bridge_ev.incoming_tango_traffic=0;
    hdr.bridge_ev.forward_flow=0;
  }
  action forward_flow_recirc(){
    hdr.set_next_signature.setInvalid();
    hdr.set_signature.setInvalid();
    hdr.incoming_tango_traffic.setInvalid();
    hdr.wire_ev.event_id=1;
    meta.egress_event_id=1;
    hdr.bridge_ev.port_event_id=0;
    hdr.bridge_ev.set_next_signature=0;
    hdr.bridge_ev.set_signature=0;
    hdr.bridge_ev.incoming_tango_traffic=0;
    hdr.bridge_ev.forward_flow=0;
  }
  action set_next_signature_to_external(){
    meta.egress_event_id=4;
    hdr.lucid_eth.setInvalid();
    hdr.wire_ev.setInvalid();
    hdr.bridge_ev.setInvalid();
    hdr.set_signature.setInvalid();
    hdr.incoming_tango_traffic.setInvalid();
    hdr.forward_flow.setInvalid();
  }
  action set_signature_to_external(){
    meta.egress_event_id=3;
    hdr.lucid_eth.setInvalid();
    hdr.wire_ev.setInvalid();
    hdr.bridge_ev.setInvalid();
    hdr.set_next_signature.setInvalid();
    hdr.incoming_tango_traffic.setInvalid();
    hdr.forward_flow.setInvalid();
  }
  action incoming_tango_traffic_to_external(){
    meta.egress_event_id=2;
    hdr.lucid_eth.setInvalid();
    hdr.wire_ev.setInvalid();
    hdr.bridge_ev.setInvalid();
    hdr.set_next_signature.setInvalid();
    hdr.set_signature.setInvalid();
    hdr.forward_flow.setInvalid();
  }
  action forward_flow_to_external(){
    meta.egress_event_id=1;
    hdr.lucid_eth.setInvalid();
    hdr.wire_ev.setInvalid();
    hdr.bridge_ev.setInvalid();
    hdr.set_next_signature.setInvalid();
    hdr.set_signature.setInvalid();
    hdr.incoming_tango_traffic.setInvalid();
  }
  action set_next_signature_to_internal(){
    meta.egress_event_id=4;
    hdr.wire_ev.event_id=4;
    hdr.bridge_ev.port_event_id=0;
    hdr.bridge_ev.set_next_signature=0;
    hdr.bridge_ev.set_signature=0;
    hdr.bridge_ev.incoming_tango_traffic=0;
    hdr.bridge_ev.forward_flow=0;
    hdr.set_signature.setInvalid();
    hdr.incoming_tango_traffic.setInvalid();
    hdr.forward_flow.setInvalid();
  }
  action set_signature_to_internal(){
    meta.egress_event_id=3;
    hdr.wire_ev.event_id=3;
    hdr.bridge_ev.port_event_id=0;
    hdr.bridge_ev.set_next_signature=0;
    hdr.bridge_ev.set_signature=0;
    hdr.bridge_ev.incoming_tango_traffic=0;
    hdr.bridge_ev.forward_flow=0;
    hdr.set_next_signature.setInvalid();
    hdr.incoming_tango_traffic.setInvalid();
    hdr.forward_flow.setInvalid();
  }
  action incoming_tango_traffic_to_internal(){
    meta.egress_event_id=2;
    hdr.wire_ev.event_id=2;
    hdr.bridge_ev.port_event_id=0;
    hdr.bridge_ev.set_next_signature=0;
    hdr.bridge_ev.set_signature=0;
    hdr.bridge_ev.incoming_tango_traffic=0;
    hdr.bridge_ev.forward_flow=0;
    hdr.set_next_signature.setInvalid();
    hdr.set_signature.setInvalid();
    hdr.forward_flow.setInvalid();
  }
  action forward_flow_to_internal(){
    meta.egress_event_id=1;
    hdr.wire_ev.event_id=1;
    hdr.bridge_ev.port_event_id=0;
    hdr.bridge_ev.set_next_signature=0;
    hdr.bridge_ev.set_signature=0;
    hdr.bridge_ev.incoming_tango_traffic=0;
    hdr.bridge_ev.forward_flow=0;
    hdr.set_next_signature.setInvalid();
    hdr.set_signature.setInvalid();
    hdr.incoming_tango_traffic.setInvalid();
  }
  table t_extract_recirc_event {
    key = {
      eg_intr_md.egress_rid : ternary;
      hdr.bridge_ev.port_event_id : ternary;
      hdr.bridge_ev.set_next_signature : ternary;
      hdr.bridge_ev.set_signature : ternary;
      hdr.bridge_ev.incoming_tango_traffic : ternary;
      hdr.bridge_ev.forward_flow : ternary;
    }
    actions = {
      egr_noop;
      set_next_signature_recirc;
      set_signature_recirc;
      incoming_tango_traffic_recirc;
      forward_flow_recirc;
    }
    const entries = {
      (1,0,0,0,1,0) : incoming_tango_traffic_recirc();
      (1,0,1,0,0,0) : set_next_signature_recirc();
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
      incoming_tango_traffic_to_external;
      incoming_tango_traffic_to_internal;
      forward_flow_to_external;
      forward_flow_to_internal;
    }
    const entries = {
      (4,0) : set_next_signature_to_internal();
      (4,_) : set_next_signature_to_external();
      (3,0) : set_signature_to_internal();
      (3,_) : set_signature_to_external();
      (2,0) : incoming_tango_traffic_to_internal();
      (2,_) : incoming_tango_traffic_to_external();
      (1,0) : forward_flow_to_internal();
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
