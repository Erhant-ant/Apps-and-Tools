import unittest

from main import calculate_split_amount, parse_positive_float, parse_positive_int


class TipCalculatorTests(unittest.TestCase):
    def test_calculate_split_amount(self) -> None:
        tip_amount, total_cost, each_person = calculate_split_amount(100.0, 15.0, 4)
        self.assertAlmostEqual(tip_amount, 15.0)
        self.assertAlmostEqual(total_cost, 115.0)
        self.assertAlmostEqual(each_person, 28.75)

    def test_parse_positive_float(self) -> None:
        self.assertEqual(parse_positive_float("12.5"), 12.5)
        self.assertIsNone(parse_positive_float("0"))
        self.assertIsNone(parse_positive_float("-4.2"))
        self.assertIsNone(parse_positive_float("hello"))

    def test_parse_positive_int(self) -> None:
        self.assertEqual(parse_positive_int("3"), 3)
        self.assertIsNone(parse_positive_int("0"))
        self.assertIsNone(parse_positive_int("-2"))
        self.assertIsNone(parse_positive_int("1.5"))
        self.assertIsNone(parse_positive_int("abc"))


if __name__ == "__main__":
    unittest.main()
