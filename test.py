import pygetwindow as gw
from mss import mss
import os
from io import BytesIO
from PIL import Image
import base64
import uuid
from time import sleep


def get_screenshot_2():
    # Capture the target window area using mss
    with mss() as sct:
        # Capture the full screen (or specify a region with bbox if needed)
        screenshot = sct.grab(sct.monitors[1])

        # Convert the screenshot to an image object
        img = Image.frombytes("RGB", screenshot.size, screenshot.rgb)

        # Save the image to a BytesIO object in memory
        buffer = BytesIO()
        img.save(buffer, format="PNG")
        buffer.seek(0)

        # Encode the BytesIO content to Base64
        base64_string = base64.b64encode(buffer.read()).decode("utf-8")
        return img,base64_string

def get_screenshot():
    # Capture the target window area using mss
    with mss() as sct:
        sct.shot(output=f"new/{uuid.uuid4().hex}.png")



for x in range(1):
    get_screenshot()

