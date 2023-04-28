"""Plot of the memory footprint used by TangoSec books."""

import matplotlib.pyplot as plt
import numpy as np


def setup_plt() -> None:
    """Configure matplotlib plot formatting."""
    plt.style.use("seaborn-v0_8-paper")
    plt.rcParams["font.family"] = "Lucida Grande"
    plt.rcParams["lines.linewidth"] = 3


def main() -> None:
    """Plot memory footprint."""
    setup_plt()

    species = ("$2^{8}$", "$2^{12}$", "$2^{16}$", "$2^{20}$", "$2^{24}$", "$2^{28}$", "$2^{32}$")
    penguin_means = {
        "Without Traffic": (0.2, 1, 5.6, 20, 64, 67, 66.2),
        "With Traffic": (0, 1, 6.2, 37.2, 70.8, 70.2, 73.6),
    }

    x = np.arange(len(species))  # the label locations
    width = 0.4  # the width of the bars
    multiplier = 0.5

    fig, ax = plt.subplots(layout="constrained")

    for attribute, measurement in penguin_means.items():
        offset = width * multiplier
        rects = ax.bar(x + offset, measurement, width, label=attribute)
        ax.bar_label(rects, fontsize=7)
        multiplier += 1

    # Add some text for labels, title and custom x-axis tick labels, etc.
    ax.set_ylabel("Write Time (ns)", fontsize=14)
    ax.set_xlabel("Signatures Written", fontsize=14)
    ax.set_xticks(x + width, species, fontsize=14)
    ax.legend(loc="upper left", ncols=2)
    ax.set_ylim(0, 80)
    ax.set_aspect(1.0 / ax.get_data_ratio(), adjustable="box")
    # plt.show()  # noqa: ERA001
    plt.savefig("runtime_labeled.pdf", bbox_inches="tight", format="pdf", dpi=600)


if __name__ == "__main__":
    main()
