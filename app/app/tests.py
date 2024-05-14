"""
Sample Tests
"""
from django.test import SimpleTestCase

from app import calc


class CalcTests(SimpleTestCase):
    """Test the calc module"""

    def test_add_number(self):
        """Add numbers together"""
        res = calc.add(1, 2)
        self.assertEqual(res, 3)

    def test_Subtract_numbers(self):
        """Subtract numbers """

        res = calc.subtract(10, 5)
        self.assertEqual(res, 5)
