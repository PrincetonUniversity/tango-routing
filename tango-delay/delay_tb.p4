# Basic Forwarding Program for Tango
# Plus Recirc Delay 
#include <core.p4>
#include <tna.p4>

//TOFINO MODEL 
//#define INTERNET_PORT 2
//#define SERVER_PORT 4 
//#define TANGO_SWITCH_PORT 0

//TOFINO HARDWARE
#define INTERNET_PORT 156
#define SERVER_PORT 9
#define TANGO_SWITCH_PORT 0

#define DELAY_TB_SIZE 65536

typedef bit<48> mac_addr_t;
typedef bit<32> ipv4_addr_t;
typedef bit<64> ipv6_addr_t;
typedef bit<16> ether_type_t;
const ether_type_t ETHERTYPE_IPV4 = 16w0x0800;
const ether_type_t ETHERTYPE_IPV6 = 16w0x86DD;
const ether_type_t ETHERTYPE_VLAN = 16w0x0810;
const ether_type_t ETHERTYPE_DELAY_INTM = 16w0xff00;

typedef bit<8> ip_protocol_t;
const ip_protocol_t IP_PROTOCOLS_ICMP = 1;
const ip_protocol_t IP_PROTOCOLS_ICMP_IPV6 = 58;
const ip_protocol_t IP_PROTOCOLS_TCP = 6;
const ip_protocol_t IP_PROTOCOLS_UDP = 17;

const mac_addr_t ZERO_MAC = 0x0;
const mac_addr_t DST_MAC = 0x00169c8ecc40;
const mac_addr_t SRC_MAC = 0x0c42a1dd5990;

const ipv6_addr_t DELAY_ADDRESS_HI = 0x26044540008D0000; 
const ipv6_addr_t DELAY_ADDRESS_LOW = 0x0000000000000001; // Path 5 - 2604:4540:8d::1

header ethernet_h {
    mac_addr_t dst_addr;
    mac_addr_t src_addr;
    bit<16> ether_type;
}

header delay_meta_h {
    bit<32> curr_round; 
    bit<32> needed_rounds; 
}

header ipv4_h {
    bit<4> version;
    bit<4> ihl;
    bit<8> diffserv;
    bit<16> total_len;
    bit<16> identification;
    bit<3> flags;
    bit<13> frag_offset;
    bit<8> ttl;
    bit<8> protocol;
    bit<16> hdr_checksum;
    ipv4_addr_t src_addr;
    ipv4_addr_t dst_addr;
}

header ipv6_h {
    bit<4> version;
    bit<8> priority_class;
    bit<20> flow_label;
    bit<16> payload_len;
    bit<8> next_hdr;
    bit<8> hop_limit;
    ipv6_addr_t src_addr_hi;
    ipv6_addr_t src_addr_low;
    ipv6_addr_t dst_addr_hi;
    ipv6_addr_t dst_addr_low;
}

header tcp_h {
    bit<16> src_port;
    bit<16> dst_port;

    bit<32> seq_no;
    bit<32> ack_no;
    bit<4> data_offset;
    bit<4> res;
    bit<8> flags;
    bit<16> window;
    bit<16> checksum;
    bit<16> urgent_ptr;
}

header udp_h {
    bit<16> src_port;
    bit<16> dst_port;
    bit<16> udp_total_len;
    bit<16> checksum;
}
header udp_padding_h{
   bit<32> a;
   bit<32> b;
   bit<32> c;
   bit<32> d;

}

header icmp_h {
   bit<8> icmp_type;
   bit<8> icmp_code;
   bit<16> icmp_checksum;
   bit<16> icmp_id;
   bit<16> icmp_seq_num;
}

struct header_t {
    ethernet_h ethernet;
    delay_meta_h delay_meta; 
    ipv4_h ipv4;
    ipv6_h ipv6;
    tcp_h tcp;
    udp_h udp;
    udp_padding_h udp_padding;
    icmp_h icmp;
}

struct ig_metadata_t {
    bit<32> first_ts_ms; 
    bit<16> ts_bucket;  
    bit<16> tcp_total_len;
    bit<1> redo_cksum;

}
struct eg_metadata_t {
}


parser TofinoIngressParser(
        packet_in pkt,
        inout ig_metadata_t ig_md,
        out ingress_intrinsic_metadata_t ig_intr_md) {
    state start {
        pkt.extract(ig_intr_md);
        transition select(ig_intr_md.resubmit_flag) {
            1 : parse_resubmit;
            0 : parse_port_metadata;
        }
    }

    state parse_resubmit {
        // Parse resubmitted packet here.
        pkt.advance(64);
        transition accept;
    }

    state parse_port_metadata {
        pkt.advance(64);  //tofino 1 port metadata size
        transition accept;
    }
}
parser SwitchIngressParser(
        packet_in pkt,
        out header_t hdr,
        out ig_metadata_t ig_md,
        out ingress_intrinsic_metadata_t ig_intr_md) {

    TofinoIngressParser() tofino_parser;

    state start {
        tofino_parser.apply(pkt, ig_md, ig_intr_md);
        transition parse_ethernet;
    }

    state parse_ethernet {
        pkt.extract(hdr.ethernet);
        transition select (hdr.ethernet.ether_type) {
            ETHERTYPE_IPV4 : parse_ipv4;
            ETHERTYPE_IPV6 : parse_ipv6;
            ETHERTYPE_DELAY_INTM : parse_delay_meta; 
            default : accept;
        }
    }

    state parse_delay_meta {
        pkt.extract(hdr.delay_meta); 
        transition parse_ipv6; // Delay is only added on IPv6 packets coming from Tango switch 
    }

    state parse_ipv4 {
        pkt.extract(hdr.ipv4);
        transition select(hdr.ipv4.protocol) {
            IP_PROTOCOLS_TCP : parse_tcp;
            IP_PROTOCOLS_UDP : parse_udp;
            IP_PROTOCOLS_ICMP : parse_icmp;
            default : accept;
        }
    }

    state parse_ipv6 {
        pkt.extract(hdr.ipv6);
        transition select(hdr.ipv6.next_hdr) {
            IP_PROTOCOLS_TCP : parse_tcp_ipv6;
            IP_PROTOCOLS_UDP : parse_udp;
            IP_PROTOCOLS_ICMP_IPV6 : parse_icmp;
            default : accept;
        }
    }

    state parse_tcp {
        pkt.extract(hdr.tcp);
        transition select(hdr.ipv4.total_len) {
            default : accept;
        }
    }

    state parse_tcp_ipv6 {
        pkt.extract(hdr.tcp);
        transition select(hdr.ipv6.payload_len) {
            default : accept;
        }
    }

    state parse_udp {
        pkt.extract(hdr.udp);
        pkt.extract(hdr.udp_padding);
        transition select(hdr.udp.dst_port) {
            default: accept;
        }
    }

    state parse_icmp {
        pkt.extract(hdr.icmp);
        transition select(hdr.icmp.icmp_type){
            default: accept;
        }
   }
}

// ---------------------------------------------------------------------------
// Ingress Deparser
// ---------------------------------------------------------------------------
control SwitchIngressDeparser(
        packet_out pkt,
        inout header_t hdr,
        in ig_metadata_t ig_md,
        in ingress_intrinsic_metadata_for_deparser_t ig_intr_dprsr_md) {


      Checksum() ipv4_checksum;
      Checksum() tcp_checksum;

    apply {
        if(ig_md.redo_cksum == 0x1){

                hdr.ipv4.hdr_checksum = ipv4_checksum.update({
                    hdr.ipv4.version,
                    hdr.ipv4.ihl,
                    hdr.ipv4.diffserv,
                    hdr.ipv4.total_len,
                    hdr.ipv4.identification,
                    hdr.ipv4.flags,
                    hdr.ipv4.frag_offset,
                    hdr.ipv4.ttl,
                    hdr.ipv4.protocol,
                    hdr.ipv4.src_addr,
                    hdr.ipv4.dst_addr
                });

                hdr.tcp.checksum = tcp_checksum.update({
                    //==pseudo header
                    hdr.ipv4.src_addr,
                    hdr.ipv4.dst_addr,
                    8w0,
                    hdr.ipv4.protocol,
                    ig_md.tcp_total_len,
                    //==actual header
                    hdr.tcp.src_port,
                    hdr.tcp.dst_port,
                    hdr.tcp.seq_no,
                    hdr.tcp.ack_no,
                    hdr.tcp.data_offset,
                    hdr.tcp.res,
                    hdr.tcp.flags,
                    hdr.tcp.window,
                    hdr.tcp.urgent_ptr
                });
        }

        pkt.emit(hdr.ethernet);
        pkt.emit(hdr.delay_meta);
        pkt.emit(hdr.ipv4);
        pkt.emit(hdr.ipv6);
        pkt.emit(hdr.tcp);
        pkt.emit(hdr.udp);
        pkt.emit(hdr.icmp);
    }
}

// ---------------------------------------------------------------------------
// Egress parser
// ---------------------------------------------------------------------------
parser SwitchEgressParser(
        packet_in pkt,
        out header_t hdr,
        out eg_metadata_t eg_md,
        out egress_intrinsic_metadata_t eg_intr_md) {
    state start {
        pkt.extract(eg_intr_md);
        transition accept;
    }
}

// ---------------------------------------------------------------------------
// Egress Deparser
// ---------------------------------------------------------------------------
control SwitchEgressDeparser(
        packet_out pkt,
        inout header_t hdr,
        in eg_metadata_t eg_md,
        in egress_intrinsic_metadata_for_deparser_t eg_intr_md_for_dprsr) {
    apply {
    }
}


// ---------------------------------------------------------------------------
// Ingress Control
// ---------------------------------------------------------------------------
control SwitchIngress(
        inout header_t hdr,
        inout ig_metadata_t ig_md,
        in ingress_intrinsic_metadata_t ig_intr_md,
        in ingress_intrinsic_metadata_from_parser_t ig_intr_prsr_md,
        inout ingress_intrinsic_metadata_for_deparser_t ig_intr_dprsr_md,
        inout ingress_intrinsic_metadata_for_tm_t ig_intr_tm_md) {

        action drop() {
            ig_intr_dprsr_md.drop_ctl = 0x1; // Drop packet.
        }
        action nop() {
        }
        action route_to(bit<9> dst){
                ig_intr_tm_md.ucast_egress_port=dst;
        }
        action reflect(){
            //send you back to where you're from
            ig_intr_tm_md.ucast_egress_port=ig_intr_md.ingress_port;
        }

        action do_recirc(){
           route_to(68); // Recirc port  
        }

        action incr_and_recirc(bit<32> old_round){
            hdr.delay_meta.curr_round = old_round + 1; // Update next round based on last round 
            do_recirc(); 
        }

        action naive_routing(){
            @in_hash{ ig_intr_tm_md.ucast_egress_port = (bit<9>) hdr.ipv4.dst_addr[31:24]; }
            hdr.ethernet.src_addr=1;
            hdr.ethernet.dst_addr[47:8] = 0;
            @in_hash{hdr.ethernet.dst_addr[7:0]=hdr.ipv4.dst_addr[31:24];}
        }

        // <entry_type, key_type> (num_entries) 
        // TODO: how many bits are ts? 
        Register<bit<32>,_>(1) reg_tsbase;
        RegisterAction<bit<32> ,_, bit<32>>(reg_tsbase) regact_tsbase_write = 
        {
            void apply(inout bit<32> value, out bit<32> ret){
                value = ig_intr_md.ingress_mac_tstamp[47:16]; // take first-seen current ts as start time in ms 
                ret = 0; 
            }

        };  

        RegisterAction<bit<32>, _, bit<32>>(reg_tsbase) regact_tsbase_read = 
        {
            void apply(inout bit<32> value, out bit<32> ret){
                ret = value; 
            }
        }; 

        action start_delay_bucket(bit<32> num_recircs){
            hdr.delay_meta.setValid(); 
            hdr.delay_meta.curr_round = 0;
            hdr.ethernet.ether_type=ETHERTYPE_DELAY_INTM;
	    ig_intr_tm_md.ucast_egress_port = 68; 
            hdr.delay_meta.needed_rounds = num_recircs; 
        }
	
	/*table tb_delay_map {
            key = {
                ig_md.ts_bucket: ternary; 
            }
            actions = {
                start_delay_bucket; 
            	drop;
	    }
	    default_action = drop(); 
	    const entries = {
	        (0): start_delay_bucket(10); // For given time bucket, perform X recirculations  
                (1): start_delay_bucket(40);
                (2): start_delay_bucket(3000);
                (_): start_delay_bucket(23); 
            } 
            // could also fill table from control plane
            size = DELAY_TB_SIZE; // 2^16  
        } // end table 

*/
        apply {
                ig_md.redo_cksum = 0;
                if (hdr.ethernet.dst_addr[47:8] == 0) {
                        hdr.ethernet.src_addr = SRC_MAC;
                        hdr.ethernet.dst_addr = DST_MAC;
                }

           	    bool is_recirc = hdr.delay_meta.isValid(); 
                bool should_delay = false;  
		        if(hdr.ethernet.ether_type==ETHERTYPE_DELAY_INTM){
                    if(is_recirc){
                        if(hdr.delay_meta.curr_round == hdr.delay_meta.needed_rounds){
                            // Remove header and release packet to Internet 
                            route_to(INTERNET_PORT); 
			                hdr.ethernet.ether_type=ETHERTYPE_IPV6;
                            hdr.delay_meta.setInvalid(); 
                        }
                        else{
                            incr_and_recirc(hdr.delay_meta.curr_round); 
                        }
                    }
		        }
        	    // NOTE: apply delays on packets from TANGO_SWITCH_PORT 
        	    // First check to determine if delay condition is met 
		    else if(ig_intr_md.ingress_port==TANGO_SWITCH_PORT && hdr.ethernet.ether_type==ETHERTYPE_IPV6 && hdr.ipv6.dst_addr_hi[23:16]==DELAY_ADDRESS_HI[23:16]){
                ig_md.first_ts_ms = regact_tsbase_read.execute(0); 
                if(ig_md.first_ts_ms==0){ // First time through, set flag to later initialize first_ts to current time, ms 
			        should_delay = true; 
		        else{ // Not first time, initial ts already written 
                	// Extract timestamp, take upper bits as delay bucket and table index
                	ig_md.ts_bucket = ig_intr_md.ingress_mac_tstamp[31:16] - ig_md.first_ts_ms[15:0];   
                	// Go to delay table
			        //tb_delay_map.apply();
		        }  
	    	}
		
		else {
                // TODO: bring reroute logic back, removed for ping test! 
                // Send IPv6/ICMP6EchoReply pkts to update routes on tango switch
                /*if(ig_intr_md.ingress_port==INTERNET_PORT && hdr.ethernet.ether_type==ETHERTYPE_IPV6
                        && hdr.ipv6.next_hdr==IP_PROTOCOLS_ICMP_IPV6 && hdr.icmp.icmp_type==129){
                        ig_intr_tm_md.ucast_egress_port = TANGO_SWITCH_PORT;
                } else*/ if (ig_intr_md.ingress_port==INTERNET_PORT) {  // All other pkts from internet go to server
                        ig_intr_tm_md.ucast_egress_port = SERVER_PORT;
                } else if (ig_intr_md.ingress_port==TANGO_SWITCH_PORT) {
                        ig_intr_tm_md.ucast_egress_port = INTERNET_PORT;
                } else {// Implicit SERVER_PORT
                        ig_intr_tm_md.ucast_egress_port = INTERNET_PORT;
                }
		}

		// If we need to start a delay cycle for a path, write initial ts for first packet seen from that path  
		if(should_delay){
			    regact_tsbase_write.execute(0); 
		}		

        } // end apply 
}

// ---------------------------------------------------------------------------
// Egress Control
// ---------------------------------------------------------------------------
control SwitchEgress(
        inout header_t hdr,
        inout eg_metadata_t eg_md,
        in egress_intrinsic_metadata_t eg_intr_md,
        in egress_intrinsic_metadata_from_parser_t eg_intr_md_from_prsr,
        inout egress_intrinsic_metadata_for_deparser_t ig_intr_dprs_md,
        inout egress_intrinsic_metadata_for_output_port_t eg_intr_oport_md) {
    apply {
    }
}



Pipeline(SwitchIngressParser(),
         SwitchIngress(),
         SwitchIngressDeparser(),
         SwitchEgressParser(),
         SwitchEgress(),
         SwitchEgressDeparser()
         ) pipe;

Switch(pipe) main;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
