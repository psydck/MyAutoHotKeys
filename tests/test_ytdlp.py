import os
import sys

import pyautogui
import pytest

#region SETUP

if not sys.platform.startswith("win"):
    pytest.skip("skipping linux-only tests", allow_module_level=True)

@pytest.fixture(autouse=True)
def run_before_and_after_tests():
    """Fixture to execute asserts before and after a test is run"""
    pyautogui.press("win") # start test script
    pyautogui.sleep(5)
    pyautogui.write('AutoHotkey', interval=0.25)
    pyautogui.sleep(5)
    pyautogui.doubleClick(1053, 738) # recent ahk file
    pyautogui.doubleClick(1053, 738) # recent ahk file
    pyautogui.sleep(5)

    """ open powershell """
    pyautogui.press("win") 
    pyautogui.sleep(5)
    pyautogui.write("powershell", interval=0.25)
    pyautogui.sleep(5)
    pyautogui.press("enter")
    pyautogui.sleep(5)

    yield # this is where the testing happens

    # Teardown : fill with any logic you want
    pyautogui.sleep(5) # dismiss test_ytdlp.ahk test message
    pyautogui.press("enter")
    pyautogui.sleep(5)

    with pyautogui.hold('alt'): # close powershell
        pyautogui.press("f4")

@pytest.fixture()
def get_history_file_path() -> str:
    return os.path.join("./test_data_stash", "history.csv")


def run_ahk_command(word):
    pyautogui.write(word, interval=0.25) # on powershell type
    pyautogui.sleep(2)
    pyautogui.press("enter")
    pyautogui.sleep(10)
    pass

#endregion

#region TESTS

@pytest.mark.skip("always Passed")
def test_history_file_created(get_history_file_path: str) -> None:
    run_ahk_command('.test_file')
    assert os.path.exists(get_history_file_path), "history file not created!"
    pass

@pytest.mark.skip("always Passed")
def test_history_file_content(get_history_file_path: str) -> None:
    run_ahk_command('.test_content')
    with open(get_history_file_path, "r") as test_content:
        assert len(test_content.readlines()) > 0, "data content, was not append!"
    pass
    
def test_history_file_append(get_history_file_path: str) -> None:
    run_ahk_command('.test_append')
    with open(get_history_file_path, "r") as test_append:
        lines: list[str] = test_append.readlines()
        lastline: str = lines[0].split("\n")[-1]
        print(f"{lastline=}")
        assert lastline == "", "last line has data"
    pass

#endregion