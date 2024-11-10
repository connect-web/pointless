from pynput.keyboard import Key, Controller
from time import sleep, time
import random
import threading
from threading import active_count, Thread
random.seed(time())

from pynput.mouse import Button
from pynput.mouse import Controller as Mouse

import time
mouse = Mouse()
keyboard = Controller()

def mm():

    mouse.press(Button.left)
    # Hold the mouse button for 5 seconds
    sleep(random.randint(500,1_000)/1000)

    # Release the left mouse button
    mouse.release(Button.left)

# Press and hold the left mouse button

def kk():
    keyboard.press('`')
    keyboard.release('`')

def ok():
    keyboard.press(Key.space)  # Press spacebar
    keyboard.release(Key.space)  # Release spacebar

def aah():
    keyboard.press(Key.esc)  # Press spacebar
    keyboard.release(Key.esc)  # Release spacebar

def eep():
    keyboard.press('d')  # Press spacebar
    sleep(random.randint(1500,5800)/1000)
    keyboard.release('d')  # Release spacebar

def eepoo():
    keyboard.press('e')  # Press spacebar
    sleep(random.randint(4500,4800)/1000)
    keyboard.release('e')  # Release spacebar



def eepo():
    keyboard.press('a')  # Press spacebar
    sleep(random.randint(4500,7800)/1000)
    keyboard.release('a')  # Release spacebar


def mave():
    while 1:
        if random.randint(1,2) == 1:
            eepo()
        else:
            eep()

Thread(target=mave).start()

while 1:
    sleep(random.randint(100,2000)/1000)
    i = random.randint(1,3)

    if random.randint(1,2) == 1:
        eepoo()

    if i == 1:
        mm()
    elif i == 2:
        ok()
