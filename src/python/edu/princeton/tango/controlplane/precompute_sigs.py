"""Precompute the sequence number and timestamp signatures."""

import logging
import sys
from dataclasses import dataclass
from datetime import timedelta
from hashlib import sha256
from pathlib import Path
from pickle import dump as pickle
from typing import List


@dataclass
class PrecomputedSignatures:
    """All precomputed signatures."""

    timestamp_signatures: List[int]
    sequence_num_signatures: List[int]


def hash_int(num: int) -> int:
    """Hash an int into a 32-bit integer."""
    return num


def compute_timestamp_signatures(
    test_length: timedelta,
) -> List[int]:
    """Generate signaures for all timestamps."""
    logger = logging.getLogger(__name__)
    logger.info("Calculating timestamp signatures...")
    num_signaures_needed = test_length // timedelta(milliseconds=1)

    return [hash_int(i) for i in range(0, num_signaures_needed)]


def compute_sequence_num_signatures(num_seq_nums: int) -> List[int]:
    """Generate signaures for all sequence numbers."""
    logger = logging.getLogger(__name__)
    logger.info("Calculating sequence number signatures...")
    return [hash_int(curr_round) for curr_round in range(0, num_seq_nums // 32)]


def pickle_signatures(filename: Path, ts_sigs: List[int], seq_sigs: List[int]) -> None:
    """Pickle the precomputed signatures."""
    with filename.open("wb") as file:
        pickle(
            PrecomputedSignatures(timestamp_signatures=ts_sigs, sequence_num_signatures=seq_sigs),
            file,
        )


def main() -> None:
    """Genreate pickle file containing all precomputed signatures."""
    if len(sys.argv) != 4:
        print(
            "\n-- ERROR --\n\nUsage: <program> <pickle-filepath> <ms-duration> <packets-per-book>",
            flush=True,
        )  # noqa: T201
        print(sys.argv, len(sys.argv))
        sys.exit(1)

    filepath = Path(sys.argv[1]).absolute()

    test_time_len = timedelta(milliseconds=int(sys.argv[2]))
    packets_per_seq_book = int(sys.argv[3])
    num_books = 1
    num_seq_sigs = packets_per_seq_book * num_books

    timestamp_sigs = compute_timestamp_signatures(test_time_len)
    seq_num_sigs = compute_sequence_num_signatures(num_seq_sigs)

    print(f"num ts: {len(timestamp_sigs)}, num_seq: {len(seq_num_sigs)}")

    pickle_signatures(filepath, ts_sigs=timestamp_sigs, seq_sigs=seq_num_sigs)
    print(f"\n-- SUCCESS --\n\nPickled signatures @ file://{filepath}")  # noqa: T201


if __name__ == "__main__":
    main()
