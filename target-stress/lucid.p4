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
  bit<4> flag_pad_4148;
  bit<1> set_next_signature;
  bit<1> set_signature;
  bit<1> incoming_tango_traffic;
  bit<1> forward_flow;
}
header set_next_signature_t {
  bit<8> set_next_signature_sig_type;
  bit<16> set_next_signature_sig_idx;
  bit<8> set_next_signature_block_idx;
  bit<32> set_next_signature_next_signature;
}
header set_signature_t {
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
Register<bit<8>,_>(32w1) sequence_counters_0;
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
  bit<4> merged_var_precompute4082_sig_addr_precompute4079_4125;
  bit<10> merged_var_precompute4081_word_addr_precompute4078_precompute_4124;
  action labeledstmt_79(){
    hdr.incoming_tango_traffic.setInvalid();
  }
  action labeledstmt_1(){
    labeledstmt_79();
  }
  action labeledstmt_80(){
    hdr.set_next_signature.setInvalid();
  }
  action labeledstmt_2(){
    labeledstmt_80();
  }
  bit<16> precompute4080;
  action labeledstmt_87(){
    precompute4080=(hdr.forward_flow.forward_flow_ip_header_2+16w18);
  }
  bit<8> tango_metrics_hdr_0;
  action labeledstmt_86(){
    tango_metrics_hdr_0=8w0;
  }
  bit<32> MetricSignatureManager_sign_ret;
  action labeledstmt_85(){
    MetricSignatureManager_sign_ret=32w32;
  }
  bit<32> sig_bitstring;
  action labeledstmt_84(){
    sig_bitstring=32w0;
  }
  bit<1> BookSignatureManager_sign_ret;
  action labeledstmt_83(){
    BookSignatureManager_sign_ret=1w0;
  }
  bit<32> time_now;
  action labeledstmt_82(){
    time_now=(ig_intr_md.ingress_mac_tstamp[47:16]);
  }
  bit<8> SequenceNumberManager_increment_ret;
  action labeledstmt_81(){
    SequenceNumberManager_increment_ret=8w32;
  }
  action labeledstmt_3(){
    labeledstmt_81();
    labeledstmt_82();
    labeledstmt_83();
    labeledstmt_84();
    labeledstmt_85();
    labeledstmt_86();
    labeledstmt_87();
  }
  bit<32> if_precomp;
  action labeledstmt_88(){
    if_precomp=(((bit<32>)hdr.set_signature.set_signature_sig_type)-32w0);
  }
  action labeledstmt_4(){
    labeledstmt_88();
  }
  bit<16> precompute4083;
  action labeledstmt_89(){
    precompute4083=(16w1+hdr.set_signature.set_signature_sig_idx);
  }
  action labeledstmt_5(){
    labeledstmt_88();
    labeledstmt_89();
  }
  action labeledstmt_6(){
    //NOOP
  }
  action labeledstmt_7(){
    //NOOP
  }
  bit<12> timestamp;
  action labeledstmt_91(){
    timestamp=(time_now[31:20]);
  }
  RegisterAction<bit<8>,bit<32>,bit<8>>(sequence_counters_0)
  sequence_counters_0_regaction_4126 = {
    void apply(inout bit<8> cell1_remote,
        out bit<8> ret_remote){
      bit<8> cell1_local=cell1_remote;
      bit<8> cell2_local=0;
      if(true){
        cell1_remote=(cell1_local+8w1);
      }
      if(true){
        cell2_local=cell1_local;
      }
      if(true){
        ret_remote=cell2_local;
      }
    }
  };
  action labeledstmt_90(){
   
SequenceNumberManager_increment_ret=sequence_counters_0_regaction_4126.execute(32w0);
  }
  action labeledstmt_8(){
    labeledstmt_90();
    labeledstmt_91();
  }
  action labeledstmt_93(){
   
merged_var_precompute4081_word_addr_precompute4078_precompute_4124=((bit<10>)hdr.set_signature.set_signature_sig_idx);
  }
  bit<1> block_idx3493;
  action labeledstmt_92(){
    block_idx3493=((bit<1>)hdr.set_signature.set_signature_block_idx);
  }
  action labeledstmt_9(){
    labeledstmt_92();
    labeledstmt_93();
  }
  action labeledstmt_95(){
   
merged_var_precompute4082_sig_addr_precompute4079_4125=((bit<4>)hdr.set_signature.set_signature_sig_idx);
  }
  bit<1> block_idx3496;
  action labeledstmt_94(){
    block_idx3496=((bit<1>)hdr.set_signature.set_signature_block_idx);
  }
  action labeledstmt_10(){
    labeledstmt_94();
    labeledstmt_95();
  }
  action labeledstmt_11(){
    labeledstmt_92();
    labeledstmt_93();
    hdr.bridge_ev.set_next_signature=1;
    hdr.set_next_signature.setValid();
   
hdr.set_next_signature.set_next_signature_sig_type=hdr.set_signature.set_signature_sig_type;
    hdr.set_next_signature.set_next_signature_sig_idx=precompute4083;
   
hdr.set_next_signature.set_next_signature_block_idx=hdr.set_signature.set_signature_block_idx;
   
hdr.set_next_signature.set_next_signature_next_signature=hdr.set_signature.set_signature_next_signature;
    hdr.bridge_ev.port_event_id=4;
    ig_tm_md.ucast_egress_port=9w196;
  }
  action labeledstmt_12(){
    labeledstmt_94();
    labeledstmt_95();
    hdr.bridge_ev.set_next_signature=1;
    hdr.set_next_signature.setValid();
   
hdr.set_next_signature.set_next_signature_sig_type=hdr.set_signature.set_signature_sig_type;
    hdr.set_next_signature.set_next_signature_sig_idx=precompute4083;
   
hdr.set_next_signature.set_next_signature_block_idx=hdr.set_signature.set_signature_block_idx;
   
hdr.set_next_signature.set_next_signature_next_signature=hdr.set_signature.set_signature_next_signature;
    hdr.bridge_ev.port_event_id=4;
    ig_tm_md.ucast_egress_port=9w196;
  }
  action labeledstmt_13(){
    //NOOP
  }
  bit<1> block_idx;
  action labeledstmt_99(){
    block_idx=(timestamp[2:2]);
  }
  bit<1> block_idx3479;
  action labeledstmt_98(){
    block_idx3479=(timestamp[4:4]);
  }
  bit<16> tango_metrics_hdr_1;
  CRCPolynomial<bit<16>>(1,false, false, false, 0, 0) hash_41270_crc;
  Hash<bit<16>>(HashAlgorithm_t.CUSTOM,hash_41270_crc) hash_41270;
  action labeledstmt_97(){
    tango_metrics_hdr_1=hash_41270.get({timestamp});
  }
  bit<8> seq_number;
  action labeledstmt_96(){
    seq_number=SequenceNumberManager_increment_ret;
  }
  action labeledstmt_14(){
    labeledstmt_96();
    labeledstmt_97();
    labeledstmt_98();
    labeledstmt_99();
  }
  bit<32> block;
  action labeledstmt_100(){
    block=((bit<32>)block_idx3493);
  }
  action labeledstmt_15(){
    labeledstmt_100();
  }
  action labeledstmt_101(){
   
merged_var_precompute4082_sig_addr_precompute4079_4125=(merged_var_precompute4082_sig_addr_precompute4079_4125+4w0);
  }
  action labeledstmt_16(){
    labeledstmt_101();
  }
  action labeledstmt_17(){
    //NOOP
  }
  action labeledstmt_104(){
   
merged_var_precompute4081_word_addr_precompute4078_precompute_4124=((bit<11>)(seq_number[7:5]));
  }
  bit<5> bitwhack_index;
  action labeledstmt_103(){
    bitwhack_index=(seq_number[4:0]);
  }
  bit<16> tango_metrics_hdr_3;
  action labeledstmt_102(){
    tango_metrics_hdr_3=((bit<16>)seq_number);
  }
  action labeledstmt_18(){
    labeledstmt_102();
    labeledstmt_103();
    labeledstmt_104();
  }
  action labeledstmt_105(){
   
merged_var_precompute4082_sig_addr_precompute4079_4125=((timestamp[3:0])+4w0);
  }
  action labeledstmt_19(){
    labeledstmt_102();
    labeledstmt_103();
    labeledstmt_105();
    labeledstmt_104();
  }
  bit<3> to_immediate_tmp;
  action labeledstmt_106(){
    to_immediate_tmp=(3w0+(seq_number[7:5]));
  }
  action labeledstmt_20(){
    labeledstmt_102();
    labeledstmt_103();
    labeledstmt_106();
  }
  action labeledstmt_21(){
    labeledstmt_102();
    labeledstmt_103();
    labeledstmt_105();
    labeledstmt_106();
  }
  action labeledstmt_107(){
   
merged_var_precompute4081_word_addr_precompute4078_precompute_4124=(merged_var_precompute4081_word_addr_precompute4078_precompute_4124+10w0);
  }
  action labeledstmt_22(){
    labeledstmt_107();
  }
  action labeledstmt_23(){
    //NOOP
  }
  RegisterAction<bit<32>,bit<4>,bit<32>>(outgoing_metric_signature_manager_0)
  outgoing_metric_signature_manager_0_regaction_4128 = {
    void apply(inout bit<32> cell1_remote,
        out bit<32> ret_remote){
      bit<32> cell1_local=cell1_remote;
      bit<32> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_108(){
   
MetricSignatureManager_sign_ret=outgoing_metric_signature_manager_0_regaction_4128.execute((timestamp[3:0]));
  }
  action labeledstmt_24(){
    labeledstmt_108();
  }
  RegisterAction<bit<32>,bit<4>,bit<32>>(outgoing_metric_signature_manager_0)
  outgoing_metric_signature_manager_0_regaction_4129 = {
    void apply(inout bit<32> cell1_remote,
        out bit<32> ret_remote){
      bit<32> cell1_local=cell1_remote;
      bit<32> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_109(){
   
MetricSignatureManager_sign_ret=outgoing_metric_signature_manager_0_regaction_4129.execute(merged_var_precompute4082_sig_addr_precompute4079_4125);
  }
  action labeledstmt_25(){
    labeledstmt_109();
  }
  action labeledstmt_110(){
   
merged_var_precompute4081_word_addr_precompute4078_precompute_4124=((bit<11>)to_immediate_tmp);
  }
  action labeledstmt_26(){
    labeledstmt_108();
    labeledstmt_110();
  }
  action labeledstmt_27(){
    labeledstmt_109();
    labeledstmt_110();
  }
  RegisterAction<bit<32>,bit<4>,bit<32>>(outgoing_metric_signature_manager_0)
  outgoing_metric_signature_manager_0_regaction_4130 = {
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
  action labeledstmt_111(){
   
outgoing_metric_signature_manager_0_regaction_4130.execute(merged_var_precompute4082_sig_addr_precompute4079_4125);
  }
  action labeledstmt_28(){
    labeledstmt_111();
  }
  RegisterAction<bit<32>,bit<4>,bit<32>>(outgoing_metric_signature_manager_0)
  outgoing_metric_signature_manager_0_regaction_4131 = {
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
  action labeledstmt_112(){
   
outgoing_metric_signature_manager_0_regaction_4131.execute(merged_var_precompute4082_sig_addr_precompute4079_4125);
  }
  action labeledstmt_29(){
    labeledstmt_112();
  }
  action labeledstmt_30(){
    //NOOP
  }
  RegisterAction<bit<32>,bit<10>,bit<32>>(outgoing_book_signature_manager_0)
  outgoing_book_signature_manager_0_regaction_4132 = {
    void apply(inout bit<32> cell1_remote,
        out bit<32> ret_remote){
      bit<32> cell1_local=cell1_remote;
      bit<32> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_114(){
   
sig_bitstring=outgoing_book_signature_manager_0_regaction_4132.execute(merged_var_precompute4081_word_addr_precompute4078_precompute_4124);
  }
  bit<32> ts_signature;
  action labeledstmt_113(){
    ts_signature=MetricSignatureManager_sign_ret;
  }
  action labeledstmt_31(){
    labeledstmt_113();
    labeledstmt_114();
  }
  RegisterAction<bit<32>,bit<10>,bit<32>>(outgoing_book_signature_manager_0)
  outgoing_book_signature_manager_0_regaction_4133 = {
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
   
sig_bitstring=outgoing_book_signature_manager_0_regaction_4133.execute(merged_var_precompute4081_word_addr_precompute4078_precompute_4124);
  }
  action labeledstmt_32(){
    labeledstmt_113();
    labeledstmt_115();
  }
  RegisterAction<bit<32>,bit<10>,bit<32>>(outgoing_book_signature_manager_0)
  outgoing_book_signature_manager_0_regaction_4134 = {
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
  action labeledstmt_116(){
   
outgoing_book_signature_manager_0_regaction_4134.execute(merged_var_precompute4081_word_addr_precompute4078_precompute_4124);
  }
  action labeledstmt_33(){
    labeledstmt_116();
  }
  RegisterAction<bit<32>,bit<10>,bit<32>>(outgoing_book_signature_manager_0)
  outgoing_book_signature_manager_0_regaction_4135 = {
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
  action labeledstmt_117(){
   
outgoing_book_signature_manager_0_regaction_4135.execute(merged_var_precompute4081_word_addr_precompute4078_precompute_4124);
  }
  action labeledstmt_34(){
    labeledstmt_117();
  }
  action labeledstmt_35(){
    //NOOP
  }
  bit<32> tango_metrics_hdr_2;
  action labeledstmt_118(){
    tango_metrics_hdr_2=ts_signature;
  }
  action labeledstmt_36(){
    labeledstmt_118();
  }
  action labeledstmt_119(){
    hdr.set_signature.setInvalid();
  }
  action labeledstmt_37(){
    labeledstmt_119();
  }
  action labeledstmt_38(){
    //NOOP
  }
  action labeledstmt_120(){
    BookSignatureManager_sign_ret=(sig_bitstring[0:0]);
  }
  action labeledstmt_39(){
    labeledstmt_120();
  }
  action labeledstmt_121(){
    BookSignatureManager_sign_ret=(sig_bitstring[1:1]);
  }
  action labeledstmt_40(){
    labeledstmt_121();
  }
  action labeledstmt_122(){
    BookSignatureManager_sign_ret=(sig_bitstring[2:2]);
  }
  action labeledstmt_41(){
    labeledstmt_122();
  }
  action labeledstmt_123(){
    BookSignatureManager_sign_ret=(sig_bitstring[3:3]);
  }
  action labeledstmt_42(){
    labeledstmt_123();
  }
  action labeledstmt_124(){
    BookSignatureManager_sign_ret=(sig_bitstring[4:4]);
  }
  action labeledstmt_43(){
    labeledstmt_124();
  }
  action labeledstmt_125(){
    BookSignatureManager_sign_ret=(sig_bitstring[5:5]);
  }
  action labeledstmt_44(){
    labeledstmt_125();
  }
  action labeledstmt_126(){
    BookSignatureManager_sign_ret=(sig_bitstring[6:6]);
  }
  action labeledstmt_45(){
    labeledstmt_126();
  }
  action labeledstmt_127(){
    BookSignatureManager_sign_ret=(sig_bitstring[7:7]);
  }
  action labeledstmt_46(){
    labeledstmt_127();
  }
  action labeledstmt_128(){
    BookSignatureManager_sign_ret=(sig_bitstring[8:8]);
  }
  action labeledstmt_47(){
    labeledstmt_128();
  }
  action labeledstmt_129(){
    BookSignatureManager_sign_ret=(sig_bitstring[9:9]);
  }
  action labeledstmt_48(){
    labeledstmt_129();
  }
  action labeledstmt_130(){
    BookSignatureManager_sign_ret=(sig_bitstring[10:10]);
  }
  action labeledstmt_49(){
    labeledstmt_130();
  }
  action labeledstmt_131(){
    BookSignatureManager_sign_ret=(sig_bitstring[11:11]);
  }
  action labeledstmt_50(){
    labeledstmt_131();
  }
  action labeledstmt_132(){
    BookSignatureManager_sign_ret=(sig_bitstring[12:12]);
  }
  action labeledstmt_51(){
    labeledstmt_132();
  }
  action labeledstmt_133(){
    BookSignatureManager_sign_ret=(sig_bitstring[13:13]);
  }
  action labeledstmt_52(){
    labeledstmt_133();
  }
  action labeledstmt_134(){
    BookSignatureManager_sign_ret=(sig_bitstring[14:14]);
  }
  action labeledstmt_53(){
    labeledstmt_134();
  }
  action labeledstmt_135(){
    BookSignatureManager_sign_ret=(sig_bitstring[15:15]);
  }
  action labeledstmt_54(){
    labeledstmt_135();
  }
  action labeledstmt_136(){
    BookSignatureManager_sign_ret=(sig_bitstring[16:16]);
  }
  action labeledstmt_55(){
    labeledstmt_136();
  }
  action labeledstmt_137(){
    BookSignatureManager_sign_ret=(sig_bitstring[17:17]);
  }
  action labeledstmt_56(){
    labeledstmt_137();
  }
  action labeledstmt_138(){
    BookSignatureManager_sign_ret=(sig_bitstring[18:18]);
  }
  action labeledstmt_57(){
    labeledstmt_138();
  }
  action labeledstmt_139(){
    BookSignatureManager_sign_ret=(sig_bitstring[19:19]);
  }
  action labeledstmt_58(){
    labeledstmt_139();
  }
  action labeledstmt_140(){
    BookSignatureManager_sign_ret=(sig_bitstring[20:20]);
  }
  action labeledstmt_59(){
    labeledstmt_140();
  }
  action labeledstmt_141(){
    BookSignatureManager_sign_ret=(sig_bitstring[21:21]);
  }
  action labeledstmt_60(){
    labeledstmt_141();
  }
  action labeledstmt_142(){
    BookSignatureManager_sign_ret=(sig_bitstring[22:22]);
  }
  action labeledstmt_61(){
    labeledstmt_142();
  }
  action labeledstmt_143(){
    BookSignatureManager_sign_ret=(sig_bitstring[23:23]);
  }
  action labeledstmt_62(){
    labeledstmt_143();
  }
  action labeledstmt_144(){
    BookSignatureManager_sign_ret=(sig_bitstring[24:24]);
  }
  action labeledstmt_63(){
    labeledstmt_144();
  }
  action labeledstmt_145(){
    BookSignatureManager_sign_ret=(sig_bitstring[25:25]);
  }
  action labeledstmt_64(){
    labeledstmt_145();
  }
  action labeledstmt_146(){
    BookSignatureManager_sign_ret=(sig_bitstring[26:26]);
  }
  action labeledstmt_65(){
    labeledstmt_146();
  }
  action labeledstmt_147(){
    BookSignatureManager_sign_ret=(sig_bitstring[27:27]);
  }
  action labeledstmt_66(){
    labeledstmt_147();
  }
  action labeledstmt_148(){
    BookSignatureManager_sign_ret=(sig_bitstring[28:28]);
  }
  action labeledstmt_67(){
    labeledstmt_148();
  }
  action labeledstmt_149(){
    BookSignatureManager_sign_ret=(sig_bitstring[29:29]);
  }
  action labeledstmt_68(){
    labeledstmt_149();
  }
  action labeledstmt_150(){
    BookSignatureManager_sign_ret=(sig_bitstring[30:30]);
  }
  action labeledstmt_69(){
    labeledstmt_150();
  }
  action labeledstmt_151(){
    BookSignatureManager_sign_ret=(sig_bitstring[31:31]);
  }
  action labeledstmt_70(){
    labeledstmt_151();
  }
  action labeledstmt_71(){
    //NOOP
  }
  bit<1> book_signature;
  action labeledstmt_152(){
    book_signature=BookSignatureManager_sign_ret;
  }
  action labeledstmt_72(){
    labeledstmt_152();
  }
  action labeledstmt_73(){
    //NOOP
  }
  bit<8> tango_metrics_hdr_4;
  action labeledstmt_153(){
    tango_metrics_hdr_4=((bit<8>)book_signature);
  }
  action labeledstmt_74(){
    labeledstmt_153();
  }
  action labeledstmt_75(){
    //NOOP
  }
  action labeledstmt_76(){
    hdr.bridge_ev.incoming_tango_traffic=1;
    hdr.incoming_tango_traffic.setValid();
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_eth_header_0=hdr.forward_flow.forward_flow_eth_header_0;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_eth_header_1=hdr.forward_flow.forward_flow_eth_header_1;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_eth_header_2=16w34525;
    hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_0=32w0;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_1=precompute4080;
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
  action labeledstmt_77(){
    //NOOP
  }
  action labeledstmt_154(){
    hdr.forward_flow.setInvalid();
  }
  action labeledstmt_78(){
    labeledstmt_154();
  }
  table table_4147 {
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
  table table_4146 {
    key = {
      hdr.wire_ev.event_id : ternary;
      if_precomp : ternary;
      hdr.set_signature.set_signature_next_signature : ternary;
    }
    actions = {
      labeledstmt_7;
      labeledstmt_8;
      labeledstmt_9;
      labeledstmt_10;
      labeledstmt_11;
      labeledstmt_12;
    }
    const entries = {
      (2,0,0) : labeledstmt_7();
      (2,_,0) : labeledstmt_7();
      (4,0,0) : labeledstmt_7();
      (4,_,0) : labeledstmt_7();
      (1,0,0) : labeledstmt_8();
      (1,_,0) : labeledstmt_8();
      (3,0,0) : labeledstmt_9();
      (3,_,0) : labeledstmt_10();
      (2,0,_) : labeledstmt_7();
      (2,_,_) : labeledstmt_7();
      (4,0,_) : labeledstmt_7();
      (4,_,_) : labeledstmt_7();
      (1,0,_) : labeledstmt_8();
      (1,_,_) : labeledstmt_8();
      (3,0,_) : labeledstmt_11();
      (3,_,_) : labeledstmt_12();
      (_,_,_) : labeledstmt_7();
    } 
  } 
  table table_4145 {
    key = {
      hdr.wire_ev.event_id : ternary;
      block_idx3496 : ternary;
      if_precomp : ternary;
    }
    actions = {
      labeledstmt_13;
      labeledstmt_14;
      labeledstmt_15;
      labeledstmt_16;
    }
    const entries = {
      (2,0,0) : labeledstmt_13();
      (2,_,0) : labeledstmt_13();
      (4,0,0) : labeledstmt_13();
      (4,_,0) : labeledstmt_13();
      (1,0,0) : labeledstmt_14();
      (1,_,0) : labeledstmt_14();
      (3,0,0) : labeledstmt_15();
      (3,_,0) : labeledstmt_15();
      (2,0,_) : labeledstmt_13();
      (4,0,_) : labeledstmt_13();
      (1,0,_) : labeledstmt_14();
      (3,0,_) : labeledstmt_13();
      (2,_,_) : labeledstmt_13();
      (4,_,_) : labeledstmt_13();
      (1,_,_) : labeledstmt_14();
      (3,_,_) : labeledstmt_16();
      (_,_,_) : labeledstmt_13();
    } 
  } 
  table table_4144 {
    key = {
      hdr.wire_ev.event_id : ternary;
      block_idx3479 : ternary;
      block_idx : ternary;
      block : ternary;
      if_precomp : ternary;
    }
    actions = {
      labeledstmt_17;
      labeledstmt_18;
      labeledstmt_19;
      labeledstmt_20;
      labeledstmt_21;
      labeledstmt_22;
    }
    const entries = {
      (2,0,0,0,0) : labeledstmt_17();
      (2,_,0,0,0) : labeledstmt_17();
      (2,0,_,0,0) : labeledstmt_17();
      (2,_,_,0,0) : labeledstmt_17();
      (4,0,0,0,0) : labeledstmt_17();
      (4,_,0,0,0) : labeledstmt_17();
      (4,0,_,0,0) : labeledstmt_17();
      (4,_,_,0,0) : labeledstmt_17();
      (1,0,0,0,0) : labeledstmt_18();
      (1,_,0,0,0) : labeledstmt_19();
      (1,0,_,0,0) : labeledstmt_20();
      (1,_,_,0,0) : labeledstmt_21();
      (3,_,_,0,0) : labeledstmt_17();
      (2,0,0,_,0) : labeledstmt_17();
      (2,_,0,_,0) : labeledstmt_17();
      (2,0,_,_,0) : labeledstmt_17();
      (2,_,_,_,0) : labeledstmt_17();
      (4,0,0,_,0) : labeledstmt_17();
      (4,_,0,_,0) : labeledstmt_17();
      (4,0,_,_,0) : labeledstmt_17();
      (4,_,_,_,0) : labeledstmt_17();
      (1,0,0,_,0) : labeledstmt_18();
      (1,_,0,_,0) : labeledstmt_19();
      (1,0,_,_,0) : labeledstmt_20();
      (1,_,_,_,0) : labeledstmt_21();
      (3,_,_,_,0) : labeledstmt_22();
      (2,0,0,_,_) : labeledstmt_17();
      (2,_,0,_,_) : labeledstmt_17();
      (4,0,0,_,_) : labeledstmt_17();
      (4,_,0,_,_) : labeledstmt_17();
      (1,0,0,_,_) : labeledstmt_18();
      (1,_,0,_,_) : labeledstmt_19();
      (2,0,_,_,_) : labeledstmt_17();
      (2,_,_,_,_) : labeledstmt_17();
      (4,0,_,_,_) : labeledstmt_17();
      (4,_,_,_,_) : labeledstmt_17();
      (1,0,_,_,_) : labeledstmt_20();
      (1,_,_,_,_) : labeledstmt_21();
      (_,_,_,_,_) : labeledstmt_17();
    } 
  } 
  table table_4143 {
    key = {
      block_idx3479 : ternary;
      hdr.wire_ev.event_id : ternary;
      block_idx3496 : ternary;
      if_precomp : ternary;
      block_idx : ternary;
    }
    actions = {
      labeledstmt_23;
      labeledstmt_24;
      labeledstmt_25;
      labeledstmt_26;
      labeledstmt_27;
      labeledstmt_28;
      labeledstmt_29;
    }
    const entries = {
      (0,2,0,0,0) : labeledstmt_23();
      (_,2,0,0,0) : labeledstmt_23();
      (0,2,0,_,0) : labeledstmt_23();
      (_,2,0,_,0) : labeledstmt_23();
      (0,2,_,0,0) : labeledstmt_23();
      (_,2,_,0,0) : labeledstmt_23();
      (0,2,_,_,0) : labeledstmt_23();
      (_,2,_,_,0) : labeledstmt_23();
      (0,4,0,0,0) : labeledstmt_23();
      (_,4,0,0,0) : labeledstmt_23();
      (0,4,0,_,0) : labeledstmt_23();
      (_,4,0,_,0) : labeledstmt_23();
      (0,4,_,0,0) : labeledstmt_23();
      (_,4,_,0,0) : labeledstmt_23();
      (0,4,_,_,0) : labeledstmt_23();
      (_,4,_,_,0) : labeledstmt_23();
      (0,1,0,0,0) : labeledstmt_24();
      (_,1,0,0,0) : labeledstmt_25();
      (0,1,0,_,0) : labeledstmt_24();
      (_,1,0,_,0) : labeledstmt_25();
      (0,1,_,0,0) : labeledstmt_24();
      (_,1,_,0,0) : labeledstmt_25();
      (0,1,_,_,0) : labeledstmt_24();
      (_,1,_,_,0) : labeledstmt_25();
      (0,2,0,0,_) : labeledstmt_23();
      (_,2,0,0,_) : labeledstmt_23();
      (0,2,0,_,_) : labeledstmt_23();
      (_,2,0,_,_) : labeledstmt_23();
      (0,2,_,0,_) : labeledstmt_23();
      (_,2,_,0,_) : labeledstmt_23();
      (0,2,_,_,_) : labeledstmt_23();
      (_,2,_,_,_) : labeledstmt_23();
      (0,4,0,0,_) : labeledstmt_23();
      (_,4,0,0,_) : labeledstmt_23();
      (0,4,0,_,_) : labeledstmt_23();
      (_,4,0,_,_) : labeledstmt_23();
      (0,4,_,0,_) : labeledstmt_23();
      (_,4,_,0,_) : labeledstmt_23();
      (0,4,_,_,_) : labeledstmt_23();
      (_,4,_,_,_) : labeledstmt_23();
      (0,1,0,0,_) : labeledstmt_26();
      (_,1,0,0,_) : labeledstmt_27();
      (0,1,0,_,_) : labeledstmt_26();
      (_,1,0,_,_) : labeledstmt_27();
      (0,1,_,0,_) : labeledstmt_26();
      (_,1,_,0,_) : labeledstmt_27();
      (0,1,_,_,_) : labeledstmt_26();
      (_,1,_,_,_) : labeledstmt_27();
      (_,3,0,0,_) : labeledstmt_23();
      (_,3,0,_,_) : labeledstmt_28();
      (_,3,_,0,_) : labeledstmt_23();
      (_,3,_,_,_) : labeledstmt_29();
      (_,_,_,_,_) : labeledstmt_23();
    } 
  } 
  table table_4142 {
    key = {
      hdr.wire_ev.event_id : ternary;
      block_idx : ternary;
      block : ternary;
      if_precomp : ternary;
    }
    actions = {
      labeledstmt_30;
      labeledstmt_31;
      labeledstmt_32;
      labeledstmt_33;
      labeledstmt_34;
    }
    const entries = {
      (2,0,0,0) : labeledstmt_30();
      (2,_,0,0) : labeledstmt_30();
      (4,0,0,0) : labeledstmt_30();
      (4,_,0,0) : labeledstmt_30();
      (1,0,0,0) : labeledstmt_31();
      (1,_,0,0) : labeledstmt_32();
      (3,_,0,0) : labeledstmt_33();
      (2,0,_,0) : labeledstmt_30();
      (2,_,_,0) : labeledstmt_30();
      (4,0,_,0) : labeledstmt_30();
      (4,_,_,0) : labeledstmt_30();
      (1,0,_,0) : labeledstmt_31();
      (1,_,_,0) : labeledstmt_32();
      (3,_,_,0) : labeledstmt_34();
      (2,0,_,_) : labeledstmt_30();
      (4,0,_,_) : labeledstmt_30();
      (1,0,_,_) : labeledstmt_31();
      (2,_,_,_) : labeledstmt_30();
      (4,_,_,_) : labeledstmt_30();
      (1,_,_,_) : labeledstmt_32();
      (_,_,_,_) : labeledstmt_30();
    } 
  } 
  @ignore_table_dependency("IngressControl.table_4141")table table_4140 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_35;
      labeledstmt_36;
      labeledstmt_37;
    }
    const entries = {
      (2) : labeledstmt_35();
      (4) : labeledstmt_35();
      (1) : labeledstmt_36();
      (3) : labeledstmt_37();
      (_) : labeledstmt_35();
    } 
  } 
  @ignore_table_dependency("IngressControl.table_4140")table table_4141 {
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
  table table_4139 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_71;
      labeledstmt_72;
    }
    const entries = {
      (2) : labeledstmt_71();
      (4) : labeledstmt_71();
      (1) : labeledstmt_72();
      (_) : labeledstmt_71();
    } 
  } 
  table table_4138 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_73;
      labeledstmt_74;
    }
    const entries = {
      (2) : labeledstmt_73();
      (4) : labeledstmt_73();
      (1) : labeledstmt_74();
      (_) : labeledstmt_73();
    } 
  } 
  table table_4137 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_75;
      labeledstmt_76;
    }
    const entries = {
      (2) : labeledstmt_75();
      (4) : labeledstmt_75();
      (1) : labeledstmt_76();
      (_) : labeledstmt_75();
    } 
  } 
  table table_4136 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_77;
      labeledstmt_78;
    }
    const entries = {
      (2) : labeledstmt_77();
      (4) : labeledstmt_77();
      (1) : labeledstmt_78();
      (_) : labeledstmt_77();
    } 
  } 
  apply {
    table_4147.apply();
    table_4146.apply();
    table_4145.apply();
    table_4144.apply();
    table_4143.apply();
    table_4142.apply();
    table_4140.apply();
    table_4141.apply();
    table_4139.apply();
    table_4138.apply();
    table_4137.apply();
    table_4136.apply();
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
 
@pa_no_overlay("egress","hdr.set_next_signature.set_next_signature_sig_type")
 
@pa_no_overlay("egress","hdr.set_next_signature.set_next_signature_sig_idx")
 
@pa_no_overlay("egress","hdr.set_next_signature.set_next_signature_block_idx")
 
@pa_no_overlay("egress","hdr.set_next_signature.set_next_signature_next_signature")
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
