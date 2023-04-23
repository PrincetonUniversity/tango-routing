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
  bit<4> flag_pad_4268;
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
Register<bit<32>,_>(32w32) outgoing_metric_signature_manager_0;
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
  bit<16> merged_var_precompute4222_precompute4219_4249;
  bit<16> merged_var_precompute4221_precompute_4248;
  action labeledstmt_100(){
    hdr.incoming_tango_traffic.setInvalid();
  }
  action labeledstmt_1(){
    labeledstmt_100();
  }
  action labeledstmt_101(){
    hdr.set_next_signature.setInvalid();
  }
  action labeledstmt_2(){
    labeledstmt_101();
  }
  bit<16> precompute4220;
  action labeledstmt_108(){
    precompute4220=(hdr.forward_flow.forward_flow_ip_header_2+16w18);
  }
  bit<8> tango_metrics_hdr_0;
  action labeledstmt_107(){
    tango_metrics_hdr_0=8w0;
  }
  bit<32> MetricSignatureManager_sign_ret;
  action labeledstmt_106(){
    MetricSignatureManager_sign_ret=32w32;
  }
  bit<1> BookSignatureManager_sign_ret;
  action labeledstmt_105(){
    BookSignatureManager_sign_ret=1w0;
  }
  bit<32> time_now;
  action labeledstmt_104(){
    time_now=(ig_intr_md.ingress_mac_tstamp[47:16]);
  }
  bit<16> to_immediate_tmp;
  RegisterAction<bit<16>,bit<32>,bit<16>>(sequence_counters_0)
  sequence_counters_0_regaction_4250 = {
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
  action labeledstmt_103(){
    to_immediate_tmp=sequence_counters_0_regaction_4250.execute(32w0);
  }
  bit<16> SequenceNumberManager_increment_ret;
  action labeledstmt_102(){
    SequenceNumberManager_increment_ret=16w32;
  }
  action labeledstmt_3(){
    labeledstmt_102();
    labeledstmt_103();
    labeledstmt_104();
    labeledstmt_105();
    labeledstmt_106();
    labeledstmt_107();
    labeledstmt_108();
  }
  bit<1> BookSignatureManager_sign_ret3423;
  action labeledstmt_110(){
    BookSignatureManager_sign_ret3423=1w0;
  }
  bit<16> seq_number3422;
  action labeledstmt_109(){
    seq_number3422=(hdr.set_signature.set_signature_curr_signature[15:0]);
  }
  action labeledstmt_4(){
    labeledstmt_109();
    labeledstmt_110();
  }
  bit<32> MetricSignatureManager_sign_ret3427;
  action labeledstmt_112(){
    MetricSignatureManager_sign_ret3427=32w32;
  }
  bit<12> timestamp3426;
  action labeledstmt_111(){
    timestamp3426=(hdr.set_signature.set_signature_curr_signature[11:0]);
  }
  action labeledstmt_5(){
    labeledstmt_111();
    labeledstmt_112();
  }
  bit<16> precompute4224;
  action labeledstmt_114(){
    precompute4224=(16w1+hdr.set_signature.set_signature_sig_idx);
  }
  bit<16> precompute4223;
  action labeledstmt_113(){
    precompute4223=(hdr.set_signature.set_signature_ip_header_1-16w32);
  }
  action labeledstmt_6(){
    labeledstmt_109();
    labeledstmt_110();
    labeledstmt_113();
    labeledstmt_114();
  }
  action labeledstmt_7(){
    labeledstmt_111();
    labeledstmt_112();
    labeledstmt_113();
    labeledstmt_114();
  }
  action labeledstmt_8(){
    //NOOP
  }
  action labeledstmt_9(){
    //NOOP
  }
  bit<12> timestamp;
  action labeledstmt_116(){
    timestamp=(time_now[31:20]);
  }
  action labeledstmt_115(){
    SequenceNumberManager_increment_ret=((bit<16>)to_immediate_tmp);
  }
  action labeledstmt_10(){
    labeledstmt_115();
    labeledstmt_116();
  }
  action labeledstmt_118(){
   
merged_var_precompute4221_precompute_4248=((bit<16>)(seq_number3422[15:5]));
  }
  bit<5> bitwhack_index3425;
  action labeledstmt_117(){
    bitwhack_index3425=(seq_number3422[4:0]);
  }
  action labeledstmt_11(){
    labeledstmt_117();
    labeledstmt_118();
  }
  action labeledstmt_119(){
   
merged_var_precompute4222_precompute4219_4249=((bit<16>)(timestamp3426[4:0]));
  }
  action labeledstmt_12(){
    labeledstmt_119();
  }
  action labeledstmt_13(){
    labeledstmt_117();
    labeledstmt_118();
    hdr.bridge_ev.set_next_signature=1;
    hdr.set_next_signature.setValid();
   
hdr.set_next_signature.set_next_signature_eth_header_0=hdr.set_signature.set_signature_eth_header_0;
   
hdr.set_next_signature.set_next_signature_eth_header_1=hdr.set_signature.set_signature_eth_header_1;
   
hdr.set_next_signature.set_next_signature_eth_header_2=hdr.set_signature.set_signature_eth_header_2;
   
hdr.set_next_signature.set_next_signature_ip_header_0=hdr.set_signature.set_signature_ip_header_0;
    hdr.set_next_signature.set_next_signature_ip_header_1=precompute4223;
   
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
    hdr.set_next_signature.set_next_signature_sig_idx=precompute4224;
   
hdr.set_next_signature.set_next_signature_block_idx=hdr.set_signature.set_signature_block_idx;
   
hdr.set_next_signature.set_next_signature_next_signature=hdr.set_signature.set_signature_next_signature;
    hdr.bridge_ev.port_event_id=4;
    ig_tm_md.ucast_egress_port=9w196;
  }
  action labeledstmt_14(){
    labeledstmt_119();
    hdr.bridge_ev.set_next_signature=1;
    hdr.set_next_signature.setValid();
   
hdr.set_next_signature.set_next_signature_eth_header_0=hdr.set_signature.set_signature_eth_header_0;
   
hdr.set_next_signature.set_next_signature_eth_header_1=hdr.set_signature.set_signature_eth_header_1;
   
hdr.set_next_signature.set_next_signature_eth_header_2=hdr.set_signature.set_signature_eth_header_2;
   
hdr.set_next_signature.set_next_signature_ip_header_0=hdr.set_signature.set_signature_ip_header_0;
    hdr.set_next_signature.set_next_signature_ip_header_1=precompute4223;
   
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
    hdr.set_next_signature.set_next_signature_sig_idx=precompute4224;
   
hdr.set_next_signature.set_next_signature_block_idx=hdr.set_signature.set_signature_block_idx;
   
hdr.set_next_signature.set_next_signature_next_signature=hdr.set_signature.set_signature_next_signature;
    hdr.bridge_ev.port_event_id=4;
    ig_tm_md.ucast_egress_port=9w196;
  }
  action labeledstmt_15(){
    //NOOP
  }
  action labeledstmt_122(){
   
merged_var_precompute4222_precompute4219_4249=((bit<16>)(timestamp[4:0]));
  }
  bit<16> tango_metrics_hdr_1;
  CRCPolynomial<bit<16>>(1,false, false, false, 0, 0) hash_42510_crc;
  Hash<bit<16>>(HashAlgorithm_t.CUSTOM,hash_42510_crc) hash_42510;
  action labeledstmt_121(){
    tango_metrics_hdr_1=hash_42510.get({timestamp});
  }
  bit<16> seq_number;
  action labeledstmt_120(){
    seq_number=SequenceNumberManager_increment_ret;
  }
  action labeledstmt_16(){
    labeledstmt_120();
    labeledstmt_121();
    labeledstmt_122();
  }
  action labeledstmt_17(){
    //NOOP
  }
 
RegisterAction<bit<32>,bit<16>,bit<32>>(outgoing_metric_signature_manager_0)
  outgoing_metric_signature_manager_0_regaction_4252 = {
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
   
MetricSignatureManager_sign_ret=outgoing_metric_signature_manager_0_regaction_4252.execute(merged_var_precompute4222_precompute4219_4249);
  }
  action labeledstmt_125(){
    merged_var_precompute4221_precompute_4248=((bit<16>)(seq_number[15:5]));
  }
  bit<5> bitwhack_index;
  action labeledstmt_124(){
    bitwhack_index=(seq_number[4:0]);
  }
  bit<16> tango_metrics_hdr_3;
  action labeledstmt_123(){
    tango_metrics_hdr_3=((bit<16>)seq_number);
  }
  action labeledstmt_18(){
    labeledstmt_123();
    labeledstmt_124();
    labeledstmt_125();
    labeledstmt_126();
  }
 
RegisterAction<bit<32>,bit<16>,bit<32>>(outgoing_metric_signature_manager_0)
  outgoing_metric_signature_manager_0_regaction_4253 = {
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
   
MetricSignatureManager_sign_ret3427=outgoing_metric_signature_manager_0_regaction_4253.execute(merged_var_precompute4222_precompute4219_4249);
  }
  action labeledstmt_19(){
    labeledstmt_127();
  }
  action labeledstmt_20(){
    //NOOP
  }
  bit<32> ts_signature;
  action labeledstmt_129(){
    ts_signature=MetricSignatureManager_sign_ret;
  }
  bit<32> sig_bitstring;
  RegisterAction<bit<32>,bit<16>,bit<32>>(outgoing_book_signature_manager_0)
  outgoing_book_signature_manager_0_regaction_4254 = {
    void apply(inout bit<32> cell1_remote,
        out bit<32> ret_remote){
      bit<32> cell1_local=cell1_remote;
      bit<32> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_128(){
   
sig_bitstring=outgoing_book_signature_manager_0_regaction_4254.execute(merged_var_precompute4221_precompute_4248);
  }
  action labeledstmt_21(){
    labeledstmt_128();
    labeledstmt_129();
  }
  bit<32> sig_bitstring3424;
  RegisterAction<bit<32>,bit<16>,bit<32>>(outgoing_book_signature_manager_0)
  outgoing_book_signature_manager_0_regaction_4255 = {
    void apply(inout bit<32> cell1_remote,
        out bit<32> ret_remote){
      bit<32> cell1_local=cell1_remote;
      bit<32> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_130(){
   
sig_bitstring3424=outgoing_book_signature_manager_0_regaction_4255.execute(merged_var_precompute4221_precompute_4248);
  }
  action labeledstmt_22(){
    labeledstmt_130();
  }
  action labeledstmt_23(){
    //NOOP
  }
  action labeledstmt_131(){
    BookSignatureManager_sign_ret3423=(sig_bitstring3424[0:0]);
  }
  action labeledstmt_24(){
    labeledstmt_131();
  }
  action labeledstmt_132(){
    BookSignatureManager_sign_ret3423=(sig_bitstring3424[1:1]);
  }
  action labeledstmt_25(){
    labeledstmt_132();
  }
  action labeledstmt_133(){
    BookSignatureManager_sign_ret3423=(sig_bitstring3424[2:2]);
  }
  action labeledstmt_26(){
    labeledstmt_133();
  }
  action labeledstmt_134(){
    BookSignatureManager_sign_ret3423=(sig_bitstring3424[3:3]);
  }
  action labeledstmt_27(){
    labeledstmt_134();
  }
  action labeledstmt_135(){
    BookSignatureManager_sign_ret3423=(sig_bitstring3424[4:4]);
  }
  action labeledstmt_28(){
    labeledstmt_135();
  }
  action labeledstmt_136(){
    BookSignatureManager_sign_ret3423=(sig_bitstring3424[5:5]);
  }
  action labeledstmt_29(){
    labeledstmt_136();
  }
  action labeledstmt_137(){
    BookSignatureManager_sign_ret3423=(sig_bitstring3424[6:6]);
  }
  action labeledstmt_30(){
    labeledstmt_137();
  }
  action labeledstmt_138(){
    BookSignatureManager_sign_ret3423=(sig_bitstring3424[7:7]);
  }
  action labeledstmt_31(){
    labeledstmt_138();
  }
  action labeledstmt_139(){
    BookSignatureManager_sign_ret3423=(sig_bitstring3424[8:8]);
  }
  action labeledstmt_32(){
    labeledstmt_139();
  }
  action labeledstmt_140(){
    BookSignatureManager_sign_ret3423=(sig_bitstring3424[9:9]);
  }
  action labeledstmt_33(){
    labeledstmt_140();
  }
  action labeledstmt_141(){
    BookSignatureManager_sign_ret3423=(sig_bitstring3424[10:10]);
  }
  action labeledstmt_34(){
    labeledstmt_141();
  }
  action labeledstmt_142(){
    BookSignatureManager_sign_ret3423=(sig_bitstring3424[11:11]);
  }
  action labeledstmt_35(){
    labeledstmt_142();
  }
  action labeledstmt_143(){
    BookSignatureManager_sign_ret3423=(sig_bitstring3424[12:12]);
  }
  action labeledstmt_36(){
    labeledstmt_143();
  }
  action labeledstmt_144(){
    BookSignatureManager_sign_ret3423=(sig_bitstring3424[13:13]);
  }
  action labeledstmt_37(){
    labeledstmt_144();
  }
  action labeledstmt_145(){
    BookSignatureManager_sign_ret3423=(sig_bitstring3424[14:14]);
  }
  action labeledstmt_38(){
    labeledstmt_145();
  }
  action labeledstmt_146(){
    BookSignatureManager_sign_ret3423=(sig_bitstring3424[15:15]);
  }
  action labeledstmt_39(){
    labeledstmt_146();
  }
  action labeledstmt_147(){
    BookSignatureManager_sign_ret3423=(sig_bitstring3424[16:16]);
  }
  action labeledstmt_40(){
    labeledstmt_147();
  }
  action labeledstmt_148(){
    BookSignatureManager_sign_ret3423=(sig_bitstring3424[17:17]);
  }
  action labeledstmt_41(){
    labeledstmt_148();
  }
  action labeledstmt_149(){
    BookSignatureManager_sign_ret3423=(sig_bitstring3424[18:18]);
  }
  action labeledstmt_42(){
    labeledstmt_149();
  }
  action labeledstmt_150(){
    BookSignatureManager_sign_ret3423=(sig_bitstring3424[19:19]);
  }
  action labeledstmt_43(){
    labeledstmt_150();
  }
  action labeledstmt_151(){
    BookSignatureManager_sign_ret3423=(sig_bitstring3424[20:20]);
  }
  action labeledstmt_44(){
    labeledstmt_151();
  }
  action labeledstmt_152(){
    BookSignatureManager_sign_ret3423=(sig_bitstring3424[21:21]);
  }
  action labeledstmt_45(){
    labeledstmt_152();
  }
  action labeledstmt_153(){
    BookSignatureManager_sign_ret3423=(sig_bitstring3424[22:22]);
  }
  action labeledstmt_46(){
    labeledstmt_153();
  }
  action labeledstmt_154(){
    BookSignatureManager_sign_ret3423=(sig_bitstring3424[23:23]);
  }
  action labeledstmt_47(){
    labeledstmt_154();
  }
  action labeledstmt_155(){
    BookSignatureManager_sign_ret3423=(sig_bitstring3424[24:24]);
  }
  action labeledstmt_48(){
    labeledstmt_155();
  }
  action labeledstmt_156(){
    BookSignatureManager_sign_ret3423=(sig_bitstring3424[25:25]);
  }
  action labeledstmt_49(){
    labeledstmt_156();
  }
  action labeledstmt_157(){
    BookSignatureManager_sign_ret3423=(sig_bitstring3424[26:26]);
  }
  action labeledstmt_50(){
    labeledstmt_157();
  }
  action labeledstmt_158(){
    BookSignatureManager_sign_ret3423=(sig_bitstring3424[27:27]);
  }
  action labeledstmt_51(){
    labeledstmt_158();
  }
  action labeledstmt_159(){
    BookSignatureManager_sign_ret3423=(sig_bitstring3424[28:28]);
  }
  action labeledstmt_52(){
    labeledstmt_159();
  }
  action labeledstmt_160(){
    BookSignatureManager_sign_ret3423=(sig_bitstring3424[29:29]);
  }
  action labeledstmt_53(){
    labeledstmt_160();
  }
  action labeledstmt_161(){
    BookSignatureManager_sign_ret3423=(sig_bitstring3424[30:30]);
  }
  action labeledstmt_54(){
    labeledstmt_161();
  }
  action labeledstmt_162(){
    BookSignatureManager_sign_ret3423=(sig_bitstring3424[31:31]);
  }
  action labeledstmt_55(){
    labeledstmt_162();
  }
  action labeledstmt_56(){
    //NOOP
  }
  action labeledstmt_163(){
    BookSignatureManager_sign_ret=(sig_bitstring[0:0]);
  }
  action labeledstmt_57(){
    labeledstmt_163();
  }
  action labeledstmt_164(){
    BookSignatureManager_sign_ret=(sig_bitstring[1:1]);
  }
  action labeledstmt_58(){
    labeledstmt_164();
  }
  action labeledstmt_165(){
    BookSignatureManager_sign_ret=(sig_bitstring[2:2]);
  }
  action labeledstmt_59(){
    labeledstmt_165();
  }
  action labeledstmt_166(){
    BookSignatureManager_sign_ret=(sig_bitstring[3:3]);
  }
  action labeledstmt_60(){
    labeledstmt_166();
  }
  action labeledstmt_167(){
    BookSignatureManager_sign_ret=(sig_bitstring[4:4]);
  }
  action labeledstmt_61(){
    labeledstmt_167();
  }
  action labeledstmt_168(){
    BookSignatureManager_sign_ret=(sig_bitstring[5:5]);
  }
  action labeledstmt_62(){
    labeledstmt_168();
  }
  action labeledstmt_169(){
    BookSignatureManager_sign_ret=(sig_bitstring[6:6]);
  }
  action labeledstmt_63(){
    labeledstmt_169();
  }
  action labeledstmt_170(){
    BookSignatureManager_sign_ret=(sig_bitstring[7:7]);
  }
  action labeledstmt_64(){
    labeledstmt_170();
  }
  action labeledstmt_171(){
    BookSignatureManager_sign_ret=(sig_bitstring[8:8]);
  }
  action labeledstmt_65(){
    labeledstmt_171();
  }
  action labeledstmt_172(){
    BookSignatureManager_sign_ret=(sig_bitstring[9:9]);
  }
  action labeledstmt_66(){
    labeledstmt_172();
  }
  action labeledstmt_173(){
    BookSignatureManager_sign_ret=(sig_bitstring[10:10]);
  }
  action labeledstmt_67(){
    labeledstmt_173();
  }
  action labeledstmt_174(){
    BookSignatureManager_sign_ret=(sig_bitstring[11:11]);
  }
  action labeledstmt_68(){
    labeledstmt_174();
  }
  action labeledstmt_175(){
    BookSignatureManager_sign_ret=(sig_bitstring[12:12]);
  }
  action labeledstmt_69(){
    labeledstmt_175();
  }
  action labeledstmt_176(){
    BookSignatureManager_sign_ret=(sig_bitstring[13:13]);
  }
  action labeledstmt_70(){
    labeledstmt_176();
  }
  action labeledstmt_177(){
    BookSignatureManager_sign_ret=(sig_bitstring[14:14]);
  }
  action labeledstmt_71(){
    labeledstmt_177();
  }
  action labeledstmt_178(){
    BookSignatureManager_sign_ret=(sig_bitstring[15:15]);
  }
  action labeledstmt_72(){
    labeledstmt_178();
  }
  action labeledstmt_179(){
    BookSignatureManager_sign_ret=(sig_bitstring[16:16]);
  }
  action labeledstmt_73(){
    labeledstmt_179();
  }
  action labeledstmt_180(){
    BookSignatureManager_sign_ret=(sig_bitstring[17:17]);
  }
  action labeledstmt_74(){
    labeledstmt_180();
  }
  action labeledstmt_181(){
    BookSignatureManager_sign_ret=(sig_bitstring[18:18]);
  }
  action labeledstmt_75(){
    labeledstmt_181();
  }
  action labeledstmt_182(){
    BookSignatureManager_sign_ret=(sig_bitstring[19:19]);
  }
  action labeledstmt_76(){
    labeledstmt_182();
  }
  action labeledstmt_183(){
    BookSignatureManager_sign_ret=(sig_bitstring[20:20]);
  }
  action labeledstmt_77(){
    labeledstmt_183();
  }
  action labeledstmt_184(){
    BookSignatureManager_sign_ret=(sig_bitstring[21:21]);
  }
  action labeledstmt_78(){
    labeledstmt_184();
  }
  action labeledstmt_185(){
    BookSignatureManager_sign_ret=(sig_bitstring[22:22]);
  }
  action labeledstmt_79(){
    labeledstmt_185();
  }
  action labeledstmt_186(){
    BookSignatureManager_sign_ret=(sig_bitstring[23:23]);
  }
  action labeledstmt_80(){
    labeledstmt_186();
  }
  action labeledstmt_187(){
    BookSignatureManager_sign_ret=(sig_bitstring[24:24]);
  }
  action labeledstmt_81(){
    labeledstmt_187();
  }
  action labeledstmt_188(){
    BookSignatureManager_sign_ret=(sig_bitstring[25:25]);
  }
  action labeledstmt_82(){
    labeledstmt_188();
  }
  action labeledstmt_189(){
    BookSignatureManager_sign_ret=(sig_bitstring[26:26]);
  }
  action labeledstmt_83(){
    labeledstmt_189();
  }
  action labeledstmt_190(){
    BookSignatureManager_sign_ret=(sig_bitstring[27:27]);
  }
  action labeledstmt_84(){
    labeledstmt_190();
  }
  action labeledstmt_191(){
    BookSignatureManager_sign_ret=(sig_bitstring[28:28]);
  }
  action labeledstmt_85(){
    labeledstmt_191();
  }
  action labeledstmt_192(){
    BookSignatureManager_sign_ret=(sig_bitstring[29:29]);
  }
  action labeledstmt_86(){
    labeledstmt_192();
  }
  action labeledstmt_193(){
    BookSignatureManager_sign_ret=(sig_bitstring[30:30]);
  }
  action labeledstmt_87(){
    labeledstmt_193();
  }
  action labeledstmt_194(){
    BookSignatureManager_sign_ret=(sig_bitstring[31:31]);
  }
  action labeledstmt_88(){
    labeledstmt_194();
  }
  action labeledstmt_89(){
    //NOOP
  }
  bit<32> tango_metrics_hdr_2;
  action labeledstmt_195(){
    tango_metrics_hdr_2=ts_signature;
  }
  action labeledstmt_90(){
    labeledstmt_195();
  }
  action labeledstmt_91(){
    //NOOP
  }
  bit<1> book_signature;
  action labeledstmt_196(){
    book_signature=BookSignatureManager_sign_ret;
  }
  action labeledstmt_92(){
    labeledstmt_196();
  }
  action labeledstmt_197(){
    hdr.set_signature.setInvalid();
  }
  action labeledstmt_93(){
    labeledstmt_197();
  }
  action labeledstmt_94(){
    //NOOP
  }
  bit<8> tango_metrics_hdr_4;
  action labeledstmt_198(){
    tango_metrics_hdr_4=((bit<8>)book_signature);
  }
  action labeledstmt_95(){
    labeledstmt_198();
  }
  action labeledstmt_96(){
    //NOOP
  }
  action labeledstmt_97(){
    hdr.bridge_ev.incoming_tango_traffic=1;
    hdr.incoming_tango_traffic.setValid();
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_eth_header_0=hdr.forward_flow.forward_flow_eth_header_0;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_eth_header_1=hdr.forward_flow.forward_flow_eth_header_1;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_eth_header_2=16w34525;
    hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_0=32w0;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_1=precompute4220;
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
  action labeledstmt_98(){
    //NOOP
  }
  action labeledstmt_199(){
    hdr.forward_flow.setInvalid();
  }
  action labeledstmt_99(){
    labeledstmt_199();
  }
  table table_4267 {
    key = {
      hdr.wire_ev.event_id : ternary;
      hdr.set_signature.set_signature_sig_type : ternary;
      hdr.set_signature.set_signature_next_signature : ternary;
    }
    actions = {
      labeledstmt_1;
      labeledstmt_2;
      labeledstmt_3;
      labeledstmt_4;
      labeledstmt_5;
      labeledstmt_6;
      labeledstmt_7;
      labeledstmt_8;
    }
    const entries = {
      (2,0,0) : labeledstmt_1();
      (2,_,0) : labeledstmt_1();
      (4,0,0) : labeledstmt_2();
      (4,_,0) : labeledstmt_2();
      (1,0,0) : labeledstmt_3();
      (1,_,0) : labeledstmt_3();
      (3,0,0) : labeledstmt_4();
      (3,_,0) : labeledstmt_5();
      (2,0,_) : labeledstmt_1();
      (2,_,_) : labeledstmt_1();
      (4,0,_) : labeledstmt_2();
      (4,_,_) : labeledstmt_2();
      (1,0,_) : labeledstmt_3();
      (1,_,_) : labeledstmt_3();
      (3,0,_) : labeledstmt_6();
      (3,_,_) : labeledstmt_7();
      (_,_,_) : labeledstmt_8();
    } 
  } 
  table table_4266 {
    key = {
      hdr.wire_ev.event_id : ternary;
      hdr.set_signature.set_signature_sig_type : ternary;
      hdr.set_signature.set_signature_next_signature : ternary;
    }
    actions = {
      labeledstmt_9;
      labeledstmt_10;
      labeledstmt_11;
      labeledstmt_12;
      labeledstmt_13;
      labeledstmt_14;
    }
    const entries = {
      (2,0,0) : labeledstmt_9();
      (2,_,0) : labeledstmt_9();
      (4,0,0) : labeledstmt_9();
      (4,_,0) : labeledstmt_9();
      (1,0,0) : labeledstmt_10();
      (1,_,0) : labeledstmt_10();
      (3,0,0) : labeledstmt_11();
      (3,_,0) : labeledstmt_12();
      (2,0,_) : labeledstmt_9();
      (2,_,_) : labeledstmt_9();
      (4,0,_) : labeledstmt_9();
      (4,_,_) : labeledstmt_9();
      (1,0,_) : labeledstmt_10();
      (1,_,_) : labeledstmt_10();
      (3,0,_) : labeledstmt_13();
      (3,_,_) : labeledstmt_14();
      (_,_,_) : labeledstmt_9();
    } 
  } 
  table table_4265 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_15;
      labeledstmt_16;
    }
    const entries = {
      (2) : labeledstmt_15();
      (4) : labeledstmt_15();
      (1) : labeledstmt_16();
      (_) : labeledstmt_15();
    } 
  } 
  table table_4264 {
    key = {
      hdr.wire_ev.event_id : ternary;
      hdr.set_signature.set_signature_sig_type : ternary;
    }
    actions = {
      labeledstmt_17;
      labeledstmt_18;
      labeledstmt_19;
    }
    const entries = {
      (2,0) : labeledstmt_17();
      (4,0) : labeledstmt_17();
      (1,0) : labeledstmt_18();
      (3,0) : labeledstmt_17();
      (2,_) : labeledstmt_17();
      (4,_) : labeledstmt_17();
      (1,_) : labeledstmt_18();
      (3,_) : labeledstmt_19();
      (_,_) : labeledstmt_17();
    } 
  } 
  table table_4263 {
    key = {
      hdr.wire_ev.event_id : ternary;
      hdr.set_signature.set_signature_sig_type : ternary;
    }
    actions = {
      labeledstmt_20;
      labeledstmt_21;
      labeledstmt_22;
    }
    const entries = {
      (2,0) : labeledstmt_20();
      (2,_) : labeledstmt_20();
      (4,0) : labeledstmt_20();
      (4,_) : labeledstmt_20();
      (1,0) : labeledstmt_21();
      (1,_) : labeledstmt_21();
      (3,0) : labeledstmt_22();
      (_,_) : labeledstmt_20();
    } 
  } 
  @ignore_table_dependency("IngressControl.table_4261")
  @ignore_table_dependency("IngressControl.table_4262")table table_4260 {
    key = {
      hdr.set_signature.set_signature_sig_type : ternary;
      hdr.wire_ev.event_id : ternary;
      bitwhack_index3425 : ternary;
    }
    actions = {
      labeledstmt_23;
      labeledstmt_24;
      labeledstmt_25;
      labeledstmt_26;
      labeledstmt_27;
      labeledstmt_28;
      labeledstmt_29;
      labeledstmt_30;
      labeledstmt_31;
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
      labeledstmt_50;
      labeledstmt_51;
      labeledstmt_52;
      labeledstmt_53;
      labeledstmt_54;
      labeledstmt_55;
    }
    const entries = {
      (0,2,_) : labeledstmt_23();
      (0,4,_) : labeledstmt_23();
      (0,1,_) : labeledstmt_23();
      (0,3,0) : labeledstmt_24();
      (0,3,1) : labeledstmt_25();
      (0,3,2) : labeledstmt_26();
      (0,3,3) : labeledstmt_27();
      (0,3,4) : labeledstmt_28();
      (0,3,5) : labeledstmt_29();
      (0,3,6) : labeledstmt_30();
      (0,3,7) : labeledstmt_31();
      (0,3,8) : labeledstmt_32();
      (0,3,9) : labeledstmt_33();
      (0,3,10) : labeledstmt_34();
      (0,3,11) : labeledstmt_35();
      (0,3,12) : labeledstmt_36();
      (0,3,13) : labeledstmt_37();
      (0,3,14) : labeledstmt_38();
      (0,3,15) : labeledstmt_39();
      (0,3,16) : labeledstmt_40();
      (0,3,17) : labeledstmt_41();
      (0,3,18) : labeledstmt_42();
      (0,3,19) : labeledstmt_43();
      (0,3,20) : labeledstmt_44();
      (0,3,21) : labeledstmt_45();
      (0,3,22) : labeledstmt_46();
      (0,3,23) : labeledstmt_47();
      (0,3,24) : labeledstmt_48();
      (0,3,25) : labeledstmt_49();
      (0,3,26) : labeledstmt_50();
      (0,3,27) : labeledstmt_51();
      (0,3,28) : labeledstmt_52();
      (0,3,29) : labeledstmt_53();
      (0,3,30) : labeledstmt_54();
      (0,3,_) : labeledstmt_55();
      (_,_,_) : labeledstmt_23();
    } 
  } 
  @ignore_table_dependency("IngressControl.table_4260")
  @ignore_table_dependency("IngressControl.table_4262")table table_4261 {
    key = {
      hdr.wire_ev.event_id : ternary;
      bitwhack_index : ternary;
    }
    actions = {
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
      labeledstmt_71;
      labeledstmt_72;
      labeledstmt_73;
      labeledstmt_74;
      labeledstmt_75;
      labeledstmt_76;
      labeledstmt_77;
      labeledstmt_78;
      labeledstmt_79;
      labeledstmt_80;
      labeledstmt_81;
      labeledstmt_82;
      labeledstmt_83;
      labeledstmt_84;
      labeledstmt_85;
      labeledstmt_86;
      labeledstmt_87;
      labeledstmt_88;
    }
    const entries = {
      (2,_) : labeledstmt_56();
      (4,_) : labeledstmt_56();
      (1,0) : labeledstmt_57();
      (1,1) : labeledstmt_58();
      (1,2) : labeledstmt_59();
      (1,3) : labeledstmt_60();
      (1,4) : labeledstmt_61();
      (1,5) : labeledstmt_62();
      (1,6) : labeledstmt_63();
      (1,7) : labeledstmt_64();
      (1,8) : labeledstmt_65();
      (1,9) : labeledstmt_66();
      (1,10) : labeledstmt_67();
      (1,11) : labeledstmt_68();
      (1,12) : labeledstmt_69();
      (1,13) : labeledstmt_70();
      (1,14) : labeledstmt_71();
      (1,15) : labeledstmt_72();
      (1,16) : labeledstmt_73();
      (1,17) : labeledstmt_74();
      (1,18) : labeledstmt_75();
      (1,19) : labeledstmt_76();
      (1,20) : labeledstmt_77();
      (1,21) : labeledstmt_78();
      (1,22) : labeledstmt_79();
      (1,23) : labeledstmt_80();
      (1,24) : labeledstmt_81();
      (1,25) : labeledstmt_82();
      (1,26) : labeledstmt_83();
      (1,27) : labeledstmt_84();
      (1,28) : labeledstmt_85();
      (1,29) : labeledstmt_86();
      (1,30) : labeledstmt_87();
      (1,_) : labeledstmt_88();
      (_,_) : labeledstmt_56();
    } 
  } 
  @ignore_table_dependency("IngressControl.table_4260")
  @ignore_table_dependency("IngressControl.table_4261")table table_4262 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_89;
      labeledstmt_90;
    }
    const entries = {
      (2) : labeledstmt_89();
      (4) : labeledstmt_89();
      (1) : labeledstmt_90();
      (_) : labeledstmt_89();
    } 
  } 
  table table_4259 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_91;
      labeledstmt_92;
      labeledstmt_93;
    }
    const entries = {
      (2) : labeledstmt_91();
      (4) : labeledstmt_91();
      (1) : labeledstmt_92();
      (3) : labeledstmt_93();
      (_) : labeledstmt_91();
    } 
  } 
  table table_4258 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_94;
      labeledstmt_95;
    }
    const entries = {
      (2) : labeledstmt_94();
      (4) : labeledstmt_94();
      (1) : labeledstmt_95();
      (_) : labeledstmt_94();
    } 
  } 
  table table_4257 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_96;
      labeledstmt_97;
    }
    const entries = {
      (2) : labeledstmt_96();
      (4) : labeledstmt_96();
      (1) : labeledstmt_97();
      (_) : labeledstmt_96();
    } 
  } 
  table table_4256 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_98;
      labeledstmt_99;
    }
    const entries = {
      (2) : labeledstmt_98();
      (4) : labeledstmt_98();
      (1) : labeledstmt_99();
      (_) : labeledstmt_98();
    } 
  } 
  apply {
    table_4267.apply();
    table_4266.apply();
    table_4265.apply();
    table_4264.apply();
    table_4263.apply();
    table_4260.apply();
    table_4261.apply();
    table_4262.apply();
    table_4259.apply();
    table_4258.apply();
    table_4257.apply();
    table_4256.apply();
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
