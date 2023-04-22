"""Convert IPv6 Addresses to lucid-compatible types."""

from ipaddress import IPv6Address
from pathlib import Path
from typing import Self


class LucidIPv6Address:
    """Model for Lucid IPv6 Address."""

    def __init__(self: Self, addr: IPv6Address) -> None:
        """Parse the IPv6 Address into a lucid representation."""
        self._addr = addr

        parsed_addr = self.convert_address()
        self._lo = parsed_addr["lo"]
        self._hi = parsed_addr["hi"]

    def convert_address(self: Self) -> dict[str, int]:
        """Convert a single IPv6 Address to lucid representation."""
        dest_int = int(self._addr)
        dest_bin = f"{dest_int:0128b}"
        lo = int(dest_bin[64:128], 2)
        hi = int(dest_bin[0:64], 2)

        return {"lo": lo, "hi": hi}

    def __str__(self: Self) -> str:
        """Convert to lucid type field format."""
        return f"dest_addr_hi = {self._hi}; dest_addr_lo = {self._lo};"


def convert_ipv6_to_lucid(filename: Path) -> None:
    """Parse a filelist of IPv6 Adresses into lucid representations."""
    with filename.open("r", encoding="utf-8") as file:
        addresses = [IPv6Address(addr.strip()) for addr in file.readlines() if addr.strip()]

    address_ints = map(int, addresses)
    address_str = map(str, map(LucidIPv6Address, addresses))

    for addr, addr_int, addr_str in zip(addresses, address_ints, address_str, strict=True):
        print(  # noqa: T201
            f"IPv6 Address: {str(addr)} -> IPv6 Int: {addr_int} -> Lucid Type Field: '{addr_str}'",
        )
