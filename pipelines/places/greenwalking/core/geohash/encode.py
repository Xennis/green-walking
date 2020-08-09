# The Geohash alphabet uses all digits 0-9 and almost all lower case letters expect "a", "i", "l" and "o".
from typing import List

__alphabet = "0123456789bcdefghjkmnpqrstuvwxyz"


def encode(latitude: float, longitude: float, precision: int = 12):
    if precision < 1 or precision > 12:
        raise ValueError("precision is not in range [0,12]")
    lat_range = (-90.0, 90.0)
    lng_range = (-180.0, 180.0)
    bits = [16, 8, 4, 2, 1]
    bit = 0
    ch = 0
    even = True

    geohash: List[str] = []
    while len(geohash) < precision:
        if even:
            mid = (lng_range[0] + lng_range[1]) / 2
            if longitude > mid:
                ch |= bits[bit]
                lng_range = (mid, lng_range[1])
            else:
                lng_range = (lng_range[0], mid)
        else:
            mid = (lat_range[0] + lat_range[1]) / 2
            if latitude > mid:
                ch |= bits[bit]
                lat_range = (mid, lat_range[1])
            else:
                lat_range = (lat_range[0], mid)
        even = not even
        if bit < 4:
            bit += 1
        else:
            geohash += __alphabet[ch]
            bit = 0
            ch = 0
    return "".join(geohash)
