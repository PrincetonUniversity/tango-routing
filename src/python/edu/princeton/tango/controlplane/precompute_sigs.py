"""Precompute the sequence number and timestamp signatures."""

import sys
from datetime import timedelta
from hashlib import sha256
from pathlib import Path
from pickle import dump as pickle

from edu.princeton.tango.controlplane.pickle_interface import PrecomputedSignatures


def hash_int(num: int) -> int:
    """Hash an int into a 32-bit integer."""
    return int.from_bytes(
        sha256(num.to_bytes((num.bit_length() + 7) // 8, "big")).digest()[-4:],
        "big",
    )


def compute_timestamp_signatures(test_length: timedelta) -> list[int]:
    """Generate signaures for all timestamps."""
    num_signaures_needed = test_length // timedelta(milliseconds=1)
    return [hash_int(i) for i in range(0, num_signaures_needed)]


def compute_sequence_num_signatures(num_seq_nums: int) -> list[int]:
    """Generate signaures for all sequence numbers."""
    return [hash_int(i) & 1 for i in range(0, num_seq_nums)]


def pickle_signatures(filename: Path, ts_sigs: list[int], seq_sigs: list[int]) -> None:
    """Pickle the precomputed signatures."""
    with filename.open("wb") as file:
        pickle(
            PrecomputedSignatures(timestamp_signatures=ts_sigs, sequence_num_signatures=seq_sigs),
            file,
        )


def main() -> None:
    """Genreate pickle file containing all precomputed signatures."""
    if len(sys.argv) != 2:
        print("\n-- ERROR --\n\nUsage: <program> <pickle-filepath>", flush=True)  # noqa: T201
        sys.exit(1)

    filepath = Path(sys.argv[1]).absolute()

    test_time_len = timedelta(minutes=1)
    num_packets = 2 ** 16

    timestamp_sigs = compute_timestamp_signatures(test_time_len)
    seq_num_sigs = compute_sequence_num_signatures(num_packets)

    pickle_signatures(filepath, ts_sigs=timestamp_sigs, seq_sigs=seq_num_sigs)
    print(f"\n-- SUCCESS --\n\nPickled signatures @ file://{filepath}")  # noqa: T201


if __name__ == "__main__":
    main()
