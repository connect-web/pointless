from pynput.keyboard import Key, Controller
from pynput import keyboard
from time import sleep, time
import random
import threading
from threading import active_count, Thread
random.seed(time())

toggle_active = False  # Global variable to track the toggle state

from pynput.mouse import Button
from pynput.mouse import Controller as Mouse

import time
mouse = Mouse()
keyboardController = Controller()

def mm():

    mouse.press(Button.left)
    # Hold the mouse button for 5 seconds
    sleep(random.randint(500,1_000)/1000)

    # Release the left mouse button
    mouse.release(Button.left)

# Press and hold the left mouse button

def kk():
    keyboardController.press('`')
    keyboardController.release('`')

def ok():
    keyboardController.press(Key.space)  # Press spacebar
    keyboardController.release(Key.space)  # Release spacebar

def aah():
    keyboardController.press(Key.esc)  # Press spacebar
    keyboardController.release(Key.esc)  # Release spacebar

def eep():
    keyboardController.press('d')  # Press spacebar
    sleep(random.randint(1500,5800)/1000)
    keyboardController.release('d')  # Release spacebar

def eepoo():
    keyboardController.press('e')  # Press spacebar
    sleep(random.randint(4500,4800)/1000)
    keyboardController.release('e')  # Release spacebar



def eepo():
    keyboardController.press('a')  # Press spacebar
    sleep(random.randint(4500,7800)/1000)
    keyboardController.release('a')  # Release spacebar


def move():
    global toggle_active
    while True:
        if toggle_active:
            if random.randint(1,2) == 1:
                eepo()
            else:
                eep()
        sleep(0.5)

def shooty():
    global toggle_active
    while True:
        if toggle_active:
            sleep(random.randint(100, 1000) / 1000)
            i = random.randint(1, 3)

            if i == 1:
                mm()
            elif i == 2:
                ok()

            if random.randint(1, 5) == 1:
                eepoo()
        sleep(0.5)



# Start the loop in a separate thread
threading.Thread(target=move, daemon=True).start()
threading.Thread(target=shooty, daemon=True).start()





def on_press(key):
    global toggle_active
    try:
        if key == keyboard.Key.alt_gr:
            toggle_active = not toggle_active
            print(f"Toggle is now {'active' if toggle_active else 'inactive'}.")
    except AttributeError:
        pass

# Listener for the right CTRL key
with keyboard.Listener(on_press=on_press) as listener:
    listener.join()