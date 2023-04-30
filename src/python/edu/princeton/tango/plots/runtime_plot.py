"""Plot of the memory footprint used by TangoSec books."""

import matplotlib.pyplot as plt
import numpy as np

data_a = [
    [1, 0, 0, 0, 0],
    [1, 1, 1, 1, 1],
    [6, 6, 5, 6, 5],
    [15, 28, 14, 21, 22],
    [66, 67, 66, 63, 58],
    [63, 76, 68, 65, 63],
    [73, 63, 72, 60, 63],
]
data_b = [
    [0, 0, 0, 0, 0],
    [1, 1, 1, 1, 1],
    [6, 6, 7, 6, 6],
    [40, 47, 18, 57, 24],
    [73, 74, 73, 60, 74],
    [74, 72, 75, 64, 66],
    [64, 74, 86, 62, 82],
]


def setup_plt() -> None:
    """Configure matplotlib plot formatting."""
    plt.style.use("seaborn-v0_8-paper")
    plt.rcParams["font.family"] = "Lucida Grande"
    plt.rcParams["lines.linewidth"] = 3


def main() -> None:
    """Plot memory footprint."""
    setup_plt()

    independent = (
        "$2^{8}$",
        "$2^{12}$",
        "$2^{16}$",
        "$2^{20}$",
        "$2^{24}$",
        "$2^{28}$",
        "$2^{32}$",
    )
    dependent = {
        "Without Traffic": [
            [1, 0, 0, 0, 0],
            [1, 1, 1, 1, 1],
            [6, 6, 5, 6, 5],
            [15, 28, 14, 21, 22],
            [66, 67, 66, 63, 58],
            [63, 76, 68, 65, 63],
            [73, 63, 72, 60, 63],
        ],
        "With Traffic": [
            [0, 0, 0, 0, 0],
            [1, 1, 1, 1, 1],
            [6, 6, 7, 6, 6],
            [40, 47, 18, 57, 24],
            [73, 74, 73, 60, 74],
            [74, 72, 75, 64, 66],
            [64, 74, 86, 62, 82],
        ],
    }

    x = np.arange(len(independent))  # the label locations
    width = 0.4  # the width of the bars
    multiplier = 0.5

    fig, ax = plt.subplots(layout="constrained")

    for attribute, measurement in dependent.items():
        offset = width * multiplier
        medians = [np.median(vals) for vals in measurement]
        err = [np.std(vals) for vals in measurement]
        ax.bar(x + offset, medians, width, label=attribute)
        (_, caps, _) = plt.errorbar(
            x + offset,
            medians,
            yerr=err,
            fmt="o",
            markersize=2,
            elinewidth=2,
            capsize=3,
            color="dimgray",
        )
        for cap in caps:
            cap.set_color("dimgray")
            cap.set_markeredgewidth(2)
        # ax.bar_label(rects, fontsize=7)  # noqa: ERA001
        multiplier += 1

    # Add some text for labels, title and custom x-axis tick labels, etc.
    ax.set_ylabel("Write Time (ns)", fontsize=14)
    ax.set_xlabel("Signatures Written", fontsize=14)
    ax.set_xticks(x + width, independent, fontsize=14)
    plt.yticks(fontsize=14)
    ax.legend(loc="upper left", ncols=2)
    ax.set_ylim(0, 90)
    ax.set_aspect(1.0 / ax.get_data_ratio(), adjustable="box")
    # plt.show()  # noqa: ERA001
    plt.savefig("runtime_err.pdf", bbox_inches="tight", format="pdf", dpi=600)


if __name__ == "__main__":
    main()
