from pynput import keyboard
from pynput.mouse import Button, Controller as Mouse
from time import sleep
import threading
import random
from controls import greenade_fast, eep,eepo, left, right, acceptMenu
# Initialize mouse controller
mouse = Mouse()
toggle_active = False  # Global variable to track the toggle state

import pydirectinput
import pyautogui
import time

def get_mouse_position():
    """
    Returns the current mouse position as an (x, y) tuple.
    """
    return pyautogui.position()

# Example usage
current_position = get_mouse_position()

def look_down():
    for x in range(10):
        pydirectinput.moveRel(0, random.randint(40,50))
        sleep(random.randint(25,50))

# Example usage


def toggle_action():
    global toggle_active
    while True:

        if toggle_active:
            for x in range(3):
                acceptMenu()
            #move_mouse_down()
            pydirectinput.moveRel(0, random.randint(250,350))
            sleep(0.1)
            pydirectinput.moveRel(0, random.randint(250,350))
            sleep(0.25)
            greenade_fast()
            #sleep(5)
        sleep(0.2)

def move():
    while True:
        if toggle_active:
            if random.randint(1,2) == 1:
                eepo()
            else:
                eep()
        sleep(0.1)
def shooty():
    global toggle_active
    while True:
        if toggle_active:
            sleep(random.randint(100, 2500) / 1000)
            threading.Thread(target=left, daemon=True).start()
            threading.Thread(target=right, daemon=True).start()


        sleep(0.5)


# Start the loop in a separate thread
threading.Thread(target=toggle_action, daemon=True).start()
# Start the loop in a separate thread
threading.Thread(target=move, daemon=True).start()

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
