from pynput import keyboard
from pynput.mouse import Button, Controller as Mouse
from time import sleep
import threading
import random
from controls import greenade_fast
# Initialize mouse controller
mouse = Mouse()
toggle_active = False  # Global variable to track the toggle state

import pydirectinput
import pyautogui
import time
import random

from controls import click_left


def toggle_action():
    global toggle_active
    while True:
        if toggle_active:
            click_left()

            #sleep(5)
        sleep(random.randint(80,150)/1000)

# Start the loop in a separate thread
threading.Thread(target=toggle_action, daemon=True).start()

def on_press(key):
    global toggle_active
    try:
        if key == keyboard.Key.ctrl_r:
            toggle_active = not toggle_active
            print(f"Toggle is now {'active' if toggle_active else 'inactive'}.")
    except AttributeError:
        pass

# Listener for the right CTRL key
with keyboard.Listener(on_press=on_press) as listener:
    listener.join()
