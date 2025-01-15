from pynput.keyboard import Key, Controller
from time import sleep, time
import random
import threading
from threading import active_count, Thread
random.seed(time())

from pynput.mouse import Button
from pynput.mouse import Controller as Mouse

import pydirectinput

toggle_active = False
import time
mouse = Mouse()
keyboard = Controller()

def mm():

    mouse.press(Button.left)
    # Hold the mouse button for 5 seconds
    sleep(random.randint(200,500)/1000)

    # Release the left mouse button
    mouse.release(Button.left)

def acceptMenu():

    keyboard.press('.')
    # Hold the mouse button for 5 seconds
    sleep(random.randint(80,120)/1000)

    # Release the left mouse button
    keyboard.release('.')



def move_mouse_down(distance=300, duration=0.5):
    steps = random.randint(2,4)  # Number of steps to make the movement smoother
    delay = duration / steps  # Delay between each step
    pixels_per_step = distance / steps  # Pixels to move per step

    for _ in range(steps):
        # Move the mouse down by the pixels_per_step
        x, y = mouse.position
        mouse.move(0, int(pixels_per_step))
        sleep(delay)

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
    sleep(random.randint(1400,2800)/1000)
    keyboard.release('d')  # Release spacebar

def greenade_hold():
    keyboard.press('e')  # Press spacebar
    sleep(random.randint(4500,4800)/1000)
    keyboard.release('e')  # Release spacebar

def greenade_fast():
    keyboard.press('e')  # Press spacebar
    pydirectinput.moveRel(0, random.randint(400, 500))
    sleep(0.25)
    sleep(random.randint(25,55)/1000)
    keyboard.release('e')  # Release spacebar

def left():
    for x in range(random.randint(1,5)):
        mouse.press(Button.left)
        # Hold the mouse button for 5 seconds
        sleep(random.randint(20, 45) / 1000)
        # Release the left mouse button
        mouse.release(Button.left)

def right():
    for x in range(random.randint(1, 5)):
        mouse.press(Button.right)
        # Hold the mouse button for 5 seconds
        sleep(random.randint(20, 45) / 1000)
        # Release the left mouse button
        mouse.release(Button.right)

def shoot_both():
    Thread(target=left).start()
    Thread(target=right()).start()
    sleep(45*5)

def eepo():
    keyboard.press('a')  # Press spacebar
    sleep(random.randint(1400,2800)/1000)
    keyboard.release('a')  # Release spacebar

