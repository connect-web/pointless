import pyautogui
import math
from screensize import get_center_coordinates

# Smoothing factor
smoothing = 1 # 0.09
ZeroX = 1920 / 2
ZeroY = 1080 / 2.18

screen_center = (ZeroX,ZeroY)


def calculate_mouse_movement(circle_point):
    """
    Calculate the mouse movement with smoothing toward the target point.

    Args:
        circle_point (tuple): (x, y) coordinates of the closest circle.
        screen_center (tuple): (x, y) coordinates of the screen center.
        smoothing (float): Smoothing factor for movement.

    Returns:
        tuple: Smoothed mouse movement (AimX, AimY).
    """
    AimX = (circle_point[0] - screen_center[0]) * smoothing
    AimY = (circle_point[1] - screen_center[1]) * smoothing
    return round(AimX), round(AimY)

def move_mouse_smoothly(circle_point):
    """
    Move the mouse smoothly toward the target point.

    Args:
        circle_point (tuple): (x, y) coordinates of the closest circle.
        screen_center (tuple): (x, y) coordinates of the screen center.
        smoothing (float): Smoothing factor for movement.
    """
    # Calculate the smoothed mouse movement
    AimX, AimY = calculate_mouse_movement(circle_point)

    # Move the mouse using pyautogui
    pyautogui.move(AimX, AimY, duration=0.1)  # duration controls smoothness further

