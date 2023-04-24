"""Create pcap file(s) for DPDK to blast Tofino with."""

import logging
import sys
from argparse import ArgumentParser
from dataclasses import dataclass
from enum import Enum
from pathlib import Path
from pickle import load as unpickle
from typing import List, Tuple

from scapy.layers.inet6 import (
    UDP,
    ByteEnumField,
    ByteField,
    Ether,
    IntField,
    IPv6,
    Packet,
    ShortField,
)
from scapy.sendrecv import wrpcap

logging.basicConfig(level=logging.INFO)


PKT_PREFIX_BYTES = 66
MTU_BYTES = 1500
INT_BYTES = 4
NULL_BYTE = 4


@dataclass
class PrecomputedSignatures:
    """All precomputed signatures."""

    timestamp_signatures: List[int]
    sequence_num_signatures: List[int]


class SignatureType(Enum):
    """Type of signature being written."""

    SEQNUM_SIG = "SEQNUM_SIG"
    TS_SIG = "TS_SIG"


class SignatureMetadata(Packet):
    """Metadata about where to write signature stream."""

    name = "SignatureMetadata"
    fields_desc = [
        [
            ByteEnumField(
                "sig_type",
                0,
                {0: SignatureType.SEQNUM_SIG.value, 1: SignatureType.TS_SIG.value},
            ),
            ShortField("sig_idx", 0),
            ByteField("block_idx", 0),
        ],
    ]


class Signature(Packet):
    """Single signature payload of packet."""

    name = "Signature"
    fields_desc = [[IntField("Signature", 0)]]


def create_signature_packet(
    sigs_type: SignatureType,
    signatures: List[int],
    start_idx: int,
    block_idx: int,
) -> Packet:
    """Create a packet containing all signatures in payload."""
    logger = logging.getLogger(__name__)
    null_sig_token = Signature(0)

    if (PKT_PREFIX_BYTES + (len(signatures) * INT_BYTES) + NULL_BYTE) >= MTU_BYTES:
        logger.error("Too many signatures were attemped to be fit in a single packet!")
        sys.exit(-1)

    pkt = Ether() / IPv6() / UDP() / SignatureMetadata(sigs_type.value, start_idx, block_idx)
    for sig in signatures:
        pkt = pkt / Signature(sig)
    pkt = pkt / null_sig_token

    return pkt


def write_ts_sigs_to_pcap(
    ts_blk_sz: int, raw_ts_sigs: List[int], max_sigs_per_pkt: int,
) -> None:
    """Marshall signature packets and write to pcap."""
    num_ts_books = len(raw_ts_sigs) // ts_blk_sz
    num_ts_pkts = ts_blk_sz // max_sigs_per_pkt

    for book in range(0, num_ts_books):
        ts_pkts = []
        for pkt_round in range(0, num_ts_pkts):
            ts_pkts.extend(
                create_signature_packet(
                    SignatureType.TS_SIG,
                    raw_ts_sigs[:max_sigs_per_pkt],
                    (pkt_round * max_sigs_per_pkt),
                    book % 2,
                ),
            )
            raw_ts_sigs = raw_ts_sigs[max_sigs_per_pkt:]

        if ts_blk_sz % max_sigs_per_pkt:
            ts_pkts.extend(
                create_signature_packet(
                    SignatureType.TS_SIG,
                    raw_ts_sigs[: (ts_blk_sz % max_sigs_per_pkt)],
                    (num_ts_pkts * max_sigs_per_pkt),
                    book % 2,
                ),
            )
            raw_ts_sigs = raw_ts_sigs[(ts_blk_sz % max_sigs_per_pkt) :]

        wrpcap(f"tsbook-{book}.pcap", ts_pkts)


def write_seq_sigs_to_pcap(
    seq_blk_sz: int, raw_seq_num_sigs: List[int], max_sigs_per_pkt: int,
) -> None:
    """Marshall and write out sequence number signature packets to pcap."""
    num_seq_books = len(raw_seq_num_sigs) // seq_blk_sz
    num_seq_pkts = seq_blk_sz // max_sigs_per_pkt

    for book in range(0, num_seq_books):
        seq_pkts = []
        for pkt_round in range(0, num_seq_pkts):
            seq_pkts.extend(
                create_signature_packet(
                    SignatureType.SEQNUM_SIG,
                    raw_seq_num_sigs[:max_sigs_per_pkt],
                    (pkt_round * max_sigs_per_pkt),
                    book % 2,
                ),
            )
            raw_seq_num_sigs = raw_seq_num_sigs[max_sigs_per_pkt:]

        if seq_blk_sz % max_sigs_per_pkt:
            seq_pkts.extend(
                create_signature_packet(
                    SignatureType.SEQNUM_SIG,
                    raw_seq_num_sigs[: (seq_blk_sz % max_sigs_per_pkt)],
                    (num_seq_pkts * max_sigs_per_pkt),
                    book % 2,
                ),
            )
            raw_seq_num_sigs = raw_seq_num_sigs[(seq_blk_sz % max_sigs_per_pkt) :]

        wrpcap(f"seqbook-{book}.pcap", seq_pkts)


def parse_cli_args() -> Tuple[int, int, Path]:
    """Parse command-line arguments."""
    parser = ArgumentParser(
        prog="TangoPcapGen",
        description="Generate PCAP files for populating Tofino with.",
    )
    parser.add_argument(
        "-f",
        "--file",
        type=Path,
        required=True,
        help="Pickle file containing all signatures.",
    )
    parser.add_argument(
        "-s",
        "--seqblksz",
        type=int,
        required=True,
        help="Number of entries in seq num block.",
    )
    parser.add_argument(
        "-t",
        "--tsblksz",
        type=int,
        required=True,
        help="Number of entries in timestamp block.",
    )
    args = parser.parse_args()
    return int(args.seqblksz), int(args.tsblksz), Path(args.file)


def main() -> None:
    """Write out signatures to pcap file(s)."""
    logger = logging.getLogger(__name__)
    seq_blk_sz, ts_blk_sz, pickle_file = parse_cli_args()

    logger.info("Reading signatures from pickle file...")
    with pickle_file.open("rb") as file:
        unpickled_data: PrecomputedSignatures = unpickle(file)  # noqa: S301

    max_sigs_per_pkt = (MTU_BYTES - PKT_PREFIX_BYTES - NULL_BYTE) // INT_BYTES

    logger.info("Writing out timestamp signatures to pcap...")
    write_ts_sigs_to_pcap(ts_blk_sz, unpickled_data.timestamp_signatures, max_sigs_per_pkt)

    logger.info("Writing out sequence number signatures to pcap...")
    write_seq_sigs_to_pcap(seq_blk_sz, unpickled_data.sequence_num_signatures, max_sigs_per_pkt)


if __name__ == "__main__":
    main()
