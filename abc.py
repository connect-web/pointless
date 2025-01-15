import pygetwindow as gw
from mss import mss
import os
from io import BytesIO
from time import sleep
import imagehash


import uuid
from PIL import Image
import io
import base64
from controls import move_mouse_down, greenade_fast


game_options = os.listdir(os.path.join('Enums/saved', 'multiplayer', 'game'))



print(game_options)
quit()

def get_base(img):
    # Convert cropped image to base64
    buffered = io.BytesIO()
    img.save(buffered, format="PNG")
    img_base64 = base64.b64encode(buffered.getvalue()).decode("utf-8")
    return img_base64

def get_hash(img):
    return imagehash.phash(img)

def get_screenshot():
    # Capture the target window area using mss
    with mss() as sct:
        # Capture the full screen (or specify a region with bbox if needed)
        screenshot = sct.grab(sct.monitors[1])

        # Convert the screenshot to an image object
        img = Image.frombytes("RGB", screenshot.size, screenshot.rgb)
    return img

def get_screenshot_base64(coords) -> (Image, str):
    # Capture the target window area using mss
    img = get_screenshot()
    img.save("screen_base_.png")
    # Crop the image (10, 10, 10, 10)
    cropped_img = img.crop(coords)
    img_base64 = get_base(cropped_img)


    return cropped_img,img_base64

def get_screenshot_hash(coords):


    # Capture the target window area using mss
    img = get_screenshot()
    img.save("screen_base_.png")
    # Crop the image (10, 10, 10, 10)
    cropped_img = img.crop(coords)

    return cropped_img, imagehash.phash(img)


def get_screenshot_2():
    img = get_screenshot()
    # Save the image to a BytesIO object in memory
    buffer = BytesIO()
    img.save(buffer, format="PNG")
    buffer.seek(0)

    # Encode the BytesIO content to Base64
    base64_string = base64.b64encode(buffer.read()).decode("utf-8")
    return img,base64_string

coords = (103,58,148,104)

alive_img = get_screenshot()
shoot_key = alive_img.crop(coords)
shoot_key.save("Shoot_key.png")
alive_base = get_base(shoot_key)
print(f'Start={get_base(shoot_key)}')




while 1:
    sleep(1)
    example, current_base = get_screenshot_base64(coords)
    #print(f'Difference = {alive_base - current_base}')
    if current_base == alive_base:
        print('in loady!')

    else:
        print("not in lody.")
