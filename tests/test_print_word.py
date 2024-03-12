import unittest
from unittest.mock import patch
from python_at_work.print_word import print_hello_world  # Relative import

class TestPrintHelloWorld(unittest.TestCase):
  @patch('builtins.print')
  def test_print_message(self, mock_print):
    print_hello_world()
    mock_print.assert_called_with("Hello World!")

if __name__ == '__main__':
  unittest.main()
