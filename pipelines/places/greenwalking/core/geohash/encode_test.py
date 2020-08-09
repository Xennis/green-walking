import unittest
from dataclasses import dataclass

from greenwalking.core.geohash import encode


class TestEncode(unittest.TestCase):
    def test_all(self):
        @dataclass
        class Test:
            lat: float
            lng: float
            expected: str

        tests = [
            Test(0, 0, "7zzzzzzzzzzz"),
            Test(-90, -180, "000000000000"),
            Test(90, 180, "zzzzzzzzzzzz"),
            Test(52.5623, 9.539, "u1qg10djdfcu"),
            Test(62.37392, -126.12123, "c5n6f4c66m6v"),
        ]
        for test in tests:
            with self.subTest(test.expected):
                actual = encode(latitude=test.lat, longitude=test.lng)
                self.assertEqual(test.expected, actual)

    def test_precision(self):
        tests = [
            (12, "u1qg10djdfcu"),
            (11, "u1qg10djdfc"),
            (10, "u1qg10djdf"),
            (9, "u1qg10djd"),
            (8, "u1qg10dj"),
            (7, "u1qg10d"),
            (6, "u1qg10"),
            (5, "u1qg1"),
            (4, "u1qg"),
            (3, "u1q"),
            (2, "u1"),
            (1, "u"),
        ]
        for (prec, expected) in tests:
            with self.subTest(prec):
                actual = encode(latitude=52.5623, longitude=9.539, precision=prec)
                self.assertEqual(expected, actual)

    def test_precision_value_error(self):
        tests = [-1, 0, 13]
        for prec in tests:
            with self.subTest(prec):
                self.assertRaises(ValueError, encode, 52.5623, 9.539, prec)
