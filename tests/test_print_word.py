import pytest
import sys
from python_at_work.print_word import print_hello_world

def test_print_word(capsys):
    print_hello_world()
    captured = capsys.readouterr()
    assert captured.out == "Hello world!\n"
