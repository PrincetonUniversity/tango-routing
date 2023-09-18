"""Plot of the memory footprint used by TangoSec books."""

from datetime import timedelta

import matplotlib.pyplot as plt
import numpy as np

PACKET_SIZE = 1500
SIGNATURE_SZ_BYTES = 4
BYTE_SZ = 8


def setup_plt() -> None:
    """Configure matplotlib plot formatting."""
    plt.style.use("seaborn-v0_8-paper")
    plt.rcParams["font.family"] = "Lucida Grande"
    plt.rcParams["lines.linewidth"] = 3


def calculate_mem(gigbit_sec_in: np.ndarray, control_loop: timedelta) -> np.ndarray:
    """Calculate the amount of memory used for given traffic."""
    byte_sec_in = (np.copy(gigbit_sec_in) * (10**9)) / 8
    pkts_sec_in = byte_sec_in / PACKET_SIZE
    pkts_per_loop = np.floor(pkts_sec_in * control_loop.total_seconds())
    return np.floor(pkts_per_loop / 32) * SIGNATURE_SZ_BYTES * BYTE_SZ


def main() -> None:
    """Plot memory footprint."""
    setup_plt()

    bytes_in = np.linspace(0, 99, 100)
    fig = plt.figure()
    ax = plt.gca()
    handles = []
    for loop_len in [2, 4, 8, 16]:
        bytes_needed = calculate_mem(bytes_in, timedelta(milliseconds=loop_len))
        handles.append(ax.plot(bytes_in, bytes_needed, label=f"{loop_len}ms"))
    plt.xlabel("Traffic In (Gb/s)", fontsize=20)
    plt.ylabel("Required Block Size (bits)", fontsize=20)
    plt.xticks(fontsize=20)
    plt.yticks(fontsize=20)
    legend = plt.legend(
        title="Refresh Period",
        fontsize=20,
        loc="upper center",
        ncol=len(handles),
        bbox_to_anchor=(0.5, 1.5),
    )
    ax.set_yscale("log", base=2)
    plt.setp(legend.get_title(), fontsize=20)

    fig.set_size_inches(3 * 3, (3 / 3) * 3)
    # plt.show()  # noqa: ERA001
    plt.savefig("memory_footprint_flat.pdf", bbox_inches="tight", format="pdf", dpi=600)


if __name__ == "__main__":
    main()
