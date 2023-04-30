"""Plot signature write times as a grouped box plot."""
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

ticks = ["$2^{8}$", "$2^{12}$", "$2^{16}$", "$2^{20}$", "$2^{24}$", "$2^{28}$", "$2^{32}$"]


def set_box_color(bp: dict, color: str) -> None:
    """Set the color of a given box plot."""
    plt.setp(bp["boxes"], color=color, linewidth=3)
    plt.setp(bp["whiskers"], color=color, linewidth=3)
    plt.setp(bp["caps"], color=color, linewidth=3)
    plt.setp(bp["medians"], color=color, linewidth=3)


def setup_plt() -> None:
    """Configure matplotlib plot formatting."""
    plt.style.use("seaborn-v0_8-paper")
    plt.rcParams["font.family"] = "Lucida Grande"
    plt.rcParams["lines.linewidth"] = 3


def main() -> None:
    """Plot box and whiskers of runtimes."""
    plt.figure()
    setup_plt()

    bpl = plt.boxplot(
        data_a,
        positions=np.array(range(len(data_a))) * 3.0 - 0.45,
        sym="",
        widths=0.6,
    )
    bpr = plt.boxplot(
        data_b,
        positions=np.array(range(len(data_b))) * 3.0 + 0.45,
        sym="",
        widths=0.6,
    )
    set_box_color(bpl, "#D7191C")
    set_box_color(bpr, "#2C7BB6")

    # draw temporary red and blue lines and use them to create a legend
    plt.plot([], c="#D7191C", label="Without Traffic")
    plt.plot([], c="#2C7BB6", label="With Traffic")
    plt.legend(loc="upper left", ncols=2)

    ax = plt.gca()
    plt.xticks(range(0, len(ticks) * 3, 3), ticks, fontsize=14)
    plt.yticks(fontsize=14)
    plt.xlim(-2, len(ticks) * 3)
    plt.ylim(0, 90)
    ax.set_aspect(1.0 / ax.get_data_ratio(), adjustable="box")
    ax.set_ylabel("Write Time (ns)", fontsize=14)
    ax.set_xlabel("Signatures Written", fontsize=14)
    plt.tight_layout()
    # plt.show()
    plt.savefig("runtime_box.pdf", bbox_inches="tight", format="pdf", dpi=600)


if __name__ == "__main__":
    main()
