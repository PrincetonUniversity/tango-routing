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
  bit<4> flag_pad_3714;
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
  action labeledstmt_59(){
    hdr.incoming_tango_traffic.setInvalid();
  }
  action labeledstmt_1(){
    labeledstmt_59();
  }
  action labeledstmt_60(){
    hdr.set_next_signature.setInvalid();
  }
  action labeledstmt_2(){
    labeledstmt_60();
  }
  bit<16> precompute3682;
  action labeledstmt_67(){
    precompute3682=(hdr.forward_flow.forward_flow_ip_header_2+16w18);
  }
  bit<8> tango_metrics_hdr_0;
  action labeledstmt_66(){
    tango_metrics_hdr_0=8w0;
  }
  bit<32> MetricSignatureManager_sign_ret;
  action labeledstmt_65(){
    MetricSignatureManager_sign_ret=32w32;
  }
  bit<1> BookSignatureManager_sign_ret;
  action labeledstmt_64(){
    BookSignatureManager_sign_ret=1w0;
  }
  bit<32> time_now;
  action labeledstmt_63(){
    time_now=(ig_intr_md.ingress_mac_tstamp[47:16]);
  }
  bit<16> to_immediate_tmp;
  RegisterAction<bit<16>,bit<32>,bit<16>>(sequence_counters_0)
  sequence_counters_0_regaction_3699 = {
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
  action labeledstmt_62(){
    to_immediate_tmp=sequence_counters_0_regaction_3699.execute(32w0);
  }
  bit<16> SequenceNumberManager_increment_ret;
  action labeledstmt_61(){
    SequenceNumberManager_increment_ret=16w32;
  }
  action labeledstmt_3(){
    labeledstmt_61();
    labeledstmt_62();
    labeledstmt_63();
    labeledstmt_64();
    labeledstmt_65();
    labeledstmt_66();
    labeledstmt_67();
  }
  action labeledstmt_4(){
    //NOOP
  }
  bit<16> precompute3684;
  action labeledstmt_69(){
    precompute3684=(16w1+hdr.set_signature.set_signature_sig_idx);
  }
  bit<16> precompute3683;
  action labeledstmt_68(){
    precompute3683=(hdr.set_signature.set_signature_ip_header_1-16w32);
  }
  action labeledstmt_5(){
    labeledstmt_68();
    labeledstmt_69();
  }
  action labeledstmt_6(){
    //NOOP
  }
  bit<12> timestamp;
  action labeledstmt_71(){
    timestamp=(time_now[31:20]);
  }
  action labeledstmt_70(){
    SequenceNumberManager_increment_ret=((bit<16>)to_immediate_tmp);
  }
  action labeledstmt_7(){
    labeledstmt_70();
    labeledstmt_71();
  }
  action labeledstmt_8(){
    hdr.bridge_ev.set_next_signature=1;
    hdr.set_next_signature.setValid();
   
hdr.set_next_signature.set_next_signature_eth_header_0=hdr.set_signature.set_signature_eth_header_0;
   
hdr.set_next_signature.set_next_signature_eth_header_1=hdr.set_signature.set_signature_eth_header_1;
   
hdr.set_next_signature.set_next_signature_eth_header_2=hdr.set_signature.set_signature_eth_header_2;
   
hdr.set_next_signature.set_next_signature_ip_header_0=hdr.set_signature.set_signature_ip_header_0;
    hdr.set_next_signature.set_next_signature_ip_header_1=precompute3683;
   
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
    hdr.set_next_signature.set_next_signature_sig_idx=precompute3684;
   
hdr.set_next_signature.set_next_signature_block_idx=hdr.set_signature.set_signature_block_idx;
   
hdr.set_next_signature.set_next_signature_next_signature=hdr.set_signature.set_signature_next_signature;
    hdr.bridge_ev.port_event_id=4;
    ig_tm_md.ucast_egress_port=9w196;
  }
  action labeledstmt_9(){
    //NOOP
  }
  bit<16> precompute3681;
  action labeledstmt_74(){
    precompute3681=((bit<16>)(timestamp[4:0]));
  }
  bit<16> tango_metrics_hdr_1;
  CRCPolynomial<bit<16>>(1,false, false, false, 0, 0) hash_37000_crc;
  Hash<bit<16>>(HashAlgorithm_t.CUSTOM,hash_37000_crc) hash_37000;
  action labeledstmt_73(){
    tango_metrics_hdr_1=hash_37000.get({timestamp});
  }
  bit<16> seq_number;
  action labeledstmt_72(){
    seq_number=SequenceNumberManager_increment_ret;
  }
  action labeledstmt_10(){
    labeledstmt_72();
    labeledstmt_73();
    labeledstmt_74();
  }
  action labeledstmt_75(){
    hdr.set_signature.setInvalid();
  }
  action labeledstmt_11(){
    labeledstmt_75();
  }
  action labeledstmt_12(){
    //NOOP
  }
 
RegisterAction<bit<32>,bit<16>,bit<32>>(outgoing_metric_signature_manager_0)
  outgoing_metric_signature_manager_0_regaction_3701 = {
    void apply(inout bit<32> cell1_remote,
        out bit<32> ret_remote){
      bit<32> cell1_local=cell1_remote;
      bit<32> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_79(){
   
MetricSignatureManager_sign_ret=outgoing_metric_signature_manager_0_regaction_3701.execute(precompute3681);
  }
  bit<16> precompute;
  action labeledstmt_78(){
    precompute=((bit<16>)(seq_number[15:5]));
  }
  bit<5> bitwhack_index;
  action labeledstmt_77(){
    bitwhack_index=(seq_number[4:0]);
  }
  bit<16> tango_metrics_hdr_3;
  action labeledstmt_76(){
    tango_metrics_hdr_3=((bit<16>)seq_number);
  }
  action labeledstmt_13(){
    labeledstmt_76();
    labeledstmt_77();
    labeledstmt_78();
    labeledstmt_79();
  }
  action labeledstmt_14(){
    //NOOP
  }
  bit<32> ts_signature;
  action labeledstmt_81(){
    ts_signature=MetricSignatureManager_sign_ret;
  }
  bit<32> sig_bitstring;
  RegisterAction<bit<32>,bit<16>,bit<32>>(outgoing_book_signature_manager_0)
  outgoing_book_signature_manager_0_regaction_3702 = {
    void apply(inout bit<32> cell1_remote,
        out bit<32> ret_remote){
      bit<32> cell1_local=cell1_remote;
      bit<32> cell2_local=0;
      if(true){
        ret_remote=cell1_local;
      }
    }
  };
  action labeledstmt_80(){
   
sig_bitstring=outgoing_book_signature_manager_0_regaction_3702.execute(precompute);
  }
  action labeledstmt_15(){
    labeledstmt_80();
    labeledstmt_81();
  }
  action labeledstmt_16(){
    //NOOP
  }
  action labeledstmt_82(){
    BookSignatureManager_sign_ret=(sig_bitstring[0:0]);
  }
  action labeledstmt_17(){
    labeledstmt_82();
  }
  action labeledstmt_83(){
    BookSignatureManager_sign_ret=(sig_bitstring[1:1]);
  }
  action labeledstmt_18(){
    labeledstmt_83();
  }
  action labeledstmt_84(){
    BookSignatureManager_sign_ret=(sig_bitstring[2:2]);
  }
  action labeledstmt_19(){
    labeledstmt_84();
  }
  action labeledstmt_85(){
    BookSignatureManager_sign_ret=(sig_bitstring[3:3]);
  }
  action labeledstmt_20(){
    labeledstmt_85();
  }
  action labeledstmt_86(){
    BookSignatureManager_sign_ret=(sig_bitstring[4:4]);
  }
  action labeledstmt_21(){
    labeledstmt_86();
  }
  action labeledstmt_87(){
    BookSignatureManager_sign_ret=(sig_bitstring[5:5]);
  }
  action labeledstmt_22(){
    labeledstmt_87();
  }
  action labeledstmt_88(){
    BookSignatureManager_sign_ret=(sig_bitstring[6:6]);
  }
  action labeledstmt_23(){
    labeledstmt_88();
  }
  action labeledstmt_89(){
    BookSignatureManager_sign_ret=(sig_bitstring[7:7]);
  }
  action labeledstmt_24(){
    labeledstmt_89();
  }
  action labeledstmt_90(){
    BookSignatureManager_sign_ret=(sig_bitstring[8:8]);
  }
  action labeledstmt_25(){
    labeledstmt_90();
  }
  action labeledstmt_91(){
    BookSignatureManager_sign_ret=(sig_bitstring[9:9]);
  }
  action labeledstmt_26(){
    labeledstmt_91();
  }
  action labeledstmt_92(){
    BookSignatureManager_sign_ret=(sig_bitstring[10:10]);
  }
  action labeledstmt_27(){
    labeledstmt_92();
  }
  action labeledstmt_93(){
    BookSignatureManager_sign_ret=(sig_bitstring[11:11]);
  }
  action labeledstmt_28(){
    labeledstmt_93();
  }
  action labeledstmt_94(){
    BookSignatureManager_sign_ret=(sig_bitstring[12:12]);
  }
  action labeledstmt_29(){
    labeledstmt_94();
  }
  action labeledstmt_95(){
    BookSignatureManager_sign_ret=(sig_bitstring[13:13]);
  }
  action labeledstmt_30(){
    labeledstmt_95();
  }
  action labeledstmt_96(){
    BookSignatureManager_sign_ret=(sig_bitstring[14:14]);
  }
  action labeledstmt_31(){
    labeledstmt_96();
  }
  action labeledstmt_97(){
    BookSignatureManager_sign_ret=(sig_bitstring[15:15]);
  }
  action labeledstmt_32(){
    labeledstmt_97();
  }
  action labeledstmt_98(){
    BookSignatureManager_sign_ret=(sig_bitstring[16:16]);
  }
  action labeledstmt_33(){
    labeledstmt_98();
  }
  action labeledstmt_99(){
    BookSignatureManager_sign_ret=(sig_bitstring[17:17]);
  }
  action labeledstmt_34(){
    labeledstmt_99();
  }
  action labeledstmt_100(){
    BookSignatureManager_sign_ret=(sig_bitstring[18:18]);
  }
  action labeledstmt_35(){
    labeledstmt_100();
  }
  action labeledstmt_101(){
    BookSignatureManager_sign_ret=(sig_bitstring[19:19]);
  }
  action labeledstmt_36(){
    labeledstmt_101();
  }
  action labeledstmt_102(){
    BookSignatureManager_sign_ret=(sig_bitstring[20:20]);
  }
  action labeledstmt_37(){
    labeledstmt_102();
  }
  action labeledstmt_103(){
    BookSignatureManager_sign_ret=(sig_bitstring[21:21]);
  }
  action labeledstmt_38(){
    labeledstmt_103();
  }
  action labeledstmt_104(){
    BookSignatureManager_sign_ret=(sig_bitstring[22:22]);
  }
  action labeledstmt_39(){
    labeledstmt_104();
  }
  action labeledstmt_105(){
    BookSignatureManager_sign_ret=(sig_bitstring[23:23]);
  }
  action labeledstmt_40(){
    labeledstmt_105();
  }
  action labeledstmt_106(){
    BookSignatureManager_sign_ret=(sig_bitstring[24:24]);
  }
  action labeledstmt_41(){
    labeledstmt_106();
  }
  action labeledstmt_107(){
    BookSignatureManager_sign_ret=(sig_bitstring[25:25]);
  }
  action labeledstmt_42(){
    labeledstmt_107();
  }
  action labeledstmt_108(){
    BookSignatureManager_sign_ret=(sig_bitstring[26:26]);
  }
  action labeledstmt_43(){
    labeledstmt_108();
  }
  action labeledstmt_109(){
    BookSignatureManager_sign_ret=(sig_bitstring[27:27]);
  }
  action labeledstmt_44(){
    labeledstmt_109();
  }
  action labeledstmt_110(){
    BookSignatureManager_sign_ret=(sig_bitstring[28:28]);
  }
  action labeledstmt_45(){
    labeledstmt_110();
  }
  action labeledstmt_111(){
    BookSignatureManager_sign_ret=(sig_bitstring[29:29]);
  }
  action labeledstmt_46(){
    labeledstmt_111();
  }
  action labeledstmt_112(){
    BookSignatureManager_sign_ret=(sig_bitstring[30:30]);
  }
  action labeledstmt_47(){
    labeledstmt_112();
  }
  action labeledstmt_113(){
    BookSignatureManager_sign_ret=(sig_bitstring[31:31]);
  }
  action labeledstmt_48(){
    labeledstmt_113();
  }
  action labeledstmt_49(){
    //NOOP
  }
  bit<32> tango_metrics_hdr_2;
  action labeledstmt_114(){
    tango_metrics_hdr_2=ts_signature;
  }
  action labeledstmt_50(){
    labeledstmt_114();
  }
  action labeledstmt_51(){
    //NOOP
  }
  bit<1> book_signature;
  action labeledstmt_115(){
    book_signature=BookSignatureManager_sign_ret;
  }
  action labeledstmt_52(){
    labeledstmt_115();
  }
  action labeledstmt_53(){
    //NOOP
  }
  bit<8> tango_metrics_hdr_4;
  action labeledstmt_116(){
    tango_metrics_hdr_4=((bit<8>)book_signature);
  }
  action labeledstmt_54(){
    labeledstmt_116();
  }
  action labeledstmt_55(){
    //NOOP
  }
  action labeledstmt_56(){
    hdr.bridge_ev.incoming_tango_traffic=1;
    hdr.incoming_tango_traffic.setValid();
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_eth_header_0=hdr.forward_flow.forward_flow_eth_header_0;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_eth_header_1=hdr.forward_flow.forward_flow_eth_header_1;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_eth_header_2=16w34525;
    hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_0=32w0;
   
hdr.incoming_tango_traffic.incoming_tango_traffic_tango_ip_header_1=precompute3682;
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
  action labeledstmt_57(){
    //NOOP
  }
  action labeledstmt_117(){
    hdr.forward_flow.setInvalid();
  }
  action labeledstmt_58(){
    labeledstmt_117();
  }
  table table_3713 {
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
      (2,0) : labeledstmt_1();
      (4,0) : labeledstmt_2();
      (1,0) : labeledstmt_3();
      (3,0) : labeledstmt_4();
      (2,_) : labeledstmt_1();
      (4,_) : labeledstmt_2();
      (1,_) : labeledstmt_3();
      (3,_) : labeledstmt_5();
      (_,_) : labeledstmt_4();
    } 
  } 
  table table_3712 {
    key = {
      hdr.wire_ev.event_id : ternary;
      hdr.set_signature.set_signature_next_signature : ternary;
    }
    actions = {
      labeledstmt_6;
      labeledstmt_7;
      labeledstmt_8;
    }
    const entries = {
      (2,0) : labeledstmt_6();
      (4,0) : labeledstmt_6();
      (1,0) : labeledstmt_7();
      (3,0) : labeledstmt_6();
      (2,_) : labeledstmt_6();
      (4,_) : labeledstmt_6();
      (1,_) : labeledstmt_7();
      (3,_) : labeledstmt_8();
      (_,_) : labeledstmt_6();
    } 
  } 
  table table_3711 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_9;
      labeledstmt_10;
      labeledstmt_11;
    }
    const entries = {
      (2) : labeledstmt_9();
      (4) : labeledstmt_9();
      (1) : labeledstmt_10();
      (3) : labeledstmt_11();
      (_) : labeledstmt_9();
    } 
  } 
  table table_3710 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_12;
      labeledstmt_13;
    }
    const entries = {
      (2) : labeledstmt_12();
      (4) : labeledstmt_12();
      (1) : labeledstmt_13();
      (_) : labeledstmt_12();
    } 
  } 
  table table_3709 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_14;
      labeledstmt_15;
    }
    const entries = {
      (2) : labeledstmt_14();
      (4) : labeledstmt_14();
      (1) : labeledstmt_15();
      (_) : labeledstmt_14();
    } 
  } 
  @ignore_table_dependency("IngressControl.table_3708")table table_3707 {
    key = {
      hdr.wire_ev.event_id : ternary;
      bitwhack_index : ternary;
    }
    actions = {
      labeledstmt_16;
      labeledstmt_17;
      labeledstmt_18;
      labeledstmt_19;
      labeledstmt_20;
      labeledstmt_21;
      labeledstmt_22;
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
    }
    const entries = {
      (2,_) : labeledstmt_16();
      (4,_) : labeledstmt_16();
      (1,0) : labeledstmt_17();
      (1,1) : labeledstmt_18();
      (1,2) : labeledstmt_19();
      (1,3) : labeledstmt_20();
      (1,4) : labeledstmt_21();
      (1,5) : labeledstmt_22();
      (1,6) : labeledstmt_23();
      (1,7) : labeledstmt_24();
      (1,8) : labeledstmt_25();
      (1,9) : labeledstmt_26();
      (1,10) : labeledstmt_27();
      (1,11) : labeledstmt_28();
      (1,12) : labeledstmt_29();
      (1,13) : labeledstmt_30();
      (1,14) : labeledstmt_31();
      (1,15) : labeledstmt_32();
      (1,16) : labeledstmt_33();
      (1,17) : labeledstmt_34();
      (1,18) : labeledstmt_35();
      (1,19) : labeledstmt_36();
      (1,20) : labeledstmt_37();
      (1,21) : labeledstmt_38();
      (1,22) : labeledstmt_39();
      (1,23) : labeledstmt_40();
      (1,24) : labeledstmt_41();
      (1,25) : labeledstmt_42();
      (1,26) : labeledstmt_43();
      (1,27) : labeledstmt_44();
      (1,28) : labeledstmt_45();
      (1,29) : labeledstmt_46();
      (1,30) : labeledstmt_47();
      (1,_) : labeledstmt_48();
      (_,_) : labeledstmt_16();
    } 
  } 
  @ignore_table_dependency("IngressControl.table_3707")table table_3708 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_49;
      labeledstmt_50;
    }
    const entries = {
      (2) : labeledstmt_49();
      (4) : labeledstmt_49();
      (1) : labeledstmt_50();
      (_) : labeledstmt_49();
    } 
  } 
  table table_3706 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_51;
      labeledstmt_52;
    }
    const entries = {
      (2) : labeledstmt_51();
      (4) : labeledstmt_51();
      (1) : labeledstmt_52();
      (_) : labeledstmt_51();
    } 
  } 
  table table_3705 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_53;
      labeledstmt_54;
    }
    const entries = {
      (2) : labeledstmt_53();
      (4) : labeledstmt_53();
      (1) : labeledstmt_54();
      (_) : labeledstmt_53();
    } 
  } 
  table table_3704 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_55;
      labeledstmt_56;
    }
    const entries = {
      (2) : labeledstmt_55();
      (4) : labeledstmt_55();
      (1) : labeledstmt_56();
      (_) : labeledstmt_55();
    } 
  } 
  table table_3703 {
    key = {
      hdr.wire_ev.event_id : ternary;
    }
    actions = {
      labeledstmt_57;
      labeledstmt_58;
    }
    const entries = {
      (2) : labeledstmt_57();
      (4) : labeledstmt_57();
      (1) : labeledstmt_58();
      (_) : labeledstmt_57();
    } 
  } 
  apply {
    table_3713.apply();
    table_3712.apply();
    table_3711.apply();
    table_3710.apply();
    table_3709.apply();
    table_3707.apply();
    table_3708.apply();
    table_3706.apply();
    table_3705.apply();
    table_3704.apply();
    table_3703.apply();
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
